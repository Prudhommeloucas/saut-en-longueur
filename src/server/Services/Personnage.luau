-- Personnage : réglage à l'apparition et objets portés (jetpack, semelles), flammes et traînées.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local Sons = require(Config:WaitForChild("Sons"))
local Donnees = require(script.Parent.Donnees)

local Personnage = {}

local surPiste = {} -- [player] = dernier état connu, pour n'activer la traînée qu'au changement

local function decor(nom: string, taille: Vector3, couleur: Color3, materiau: Enum.Material): Part
	local p = Instance.new("Part")
	p.Name = nom
	p.Size = taille
	-- Style blocs à studs : plastique classique, studs dessus, couleur BrickColor la plus proche.
	-- Le néon reste pour ce qui doit briller (tuyères, semelles).
	p.BrickColor = BrickColor.new(couleur)
	p.Material = if materiau == Enum.Material.Neon then Enum.Material.Neon else Enum.Material.Plastic
	p.TopSurface = Enum.SurfaceType.Studs
	p.BottomSurface = Enum.SurfaceType.Inlet
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	return p
end

local function souder(p: Part, cible: BasePart, decalage: CFrame, parent: Instance)
	p.CFrame = cible.CFrame * decalage
	local w = Instance.new("WeldConstraint")
	w.Part0 = cible
	w.Part1 = p
	w.Parent = p
	p.Parent = parent
end

-- Flamme, lueur et son dans une tuyère de jetpack (éteints par défaut)
local function ajouterFlamme(tuyere: Part, avecSon: boolean)
	local f = Instance.new("ParticleEmitter")
	f.Name = "Flamme"
	f.Enabled = false
	f.Texture = "rbxasset://textures/particles/fire_main.dds"
	f.EmissionDirection = Enum.NormalId.Bottom
	f.Color = ColorSequence.new(Color3.fromRGB(255, 230, 120), Color3.fromRGB(255, 90, 20))
	f.LightEmission = 1
	f.Rate = 90
	f.Lifetime = NumberRange.new(0.25, 0.45)
	f.Speed = NumberRange.new(10, 16)
	f.SpreadAngle = Vector2.new(8, 8)
	f.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.1), NumberSequenceKeypoint.new(1, 0) })
	f.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
	f.Parent = tuyere
	local l = Instance.new("PointLight")
	l.Name = "Lueur"
	l.Enabled = false
	l.Color = Color3.fromRGB(255, 150, 50)
	l.Range = 14
	l.Brightness = 2
	l.Parent = tuyere
	if avecSon then
		local s = Instance.new("Sound")
		s.Name = "SonJetpack"
		s.SoundId = Sons.Jetpack
		s.Looped = true
		s.Volume = 1.2
		s.PlaybackSpeed = 1.6
		s.RollOffMaxDistance = 150
		s.Parent = tuyere
	end
end

-- Traînée lumineuse derrière une semelle (éteinte par défaut)
local function ajouterTrainee(semelle: Part)
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(-semelle.Size.X / 2, 0, 0)
	a0.Parent = semelle
	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(semelle.Size.X / 2, 0, 0)
	a1.Parent = semelle
	local t = Instance.new("Trail")
	t.Name = "Trainee"
	t.Enabled = false
	t.Attachment0 = a0
	t.Attachment1 = a1
	t.Lifetime = 0.5
	t.LightEmission = 1
	t.Color = ColorSequence.new(Color3.fromRGB(255, 190, 60), Color3.fromRGB(255, 90, 20))
	t.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	t.Parent = semelle
end

function Personnage.activerJetpack(char: Model, actif: boolean)
	local obj = char:FindFirstChild("ObjetsSaut")
	if not obj then
		return
	end
	for _, d in obj:GetDescendants() do
		if d.Name == "Flamme" or d.Name == "Lueur" then
			d.Enabled = actif
		elseif d.Name == "SonJetpack" then
			if actif then
				d:Play()
			else
				d:Stop()
			end
		end
	end
end

local function activerTrainees(char: Model, actif: boolean)
	local obj = char:FindFirstChild("ObjetsSaut")
	if not obj then
		return
	end
	for _, d in obj:GetDescendants() do
		if d:IsA("Trail") then
			d.Enabled = actif
		end
	end
end

-- Allume les traînées sur la piste, les éteint ailleurs (seulement au changement)
function Personnage.majTrainees(player: Player, char: Model, sp: boolean)
	if surPiste[player] ~= sp then
		surPiste[player] = sp
		activerTrainees(char, sp)
	end
end

function Personnage.equiperVisuels(player: Player)
	local char = player.Character
	if not char then
		return
	end
	local ancien = char:FindFirstChild("ObjetsSaut")
	if ancien then
		ancien:Destroy()
	end
	local dossier = Instance.new("Model")
	dossier.Name = "ObjetsSaut"
	dossier.Parent = char

	if player:GetAttribute("Jetpack") then
		local torse = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		if torse then
			local gris = Color3.fromRGB(90, 90, 100)
			souder(
				decor("JetpackG", Vector3.new(0.7, 1.6, 0.7), gris, Enum.Material.Metal),
				torse,
				CFrame.new(-0.45, 0, 0.85),
				dossier
			)
			souder(
				decor("JetpackD", Vector3.new(0.7, 1.6, 0.7), gris, Enum.Material.Metal),
				torse,
				CFrame.new(0.45, 0, 0.85),
				dossier
			)
			local feu = Color3.fromRGB(255, 140, 30)
			local tuyereG = decor("TuyereG", Vector3.new(0.5, 0.3, 0.5), feu, Enum.Material.Neon)
			souder(tuyereG, torse, CFrame.new(-0.45, -0.95, 0.85), dossier)
			ajouterFlamme(tuyereG, true)
			local tuyereD = decor("TuyereD", Vector3.new(0.5, 0.3, 0.5), feu, Enum.Material.Neon)
			souder(tuyereD, torse, CFrame.new(0.45, -0.95, 0.85), dossier)
			ajouterFlamme(tuyereD, false)
		end
	end

	if player:GetAttribute("Chaussures") then
		local orange = Color3.fromRGB(255, 150, 40)
		for _, nom in { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" } do
			local pied = char:FindFirstChild(nom)
			if pied and pied:IsA("BasePart") then
				local bas = -pied.Size.Y / 2
				local semelle =
					decor("Semelle", Vector3.new(pied.Size.X + 0.2, 0.3, pied.Size.Z + 0.3), orange, Enum.Material.Neon)
				souder(semelle, pied, CFrame.new(0, bas, 0), dossier)
				ajouterTrainee(semelle)
			end
		end
	end
	surPiste[player] = nil -- force la boucle des stats à réappliquer l'état des traînées
end

local function surPersonnage(player: Player, char: Model)
	local hum = char:WaitForChild("Humanoid", 10)
	if not hum then
		return
	end
	hum.UseJumpPower = true
	char:WaitForChild("HumanoidRootPart", 10)
	task.wait(0.5) -- laisse le temps aux membres d'arriver
	while not Donnees.estCharge(player) and player.Parent do
		task.wait(0.1)
	end
	if player.Character == char then
		Personnage.equiperVisuels(player)
	end
end

local function surJoueur(player: Player)
	player.CharacterAdded:Connect(function(char)
		surPersonnage(player, char)
	end)
	if player.Character then
		task.spawn(surPersonnage, player, player.Character)
	end
end

function Personnage.demarrer()
	Players.PlayerAdded:Connect(surJoueur)
	for _, p in Players:GetPlayers() do
		task.spawn(surJoueur, p)
	end
	Players.PlayerRemoving:Connect(function(player)
		surPiste[player] = nil
	end)
end

return Personnage
