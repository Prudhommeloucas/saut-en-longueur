-- T-116 : dirigeable, canons à confettis, lanceurs de feux d'artifice, drapeaux du vent (vrais modèles).
-- Prépare les quatre modèles importés par Fichier → Importer (Workspace.<nom>) et les range dans
-- ReplicatedStorage.Assets.Decor, puis pose dans Workspace.Mondes.Monde1.Decor :
--  - Dirigeable (Model qui tourne autour du stade, hélices qui tournent) à 120 studs de haut ;
--  - CanonsConfettis : 6 paires le long de la piste (tag CanonConfettis sur la Part Bouche, à la sortie du fût) ;
--  - LanceursFeux : 8 derrière les tribunes (tag LanceurFeuArtifice, Palier = 0) ;
--  - les 25 drapeaux en blocs du bac (Decor.Drapeaux) remplacés par le modèle (tag DrapeauVent, drapeau qui flotte).
-- Les blocs remplacés sont rangés dans ServerStorage.Modeles.BlocsT116. Relançable, annulable par Ctrl+Z.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local decor = workspace.Mondes.Monde1.Decor
local COUL = {
	Orange = "FF7A1A",
	Blanc = "FFFFFF",
	Bleu = "1E90FF",
	CielClair = "BEE6FF",
	Or = "FFC83D",
	Gris = "5B6577",
	Nuit = "16213E",
	Fond = "2B2F38",
	Ardoise = "16213E",
}
local GROUPES = { "HeliceG_", "HeliceD_", "Pointes_", "Fut_", "Drapeau_" }

local function preparer(nom)
	local d = RS.Assets.Decor:FindFirstChild(nom)
	if d then
		return d
	end
	local m = workspace:FindFirstChild(nom)
	assert(m, nom .. " : importer d'abord le .fbx")
	for _, p in m:GetDescendants() do
		if p:IsA("MeshPart") then
			p.Parent = m
		end
	end
	for _, c in m:GetChildren() do
		if not c:IsA("MeshPart") then
			c:Destroy()
		end
	end
	for _, p in m:GetChildren() do
		p.Name = string.gsub(p.Name, "^" .. nom .. "_", "")
		local couleur = string.match(p.Name, "(%a+)$")
		if COUL[couleur] then
			p.Color = Color3.fromHex(COUL[couleur])
		end
		p.Material = Enum.Material.SmoothPlastic
		p.Anchored = true
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
	end
	local cf, taille = m:GetBoundingBox()
	m.WorldPivot = CFrame.new(cf.X, cf.Y - taille.Y / 2, cf.Z)
	m:PivotTo(CFrame.new())
	for _, prefixe in GROUPES do
		local g
		for _, p in m:GetChildren() do
			if p:IsA("MeshPart") and string.sub(p.Name, 1, #prefixe) == prefixe then
				if not g then
					g = Instance.new("Model")
					g.Name = string.sub(prefixe, 1, -2)
					g.Parent = m
				end
				p.Parent = g
			end
		end
		if g then
			local gc = g:GetBoundingBox()
			g.WorldPivot = gc
		end
	end
	m.Parent = RS.Assets.Decor
	return m
end

local function anime(objet, type_, attrs)
	CS:AddTag(objet, "DecorAnime")
	objet:SetAttribute("Type", type_)
	for k, v in attrs do
		objet:SetAttribute(k, v)
	end
end

local function dossier(nom)
	local f = decor:FindFirstChild(nom)
	if f then
		f:Destroy()
	end
	f = Instance.new("Folder")
	f.Name = nom
	f.Parent = decor
	return f
end

local rec = CHS:TryBeginRecording("T-116 décor animé du stade")
local range = SS.Modeles:FindFirstChild("BlocsT116") or Instance.new("Folder")
range.Name = "BlocsT116"
range.Parent = SS.Modeles

local D = preparer("stade_dirigeable")
local C = preparer("stade_canon")
local L = preparer("stade_lanceur")
local V = preparer("stade_drapeau_vent")

-- Dirigeable : il tourne autour du centre du stade (pivot du Model au centre du cercle), nez dans le sens du tour
local fd = dossier("Dirigeable")
local dir = D:Clone()
dir.Name = "Dirigeable"
dir:ScaleTo(1.3)
local centre = Vector3.new(260, 120, 0)
local rayon = 140
-- nez (-Z après import) tangent au cercle, banderole vers le centre
dir:PivotTo(CFrame.new(centre + Vector3.new(rayon, 0, 0)) * CFrame.Angles(0, 0, 0))
for _, h in { dir.HeliceG, dir.HeliceD } do
	anime(h, "Rotation", { Vitesse = 360, AxeRotation = Vector3.zAxis })
end
-- Banderoles : une Part invisible par flanc, collée au panneau blanc, texte sur la face tournée vers l'extérieur
local ballon = dir.Orange
for _, s in { -1, 1 } do
	local banderole = Instance.new("Part")
	banderole.Name = "Banderole"
	banderole.Anchored = true
	banderole.CanCollide = false
	banderole.CanTouch = false
	banderole.CanQuery = false
	banderole.Transparency = 1
	banderole.Size = Vector3.new(0.2, 5.6 * 1.3, 22 * 1.3)
	banderole.CFrame = CFrame.new(
		ballon.Position.X + s * (ballon.Size.X / 2 + 0.75 * 1.3),
		ballon.Position.Y + 1.3,
		ballon.Position.Z + 1.3
	)
	banderole.Parent = dir
	local sg = Instance.new("SurfaceGui")
	sg.Face = if s > 0 then Enum.NormalId.Right else Enum.NormalId.Left
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 20
	sg.LightInfluence = 0
	sg.Parent = banderole
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = Color3.fromHex("1E90FF")
	t.Text = "SAUT EN LONGUEUR"
	t.Parent = sg
end
dir.WorldPivot = CFrame.new(centre)
anime(dir, "Rotation", { Vitesse = 4 })
dir.Parent = fd

-- Canons : 6 paires le long de la piste (X 15 à 105), au bord des couloirs, le fût vers la piste et le ciel
local fc = dossier("CanonsConfettis")
for i = 0, 5 do
	local x = 15 + i * 18
	for _, s in { -1, 1 } do
		local c = C:Clone()
		c.Name = "Canon"
		c:ScaleTo(1.2)
		-- l'avant du canon (-Z) regarde vers la piste (Z = 0)
		c:PivotTo(CFrame.lookAt(Vector3.new(x, 0, s * 10.5), Vector3.new(x, 0, 0)))
		local _, t = c.Fut:GetBoundingBox()
		local bouche = Instance.new("Part")
		bouche.Name = "Bouche"
		bouche.Anchored = true
		bouche.CanCollide = false
		bouche.CanTouch = false
		bouche.CanQuery = false
		bouche.Transparency = 1
		bouche.Size = Vector3.one
		-- sortie du fût : haut du canon, un peu vers la piste, orientée à 45°
		bouche.CFrame = CFrame.lookAt(Vector3.new(x, t.Y + 1.6, s * 9), Vector3.new(x, t.Y + 11.6, s * -1))
		bouche.Parent = c
		CS:AddTag(bouche, "CanonConfettis")
		c.Parent = fc
	end
end

-- Lanceurs derrière les tribunes (Z ±48), discrets
local fl = dossier("LanceursFeux")
for i = 0, 3 do
	local x = 60 + i * 120
	for _, s in { -1, 1 } do
		local l = L:Clone()
		l.Name = "Lanceur"
		l:ScaleTo(1.5)
		l:PivotTo(CFrame.new(x, 0, s * 48))
		CS:AddTag(l, "LanceurFeuArtifice")
		l:SetAttribute("Palier", 0)
		l.Parent = fl
	end
end

-- Drapeaux du bac : chaque mât en bloc est remplacé par le modèle (drapeau tendu vers +X, sens du saut)
local blocs = decor:FindFirstChild("Drapeaux")
if blocs then
	local fv = dossier("DrapeauxVent")
	for _, p in blocs:GetChildren() do
		if p.Name == "Mat" then
			local d = V:Clone()
			d.Name = "DrapeauVent"
			d:PivotTo(CFrame.new(p.Position.X, -0.2, p.Position.Z))
			-- le pivot du modèle est au centre de sa boîte : on recale pour que le mât tombe sur l'ancien
			local ecart = Vector3.new(p.Position.X - d.Gris.Position.X, 0, p.Position.Z - d.Gris.Position.Z)
			d:PivotTo(d:GetPivot() + ecart)
			local dr = d.Drapeau
			dr.WorldPivot = CFrame.new(p.Position.X, 10.2, p.Position.Z)
			anime(dr, "Balancement", { Amplitude = 14, Vitesse = 0.6, AxeRotation = Vector3.yAxis })
			CS:AddTag(d, "DrapeauVent")
			d.Parent = fv
		end
	end
	blocs.Parent = range
end

if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
return string.format(
	"dirigeable 1, canons %d, lanceurs %d, drapeaux %d",
	#fc:GetChildren(),
	#fl:GetChildren(),
	decor:FindFirstChild("DrapeauxVent") and #decor.DrapeauxVent:GetChildren() or 0
)
