-- T-206 : salle d'entraînement de la place centrale (plan validé le 2026-11-24, toile Claude Design
-- « Plan de la salle d'entraînement »). Relançable, annulable par Ctrl+Z.
--  1. Estrade VIP agrandie (40 × 20) devenue simple décor, avec deux zones dessus : VIPPuissance et VIPVitesse
--     (tag ZoneEntrainement, Palier = 4), marches, tapis rouge, cordons, panneau « VIP ×20 ».
--  2. Panneaux des zones réécrits d'après Config/Mondes (ils affichaient les anciens multiplicateurs).
--  3. Machines (si les modèles salle_cage, salle_presse, salle_tapis sont importés dans le Workspace ou déjà rangés
--     dans ReplicatedStorage.Assets.Decor) : posées sur le bord extérieur de chaque zone, finition selon le palier
--     (peint, chromé, doré sur socle lumineux), pièces mobiles taguées DecorAnime.
-- Blender (x, y, z) → Roblox (x, z, y) ; l'avant -Y de Blender est -Z dans Roblox.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")

local monde = workspace.Mondes.Monde1
local dossier = monde.Entrainement
local MONDES = require(RS.Shared.Config.Mondes)
local paliers = MONDES.LISTE[1].zones

local COUL = {
	Or = Color3.fromHex("FFC83D"),
	Tapis = Color3.fromHex("3A3F48"),
	Anthracite = Color3.fromHex("2B2F38"),
	Noir = Color3.fromHex("1F2229"),
	Blanc = Color3.fromHex("FFFFFF"),
	Metal = Color3.fromHex("B9C2CC"),
	Nuit = Color3.fromHex("16213E"),
	Orange = Color3.fromHex("FF7A1A"),
	Cyan = Color3.fromHex("3BE0FF"),
}
local CADRE = {
	salle_cage = Color3.fromHex("E5484D"),
	salle_presse = Color3.fromHex("1E90FF"),
	salle_tapis = Color3.fromHex("C7CFD8"),
}
local VIOLET = Color3.fromHex("3B2A55")
local ROUGE_TAPIS = Color3.fromHex("B0182A")
local OR = COUL.Or

-- Part réglée ; « part » reprend celle du même nom si elle existe (relançable), « neuf » en crée toujours une
local function regler(p, taille, cf, couleur, matiere, collision)
	p.Size = taille
	p.CFrame = cf
	p.Color = couleur
	p.Material = matiere or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = collision ~= false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	return p
end

local function part(parent, nom, taille, cf, couleur, matiere, collision)
	local p = parent:FindFirstChild(nom)
	if not (p and p:IsA("BasePart")) then
		p = Instance.new("Part")
		p.Name = nom
		p.Parent = parent
	end
	return regler(p, taille, cf, couleur, matiere, collision)
end

local function neuf(parent, nom, taille, cf, couleur, matiere, collision)
	local p = Instance.new("Part")
	p.Name = nom
	p.Parent = parent
	return regler(p, taille, cf, couleur, matiere, collision)
end

local function sousDossier(parent, nom)
	local f = parent:FindFirstChild(nom)
	if not f then
		f = Instance.new("Folder")
		f.Name = nom
		f.Parent = parent
	end
	return f
end

-- ------------------------------------------------------------------ 1. Estrade VIP
local function estrade()
	local E = Vector3.new(-90, 0, -108) -- centre au sol
	local L, P, H = 40, 20, 2
	local base = dossier:FindFirstChild("EstradeVIP")
	local ancienPanneau, ancienneEtincelle
	if base and CS:HasTag(base, "ZoneEntrainement") then
		-- ancienne estrade = ancienne zone : on garde son panneau et ses étincelles pour les nouvelles zones
		CS:RemoveTag(base, "ZoneEntrainement")
		for _, a in { "Multiplicateur", "Palier", "PasseRequis", "Stat", "RecordRequis" } do
			base:SetAttribute(a, nil)
		end
		ancienPanneau = base:FindFirstChild("Panneau")
		ancienneEtincelle = base:FindFirstChild("Etincelles")
	end
	base = part(dossier, "EstradeVIP", Vector3.new(L, H, P), CFrame.new(E + Vector3.new(0, H / 2, 0)), VIOLET)
	local deco = sousDossier(dossier, "DecorVIP")
	deco:ClearAllChildren()
	local haut = H
	local avant = E.Z + P / 2 -- côté place (+Z)
	-- bordure dorée (ouverte devant les marches)
	neuf(deco, "Bordure", Vector3.new(L, 0.4, 0.6), CFrame.new(E.X, haut + 0.2, E.Z - P / 2 + 0.3), OR)
	neuf(deco, "Bordure", Vector3.new(0.6, 0.4, P), CFrame.new(E.X - L / 2 + 0.3, haut + 0.2, E.Z), OR)
	neuf(deco, "Bordure", Vector3.new(0.6, 0.4, P), CFrame.new(E.X + L / 2 - 0.3, haut + 0.2, E.Z), OR)
	for _, s in { -1, 1 } do
		neuf(deco, "Bordure", Vector3.new(13, 0.4, 0.6), CFrame.new(E.X + s * 13.5, haut + 0.2, avant - 0.3), OR)
	end
	-- deux marches et le tapis rouge
	neuf(deco, "Marche", Vector3.new(12, 1.33, 1.5), CFrame.new(E.X, 0.665, avant + 0.75), VIOLET)
	neuf(deco, "Marche", Vector3.new(12, 0.67, 1.5), CFrame.new(E.X, 0.335, avant + 2.25), VIOLET)
	neuf(deco, "TapisRouge", Vector3.new(6, 0.05, 1.5), CFrame.new(E.X, 1.355, avant + 0.75), ROUGE_TAPIS, nil, false)
	neuf(deco, "TapisRouge", Vector3.new(6, 0.05, 1.5), CFrame.new(E.X, 0.695, avant + 2.25), ROUGE_TAPIS, nil, false)
	neuf(
		deco,
		"TapisRouge",
		Vector3.new(6, 0.05, 3),
		CFrame.new(E.X, haut + 0.025, avant - 1.5),
		ROUGE_TAPIS,
		nil,
		false
	)
	-- cordons de velours sur le devant, ouverts devant les marches
	local poteaux = {}
	for x = E.X - L / 2 + 1, E.X + L / 2 - 1, 4.5 do
		if math.abs(x - E.X) > 6.5 then
			table.insert(poteaux, x)
		end
	end
	for i, x in poteaux do
		local p = neuf(
			deco,
			"Poteau",
			Vector3.new(3, 0.5, 0.5),
			CFrame.new(x, haut + 1.5, avant - 1) * CFrame.Angles(0, 0, math.rad(90)),
			OR
		)
		p.Shape = Enum.PartType.Cylinder
		local suivant = poteaux[i + 1]
		if suivant and suivant - x < 5 then
			neuf(
				deco,
				"Cordon",
				Vector3.new(suivant - x, 0.25, 0.25),
				CFrame.new((x + suivant) / 2, haut + 2.4, avant - 1),
				ROUGE_TAPIS,
				nil,
				false
			)
		end
	end
	-- panneau « VIP ×20 » au fond, tourné vers la place
	for _, s in { -1, 1 } do
		neuf(deco, "MatPanneau", Vector3.new(0.8, 12, 0.8), CFrame.new(E.X + s * 13, haut + 6, E.Z - P / 2 + 1), OR)
	end
	local panneau = neuf(deco, "PanneauVIP", Vector3.new(30, 4, 0.6), CFrame.new(E.X, haut + 13, E.Z - P / 2 + 1), OR)
	local sg = Instance.new("SurfaceGui")
	sg.Name = "Affichage"
	sg.Face = Enum.NormalId.Back -- +Z, vers la place
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 40
	sg.LightInfluence = 0
	sg.Parent = panneau
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = VIOLET
	t.Text = "VIP ×" .. paliers[4].multiplicateur
	t.Parent = sg
	-- deux zones sur l'estrade
	local zones = {
		{ nom = "VIPPuissance", stat = "Puissance", x = E.X - 10, couleur = Color3.fromHex("C4281C") },
		{ nom = "VIPVitesse", stat = "Vitesse", x = E.X + 10, couleur = Color3.fromHex("0D69AC") },
	}
	for _, z in zones do
		local zp = part(dossier, z.nom, Vector3.new(16, 0.2, 14), CFrame.new(z.x, haut + 0.1, E.Z + 1), z.couleur)
		CS:AddTag(zp, "ZoneEntrainement")
		zp:SetAttribute("Stat", z.stat)
		zp:SetAttribute("Palier", 4)
		if ancienPanneau and not zp:FindFirstChild("Panneau") then
			ancienPanneau:Clone().Parent = zp
		end
		if ancienneEtincelle and not zp:FindFirstChild("Etincelles") then
			ancienneEtincelle:Clone().Parent = zp
		end
	end
	if ancienPanneau then
		ancienPanneau:Destroy()
	end
	if ancienneEtincelle then
		ancienneEtincelle:Destroy()
	end
end

-- ------------------------------------------------------------------ 2. Panneaux
local NOMS_PALIER = { "DÉBUTANT", "CONFIRMÉ", "ÉLITE", "VIP" }
local function panneaux()
	for _, z in CS:GetTagged("ZoneEntrainement") do
		if z:IsDescendantOf(dossier) then
			local palier = z:GetAttribute("Palier")
			local p = palier and paliers[palier]
			local texte = z:FindFirstChild("Panneau") and z.Panneau:FindFirstChild("Texte")
			if p and texte then
				local condition = if p.recordRequis
					then " · record " .. p.recordRequis .. " m"
					elseif p.passe then " · passe VIP"
					else ""
				texte.Text = string.upper(z:GetAttribute("Stat"))
					.. " · "
					.. NOMS_PALIER[palier]
					.. "\n×"
					.. p.multiplicateur
					.. condition
			end
		end
	end
end

-- ------------------------------------------------------------------ 3. Machines
local function preparer(nom)
	local decor = RS.Assets.Decor
	local deja = decor:FindFirstChild(nom)
	if deja then
		return deja
	end
	local importe = workspace:FindFirstChild(nom)
	if not importe then
		return nil
	end
	-- l'import pose un Model dans un Model : on aplatit
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
		p.Color = if couleur == "Cadre" then CADRE[nom] else (COUL[couleur] or p.Color)
		p.Material = if couleur == "Cyan" then Enum.Material.Neon else Enum.Material.SmoothPlastic
		p.Anchored = true
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
	end
	local cf, taille = importe:GetBoundingBox()
	importe.WorldPivot = CFrame.new(cf.X, cf.Y - taille.Y / 2, cf.Z)
	importe:PivotTo(CFrame.new())
	-- pièces mobiles regroupées : barre (monte et descend), plateau (bascule), écran (clignote)
	local function grouper(prefixe, nomModele)
		local m
		for _, p in importe:GetChildren() do
			if p:IsA("MeshPart") and string.sub(p.Name, 1, #prefixe) == prefixe then
				if not m then
					m = Instance.new("Model")
					m.Name = nomModele
					m.Parent = importe
				end
				p.Parent = m
			end
		end
		return m
	end
	local barre = grouper("Barre_", "Barre")
	if barre then
		CS:AddTag(barre, "DecorAnime")
		barre:SetAttribute("Type", "Flottement")
		barre:SetAttribute("Amplitude", 0.9)
		barre:SetAttribute("Vitesse", 0.4)
	end
	local plateau = grouper("Plateau_", "Plateau")
	if plateau then
		local pc, pt = plateau:GetBoundingBox()
		plateau.WorldPivot = CFrame.new(pc.X, pc.Y - pt.Y / 2, pc.Z + pt.Z / 2) -- bord arrière
		CS:AddTag(plateau, "DecorAnime")
		plateau:SetAttribute("Type", "Balancement")
		plateau:SetAttribute("Amplitude", 7)
		plateau:SetAttribute("Vitesse", 0.5)
		plateau:SetAttribute("AxeRotation", Vector3.xAxis)
	end
	local ecran = importe:FindFirstChild("Ecran_Cyan")
	if ecran then
		CS:AddTag(ecran, "DecorAnime")
		ecran:SetAttribute("Type", "Pulsation")
		ecran:SetAttribute("Amplitude", 0.04)
		ecran:SetAttribute("Vitesse", 1)
	end
	grouper("Bande_", "Bande")
	importe.Parent = decor
	return importe
end

-- Finition du cadre selon le palier
local FINITIONS = {
	peint = function(_cadre) end,
	chrome = function(cadre)
		cadre.Color = Color3.fromHex("C7CFD8")
		cadre.Material = Enum.Material.Metal
		cadre.Reflectance = 0.2
	end,
	or_ = function(cadre)
		cadre.Color = OR
		cadre.Material = Enum.Material.SmoothPlastic
		cadre.Reflectance = 0.25
	end,
}

-- Une machine par entrée : modèle, nombre, échelle, écart entre centres, finition
local MACHINES = {
	PuissanceDebutant = { modele = "salle_cage", n = 3, echelle = 0.85, ecart = 8.2, finition = "peint" },
	PuissanceConfirme = { modele = "salle_cage", n = 3, echelle = 0.85, ecart = 8.2, finition = "chrome" },
	PuissanceElite = { modele = "salle_cage", n = 2, echelle = 1.15, ecart = 12, finition = "or_", socle = true },
	VitesseDebutant = { modele = "salle_presse", n = 3, echelle = 1, ecart = 7.5, finition = "peint" },
	VitesseConfirme = { modele = "salle_tapis", n = 3, echelle = 1, ecart = 7, finition = "chrome" },
	VitesseElite = { modele = "salle_tapis", n = 2, echelle = 1.25, ecart = 9, finition = "or_", socle = true },
	VIPPuissance = { modele = "salle_cage", n = 1, echelle = 1.4, ecart = 0, finition = "or_", socle = true },
	VIPVitesse = { modele = "salle_tapis", n = 1, echelle = 1.2, ecart = 0, finition = "or_", socle = true },
}

local function machines()
	local modeles = {}
	for _, nom in { "salle_cage", "salle_presse", "salle_tapis" } do
		modeles[nom] = preparer(nom)
	end
	if not (modeles.salle_cage and modeles.salle_presse and modeles.salle_tapis) then
		return "machines non posées : importer d'abord salle_cage.fbx, salle_presse.fbx et salle_tapis.fbx"
	end
	local racine = sousDossier(dossier, "Machines")
	racine:ClearAllChildren()
	local poses = 0
	for nomZone, m in MACHINES do
		local zone = dossier:FindFirstChild(nomZone)
		if zone then
			-- bord extérieur : nord (-Z) pour la Puissance et l'estrade, sud (+Z) pour la Vitesse au sol
			local cote = if zone.Position.Z < 0 then -1 else 1
			local source = modeles[m.modele]
			local _, taille = source:GetBoundingBox()
			local profondeur = taille.Z * m.echelle
			local largeur = taille.X * m.echelle
			local socle = if m.socle then 0.4 else 0
			local dessus = zone.Position.Y + zone.Size.Y / 2
			local z = zone.Position.Z + cote * (zone.Size.Z / 2 - 1 - profondeur / 2)
			for i = 1, m.n do
				local x = zone.Position.X + (i - (m.n + 1) / 2) * m.ecart
				local pos = Vector3.new(x, dessus + socle, z)
				local machine = source:Clone()
				machine.Name = nomZone .. "_" .. i
				machine:ScaleTo(m.echelle)
				-- l'avant du modèle (-Z) regarde vers le centre de la zone ; le tapis, lui, a sa console au bord
				local regard = if m.modele == "salle_tapis" then cote else -cote
				machine:PivotTo(CFrame.lookAt(pos, pos + Vector3.new(0, 0, regard)))
				FINITIONS[m.finition](machine:FindFirstChild("Cadre"))
				-- collision : le cadre (le tapis : seulement le plateau, on peut monter dessus)
				local cadre = machine.Cadre
				local hauteur = if m.modele == "salle_tapis" then 1.3 * m.echelle else cadre.Size.Y
				local col = neuf(
					machine,
					"Collision",
					Vector3.new(cadre.Size.X, hauteur, cadre.Size.Z),
					CFrame.new(cadre.Position.X, pos.Y + hauteur / 2, cadre.Position.Z),
					OR,
					nil,
					true
				)
				col.Transparency = 1
				col.CanQuery = false
				if m.socle then
					neuf(
						machine,
						"Socle",
						Vector3.new(largeur + 1, socle, profondeur + 1),
						CFrame.new(x, dessus + socle / 2, z),
						Color3.fromHex("FFD24A"),
						Enum.Material.Neon,
						true
					)
				end
				machine.Parent = racine
				poses += 1
			end
		end
	end
	return poses .. " machines posées"
end

local rec = CHS:TryBeginRecording("T-206 salle d'entraînement")
local ok, res = pcall(function()
	estrade()
	panneaux()
	return machines()
end)
if rec then
	CHS:FinishRecording(rec, if ok then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
end
assert(ok, res)
return res
