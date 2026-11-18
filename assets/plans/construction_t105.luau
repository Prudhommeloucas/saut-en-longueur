-- T-105 : stade du monde 1 en blocs, d'après la toile « Plan du stade » (lien dans Construction du monde 1).
-- À lancer en mode Édition (MCP ou barre de commande). Ne fait rien si le stade existe déjà (Bac.Bordure).
-- Ce qui est remplacé est rangé dans ServerStorage.Modeles.BlocsT105, pas supprimé. Ctrl+Z annule tout.
local CHS = game:GetService("ChangeHistoryService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local m = workspace.Mondes.Monde1
if m.Bac:FindFirstChild("Bordure") then
	return "Le stade T-105 existe déjà : rien à faire."
end
local log = {}
local enregistrement = CHS:TryBeginRecording("T-105 stade en blocs")

local BLEU = Color3.fromHex("1E90FF")
local OR = Color3.fromHex("FFC83D")
local ORANGE = Color3.fromHex("FF7A1A")
local BRIQUE = Color3.fromHex("C8552D")
local ROUGE = Color3.fromHex("E5484D")
local PIERRE = Color3.fromHex("D9D4C7")
local NUIT = Color3.fromHex("16213E")

local function dossier(parent, nom)
	local d = parent:FindFirstChild(nom)
	if not d then
		d = Instance.new("Folder")
		d.Name = nom
		d.Parent = parent
	end
	return d
end
local function bloc(props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	for k, v in props do
		if k ~= "Parent" then
			p[k] = v
		end
	end
	p.Parent = props.Parent
	return p
end
-- Texte peint sur une face latérale d'un bloc. Roblox plafonne le texte à 100 px :
-- la densité suit la hauteur du bloc pour que le texte la remplisse presque.
local function ecrire(part, face, texte, couleur)
	local g = Instance.new("SurfaceGui")
	g.Face = face
	g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	g.PixelsPerStud = math.clamp(110 / part.Size.Y, 4, 40)
	g.Parent = part
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = couleur
	t.Text = texte
	t.Parent = g
end

local stock = dossier(dossier(ServerStorage, "Modeles"), "BlocsT105")
local function ranger(objet, sousDossier)
	objet.Parent = dossier(stock, sousDossier)
end

-- 1. Ranger ce qui est remplacé : anciennes tribunes, ancienne arche, poteaux de 10 à 100 m, deux arbres gênants
for _, c in m.Decor.Tribunes:GetChildren() do
	ranger(c, "Tribunes")
end
for _, c in m.Piste.Arche:GetChildren() do
	ranger(c, "Arche")
end
for _, c in m.Bac.Marqueurs:GetChildren() do
	if c.Name:match("^Poteau") and c.Position.X <= 540 then
		ranger(c, "Poteaux")
	end
end
local function dansBoite(p, x1, x2, z1, z2)
	return p.Position.X >= x1 and p.Position.X <= x2 and p.Position.Z >= z1 and p.Position.Z <= z2
end
for _, c in m.Decor.ArbresPiste:GetChildren() do
	if c:IsA("BasePart") and (dansBoite(c, 375, 395, -46, -34) or dansBoite(c, 527, 547, 34, 46)) then
		ranger(c, "Arbres")
	end
end
table.insert(log, "Rangés dans ServerStorage.Modeles.BlocsT105 : tribunes, arche, poteaux 10 à 100 m, 2 arbres")

-- 2. Piste et planche : brique orange, planche blanche à bande rouge
m.Piste.Piste.Color = BRIQUE
m.Piste.Piste.Material = Enum.Material.SmoothPlastic
local planche = m.Piste.PlancheAppel
planche.Color = Color3.new(1, 1, 1)
bloc({
	Name = "BandePlanche",
	Size = Vector3.new(0.5, 0.12, planche.Size.Z),
	CFrame = CFrame.new(planche.Position.X + planche.Size.X / 2 - 0.25, planche.Position.Y + 0.02, planche.Position.Z),
	Color = ROUGE,
	CanCollide = false,
	CanQuery = false,
	CanTouch = false,
	Parent = m.Piste,
})

-- 3. Arche d'entrée en blocs : 8 de profondeur, 28 de large, 30 de haut
for _, cote in { -1, 1 } do
	bloc({
		Name = "Poteau",
		Size = Vector3.new(4, 30, 4),
		CFrame = CFrame.new(0, 15, cote * 13),
		Color = BLEU,
		Parent = m.Piste.Arche,
	})
end
local poutre = bloc({
	Name = "Poutre",
	Size = Vector3.new(8, 6, 30),
	CFrame = CFrame.new(0, 27, 0),
	Color = OR,
	Parent = m.Piste.Arche,
})
ecrire(poutre, Enum.NormalId.Left, "SAUT !", NUIT)

-- 4. Bordure blanche arrondie du bac, de 0 à 100 m
local bordure = dossier(m.Bac, "Bordure")
for _, cote in { -1, 1 } do
	bloc({
		Name = "Bordure",
		Shape = Enum.PartType.Cylinder,
		Size = Vector3.new(400, 1, 1),
		CFrame = CFrame.new(320, 0.1, cote * 20.5),
		Color = Color3.new(1, 1, 1),
		CanCollide = false,
		Parent = bordure,
	})
end

-- 5. Panneaux de distance côté nord (le côté sud a les drapeaux) : petits tous les 10 m, grand à 50 m
local panneaux = dossier(m.Bac, "Panneaux")
for metres = 10, 90, 10 do
	local x = 120 + metres * 4
	local grand = metres == 50
	local h = grand and 8 or 3
	bloc({
		Name = "Pied" .. metres,
		Size = Vector3.new(grand and 1 or 0.4, grand and 4 or 3, grand and 1 or 0.4),
		CFrame = CFrame.new(x, (grand and 4 or 3) / 2, -24),
		Color = Color3.fromHex("5B6577"),
		Parent = panneaux,
	})
	local p = bloc({
		Name = "Panneau" .. metres,
		Size = Vector3.new(grand and 1 or 0.5, h, grand and 5 or 4),
		CFrame = CFrame.new(x, (grand and 4 or 3) + h / 2, -24),
		Color = grand and ORANGE or OR,
		Parent = panneaux,
	})
	ecrire(p, Enum.NormalId.Left, metres .. " m", grand and Color3.new(1, 1, 1) or NUIT)
	ecrire(p, Enum.NormalId.Right, metres .. " m", grand and Color3.new(1, 1, 1) or NUIT)
end

-- 6. Tunnel de sortie à 100 m (X 500 à 540) : deux piliers et un linteau qu'on traverse en vol
local tunnel = dossier(m.Bac, "Tunnel")
for _, cote in { -1, 1 } do
	bloc({
		Name = "Pilier",
		Size = Vector3.new(40, 60, 38),
		CFrame = CFrame.new(520, 30, cote * 41),
		Color = PIERRE,
		Parent = tunnel,
	})
end
local linteau = bloc({
	Name = "Linteau",
	Size = Vector3.new(40, 12, 120),
	CFrame = CFrame.new(520, 66, 0),
	Color = PIERRE,
	CanCollide = false,
	CanQuery = false,
	Parent = tunnel,
})
ecrire(linteau, Enum.NormalId.Left, "100 m", ORANGE)
table.insert(log, "Arche, bordure, 9 panneaux et tunnel posés")

-- 7. Tribunes : le module de T-010 (20 de large), de X 10 à 490, des deux côtés, l'avant à Z ±27
local modele = ReplicatedStorage.Assets.Decor.tribune_module
local tribunes = m.Decor.Tribunes
local n = 0
for _, cote in { 1, -1 } do
	for i = 0, 23 do
		local t = modele:Clone()
		t.Name = "Tribune"
		local cf = CFrame.new(20 + 20 * i, 0, cote * 28.7)
		if cote == -1 then
			cf *= CFrame.Angles(0, math.pi, 0)
		end
		t:PivotTo(cf)
		t.Parent = tribunes
		n += 1
		if n % 8 == 0 then
			task.wait()
		end
	end
end
table.insert(log, n .. " modules de tribune posés")

if enregistrement then
	CHS:FinishRecording(enregistrement, Enum.FinishRecordingOperation.Commit)
end
return table.concat(log, "\n")
