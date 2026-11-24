-- T-215 : voyage par paliers, première moitié, en blocs (plan validé le 2026-11-24, toile Claude Design
-- « Plan du parc et du lac »). Construit Workspace.Mondes.Monde1.Paliers.Parc et .Lac, et les arches de 200 et 300 m.
-- Relançable (reconstruit les deux Models), annulable par Ctrl+Z. Les arbres de ArbresPiste entre X 520 et 1340
-- sont rangés dans ServerStorage.Modeles.BlocsT215.
-- Repère : X le long du bac (1 m = 4 studs, 100 m = X 520), Z sur le côté, sable à Z ±20, dessus du sable Y = 0,
-- dessus de l'herbe Y = -0,2.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local SS = game:GetService("ServerStorage")

local monde = workspace.Mondes.Monde1
local OR = Color3.fromHex("FFC83D")
local ORANGE = Color3.fromHex("FF7A1A")
local BLEU = Color3.fromHex("1E90FF")
local NUIT = Color3.fromHex("16213E")
local BLANC = Color3.new(1, 1, 1)
local VERT = Color3.fromHex("2F8A45")
local TRONC = Color3.fromHex("7A4E26")

local function bloc(parent, nom, taille, cf, couleur, opts)
	opts = opts or {}
	local p = Instance.new("Part")
	p.Name = nom
	p.Size = taille
	p.CFrame = cf
	p.Color = couleur
	p.Material = opts.matiere or Enum.Material.SmoothPlastic
	p.Shape = opts.forme or Enum.PartType.Block
	p.Anchored = true
	p.CanCollide = opts.collision == true
	p.CanTouch = false
	p.CanQuery = opts.collision == true
	p.CastShadow = opts.ombre ~= false
	p.Reflectance = opts.reflet or 0
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function modele(parent, nom)
	local m = Instance.new("Model")
	m.Name = nom
	m.Parent = parent
	return m
end

local function anime(objet, type_, attrs)
	CS:AddTag(objet, "DecorAnime")
	objet:SetAttribute("Type", type_)
	for k, v in attrs do
		objet:SetAttribute(k, v)
	end
end

local function texte(part, face, contenu, couleur)
	local sg = Instance.new("SurfaceGui")
	sg.Face = face
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 25
	sg.LightInfluence = 0
	sg.Parent = part
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = couleur
	t.Text = contenu
	t.Parent = sg
end

local function arbre(parent, x, z, r)
	local m = modele(parent, "Arbre")
	local h = 4 + r * 0.6
	bloc(
		m,
		"Tronc",
		Vector3.new(h, 1.6, 1.6),
		CFrame.new(x, h / 2 - 0.2, z) * CFrame.Angles(0, 0, math.rad(90)),
		TRONC,
		{ forme = Enum.PartType.Cylinder, collision = true }
	)
	bloc(m, "Feuillage", Vector3.one * (r * 1.6), CFrame.new(x, h + r * 0.55, z), VERT, { forme = Enum.PartType.Ball })
	return m
end

local rec = CHS:TryBeginRecording("T-215 parc et lac en blocs")

-- Rangement des anciens arbres de la zone
local modeles = SS:FindFirstChild("Modeles") or Instance.new("Folder")
modeles.Name = "Modeles"
modeles.Parent = SS
local range = modeles:FindFirstChild("BlocsT215") or Instance.new("Folder")
range.Name = "BlocsT215"
range.Parent = modeles
for _, p in monde.Decor.ArbresPiste:GetChildren() do
	if p:IsA("BasePart") and p.Position.X > 520 and p.Position.X < 1340 then
		p.Parent = range
	end
end

local paliers = monde:FindFirstChild("Paliers") or Instance.new("Folder")
paliers.Name = "Paliers"
paliers.Parent = monde
for _, nom in { "Parc", "Lac", "Arches" } do
	local ancien = paliers:FindFirstChild(nom)
	if ancien then
		ancien:Destroy()
	end
end

-- Arches de palier (200 et 300 m) : piliers hors des murs, haut sans collision, distance écrite en grand
local arches = Instance.new("Folder")
arches.Name = "Arches"
for i, d in { 200, 300 } do
	local x = 120 + d * 4
	local m = modele(arches, "Arche" .. d)
	for _, s in { -1, 1 } do
		bloc(m, "Pilier", Vector3.new(8, 40, 8), CFrame.new(x, 19.8, s * 32), BLEU, { collision = true })
		bloc(m, "Chapeau", Vector3.new(9, 2, 9), CFrame.new(x, 40.8, s * 32), OR)
		local lanceur = bloc(m, "Lanceur", Vector3.new(2, 3, 2), CFrame.new(x, 1.3, s * 40), NUIT)
		CS:AddTag(lanceur, "LanceurFeuArtifice")
		lanceur:SetAttribute("Palier", i)
	end
	bloc(m, "Poutre", Vector3.new(8, 8, 72), CFrame.new(x, 36, 0), ORANGE)
	local plaque = bloc(m, "Plaque", Vector3.new(8.4, 6, 30), CFrame.new(x, 36, 0), OR)
	texte(plaque, Enum.NormalId.Left, d .. " m", NUIT)
	texte(plaque, Enum.NormalId.Right, d .. " m", NUIT)
	CS:AddTag(m, "ArchePalier")
	m:SetAttribute("Distance", d)
	m:SetAttribute("Monde", 1)
end
arches.Parent = paliers

-- Parc (100 à 200 m) ----------------------------------------------------------
local parc = modele(paliers, "Parc")
parc.ModelStreamingMode = Enum.ModelStreamingMode.Default
local arbres = modele(parc, "Arbres")
for _, a in
	{
		{ 570, 60, 9 },
		{ 590, 85, 7 },
		{ 560, 110, 10 },
		{ 620, 125, 8 },
		{ 640, -110, 9 },
		{ 600, -60, 8 },
		{ 560, -95, 10 },
		{ 700, 120, 9 },
		{ 740, 100, 7 },
		{ 780, 130, 10 },
		{ 820, -120, 9 },
		{ 860, -100, 8 },
		{ 760, -125, 8 },
		{ 860, 120, 9 },
		{ 890, 95, 7 },
		{ 650, -135, 7 },
		{ 580, -135, 8 },
	}
do
	arbre(arbres, a[1], a[2], a[3])
end
bloc(parc, "Allee", Vector3.new(360, 0.2, 6), CFrame.new(700, -0.1, -45), Color3.fromHex("C9A46A"))
for _, x in { 620, 660, 760, 800 } do
	local banc = modele(parc, "Banc")
	bloc(banc, "Assise", Vector3.new(8, 0.6, 2.4), CFrame.new(x, 1.6, -50.5), TRONC, { collision = true })
	bloc(banc, "Dossier", Vector3.new(8, 2, 0.5), CFrame.new(x, 2.8, -51.6), TRONC)
end
for _, f in { { 680, 40 }, { 720, 55 }, { 600, -30 }, { 880, -40 } } do
	bloc(
		parc,
		"Fleurs",
		Vector3.new(1.2, 8, 8),
		CFrame.new(f[1], 0.3, f[2]) * CFrame.Angles(0, 0, math.rad(90)),
		Color3.fromHex("FF8FB1"),
		{ forme = Enum.PartType.Cylinder }
	)
end
-- Kiosque à musique : socle, huit poteaux, toit qui tourne lentement
local kiosque = modele(parc, "Kiosque")
bloc(
	kiosque,
	"Socle",
	Vector3.new(1.5, 24, 24),
	CFrame.new(700, 0.55, -75) * CFrame.Angles(0, 0, math.rad(90)),
	BLANC,
	{ forme = Enum.PartType.Cylinder, collision = true }
)
for i = 0, 7 do
	local a = i * math.pi / 4
	bloc(
		kiosque,
		"Poteau",
		Vector3.new(0.8, 9, 0.8),
		CFrame.new(700 + math.cos(a) * 10.5, 5.8, -75 + math.sin(a) * 10.5),
		BLANC,
		{ collision = true }
	)
end
local toit = bloc(
	kiosque,
	"Toit",
	Vector3.new(3, 26, 26),
	CFrame.new(700, 11.8, -75) * CFrame.Angles(0, 0, math.rad(90)),
	ORANGE,
	{ forme = Enum.PartType.Cylinder }
)
anime(toit, "Rotation", { Vitesse = 8, AxeRotation = Vector3.xAxis }) -- cylindre couché : son axe X est vertical
-- Panneau du monde 2 à 150 m, tourné vers le joueur qui arrive (-X)
local panneau = modele(parc, "PanneauMonde2")
bloc(panneau, "Pied", Vector3.new(1, 6, 1), CFrame.new(720, 2.8, -36), NUIT, { collision = true })
local tableau = bloc(panneau, "Tableau", Vector3.new(1, 9, 20), CFrame.new(720, 10, -36), NUIT)
bloc(panneau, "Cadre", Vector3.new(0.8, 10, 21), CFrame.new(720.2, 10, -36), OR)
texte(tableau, Enum.NormalId.Left, "MONDE 2 · Plage des Alizés\nrecord 150 m", OR)
-- Montgolfières (pas de collision, |Z| ≥ 60)
for i, m in { { 620, 75, 70 }, { 780, -95, 95 }, { 880, 60, 110 } } do
	local g = modele(parc, "Montgolfiere")
	bloc(
		g,
		"Ballon",
		Vector3.one * 20,
		CFrame.new(m[1], m[3] + 14, m[2]),
		if i == 2 then BLEU else ORANGE,
		{ forme = Enum.PartType.Ball }
	)
	bloc(
		g,
		"Bande",
		Vector3.new(4, 20.4, 20.4),
		CFrame.new(m[1], m[3] + 14, m[2]) * CFrame.Angles(0, 0, math.rad(90)),
		OR,
		{ forme = Enum.PartType.Cylinder }
	)
	bloc(g, "Nacelle", Vector3.new(5, 4, 5), CFrame.new(m[1], m[3], m[2]), TRONC)
	g.WorldPivot = CFrame.new(m[1], m[3] + 8, m[2])
	anime(g, "Flottement", { Amplitude = 3, Vitesse = 0.15 })
end
-- Cerfs-volants tenus par un piquet
for _, k in { { 660, 48, 650, 90 }, { 840, -50, 830, -95 } } do
	local c = modele(parc, "CerfVolant")
	local haut = Vector3.new(k[1], 40, k[2])
	local bas = Vector3.new(k[3], 1, k[4])
	bloc(
		c,
		"Voile",
		Vector3.new(0.3, 6, 6),
		CFrame.new(haut) * CFrame.Angles(math.rad(45), 0, 0),
		Color3.fromHex("9B5CFF")
	)
	bloc(
		c,
		"Fil",
		Vector3.new(0.1, 0.1, (haut - bas).Magnitude),
		CFrame.lookAt((haut + bas) / 2, haut),
		BLANC,
		{ ombre = false }
	)
	bloc(parc, "Piquet", Vector3.new(0.5, 2, 0.5), CFrame.new(bas), Color3.fromHex("5B6577"))
	c.WorldPivot = CFrame.new(bas)
	anime(c, "Balancement", { Amplitude = 6, Vitesse = 0.25, AxeRotation = Vector3.xAxis })
end
-- Vol d'oiseaux qui tourne au-dessus du bac
local oiseaux = modele(parc, "Oiseaux")
for i = 0, 5 do
	local a = i * math.pi / 3
	bloc(
		oiseaux,
		"Oiseau",
		Vector3.new(2, 0.4, 1),
		CFrame.new(760 + math.cos(a) * 26, 70 + (i % 2) * 3, math.sin(a) * 26) * CFrame.Angles(0, -a, 0),
		BLANC,
		{ ombre = false }
	)
end
oiseaux.WorldPivot = CFrame.new(760, 70, 0)
anime(oiseaux, "Rotation", { Vitesse = 12 })

-- Lac (200 à 300 m) -----------------------------------------------------------
local lac = modele(paliers, "Lac")
for _, s in { -1, 1 } do
	-- l'eau recouvre l'herbe de Z = 22 à 140 ; le sable devient une jetée
	bloc(
		lac,
		"Eau",
		Vector3.new(400, 0.4, 118),
		CFrame.new(1120, -0.3, s * 81),
		Color3.fromHex("4FA9E0"),
		{ reflet = 0.15, ombre = false }
	)
	for x = 930, 1310, 20 do
		bloc(
			lac,
			"Pilotis",
			Vector3.new(3.2, 1.2, 1.2),
			CFrame.new(x, -0.4, s * 21.8) * CFrame.Angles(0, 0, math.rad(90)),
			TRONC,
			{ forme = Enum.PartType.Cylinder }
		)
	end
	for x = 940, 1320, 35 do
		bloc(
			lac,
			"Roseaux",
			Vector3.new(4, 5, 5),
			CFrame.new(x + (s > 0 and 15 or 0), 1.6, s * 142) * CFrame.Angles(0, 0, math.rad(90)),
			Color3.fromHex("5E9E3A"),
			{ forme = Enum.PartType.Cylinder }
		)
	end
end
for _, b in { { 1000, 80 }, { 1160, -90 }, { 1260, 100 } } do
	local v = modele(lac, "Voilier")
	bloc(v, "Coque", Vector3.new(16, 3, 6), CFrame.new(b[1], 0.8, b[2]), BLANC)
	bloc(v, "Liseré", Vector3.new(16.2, 0.6, 6.2), CFrame.new(b[1], 0.2, b[2]), BLEU)
	bloc(v, "Mat", Vector3.new(0.6, 14, 0.6), CFrame.new(b[1], 9, b[2]), TRONC)
	bloc(v, "Voile", Vector3.new(7, 11, 0.3), CFrame.new(b[1] + 3.8, 9.5, b[2]), Color3.fromHex("FFF3D6"))
	v.WorldPivot = CFrame.new(b[1], 0, b[2])
	anime(v, "Balancement", { Amplitude = 4, Vitesse = 0.3, AxeRotation = Vector3.xAxis })
end
for _, c in { { 960, 40 }, { 968, 46 }, { 1100, -35 }, { 1106, -42 }, { 1112, -36 }, { 1230, 45 }, { 1237, 50 } } do
	local canard = modele(lac, "Canard")
	bloc(canard, "Corps", Vector3.new(2, 1.2, 1.4), CFrame.new(c[1], 0.4, c[2]), Color3.fromHex("FFD84A"))
	bloc(
		canard,
		"Tete",
		Vector3.one,
		CFrame.new(c[1] + 0.9, 1.3, c[2]),
		Color3.fromHex("FFD84A"),
		{ forme = Enum.PartType.Ball }
	)
	bloc(canard, "Bec", Vector3.new(0.6, 0.3, 0.5), CFrame.new(c[1] + 1.5, 1.2, c[2]), ORANGE)
	anime(canard, "Flottement", { Amplitude = 0.25, Vitesse = 0.6 })
end
for _, j in { { 1040, -55 }, { 1040, 55 }, { 1200, -55 }, { 1200, 55 } } do
	local jet = bloc(
		lac,
		"JetDEau",
		Vector3.new(0.6, 4, 4),
		CFrame.new(j[1], -0.05, j[2]) * CFrame.Angles(0, 0, math.rad(90)),
		Color3.fromHex("E8F7FF"),
		{ forme = Enum.PartType.Cylinder }
	)
	local e = Instance.new("ParticleEmitter")
	e.Name = "Eau"
	e.Texture = "rbxasset://textures/particles/smoke_main.dds"
	e.Color = ColorSequence.new(Color3.fromHex("E8F7FF"))
	e.EmissionDirection = Enum.NormalId.Right -- +X local = vers le haut (cylindre couché puis tourné)
	e.Rate = 35
	e.Lifetime = NumberRange.new(1.2, 1.6)
	e.Speed = NumberRange.new(28, 32)
	e.SpreadAngle = Vector2.new(6, 6)
	e.Acceleration = Vector3.new(0, -40, 0)
	e.Size = NumberSequence.new(1.2, 2.4)
	e.Transparency = NumberSequence.new(0.2, 1)
	e.Parent = jet
end

-- Collines qui cachent le bord, des deux côtés des deux paliers
local collines = modele(paliers.Parc, "Collines")
for x = 560, 1320, 60 do
	for _, s in { -1, 1 } do
		local r = 40 + (x % 120 == 0 and 14 or 0)
		bloc(
			collines,
			"Colline",
			Vector3.one * r * 2,
			CFrame.new(x, -r * 0.55, s * (160 + r * 0.6)),
			Color3.fromHex("4B974B"),
			{ forme = Enum.PartType.Ball }
		)
	end
end

if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
local n = 0
for _, d in paliers:GetDescendants() do
	if d:IsA("BasePart") then
		n += 1
	end
end
return n .. " Parts dans Paliers ; " .. #range:GetChildren() .. " Parts rangées dans BlocsT215"
