-- Entraînement : gain de Puissance (zone de squat) ou de Vitesse (zone de mollets) à intervalle régulier.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local StatsConfig = require(Config:WaitForChild("Stats"))
local Donnees = require(script.Parent.Donnees)

local Entrainement = {}

local function dansZone(zone: BasePart, pos: Vector3): boolean
	local l = zone.CFrame:PointToObjectSpace(pos)
	return math.abs(l.X) <= zone.Size.X / 2 and math.abs(l.Z) <= zone.Size.Z / 2 and l.Y > -1 and l.Y < 12
end

function Entrainement.demarrer()
	local map = workspace:WaitForChild("Map")
	local zoneSquat = map:WaitForChild("Entrainement"):WaitForChild("ZoneSquat")
	local zoneMollets = map.Entrainement:WaitForChild("ZoneMollets")

	task.spawn(function()
		local accum = 0
		while true do
			accum += task.wait(0.2)
			if accum >= StatsConfig.ENTRAINEMENT_INTERVALLE then
				accum -= StatsConfig.ENTRAINEMENT_INTERVALLE
				for _, player in Players:GetPlayers() do
					local char = player.Character
					local hum = char and char:FindFirstChildOfClass("Humanoid")
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if Donnees.estCharge(player) and hum and hrp and hum.Health > 0 then
						local pos = hrp.Position
						if dansZone(zoneSquat, pos) then
							player:SetAttribute(
								"Puissance",
								player:GetAttribute("Puissance") + StatsConfig.ENTRAINEMENT_GAIN
							)
						elseif dansZone(zoneMollets, pos) then
							player:SetAttribute(
								"Vitesse",
								player:GetAttribute("Vitesse") + StatsConfig.ENTRAINEMENT_GAIN
							)
						end
					end
				end
			end
		end
	end)
end

return Entrainement
