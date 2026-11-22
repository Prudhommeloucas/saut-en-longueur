-- Boutique : chaque Model ou Part tagué « Stand » (attribut Objet, avec un ProximityPrompt) vend un objet.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Equipement = require(Config:WaitForChild("Equipement"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))
local Donnees = require(script.Parent.Donnees)
local Personnage = require(script.Parent.Personnage)

local Boutique = {}

local function acheter(player: Player, cle: string, info)
	if not Donnees.estCharge(player) then
		return
	end
	if player:GetAttribute(cle) then
		Remotes.Notif:FireClient(player, string.format(Textes.BOUTIQUE_DEJA, info.nom))
		return
	end
	local pieces = player.leaderstats["Pièces"]
	if pieces.Value < info.prix then
		Remotes.Notif:FireClient(player, string.format(Textes.BOUTIQUE_MANQUE, tostring(info.prix - pieces.Value)))
		return
	end
	pieces.Value -= info.prix
	player:SetAttribute(cle, true)
	Personnage.equiperVisuels(player)
	Remotes.Notif:FireClient(player, string.format(Textes.BOUTIQUE_ACHETE, info.nom))
end

-- Matériel d'entraînement (T-202) : le stand vend le palier suivant celui du joueur (attribut Materiel)
local function acheterMateriel(player: Player)
	if not Donnees.estCharge(player) then
		return
	end
	local palier = player:GetAttribute("Materiel") or 0
	local suivant = Equipement.MATERIEL[palier + 1]
	if not suivant then
		Remotes.Notif:FireClient(player, Textes.MATERIEL_MAX)
		return
	end
	local pieces = player.leaderstats["Pièces"]
	if pieces.Value < suivant.prix then
		Remotes.Notif:FireClient(
			player,
			string.format(Textes.BOUTIQUE_MANQUE, Nombres.abreger(suivant.prix - pieces.Value))
				.. " ("
				.. suivant.nom
				.. ")"
		)
		return
	end
	pieces.Value -= suivant.prix
	player:SetAttribute("Materiel", palier + 1)
	Remotes.Notif:FireClient(
		player,
		string.format(Textes.MATERIEL_ACHETE, suivant.nom, Nombres.abreger(suivant.multiplicateur))
	)
end

function Boutique.demarrer()
	-- Chaque stand tagué « Stand » vend l'objet nommé par son attribut Objet (identifiant de Config/Equipement)
	Map.surChaque("Stand", function(stand)
		local cle = stand:GetAttribute("Objet")
		if cle == nil then
			return -- stand posé d'avance, sans objet en vente pour l'instant (Tenue)
		end
		if cle == "Materiel" then
			local prompt = stand:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt then
				prompt.ObjectText = Textes.STAND_MATERIEL
				prompt.Triggered:Connect(acheterMateriel)
			end
			return
		end
		local info = Equipement.OBJETS[cle]
		local prompt = stand:FindFirstChildWhichIsA("ProximityPrompt", true)
		if not (info and prompt) then
			warn("Stand sans objet connu ou sans ProximityPrompt :", stand:GetFullName())
			return
		end
		prompt.ObjectText = string.format(Textes.STAND_PRIX, info.nom, tostring(info.prix))
		prompt.Triggered:Connect(function(player)
			acheter(player, cle, info)
		end)
	end)
end

return Boutique
