-- Personnage : réglage à l'apparition et objets portés (T-203 : vrais modèles d'Assets.Equipement, propulseur
-- dans le dos, chaussures aux deux pieds), flammes et traînées.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local Sons = require(Config:WaitForChild("Sons"))
local EffetsConfig = require(Config:WaitForChild("Effets"))
local Effets = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("Effets"))
local Donnees = require(script.Parent.Donnees)

local dossierModeles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Equipement")

local Personnage = {}

local surPiste = {} -- [player] = dernier état connu, pour n'activer la traînée qu'au changement

-- Flamme, lueur et son dans une tuyère de jetpack (éteints par défaut)
local function ajouterFlamme(tuyere: BasePart, avecSon: boolean)
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

-- Traînée lumineuse derrière une semelle (éteinte par défaut), de `largeur` studs
local function ajouterTrainee(semelle: BasePart, largeur: number)
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(-largeur / 2, 0, 0)
	a0.Parent = semelle
	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(largeur / 2, 0, 0)
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

-- Copie prête à porter d'un modèle d'Assets.Equipement : pièces libres, sans masse ni collision, soudées à la Poignee
local function copieModele(id: string): Model?
	local modele = dossierModeles:FindFirstChild(id)
	if not (modele and modele:IsA("Model") and modele.PrimaryPart) then
		warn("Modèle d'équipement introuvable :", id)
		return nil
	end
	local m = modele:Clone()
	local poignee = m.PrimaryPart :: BasePart
	for _, d in m:GetDescendants() do
		if d:IsA("BasePart") then
			d.Anchored = false
			d.CanCollide = false
			d.CanTouch = false
			d.CanQuery = false
			d.Massless = true
			if d ~= poignee then
				local w = Instance.new("WeldConstraint")
				w.Part0 = poignee
				w.Part1 = d
				w.Parent = d
			end
		end
	end
	return m
end

-- Pose une copie : sa Poignee à `cf`, soudée à `cible`
local function poser(m: Model, cible: BasePart, cf: CFrame, parent: Instance)
	m:PivotTo(cf)
	local w = Instance.new("WeldConstraint")
	w.Part0 = cible
	w.Part1 = m.PrimaryPart
	w.Parent = m.PrimaryPart
	m.Parent = parent
end

-- Tuyère invisible sous le propulseur : les flammes et le son du jetpack y sont accrochés
local function ajouterTuyere(m: Model, parent: Instance)
	local cf, taille = m:GetBoundingBox()
	local t = Instance.new("Part")
	t.Name = "Tuyere"
	t.Size = Vector3.new(0.4, 0.2, 0.4)
	t.Transparency = 1
	t.CanCollide = false
	t.CanTouch = false
	t.CanQuery = false
	t.Massless = true
	t.CFrame = cf * CFrame.new(0, -taille.Y / 2, 0)
	local w = Instance.new("WeldConstraint")
	w.Part0 = m.PrimaryPart
	w.Part1 = t
	w.Parent = t
	t.Parent = parent
	ajouterFlamme(t, true)
end

-- Saut rare en cours (attribut « SautRare », posé par le service Saut au passage de la planche) :
-- aura dorée autour du joueur et traînée du corps à la couleur du saut rare (T-111)
function Personnage.majSautRare(player: Player)
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (hrp and hrp:IsA("BasePart")) then
		return
	end
	local id = player:GetAttribute("SautRare")
	local actif = type(id) == "string" and id ~= ""
	local aura = hrp:FindFirstChild("AuraDoree")
	if actif and not aura then
		Effets.attacher("AuraDoree", hrp)
	elseif not actif and aura then
		aura:Destroy()
	end
	local trainee = char:FindFirstChild("ObjetsSaut") and char.ObjetsSaut:FindFirstChild("Trainee")
	if trainee and trainee:IsA("Trail") then
		trainee.Color = if actif
			then EffetsConfig.TRAINEE_RARE[id] or EffetsConfig.TRAINEE_RARE.Dore
			else EffetsConfig.TRAINEE_NORMALE
	end
end

-- Porte les objets du joueur (attributs « Chaussures », « Propulseur » ; la tenue n'a pas encore de modèle, T-207)
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

	-- Traînée du corps (T-111) : dans ObjetsSaut, elle s'allume et s'éteint avec les autres traînées (sur la piste)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp:IsA("BasePart") then
		Effets.trainee("Trainee", hrp, EffetsConfig.TRAINEE_HAUTEUR, dossier)
		Personnage.majSautRare(player)
	end

	local propulseur = player:GetAttribute("Propulseur")
	local torse = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if propulseur and torse and torse:IsA("BasePart") then
		local m = copieModele(propulseur)
		if m then
			-- La plaque du propulseur contre le dos : l'arrière du torse est son +Z
			poser(m, torse, torse.CFrame * CFrame.new(0, 0, torse.Size.Z / 2), dossier)
			ajouterTuyere(m, dossier)
		end
	end

	local chaussures = player:GetAttribute("Chaussures")
	if chaussures then
		for _, nom in { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" } do
			local pied = char:FindFirstChild(nom)
			if pied and pied:IsA("BasePart") then
				local m = copieModele(chaussures)
				if m then
					-- La Poignee est au centre du dessus de la semelle : sous le pied, pointe vers l'avant (-Z)
					poser(m, pied, pied.CFrame * CFrame.new(0, -pied.Size.Y / 2, 0), dossier)
					ajouterTrainee(m.PrimaryPart, 1.2)
				end
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
	player:GetAttributeChangedSignal("SautRare"):Connect(function()
		Personnage.majSautRare(player)
	end)
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
