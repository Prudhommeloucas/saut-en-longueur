-- T-215 : remplace les blocs du parc et du lac (construction_t215.luau) par les vrais modèles.
-- 1. Prépare les neuf modèles importés par Fichier → Importer (Workspace.<nom>) : aplatis, meshes renommés
--    par leur couleur et colorés, sans collision, pivot au sol, rangés dans ReplicatedStorage.Assets.Decor ;
--    pièces mobiles regroupées (Toit, Nacelle, Voile, Drapeau).
-- 2. Pose : arches 200 et 300 m, arbres, kiosque, montgolfières, cerfs-volants, voiliers, canards, roseaux,
--    et 8 bouées le long de la jetée. Les blocs remplacés vont dans ServerStorage.Modeles.BlocsT215.
-- Relançable, annulable par Ctrl+Z. Blender (x, y, z) → Roblox (x, z, y) ; l'avant -Y de Blender est -Z.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local monde = workspace.Mondes.Monde1
local paliers = monde.Paliers
local range = SS.Modeles.BlocsT215
local alea = Random.new(215)

local COUL = {
	Bleu = "1E90FF",
	Or = "FFC83D",
	Blanc = "FFFFFF",
	Orange = "FF7A1A",
	Bois = "A0703C",
	Brun = "7A4E26",
	Vert = "4FB83A",
	VertClair = "8BD43A",
	Violet = "7B3FD6",
	Creme = "FFF3D6",
	Jaune = "FFD84A",
	Rouge = "E5484D",
	Noir = "1F2229",
	Lumiere = "FFB347",
	Roseau = "4E9A3A",
	Gris = "9AA3AE",
	Osier = "B07A45",
}
local GROUPES = { "Toit_", "Nacelle_", "Voile_", "Drapeau_" }

local function preparer(nom)
	local decor = RS.Assets.Decor
	local deja = decor:FindFirstChild(nom)
	if deja then
		return deja
	end
	local importe = workspace:FindFirstChild(nom)
	assert(importe, nom .. " : importer d'abord le .fbx")
	for _, p in importe:GetDescendants() do
		if p:IsA("MeshPart") then
			p.Parent = importe
		end
	end
	for _, c in importe:GetChildren() do
		if not c:IsA("MeshPart") then
			c:Destroy()
		end
	end
	for _, p in importe:GetChildren() do
		p.Name = string.gsub(p.Name, "^" .. nom .. "_", "")
		local couleur = string.match(p.Name, "(%a+)$")
		if COUL[couleur] then
			p.Color = Color3.fromHex(COUL[couleur])
		end
		p.Material = if couleur == "Lumiere" then Enum.Material.Neon else Enum.Material.SmoothPlastic
		p.Anchored = true
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
	end
	local cf, taille = importe:GetBoundingBox()
	importe.WorldPivot = CFrame.new(cf.X, cf.Y - taille.Y / 2, cf.Z)
	importe:PivotTo(CFrame.new())
	for _, prefixe in GROUPES do
		local m
		for _, p in importe:GetChildren() do
			if p:IsA("MeshPart") and string.sub(p.Name, 1, #prefixe) == prefixe then
				if not m then
					m = Instance.new("Model")
					m.Name = string.sub(prefixe, 1, -2)
					m.Parent = importe
				end
				p.Parent = m
			end
		end
	end
	importe.Parent = decor
	return importe
end

local function anime(objet, type_, attrs)
	CS:AddTag(objet, "DecorAnime")
	objet:SetAttribute("Type", type_)
	for k, v in attrs do
		objet:SetAttribute(k, v)
	end
end

local function collision(parent, taille, cf, forme)
	local p = Instance.new("Part")
	p.Name = "Collision"
	p.Size = taille
	p.CFrame = cf
	p.Shape = forme or Enum.PartType.Block
	p.Anchored = true
	p.Transparency = 1
	p.CanTouch = false
	p.CanQuery = false
	p.Parent = parent
	return p
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

local function poser(source, parent, nom, cf, echelle)
	local m = source:Clone()
	m.Name = nom
	if echelle and echelle ~= 1 then
		m:ScaleTo(echelle)
	end
	m:PivotTo(cf)
	m.Parent = parent
	return m
end

local function ranger(objet)
	objet.Parent = range
end

local rec = CHS:TryBeginRecording("T-215 vrais modèles du parc et du lac")
local M = {}
for _, nom in
	{
		"palier_arche",
		"parc_kiosque",
		"parc_arbre",
		"parc_montgolfiere",
		"parc_cerf_volant",
		"lac_voilier",
		"lac_canard",
		"lac_bouee",
		"lac_roseaux",
	}
do
	M[nom] = preparer(nom)
end

-- Arches : la largeur du modèle (X) passe en travers du bac (Z), plaques tournées vers ±X
for _, ancien in paliers.Arches:GetChildren() do
	local d = ancien:GetAttribute("Distance")
	if d and ancien:FindFirstChild("Pilier") then
		local x = 120 + d * 4
		local arche = poser(
			M.palier_arche,
			paliers.Arches,
			"Arche" .. d,
			CFrame.new(x, -0.2, 0) * CFrame.Angles(0, math.rad(90), 0)
		)
		CS:AddTag(arche, "ArchePalier")
		arche:SetAttribute("Distance", d)
		arche:SetAttribute("Monde", 1)
		for _, s in { -1, 1 } do
			collision(arche, Vector3.new(9, 40, 9), CFrame.new(x, 19.8, s * 32))
		end
		local plaque = Instance.new("Part")
		plaque.Name = "Plaque"
		plaque.Size = Vector3.new(7.2, 5, 18.6)
		plaque.CFrame = CFrame.new(x, 36.6, 0)
		plaque.Anchored = true
		plaque.Transparency = 1
		plaque.CanCollide = false
		plaque.CanTouch = false
		plaque.CanQuery = false
		plaque.Parent = arche
		texte(plaque, Enum.NormalId.Left, d .. " m", Color3.fromHex("16213E"))
		texte(plaque, Enum.NormalId.Right, d .. " m", Color3.fromHex("16213E"))
		for _, l in ancien:GetChildren() do
			if CS:HasTag(l, "LanceurFeuArtifice") then
				l.Parent = arche
			end
		end
		ranger(ancien)
	end
end

-- Arbres : un modèle par bloc, taille selon le feuillage du bloc, tourné au hasard
local parc = paliers.Parc
for _, a in parc.Arbres:GetChildren() do
	local f = a:FindFirstChild("Feuillage")
	if f then
		local r = f.Size.X / 1.6
		local x, z = f.Position.X, f.Position.Z
		local arbre = poser(
			M.parc_arbre,
			parc.Arbres,
			"ArbreParc",
			CFrame.new(x, -0.2, z) * CFrame.Angles(0, alea:NextNumber(0, 2 * math.pi), 0),
			r / 8.5
		)
		collision(
			arbre,
			Vector3.new(7 * r / 8.5, 2.4, 2.4),
			CFrame.new(x, 3.3 * r / 8.5, z) * CFrame.Angles(0, 0, math.rad(90)),
			Enum.PartType.Cylinder
		)
		ranger(a)
	end
end

-- Kiosque : marches vers le bac (+Z), toit qui tourne
local ancienK = parc:FindFirstChild("Kiosque")
if ancienK and ancienK:FindFirstChild("Socle") then
	local k = poser(M.parc_kiosque, parc, "Kiosque", CFrame.new(700, -0.2, -75) * CFrame.Angles(0, math.pi, 0))
	anime(k.Toit, "Rotation", { Vitesse = 8 })
	collision(
		k,
		Vector3.new(2.6, 24, 24),
		CFrame.new(700, 1.1, -75) * CFrame.Angles(0, 0, math.rad(90)),
		Enum.PartType.Cylinder
	)
	ranger(ancienK)
end

-- Montgolfières : nacelle à la hauteur du bloc, la deuxième en bleu
local n = 0
for _, g in parc:GetChildren() do
	if g.Name == "Montgolfiere" and g:FindFirstChild("Nacelle") and g.Nacelle:IsA("BasePart") then
		n += 1
		local p = g.Nacelle.Position
		local m = poser(
			M.parc_montgolfiere,
			parc,
			"Montgolfiere",
			CFrame.new(p.X, p.Y - 2, p.Z) * CFrame.Angles(0, alea:NextNumber(0, 2 * math.pi), 0)
		)
		if n == 2 then
			m.Orange.Color = Color3.fromHex(COUL.Bleu)
		end
		anime(m, "Flottement", { Amplitude = 3, Vitesse = 0.15 })
		ranger(g)
	end
end

-- Cerfs-volants : le modèle remplace la voile du bloc, face au bac ; le fil et le piquet restent
for _, c in parc:GetChildren() do
	local voile = c.Name == "CerfVolant" and c:FindFirstChild("Voile")
	if voile then
		local p = voile.Position
		local face = if p.Z > 0 then 0 else math.pi
		local kite = M.parc_cerf_volant:Clone()
		local _, t = kite:GetBoundingBox()
		kite:PivotTo(CFrame.new(p.X, p.Y - t.Y * 0.78, p.Z) * CFrame.Angles(0, face, 0))
		for _, d in kite:GetChildren() do
			d.Parent = c
		end
		kite:Destroy()
		voile.Parent = range
	end
end

-- Lac : voiliers, canards, roseaux
local lac = paliers.Lac
for _, v in lac:GetChildren() do
	if v.Name == "Voilier" and v:FindFirstChild("Coque") then
		local p = v.Coque.Position
		local m = poser(
			M.lac_voilier,
			lac,
			"Voilier",
			CFrame.new(p.X, -1.1, p.Z) * CFrame.Angles(0, alea:NextNumber(-0.6, 0.6), 0)
		)
		anime(m, "Balancement", { Amplitude = 4, Vitesse = 0.3, AxeRotation = Vector3.xAxis })
		ranger(v)
	elseif v.Name == "Canard" and v:FindFirstChild("Corps") then
		local p = v.Corps.Position
		local m = poser(
			M.lac_canard,
			lac,
			"Canard",
			CFrame.new(p.X, -0.6, p.Z) * CFrame.Angles(0, alea:NextNumber(0, 2 * math.pi), 0)
		)
		anime(m, "Flottement", { Amplitude = 0.25, Vitesse = 0.6 })
		ranger(v)
	elseif v.Name == "Roseaux" and v:IsA("BasePart") then
		local p = v.Position
		for _ = 1, 3 do
			local dx, dz = alea:NextNumber(-3, 3), alea:NextNumber(-3, 3)
			poser(
				M.lac_roseaux,
				lac,
				"Roseaux",
				CFrame.new(p.X + dx, -0.3, p.Z + dz) * CFrame.Angles(0, alea:NextNumber(0, 2 * math.pi), 0),
				alea:NextNumber(0.9, 1.3)
			)
		end
		ranger(v)
	end
end
-- Bouées le long de la jetée
for _, x in if lac:FindFirstChild("Bouee") then {} else { 960, 1060, 1160, 1280 } do
	for _, s in { -1, 1 } do
		local b = poser(M.lac_bouee, lac, "Bouee", CFrame.new(x, -1.3, s * 32))
		anime(b, "Flottement", { Amplitude = 0.2, Vitesse = 0.5 })
	end
end

if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
local meshes = 0
for _, d in paliers:GetDescendants() do
	if d:IsA("MeshPart") then
		meshes += 1
	end
end
return meshes .. " MeshParts posées dans Paliers ; " .. #range:GetChildren() .. " objets dans BlocsT215"
