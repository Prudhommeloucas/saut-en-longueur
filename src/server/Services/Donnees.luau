-- Données des joueurs : chargement, leaderstats, attributs, sauvegarde.
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local Donnees = {}

local store
local charge = {} -- [player] = true quand ses données sont prêtes
local peutSauvegarder = {} -- [player] = true si le chargement a réussi

function Donnees.estCharge(player: Player): boolean
	return charge[player] == true
end

local function chargerDonnees(player: Player)
	local data = {}
	if store then
		local ok, res = pcall(function()
			return store:GetAsync("joueur_" .. player.UserId)
		end)
		if ok then
			peutSauvegarder[player] = true
			if type(res) == "table" then
				data = res
			end
		end
	end
	if not player.Parent then
		return
	end

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local pieces = Instance.new("IntValue")
	pieces.Name = "Pièces"
	pieces.Value = data.Pieces or 0
	pieces.Parent = ls
	local record = Instance.new("IntValue")
	record.Name = "Record (m)"
	record.Value = math.floor(data.Record or 0)
	record.Parent = ls
	ls.Parent = player

	player:SetAttribute("Record", data.Record or 0)
	player:SetAttribute("Puissance", data.Puissance or 0)
	player:SetAttribute("Vitesse", data.Vitesse or 0)
	player:SetAttribute("Chaussures", data.Chaussures == true)
	player:SetAttribute("Jetpack", data.Jetpack == true)
	charge[player] = true
end

local function sauvegarder(player: Player)
	if not (store and charge[player] and peutSauvegarder[player]) then
		return
	end
	local data = {
		Pieces = player.leaderstats["Pièces"].Value,
		Record = player:GetAttribute("Record"),
		Puissance = player:GetAttribute("Puissance"),
		Vitesse = player:GetAttribute("Vitesse"),
		Chaussures = player:GetAttribute("Chaussures"),
		Jetpack = player:GetAttribute("Jetpack"),
	}
	pcall(function()
		store:SetAsync("joueur_" .. player.UserId, data)
	end)
end

function Donnees.demarrer()
	-- Sauvegarde (ne fonctionne que dans une place publiée avec l'accès API activé)
	pcall(function()
		store = DataStoreService:GetDataStore("SautEnLongueur_v1")
	end)

	Players.PlayerAdded:Connect(chargerDonnees)
	for _, p in Players:GetPlayers() do
		task.spawn(chargerDonnees, p)
	end

	Players.PlayerRemoving:Connect(function(player)
		sauvegarder(player)
		charge[player] = nil
		peutSauvegarder[player] = nil
	end)

	game:BindToClose(function()
		for _, p in Players:GetPlayers() do
			sauvegarder(p)
		end
	end)
end

return Donnees
