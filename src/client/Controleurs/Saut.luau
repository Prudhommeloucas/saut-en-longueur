-- Saut (joueur) : poussée du jetpack (maintenir Saut en l'air, sur la piste), champ de vision, distance en direct.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local StatsConfig = require(Config:WaitForChild("Stats"))
local CameraConfig = require(Config:WaitForChild("Camera"))
local Equipement = require(Config:WaitForChild("Equipement"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Hud = require(script.Parent.Hud)

local player = Players.LocalPlayer
local infoJetpack = Equipement.OBJETS.Jetpack

local Saut = {}

local carburant = infoJetpack.carburant
local dernierSaut = 0
local jetActif = false

local function chaqueImage(dt: number)
	local maintenant = os.clock()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	local pousse = false
	if hum and hrp and hum.Health > 0 then
		local enLAir = hum.FloorMaterial == Enum.Material.Air
		if not enLAir then
			carburant = infoJetpack.carburant
		elseif player:GetAttribute("Jetpack") and carburant > 0 and hrp.Position.X > SautConfig.DEBUT_PISTE_X then
			local maintenu = (maintenant - dernierSaut) < 0.15 or UserInputService:IsKeyDown(Enum.KeyCode.Space)
			if maintenu then
				pousse = true
				carburant = math.max(0, carburant - dt)
				local v = hrp.AssemblyLinearVelocity
				local vy = math.min(v.Y + infoJetpack.poussee * dt, math.max(v.Y, infoJetpack.vitesseMontee))
				hrp.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
			end
		end
		Hud.majCarburant(carburant / infoJetpack.carburant)

		-- Champ de vision plus large quand on va vite
		local cam = workspace.CurrentCamera
		if cam then
			local v = hrp.AssemblyLinearVelocity
			local vitesse = Vector3.new(v.X, 0, v.Z).Magnitude
			local cible = math.min(
				CameraConfig.FOV_BASE + math.max(0, vitesse - StatsConfig.VITESSE_BASE) / 4,
				CameraConfig.FOV_MAX
			)
			cam.FieldOfView += (cible - cam.FieldOfView) * math.min(1, dt * 5)
		end

		Hud.distanceEnDirect(hrp.Position.X - SautConfig.LIGNE_X)
	end

	-- Prévient le serveur quand la poussée démarre ou s'arrête (flammes visibles par tous)
	if pousse ~= jetActif then
		jetActif = pousse
		Remotes.JetpackEtat:FireServer(pousse)
	end
end

function Saut.demarrer()
	UserInputService.JumpRequest:Connect(function()
		dernierSaut = os.clock()
	end)
	RunService.Heartbeat:Connect(chaqueImage)
end

return Saut
