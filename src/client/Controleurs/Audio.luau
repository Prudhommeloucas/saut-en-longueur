-- Audio : sons joués par l'interface du joueur.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Sons = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Sons"))

local Audio = {}

local sonPieces: Sound

function Audio.pieces()
	if sonPieces then
		sonPieces:Play()
	end
end

function Audio.demarrer()
	sonPieces = Instance.new("Sound")
	sonPieces.Name = "SonPieces"
	sonPieces.SoundId = Sons.Pieces
	sonPieces.Volume = 0.7
	sonPieces.Parent = SoundService
end

return Audio
