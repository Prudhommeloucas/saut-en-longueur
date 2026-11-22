-- T-106 : remplace les blocs de l'anneau, de l'écran géant, des projecteurs et du public par les vrais modèles.
-- Lancé le 2026-11-22 dans la place partagée, en cinq morceaux (un par section) pour ne pas dépasser le délai du MCP.
-- Prérequis : les quatre FBX (assets/modeles/export/stade_*.fbx) importés dans le Workspace par Fichier → Importer.
-- Les blocs remplacés sont rangés dans ServerStorage.Modeles.BlocsT106, pas supprimés. Chaque section s'annule par Ctrl+Z.
local CHS = game:GetService("ChangeHistoryService")
local SS = game:GetService("ServerStorage")
local decor = game.ReplicatedStorage.Assets.Decor
local m = workspace.Mondes.Monde1

local function dossier(parent, nom)
	local d = parent:FindFirstChild(nom)
	if not d then
		d = Instance.new("Folder")
		d.Name = nom
		d.Parent = parent
	end
	return d
end
local stock = dossier(dossier(SS, "Modeles"), "BlocsT106")
local rec = CHS:TryBeginRecording("T-106 vrais modèles")

-- 1. Préparer les modèles importés : noms par couleur, couleurs, ancrés, sans contact, pivot au sol, rangés dans Assets.Decor
local COUL = {
	Or = "FFC83D",
	Blanc = "FFFFFF",
	Bleu = "1E90FF",
	Nuit = "16213E",
	Gris = "5B6577",
	Creme = "FFF8E7",
	Corps = "1E90FF",
	Peau = "F2C9A0",
	Charniere = "FFC83D",
	Chapeau = "FFC83D",
	Cerclages = "FFC83D",
	Tete = "16213E",
	Lampe = "FFF8E7",
}
local NOMS = { stade_projecteur = { Gris = "Mat", Bleu = "Bagues" }, stade_spectateur = { Peau = "Tete" } }
local PRIMAIRE = { stade_anneau = "Or", stade_ecran = "Nuit", stade_projecteur = "Tete", stade_spectateur = "Corps" }
for _, id in { "stade_anneau", "stade_ecran", "stade_projecteur", "stade_spectateur" } do
	local mdl = workspace:FindFirstChild(id)
	if mdl and not decor:FindFirstChild(id) then
		local cf, s = mdl:GetBoundingBox()
		for _, d in mdl:GetDescendants() do
			if d:IsA("MeshPart") then
				local suffixe = d.Name:sub(#id + 2)
				d.Color = Color3.fromHex(COUL[suffixe])
				d.Name = (NOMS[id] and NOMS[id][suffixe]) or suffixe
				d.Anchored = true
				d.CanCollide = (id == "stade_projecteur" and d.Name == "Mat")
				d.CanTouch = false
				d.CanQuery = false
				d.CastShadow = (id ~= "stade_spectateur" and id ~= "stade_anneau")
				d.Material = (d.Name == "Lampe") and Enum.Material.Neon or Enum.Material.SmoothPlastic
				d.Parent = mdl
			end
		end
		for _, c in mdl:GetChildren() do
			if not c:IsA("MeshPart") then
				c:Destroy()
			end
		end
		mdl.PrimaryPart = mdl[PRIMAIRE[id]]
		mdl.PrimaryPart.PivotOffset = mdl.PrimaryPart.CFrame:ToObjectSpace(CFrame.new(cf.X, cf.Y - s.Y / 2, cf.Z))
		mdl:PivotTo(CFrame.new())
		mdl.Parent = decor
	end
end

-- 2. Anneaux : le modèle (plan XY, face -Z) tourne d'un quart de tour pour faire face à la piste ; la Zone reste
local modeleAnneau = decor.stade_anneau
local _, tailleAnneau = modeleAnneau:GetBoundingBox()
for _, serie in m.Anneaux:GetChildren() do
	for _, a in serie:GetChildren() do
		local zone = a.Zone
		local couleur
		local blocs = Instance.new("Model")
		blocs.Name = serie.Name .. "_" .. a.Name
		for _, s in a:GetChildren() do
			if s.Name == "Segment" then
				couleur = s.Color
				s.Parent = blocs
			end
		end
		blocs.Parent = dossier(stock, "Anneaux")
		local rayon = zone.Size.Y / 2
		local c = modeleAnneau:Clone()
		c:ScaleTo(rayon / 6)
		c:PivotTo(
			CFrame.new(zone.Position)
				* CFrame.Angles(0, math.rad(90), 0)
				* CFrame.new(0, -tailleAnneau.Y * rayon / 12, 0)
		)
		for _, p in c:GetChildren() do
			if p.Name == "Or" and couleur then
				p.Color = couleur
			end
			p.Parent = a
		end
		c:Destroy()
		a.PrimaryPart = zone
	end
end

-- 3. Écran géant : posé sur l'arche (sommet à Y 34,5), tourné face à la place et à la piste ; Surface recalée sur l'écran
local ecran = m.Piste.EcranGeant
local blocsEcran = Instance.new("Model")
blocsEcran.Name = "EcranGeantBlocs"
for _, p in ecran:GetChildren() do
	if p:IsA("BasePart") and p.Name ~= "Surface" then
		p.Parent = blocsEcran
	end
end
blocsEcran.Parent = stock
local ce = decor.stade_ecran:Clone()
ce:PivotTo(CFrame.new(0, 34.5, 0) * CFrame.Angles(0, math.rad(90), 0))
local nuit
for _, p in ce:GetChildren() do
	p.Parent = ecran
	if p.Name == "Nuit" then
		nuit = p
	end
end
ce:Destroy()
ecran.Surface.CFrame = CFrame.new(nuit.Position)
ecran.Surface.Size = Vector3.new(1.7, 13.8, 27.8)
ecran.PrimaryPart = ecran.Surface

-- 4. Projecteurs : tournés vers le bac, tête inclinée autour de la charnière (Y 48) ; le SpotLight passe sur Lampe
local modeleProj = decor.stade_projecteur
local base0 = modeleProj:GetPivot()
local CHARNIERE = 48
local TETE = { Tete = true, Lampe = true, Cerclages = true, Chapeau = true }
for _, p in m.Decor.Projecteurs:GetChildren() do
	local x, z = p.Mat.Position.X, p.Mat.Position.Z
	local spot = p.Lampe:FindFirstChildOfClass("SpotLight")
	local blocs = Instance.new("Model")
	blocs.Name = p.Name
	for _, c in p:GetChildren() do
		c.Parent = blocs
	end
	blocs.Parent = dossier(stock, "Projecteurs")
	local cible = Vector3.new(x + (x < 250 and 60 or (x > 250 and -60 or 0)), 0, 0)
	local horiz = Vector3.new(cible.X - x, 0, cible.Z - z)
	local base = CFrame.new(x, 0, z) * CFrame.lookAt(Vector3.zero, horiz)
	local tete = CFrame.new(0, CHARNIERE, 0)
		* CFrame.Angles(-math.atan2(CHARNIERE, horiz.Magnitude), 0, 0)
		* CFrame.new(0, -CHARNIERE, 0)
	for _, piece in modeleProj:GetChildren() do
		local c = piece:Clone()
		local rel = base0:ToObjectSpace(piece.CFrame)
		c.CFrame = TETE[piece.Name] and (base * tete * rel) or (base * rel)
		c.Parent = p
	end
	spot:Clone().Parent = p.Lampe
	p.PrimaryPart = p.Tete
end

-- 5. Public : chaque bloc Corps + Tete devient le spectateur modélisé, mêmes couleurs, pieds sur le gradin
local modeleSpec = decor.stade_spectateur
local b0 = modeleSpec:GetPivot()
local relCorps, relTete = b0:ToObjectSpace(modeleSpec.Corps.CFrame), b0:ToObjectSpace(modeleSpec.Tete.CFrame)
for i, t in m.Decor.Tribunes:GetChildren() do
	local public = t:FindFirstChild("Public")
	if public and not public:GetAttribute("T106Modele") then
		local blocs = Instance.new("Model")
		blocs.Name = string.format("Module%02d", i)
		local corpsListe, tetes, nouveaux = {}, {}, {}
		for _, p in public:GetChildren() do
			if p.Name == "Corps" then
				table.insert(corpsListe, p)
			elseif p.Name == "Tete" then
				table.insert(tetes, p)
			end
		end
		for _, corps in corpsListe do
			local proche, d = nil, math.huge
			for _, h in tetes do
				local e = (h.Position - corps.Position).Magnitude
				if e < d then
					proche, d = h, e
				end
			end
			local base = corps.CFrame * CFrame.new(0, -1, 0)
			local c = modeleSpec.Corps:Clone()
			c.CFrame = base * relCorps
			c.Color = corps.Color
			local h = modeleSpec.Tete:Clone()
			h.CFrame = base * relTete
			h.Color = proche.Color
			table.insert(nouveaux, c)
			table.insert(nouveaux, h)
		end
		for _, p in public:GetChildren() do
			p.Parent = blocs
		end
		for _, p in nouveaux do
			p.Parent = public
		end
		blocs.Parent = dossier(stock, "Public")
		public:SetAttribute("T106Modele", true)
		task.wait()
	end
end

if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
return "Vrais modèles T-106 posés"
