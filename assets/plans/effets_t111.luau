-- T-111 : effets visuels du saut, construits dans ReplicatedStorage.Assets.Effets (relançable : reconstruit le dossier).
-- Lus par Shared/Util/Effets : une Attachment par effet ponctuel (chaque ParticleEmitter a un attribut « Emission » :
-- nombre de particules émises d'un coup), une Attachment par effet continu, un Trail pour la traînée du corps.
-- Textures intégrées à Roblox (rbxasset://textures/particles/…), aucune image à publier.
local CHS = game:GetService("ChangeHistoryService")
local RS = game:GetService("ReplicatedStorage")

local T = "rbxasset://textures/particles/"
local function seq(...)
	local v = { ... }
	if #v == 1 then
		return NumberSequence.new(v[1])
	end
	local kp = {}
	for i, x in v do
		table.insert(kp, NumberSequenceKeypoint.new((i - 1) / (#v - 1), x))
	end
	return NumberSequence.new(kp)
end

local function emetteur(parent, nom, r)
	local e = Instance.new("ParticleEmitter")
	e.Name = nom
	e.Enabled = r.Enabled or false
	e.Rate = r.Rate or 0
	e.Texture = T .. r.Texture
	e.Color = r.Color
	e.Size = r.Size
	e.Transparency = r.Transparency or seq(0, 1)
	e.Lifetime = r.Lifetime
	e.Speed = r.Speed or NumberRange.new(0)
	e.SpreadAngle = r.SpreadAngle or Vector2.zero
	e.Acceleration = r.Acceleration or Vector3.zero
	e.Drag = r.Drag or 0
	e.LightEmission = r.LightEmission or 0
	e.Rotation = r.Rotation or NumberRange.new(0)
	e.RotSpeed = r.RotSpeed or NumberRange.new(0)
	e.EmissionDirection = r.EmissionDirection or Enum.NormalId.Top
	e.Orientation = r.Orientation or Enum.ParticleOrientation.FacingCamera
	e.Squash = r.Squash or seq(0)
	e.ZOffset = r.ZOffset or 0
	if r.Emission then
		e:SetAttribute("Emission", r.Emission)
	end
	e.Parent = parent
	return e
end

local function attache(parent, nom)
	local a = Instance.new("Attachment")
	a.Name = nom
	a.Parent = parent
	return a
end

local SABLE = Color3.fromRGB(232, 205, 140)
local OR = Color3.fromRGB(255, 200, 61)

local rec = CHS:TryBeginRecording("T-111 effets du saut")
local assets = RS:FindFirstChild("Assets") or Instance.new("Folder")
assets.Name = "Assets"
assets.Parent = RS
local ancien = assets:FindFirstChild("Effets")
if ancien then
	ancien:Destroy()
end
local dossier = Instance.new("Folder")
dossier.Name = "Effets"

-- Sable : gerbe de grains, nuage de poussière, onde au sol (échelle selon la vitesse d'arrivée)
local sable = attache(dossier, "Sable")
emetteur(sable, "Gerbe", {
	Texture = "SquareParticle.png",
	Color = ColorSequence.new(SABLE, Color3.fromRGB(205, 170, 105)),
	Size = seq(0.35, 0.2),
	Transparency = seq(0, 0, 1),
	Lifetime = NumberRange.new(0.6, 1.1),
	Speed = NumberRange.new(15, 35),
	SpreadAngle = Vector2.new(50, 50),
	Acceleration = Vector3.new(0, -90, 0),
	Drag = 1,
	Rotation = NumberRange.new(0, 360),
	RotSpeed = NumberRange.new(-200, 200),
	Emission = 45,
})
emetteur(sable, "Nuage", {
	Texture = "smoke_main.dds",
	Color = ColorSequence.new(SABLE),
	Size = seq(2, 5),
	Transparency = seq(0.35, 1),
	Lifetime = NumberRange.new(1, 1.6),
	Speed = NumberRange.new(4, 10),
	SpreadAngle = Vector2.new(90, 90),
	Acceleration = Vector3.new(0, 2, 0),
	Drag = 3,
	Rotation = NumberRange.new(0, 360),
	RotSpeed = NumberRange.new(-30, 30),
	Emission = 14,
})
emetteur(sable, "Onde", {
	Texture = "explosion01_shockwave_main.dds",
	Color = ColorSequence.new(Color3.fromRGB(255, 240, 210)),
	Size = seq(1, 9),
	Transparency = seq(0.3, 1),
	Lifetime = NumberRange.new(0.45),
	Speed = NumberRange.new(0.01),
	Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
	Emission = 1,
})

-- Confettis du record : cinq couleurs du jeu qui tournoient, et des étoiles dorées
local confettis = attache(dossier, "Confettis")
for nom, c in {
	Orange = Color3.fromHex("FF7A1A"),
	Bleu = Color3.fromHex("1E90FF"),
	Or = Color3.fromHex("FFC83D"),
	Violet = Color3.fromHex("9B5CFF"),
	Blanc = Color3.fromHex("FFFFFF"),
} do
	emetteur(confettis, "Confettis" .. nom, {
		Texture = "SquareParticle.png",
		Color = ColorSequence.new(c),
		Size = seq(0.55),
		Transparency = seq(0, 0, 0, 1),
		Lifetime = NumberRange.new(2.5, 3.5),
		Speed = NumberRange.new(30, 50),
		SpreadAngle = Vector2.new(30, 30),
		Acceleration = Vector3.new(0, -30, 0),
		Drag = 1.2,
		Rotation = NumberRange.new(0, 360),
		RotSpeed = NumberRange.new(-300, 300),
		Squash = seq(0, 1, -1, 1, -1, 1, 0),
		Emission = 18,
	})
end
emetteur(confettis, "Etoiles", {
	Texture = "sparkles_main.dds",
	Color = ColorSequence.new(OR),
	Size = seq(1.2, 0),
	Lifetime = NumberRange.new(1, 1.6),
	Speed = NumberRange.new(20, 35),
	SpreadAngle = Vector2.new(40, 40),
	Acceleration = Vector3.new(0, -20, 0),
	LightEmission = 1,
	Emission = 20,
})

-- Appel parfait : anneau doré au sol, éclat d'étoiles, gerbe d'étincelles vers l'avant et le haut
local appel = attache(dossier, "AppelParfait")
emetteur(appel, "Anneau", {
	Texture = "explosion01_shockwave_main.dds",
	Color = ColorSequence.new(OR),
	Size = seq(1, 8),
	Transparency = seq(0, 1),
	Lifetime = NumberRange.new(0.35),
	Speed = NumberRange.new(0.01),
	Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
	LightEmission = 1,
	Emission = 1,
})
emetteur(appel, "Eclat", {
	Texture = "sparkles_main.dds",
	Color = ColorSequence.new(Color3.fromRGB(255, 245, 190), OR),
	Size = seq(1.4, 0),
	Lifetime = NumberRange.new(0.5, 0.8),
	Speed = NumberRange.new(10, 20),
	SpreadAngle = Vector2.new(180, 180),
	Drag = 2,
	LightEmission = 1,
	Emission = 30,
})
emetteur(appel, "Etincelles", {
	Texture = "fire_sparks_main.dds",
	Color = ColorSequence.new(OR),
	Size = seq(0.6, 0),
	Lifetime = NumberRange.new(0.4, 0.7),
	Speed = NumberRange.new(15, 30),
	SpreadAngle = Vector2.new(60, 60),
	Acceleration = Vector3.new(0, -40, 0),
	LightEmission = 1,
	Emission = 20,
})

-- Aura du saut rare : paillettes dorées autour du joueur et lueur, tant que le saut rare dure
local aura = attache(dossier, "AuraDoree")
emetteur(aura, "Paillettes", {
	Enabled = true,
	Rate = 45,
	Texture = "sparkles_main.dds",
	Color = ColorSequence.new(Color3.fromRGB(255, 245, 180), OR),
	Size = seq(1.6, 0),
	Lifetime = NumberRange.new(0.6, 1),
	Speed = NumberRange.new(3, 6),
	SpreadAngle = Vector2.new(180, 180),
	Drag = 2,
	LightEmission = 1,
	ZOffset = 1,
})
local lueur = Instance.new("PointLight")
lueur.Name = "Lueur"
lueur.Color = OR
lueur.Range = 10
lueur.Brightness = 1.5
lueur.Parent = aura

-- Traînée du corps, tendue de la tête aux hanches (Shared/Util/Effets.trainee pose les attaches)
local trainee = Instance.new("Trail")
trainee.Name = "Trainee"
trainee.Enabled = false
trainee.Lifetime = 0.45
trainee.MinLength = 0.1
trainee.FaceCamera = true
trainee.LightEmission = 0.3
trainee.WidthScale = seq(1, 0)
trainee.Transparency = seq(0.1, 1)
trainee.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 160, 60))
trainee.Parent = dossier

dossier.Parent = assets
if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
local noms = {}
for _, c in dossier:GetChildren() do
	table.insert(noms, c.Name)
end
return "Assets.Effets : " .. table.concat(noms, ", ")
