-- Stats : vitesse de course et puissance de saut selon que le joueur est sur la piste ou non.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local StatsConfig = require(Config:WaitForChild("Stats"))
local Map = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("Map"))
local Donnees = require(script.Parent.Donnees)
local Personnage = require(script.Parent.Personnage)

local Stats = {}

local function majJoueur(player: Player)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (Donnees.estCharge(player) and hum and hrp and hum.Health > 0) then
		return
	end
	local debut = Map.debutPisteX(Map.mondeDe(player))
	local sp = debut ~= nil and hrp.Position.X > debut
	if sp then
		local monde = Map.mondeDe(player)
		hum.WalkSpeed = StatsConfig.vitesseCourse(player:GetAttribute("Vitesse"), monde)
		hum.JumpPower =
			StatsConfig.puissanceSaut(player:GetAttribute("Puissance"), player:GetAttribute("Chaussures"), monde)
	else
		hum.WalkSpeed = StatsConfig.VITESSE_BASE
		hum.JumpPower = StatsConfig.SAUT_BASE
	end
	Personnage.majTrainees(player, char, sp)
end

function Stats.demarrer()
	task.spawn(function()
		while true do
			task.wait(0.2)
			for _, player in Players:GetPlayers() do
				majJoueur(player)
			end
		end
	end)
end

return Stats
