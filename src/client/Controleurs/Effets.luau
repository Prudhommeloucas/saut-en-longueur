-- Effets : joue chez ce joueur les effets ponctuels annoncés par le serveur (événement « Effet », T-111) :
-- gerbe de sable, confettis du record, éclat de l'appel parfait. Voir Shared/Util/Effets.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared:WaitForChild("Remotes"))
local Effets = require(Shared:WaitForChild("Util"):WaitForChild("Effets"))

local Controleur = {}

function Controleur.demarrer()
	Remotes.Effet.OnClientEvent:Connect(function(nom: unknown, position: unknown, echelle: unknown)
		if type(nom) == "string" and typeof(position) == "Vector3" then
			Effets.jouerIci(nom, position, if type(echelle) == "number" then echelle else nil)
		end
	end)
end

return Controleur
