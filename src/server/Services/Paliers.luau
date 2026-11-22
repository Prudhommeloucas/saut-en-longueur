-- Paliers (T-204) : quand le record d'un joueur monte (attribut « Record »), prévient le joueur des fonctions qui
-- s'ouvrent (événement Deblocage, mise en scène côté joueur) et des paliers de record franchis (PalierFranchi).
-- La récompense d'un palier (gemmes, pièces) se prend une fois : tout de suite tant que Paliers.RECLAMATION_AUTO
-- est vrai, sinon par l'événement ReclamerPalier (EcranPaliers, T-209). Les paliers franchis avant cette tâche
-- sont rattrapés au chargement.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PaliersConfig = require(Shared:WaitForChild("Config"):WaitForChild("Paliers"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Donnees = require(script.Parent.Donnees)

local Paliers = {}

local dernierRecord = {} -- [player] = record déjà traité

-- Donne la récompense d'un palier franchi, une seule fois ; renvoie vrai si elle vient d'être donnée
local function recompenser(player: Player, monde: number, palier): boolean
	local data = Donnees.donnees(player)
	local cle = PaliersConfig.cle(monde, palier.record)
	if not data or data.paliers.reclames[cle] or (player:GetAttribute("Record") or 0) < palier.record then
		return false
	end
	data.paliers.reclames[cle] = true
	player:SetAttribute("Gemmes", (player:GetAttribute("Gemmes") or 0) + palier.gemmes)
	player.leaderstats["Pièces"].Value += palier.pieces
	return true
end

-- Paliers de l'échelle franchis entre deux records (le premier appel au chargement rattrape tout)
local function paliersFranchis(player: Player, ancien: number, nouveau: number)
	local monde = Map.mondeDe(player)
	for _, p in PaliersConfig.ECHELLE[monde] or {} do
		if
			nouveau >= p.record
			and (ancien < p.record or not Donnees.donnees(player).paliers.reclames[PaliersConfig.cle(monde, p.record)])
		then
			local recu = PaliersConfig.RECLAMATION_AUTO and recompenser(player, monde, p)
			if ancien < p.record or recu then
				Remotes.PalierFranchi:FireClient(player, monde, p.record, p.gemmes, p.pieces, recu)
			end
		end
	end
end

local function surRecord(player: Player)
	local ancien = dernierRecord[player]
	local nouveau = player:GetAttribute("Record") or 0
	if ancien == nil or nouveau <= ancien then
		return
	end
	dernierRecord[player] = nouveau
	for _, d in PaliersConfig.nouveauxDeblocages(ancien, nouveau) do
		Remotes.Deblocage:FireClient(player, d.id, d.nom)
	end
	paliersFranchis(player, ancien, nouveau)
end

function Paliers.demarrer()
	Donnees.auChargement(function(player)
		local record = player:GetAttribute("Record") or 0
		dernierRecord[player] = record
		paliersFranchis(player, record, record) -- rattrapage des paliers non réclamés
		player:GetAttributeChangedSignal("Record"):Connect(function()
			surRecord(player)
		end)
	end)
	Remotes.ReclamerPalier.OnServerEvent:Connect(function(player, monde, record)
		if type(monde) ~= "number" or type(record) ~= "number" then
			return
		end
		for _, p in PaliersConfig.ECHELLE[monde] or {} do
			if p.record == record and recompenser(player, monde, p) then
				Remotes.PalierFranchi:FireClient(player, monde, p.record, p.gemmes, p.pieces, true)
			end
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
		dernierRecord[player] = nil
	end)
end

return Paliers
