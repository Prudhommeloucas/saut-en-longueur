-- Saut (joueur) : poussée du jetpack (maintenir Saut en l'air, sur la piste), champ de vision, distance en direct.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local StatsConfig = require(Config:WaitForChild("Stats"))
local CameraConfig = require(Config:WaitForChild("Camera"))
local Equipement = require(Config:WaitForChild("Equipement"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
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
		local monde = Map.mondeDe(player)
		local debut = Map.debutPisteX(monde)
		local enLAir = hum.FloorMaterial == Enum.Material.Air
		if not enLAir then
			carburant = infoJetpack.carburant
		elseif player:GetAttribute("Jetpack") and carburant > 0 and hrp.Position.X > (debut or math.huge) then
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

		local ligne = Map.ligneX(monde)
		if ligne then
			Hud.distanceEnDirect(hrp.Position.X - ligne)
		end
	end

	-- Prévient le serveur quand la poussée démarre ou s'arrête (flammes visibles par tous)
	if pousse ~= jetActif then
		jetActif = pousse
		Remotes.JetpackEtat:FireServer(pousse)
	end
end

-- Anneaux : poussée vers le haut et l'avant, une fois par anneau et par saut (le serveur donne les pièces)
local anneauxPris = {} -- [anneau] = true pendant le saut en cours

local function surAnneau(anneau: BasePart, hit: BasePart)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not (hrp and hum and hit:IsDescendantOf(char)) or hum.FloorMaterial ~= Enum.Material.Air then
		return
	end
	if anneauxPris[anneau] then
		return
	end
	anneauxPris[anneau] = true
	local poussee = anneau:GetAttribute("Poussee") or SautConfig.ANNEAU_POUSSEE
	local v = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(v.X + poussee / 2, math.max(v.Y, 0) + poussee, v.Z)
end

local function brancherAnneau(anneau: Instance)
	if anneau:IsA("BasePart") and anneau:IsDescendantOf(workspace) then
		anneau.Touched:Connect(function(hit)
			surAnneau(anneau, hit)
		end)
	end
end

function Saut.demarrer()
	UserInputService.JumpRequest:Connect(function()
		dernierSaut = os.clock()
	end)
	RunService.Heartbeat:Connect(chaqueImage)

	CollectionService:GetInstanceAddedSignal("Anneau"):Connect(brancherAnneau)
	for _, a in CollectionService:GetTagged("Anneau") do
		brancherAnneau(a)
	end
	-- De retour au sol : les anneaux redeviennent disponibles
	RunService.Heartbeat:Connect(function()
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.FloorMaterial ~= Enum.Material.Air and next(anneauxPris) then
			table.clear(anneauxPris)
		end
	end)
end

return Saut
