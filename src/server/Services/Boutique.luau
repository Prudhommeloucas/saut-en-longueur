-- Boutique : un stand par objet (Map.Boutique.Stand<identifiant>, avec un ProximityPrompt « Prompt »).
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Equipement = require(Config:WaitForChild("Equipement"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
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

function Boutique.demarrer()
	local boutique = workspace:WaitForChild("Map"):WaitForChild("Boutique")
	for cle, info in Equipement.OBJETS do
		local stand = boutique:WaitForChild("Stand" .. cle)
		local prompt = stand:WaitForChild("Prompt")
		prompt.ObjectText = string.format(Textes.STAND_PRIX, info.nom, tostring(info.prix))
		prompt.Triggered:Connect(function(player)
			acheter(player, cle, info)
		end)
	end
end

return Boutique
