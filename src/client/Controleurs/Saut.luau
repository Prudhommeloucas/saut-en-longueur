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
local reculNormal = player.CameraMinZoomDistance -- distance minimale réglée dans StarterPlayer
local recul = reculNormal

-- Réception : un seul essai par saut, le premier nouvel appui pendant la descente au-dessus du sable
local essaiFait = false
local enDescente = false
local filtreBac = RaycastParams.new()
filtreBac.FilterType = Enum.RaycastFilterType.Include

-- Temps estimé avant que les pieds touchent le sable (nil si on monte ou s'il n'y a pas de sable dessous)
local function tempsAvantContact(hum: Humanoid, hrp: BasePart, monde: number): number?
	local vy = hrp.AssemblyLinearVelocity.Y
	if vy > 0 then
		return nil
	end
	filtreBac.FilterDescendantsInstances = Map.tous("Bac", monde)
	local res = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), filtreBac)
	if not res then
		return nil
	end
	local h = math.max(0, res.Distance - hum.HipHeight - hrp.Size.Y / 2)
	local g = workspace.Gravity
	local descente = -vy
	return (-descente + math.sqrt(descente * descente + 2 * g * h)) / g
end

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

		-- Caméra qui recule pendant le vol au-dessus du sable, puis revient
		local enVol = enLAir and ligne ~= nil and hrp.Position.X > ligne
		local cibleRecul = if enVol then CameraConfig.RECUL_VOL else reculNormal
		recul += (cibleRecul - recul) * math.min(1, dt * CameraConfig.RECUL_RAPIDITE)
		if math.abs(recul - reculNormal) < 0.05 then
			recul = reculNormal
		end
		if player.CameraMinZoomDistance ~= recul then
			player.CameraMinZoomDistance = recul
		end

		if ligne then
			Hud.distanceEnDirect(hrp.Position.X - ligne)
			Hud.majJaugeAppel((ligne - hrp.Position.X) / SautConfig.STUDS_PAR_METRE)
		end

		-- Indice de réception : cercle qui se referme à l'approche du sable
		if not enLAir then
			essaiFait = false
		end
		enDescente = enVol and hrp.AssemblyLinearVelocity.Y < 0
		Hud.majIndiceReception(if enDescente then tempsAvantContact(hum, hrp, monde) else nil, essaiFait)
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

-- Appel : au décollage près de la planche, la qualité multiplie la vitesse verticale du saut.
-- Le joueur la calcule pour que l'effet soit immédiat ; le serveur la juge lui-même pour le résultat.
local function surDecollage(hum: Humanoid, hrp: BasePart)
	local ligne = Map.ligneX(Map.mondeDe(player))
	if not ligne or hum.Health <= 0 then
		return
	end
	local avant = (ligne - hrp.Position.X) / SautConfig.STUDS_PAR_METRE
	local q = SautConfig.qualiteAppel(avant, player:GetAttribute("BonusZoneParfait"))
	if not q then
		return
	end
	Remotes.Appel:FireServer(hrp.Position.X)
	Hud.afficherAppel(q.id)
	-- La vitesse du saut est donnée par le moteur à l'étape physique suivante
	RunService.Heartbeat:Once(function()
		local v = hrp.AssemblyLinearVelocity
		if v.Y > 0 then
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, v.Y * q.multiplicateur, v.Z)
		end
	end)
end

local function surPersonnage(char: Model)
	local hum = char:WaitForChild("Humanoid") :: Humanoid
	local hrp = char:WaitForChild("HumanoidRootPart") :: BasePart
	hum.StateChanged:Connect(function(_, nouvel)
		if nouvel == Enum.HumanoidStateType.Jumping then
			surDecollage(hum, hrp)
		end
	end)
end

function Saut.demarrer()
	UserInputService.JumpRequest:Connect(function()
		-- Garder Saut enfoncé répète la demande à chaque image : seul un nouvel appui compte pour la réception
		local nouvelAppui = os.clock() - dernierSaut > 0.2
		dernierSaut = os.clock()
		if nouvelAppui and enDescente and not essaiFait then
			essaiFait = true
			Remotes.Reception:FireServer()
		end
	end)
	player.CharacterAdded:Connect(surPersonnage)
	if player.Character then
		task.spawn(surPersonnage, player.Character)
	end
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
