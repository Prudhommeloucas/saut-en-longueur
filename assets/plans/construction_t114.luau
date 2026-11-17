-- T-114 : construit la place centrale du monde 1 en blocs, depuis le relevé assets/plans/monde1.md.
-- À lancer en mode Édition (MCP ou barre de commande). Ne fait rien si la place existe déjà (Spawn.SolPlace).
-- Les anciens objets du spawn sont rangés dans ServerStorage.Modeles.AncienSpawn, pas supprimés. Ctrl+Z annule tout.
local CS = game:GetService("CollectionService")
local CHS = game:GetService("ChangeHistoryService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local m = workspace.Mondes.Monde1
if m.Spawn:FindFirstChild("SolPlace") then
	return "La place centrale existe déjà : rien à faire."
end
local log = {}
local enregistrement = CHS:TryBeginRecording("T-114 place centrale")

local CENTRE = Vector3.new(-90, 0, 0)
local function plat(x, z)
	return Vector3.new(x, 0, z)
end
local function versCentre(pos: Vector3): CFrame
	local cible = Vector3.new(CENTRE.X, pos.Y, CENTRE.Z)
	return CFrame.lookAt(pos, cible)
end
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
local function taguer(objet, tag, attrs)
	CS:AddTag(objet, tag)
	for k, v in attrs or {} do
		objet:SetAttribute(k, v)
	end
end
local function texte(panneau, t)
	for _, d in panneau:GetDescendants() do
		if d:IsA("TextLabel") then
			d.Text = t
		end
	end
end

-- Couleurs du jeu
local ORANGE = Color3.fromRGB(255, 140, 0)
local ROUGE = Color3.fromRGB(196, 40, 28)
local BLEU = Color3.fromRGB(13, 105, 172)
local JAUNE = Color3.fromRGB(240, 200, 40)
local VIOLET = Color3.fromRGB(140, 80, 200)
local TURQUOISE = Color3.fromRGB(30, 200, 190)
local CREME = Color3.fromRGB(235, 225, 200)
local DALLES = Color3.fromRGB(214, 205, 186)
local OR = Color3.fromRGB(230, 180, 40)
local HERBE = m.Decor.Sol.Herbe.Color

-- Emprises des nouveaux éléments, pour ranger les arbres qui les gêneraient (centre X, Z, demi-largeur)
local EMPRISES = {
	{ -90, -108, 20 }, -- estrade VIP
	{ -212, 0, 28 }, -- panthéon
	{ -4, 40, 14 }, -- podium
	{ -4, -40, 14 }, -- panneaux de classement
	{ -172, 0, 18 }, -- portail
}
local function dansEmprise(x, z, marge)
	for _, e in EMPRISES do
		if math.abs(x - e[1]) < e[3] + marge and math.abs(z - e[2]) < e[3] + marge then
			return true
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------
-- 1. Ranger l'ancien spawn (gardé dans ServerStorage pour pouvoir revenir en arrière)
local stock = dossier(dossier(ServerStorage, "Modeles"), "AncienSpawn")
local ancienSpawn = m.Spawn.Spawn
local modeleZonePuissance = m.Entrainement.ZoneSquat
local modeleZoneVitesse = m.Entrainement.ZoneMollets
local ancienChaussures = m.Boutique.StandChaussures
local ancienJetpack = m.Boutique.StandJetpack

local function ranger(objet, sous)
	objet.Parent = dossier(stock, sous)
end
ranger(m.Spawn.SolSpawn, "Spawn")
for _, c in m.Entrainement:GetChildren() do
	ranger(c, "Entrainement")
end
for _, c in m.Boutique:GetChildren() do
	ranger(c, "Boutique")
end
for _, nom in { "Gym", "Lampadaires" } do
	local f = m.Decor:FindFirstChild(nom)
	if f then
		ranger(f, "Decor")
	end
end
-- Arbres dans la place ou sur une emprise : les trois Parts d'un arbre ont le même X et Z
local arbresRanges = 0
local arbresStock = dossier(dossier(stock, "Decor"), "Arbres")
for _, p in m.Decor.Arbres:GetChildren() do
	local d = (plat(p.Position.X, p.Position.Z) - CENTRE).Magnitude
	if d < 100 or dansEmprise(p.Position.X, p.Position.Z, 8) then
		p.Parent = arbresStock
		arbresRanges += 1
	end
end
table.insert(
	log,
	"Rangés dans ServerStorage.Modeles.AncienSpawn : sol, zones, racks, marches, stands, gym, lampadaires, "
		.. arbresRanges / 3
		.. " arbres"
)
task.wait()

----------------------------------------------------------------------------------------------------
-- 2. Sol : place ronde, rosace, herbe prolongée vers l'ouest, le nord et le sud
local spawnF = m.Spawn
local rot = CFrame.Angles(0, 0, math.rad(90)) -- l'axe d'un cylindre est X : on le met debout
bloc({
	Name = "SolPlace",
	Shape = Enum.PartType.Cylinder,
	Size = Vector3.new(1, 170, 170),
	CFrame = CFrame.new(CENTRE + Vector3.new(0, -0.45, 0)) * rot,
	Color = DALLES,
	Material = Enum.Material.Pavement,
	Parent = spawnF,
})
local anneaux = { { 18, ORANGE }, { 15, CREME }, { 9, BLEU }, { 4, JAUNE } }
for i, a in anneaux do
	bloc({
		Name = "Rosace",
		Shape = Enum.PartType.Cylinder,
		Size = Vector3.new(0.2, a[1] * 2, a[1] * 2),
		CFrame = CFrame.new(CENTRE + Vector3.new(0, 0.05 + i * 0.01, 0)) * rot,
		Color = a[2],
		Material = Enum.Material.SmoothPlastic,
		CanCollide = false,
		Parent = spawnF,
	})
end
local sol = m.Decor.Sol
bloc({
	Name = "HerbeOuest",
	Size = Vector3.new(250, 2, 500),
	Position = Vector3.new(-325, -1, 0),
	Color = HERBE,
	Material = m.Decor.Sol.Herbe.Material,
	Parent = sol,
})
bloc({
	Name = "HerbeNord",
	Size = Vector3.new(400, 2, 100),
	Position = Vector3.new(0, -1, -200),
	Color = HERBE,
	Material = m.Decor.Sol.Herbe.Material,
	Parent = sol,
})
bloc({
	Name = "HerbeSud",
	Size = Vector3.new(400, 2, 100),
	Position = Vector3.new(0, -1, 200),
	Color = HERBE,
	Material = m.Decor.Sol.Herbe.Material,
	Parent = sol,
})

-- Six points d'apparition en cercle autour du centre, tournés vers la piste
for k = 0, 5 do
	local a = math.rad(k * 60)
	local pos = CENTRE + Vector3.new(math.cos(a) * 10, 0.5, math.sin(a) * 10)
	local s = ancienSpawn:Clone()
	s.Name = "PointApparition"
	s.Size = Vector3.new(6, 1, 6)
	s.CFrame = CFrame.lookAt(pos, pos + Vector3.xAxis)
	s.Parent = spawnF
	taguer(s, "PointApparition", { Monde = 1 })
end
ranger(ancienSpawn, "Spawn")
table.insert(log, "Sol, rosace, herbe prolongée, 6 points d'apparition")
task.wait()

----------------------------------------------------------------------------------------------------
-- 3. Zones d'entraînement (copies des anciennes : même panneau et mêmes étincelles)
local ZONES = {
	{ "PuissanceDebutant", -42, -36, "Puissance", 1, 0, "PUISSANCE · DÉBUTANT\n+ Puissance de saut" },
	{ "PuissanceConfirme", -66, -58, "Puissance", 5, 25, "PUISSANCE · CONFIRMÉ\n×5 · record 25 m" },
	{ "PuissanceElite", -96, -64, "Puissance", 25, 80, "PUISSANCE · ÉLITE\n×25 · record 80 m" },
	{ "VitesseDebutant", -42, 36, "Vitesse", 1, 0, "VITESSE · DÉBUTANT\n+ Vitesse d'élan" },
	{ "VitesseConfirme", -66, 58, "Vitesse", 5, 25, "VITESSE · CONFIRMÉ\n×5 · record 25 m" },
	{ "VitesseElite", -96, 64, "Vitesse", 25, 80, "VITESSE · ÉLITE\n×25 · record 80 m" },
}
for _, z in ZONES do
	local modele = z[4] == "Puissance" and modeleZonePuissance or modeleZoneVitesse
	local p = modele:Clone()
	p.Name = z[1]
	p.Size = Vector3.new(24, 0.2, 24)
	p.CFrame = versCentre(Vector3.new(z[2], 0.2, z[3]))
	p.Parent = m.Entrainement
	taguer(p, "ZoneEntrainement", { Stat = z[4], Multiplicateur = z[5], RecordRequis = z[6] })
	texte(p.Panneau, z[7])
end
local vip = modeleZonePuissance:Clone()
vip.Name = "EstradeVIP"
vip.Size = Vector3.new(24, 2, 16)
vip.CFrame = versCentre(Vector3.new(-90, 1, -108))
vip.Color = OR
vip.Parent = m.Entrainement
taguer(vip, "ZoneEntrainement", { Stat = "Puissance", Multiplicateur = 40, RecordRequis = 0, PasseRequis = "VIP" })
texte(vip.Panneau, "ESTRADE VIP\n×40 · passe VIP")
table.insert(log, "7 zones d'entraînement (dont l'estrade VIP)")
task.wait()

----------------------------------------------------------------------------------------------------
-- 4. Stands (blocs tournés vers le centre ; Chaussures et Propulseur reprennent prompt et panneau)
local STANDS = {
	{ "Chaussures", -127, -52, Color3.fromRGB(232, 171, 45), "Chaussures", ancienChaussures },
	{ "Propulseur", -140, -40, Color3.fromRGB(140, 91, 159), "Jetpack", ancienJetpack },
	{ "Materiel", -149, -26, Color3.fromRGB(110, 153, 120), nil, nil },
	{ "Tenue", -154, -11, Color3.fromRGB(220, 120, 170), nil, nil },
}
for _, s in STANDS do
	local p = bloc({
		Name = "Stand" .. s[1],
		Size = Vector3.new(12, 8, 12),
		CFrame = versCentre(Vector3.new(s[2], 4, s[3])),
		Color = s[4],
		Parent = m.Boutique,
	})
	taguer(p, "Stand", { Famille = s[1] })
	local panneau = ancienChaussures.Panneau:Clone()
	panneau.StudsOffset = Vector3.new(0, 7, 0)
	panneau.Parent = p
	if s[5] then
		p:SetAttribute("Objet", s[5])
		s[6].Prompt:Clone().Parent = p
		texte(panneau, s[6].Panneau:FindFirstChildWhichIsA("TextLabel", true).Text)
	else
		texte(panneau, (s[1] == "Materiel" and "Matériel" or "Tenues") .. " · bientôt")
	end
end
table.insert(log, "4 stands (2 en vente, Matériel et Tenue sans objet pour l'instant)")
task.wait()

----------------------------------------------------------------------------------------------------
-- 5. Œufs : vrais incubateurs, coffre et roue en blocs (T-605)
local oeufsF = dossier(m, "Oeufs")
local modeleIncubateur = ReplicatedStorage.Assets.Decor.incubateur
for _, i in { { "Incubateur_stade", -126, 51, "oeuf_stade" }, { "Incubateur_champion", -141, 36, "oeuf_champion" } } do
	local inc = modeleIncubateur:Clone()
	inc.Name = i[1]
	inc:PivotTo(versCentre(Vector3.new(i[2], 0.05, i[3])))
	inc:SetAttribute("Oeuf", i[4])
	inc.Parent = oeufsF
end
bloc({
	Name = "Coffre",
	Size = Vector3.new(8, 4, 8),
	CFrame = versCentre(Vector3.new(-152, 2, 18)),
	Color = Color3.fromRGB(124, 82, 46),
	Material = Enum.Material.Wood,
	Parent = oeufsF,
})
-- Roue debout, face au centre (l'axe du cylindre est X : quart de tour pour le pointer vers le centre)
bloc({
	Name = "Roue",
	Shape = Enum.PartType.Cylinder,
	Size = Vector3.new(2, 10, 10),
	CFrame = versCentre(Vector3.new(-120, 6, 72)) * CFrame.Angles(0, math.rad(90), 0),
	Color = JAUNE,
	Parent = oeufsF,
})
bloc({
	Name = "PiedRoue",
	Size = Vector3.new(4, 2, 2),
	CFrame = versCentre(Vector3.new(-120, 1, 72)),
	Color = Color3.fromRGB(80, 80, 80),
	Parent = oeufsF,
})
table.insert(log, "2 incubateurs, coffre, roue")
task.wait()

----------------------------------------------------------------------------------------------------
-- 6. Portail vers le monde 2 (Model tagué), sur trois marches
local portail = Instance.new("Model")
portail.Name = "PortailMonde2"
local base = CFrame.lookAt(Vector3.new(-172, 0, 0), Vector3.new(CENTRE.X, 0, 0)) -- face au centre (vers +X)
for i, l in { 16, 12, 8 } do
	-- Les marches montent en s'éloignant du centre
	bloc({
		Name = "Marche",
		Size = Vector3.new(24, 1, l),
		CFrame = base * CFrame.new(0, i - 0.5, (16 - l) / 2),
		Color = CREME,
		Material = Enum.Material.Marble,
		Parent = portail,
	})
end
local haut = base * CFrame.new(0, 3, 4)
bloc({
	Name = "Poteau",
	Size = Vector3.new(2, 20, 2),
	CFrame = haut * CFrame.new(-11, 10, 0),
	Color = TURQUOISE,
	Material = Enum.Material.Neon,
	Parent = portail,
})
bloc({
	Name = "Poteau",
	Size = Vector3.new(2, 20, 2),
	CFrame = haut * CFrame.new(11, 10, 0),
	Color = TURQUOISE,
	Material = Enum.Material.Neon,
	Parent = portail,
})
bloc({
	Name = "Linteau",
	Size = Vector3.new(24, 2, 2),
	CFrame = haut * CFrame.new(0, 21, 0),
	Color = TURQUOISE,
	Material = Enum.Material.Neon,
	Parent = portail,
})
local surface = bloc({
	Name = "Surface",
	Size = Vector3.new(20, 20, 0.5),
	CFrame = haut * CFrame.new(0, 10, 0),
	Color = VIOLET,
	Material = Enum.Material.Neon,
	Transparency = 0.4,
	CanCollide = false,
	Parent = portail,
})
portail.PrimaryPart = surface
portail.Parent = m.Portails
taguer(portail, "Portail", { VersMonde = 2 })
table.insert(log, "Portail vers le monde 2")

----------------------------------------------------------------------------------------------------
-- 7. Panthéon, panneaux de classement, podium
local decor = m.Decor
local pantheon = Instance.new("Model")
pantheon.Name = "Pantheon"
local pb = CFrame.lookAt(Vector3.new(-212, 0, 0), Vector3.new(CENTRE.X, 0, 0))
local socle = bloc({
	Name = "Socle",
	Size = Vector3.new(40, 2, 30),
	CFrame = pb * CFrame.new(0, 1, 0),
	Color = CREME,
	Material = Enum.Material.Marble,
	Parent = pantheon,
})
for _, x in { -18, -9, 0, 9, 18 } do
	for _, z in { -13, 13 } do
		bloc({
			Name = "Colonne",
			Shape = Enum.PartType.Cylinder,
			Size = Vector3.new(18, 2.5, 2.5),
			CFrame = pb * CFrame.new(x, 11, z) * rot,
			Color = CREME,
			Material = Enum.Material.Marble,
			Parent = pantheon,
		})
	end
end
bloc({
	Name = "Toit",
	Size = Vector3.new(40, 2, 30),
	CFrame = pb * CFrame.new(0, 21, 0),
	Color = CREME,
	Material = Enum.Material.Marble,
	Parent = pantheon,
})
bloc({
	Name = "Fronton",
	Size = Vector3.new(40, 3, 30),
	CFrame = pb * CFrame.new(0, 23.5, 0),
	Color = OR,
	Parent = pantheon,
})
bloc({
	Name = "Vasque",
	Size = Vector3.new(5, 2, 5),
	CFrame = pb * CFrame.new(0, 26, 0),
	Color = OR,
	Material = Enum.Material.Metal,
	Parent = pantheon,
})
pantheon.PrimaryPart = socle
pantheon.Parent = decor
taguer(pantheon, "Pantheon")

local panneau = bloc({
	Name = "PanneauClassement",
	Size = Vector3.new(16, 12, 1),
	CFrame = versCentre(Vector3.new(-4, 9, -40)),
	Color = Color3.fromRGB(30, 35, 50),
	Parent = decor,
})
taguer(panneau, "PanneauClassement", { Classement = "monde" })
for _, dx in { -7, 7 } do
	bloc({
		Name = "PiedPanneau",
		Size = Vector3.new(1, 3, 1),
		CFrame = panneau.CFrame * CFrame.new(dx, -7.5, 0),
		Color = Color3.fromRGB(80, 80, 80),
		Parent = decor,
	})
end

local podium = Instance.new("Model")
podium.Name = "Podium"
local pod = versCentre(Vector3.new(-4, 0, 40))
local p1 = bloc({
	Name = "Place1",
	Size = Vector3.new(5.4, 3, 10),
	CFrame = pod * CFrame.new(0, 1.5, 0),
	Color = OR,
	Parent = podium,
})
bloc({
	Name = "Place2",
	Size = Vector3.new(5.3, 2, 10),
	CFrame = pod * CFrame.new(-5.35, 1, 0),
	Color = Color3.fromRGB(190, 190, 200),
	Parent = podium,
})
bloc({
	Name = "Place3",
	Size = Vector3.new(5.3, 1, 10),
	CFrame = pod * CFrame.new(5.35, 0.5, 0),
	Color = Color3.fromRGB(176, 110, 60),
	Parent = podium,
})
podium.PrimaryPart = p1
podium.Parent = decor
taguer(podium, "Podium")
table.insert(log, "Panthéon, panneau de classement, podium")
task.wait()

----------------------------------------------------------------------------------------------------
-- 8. Marquages au sol, du bord de la rosace vers chaque activité
local marquages = dossier(spawnF, "Marquages")
local function marquage(nom, x, z, arret, couleur)
	local cible = plat(x, z)
	local dir = (cible - CENTRE).Unit
	local debut = CENTRE + dir * 18.5
	local fin = cible - dir * arret
	local long = (fin - debut).Magnitude
	local milieu = (debut + fin) / 2 + Vector3.new(0, 0.05, 0)
	bloc({
		Name = nom,
		Size = Vector3.new(3, 0.1, long),
		CFrame = CFrame.lookAt(milieu, milieu + dir),
		Color = couleur,
		Material = Enum.Material.SmoothPlastic,
		CanCollide = false,
		Parent = marquages,
	})
end
marquage("VersPiste", -1, 0, 0, ORANGE)
marquage("VersPuissance", -42, -36, 14, ROUGE)
marquage("VersVitesse", -42, 36, 14, BLEU)
marquage("VersBoutique", -140, -36, 12, JAUNE)
marquage("VersOeufs", -134, 44, 8, VIOLET)
marquage("VersPortail", -164, 0, 2, TURQUOISE)
table.insert(log, "6 marquages au sol")
task.wait()

----------------------------------------------------------------------------------------------------
-- 9. Collines et arbres autour de la place (pas vers la piste), plus loin derrière l'estrade VIP et le panthéon
local collines = dossier(decor, "Collines")
local arbresPlace = dossier(decor, "ArbresPlace")
local hasard = Random.new(114)
local function colline(angle, r)
	local hauteur = hasard:NextNumber(12, 30)
	local rayonSol = hasard:NextNumber(18, 25)
	-- Boule enfoncée : rayon R tel que le cercle au sol fasse rayonSol pour cette hauteur
	local R = (rayonSol ^ 2 + hauteur ^ 2) / (2 * hauteur)
	local pos = CENTRE + Vector3.new(math.cos(angle) * r, hauteur - R, math.sin(angle) * r)
	bloc({
		Name = "Colline",
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(2 * R, 2 * R, 2 * R),
		Position = pos,
		Color = HERBE:Lerp(Color3.fromRGB(60, 130, 60), hasard:NextNumber()),
		Material = Enum.Material.Grass,
		Parent = collines,
	})
end
local modeleArbre = {}
local tronc = m.Decor.Arbres:FindFirstChild("Tronc")
for _, p in m.Decor.Arbres:GetChildren() do
	if (p.Position - tronc.Position) * Vector3.new(1, 0, 1) == Vector3.zero then
		table.insert(modeleArbre, p)
	end
end
local function arbre(x, z)
	local decalage = Vector3.new(x - tronc.Position.X, 0, z - tronc.Position.Z)
	local tourne = CFrame.Angles(0, hasard:NextNumber(0, math.pi * 2), 0)
	for _, p in modeleArbre do
		local c = p:Clone()
		local relatif = p.CFrame - tronc.Position
		c.CFrame = CFrame.new(tronc.Position + decalage) * tourne * relatif
		c.Parent = arbresPlace
	end
end
local nbCollines, nbArbres = 0, 0
for deg = 45, 315, 13 do
	local a = math.rad(deg)
	local versVIP = math.abs(deg - 270) < 22 -- -Z (nord), z = sin(270°) = -1
	local versPantheon = math.abs(deg - 180) < 22
	local r = (versVIP and 150) or (versPantheon and 168) or hasard:NextNumber(118, 128)
	colline(a, r)
	nbCollines += 1
	-- Un arbre entre deux collines, un peu en avant
	local aa = math.rad(deg + 6.5)
	local ra = (versVIP and 135) or (versPantheon and 150) or hasard:NextNumber(100, 108)
	local x, z = CENTRE.X + math.cos(aa) * ra, CENTRE.Z + math.sin(aa) * ra
	if deg + 6.5 <= 315 and not dansEmprise(x, z, 8) then
		arbre(x, z)
		nbArbres += 1
	end
end
table.insert(log, nbCollines .. " collines, " .. nbArbres .. " arbres")

if enregistrement then
	CHS:FinishRecording(enregistrement, Enum.FinishRecordingOperation.Commit)
end
return table.concat(log, "\n")
