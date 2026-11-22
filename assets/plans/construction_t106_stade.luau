-- T-106 : écran géant, projecteurs et public du stade du monde 1, en blocs.
-- À lancer en mode Édition (MCP ou barre de commande). Ne fait rien si l'écran existe déjà (Piste.EcranGeant).
-- Ctrl+Z annule tout. Repère : X vers l'est (piste), axe de la piste à Z = 0, sol à Y = 0.
--
-- - Écran géant : Model Piste.EcranGeant posé sur l'arche (sommet à Y 34,5). La Part « Surface » porte le tag
--   EcranGeant et deux SurfaceGui (face ouest vers la place, face est vers la piste), contenu provisoire.
-- - Projecteurs : 6 Models dans Decor.Projecteurs, tag Projecteur, derrière les tribunes (Z ±50) aux deux bouts
--   et au milieu. « Tete » est la partie à orienter, elle vise l'axe du bac ; « Lampe » porte un SpotLight.
-- - Public : un Model « Public » par module de tribune (48), tag Public, attribut Rang = ordre le long de la
--   piste (1 à 24, le même des deux côtés) pour la ola. Silhouettes = corps + tête, sans collision ni contact.
local CHS = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")

local m = workspace.Mondes.Monde1
if m.Piste:FindFirstChild("EcranGeant") then
	return "L'écran géant T-106 existe déjà : rien à faire."
end
local enregistrement = CHS:TryBeginRecording("T-106 écran, projecteurs, public")

local BLEU = Color3.fromHex("1E90FF")
local OR = Color3.fromHex("FFC83D")
local NUIT = Color3.fromHex("16213E")
local GRIS = Color3.fromHex("8A8F98")
local BLANC = Color3.fromHex("FFF8E7")

local function dossier(parent, nom)
	local d = parent:FindFirstChild(nom)
	if not d then
		d = Instance.new("Folder")
		d.Name = nom
		d.Parent = parent
	end
	return d
end
-- Bloc de décor : ancré, lisse ; sans collision ni contact sauf si demandé
local function bloc(props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CanTouch = false
	p.CanQuery = false
	for k, v in props do
		if k ~= "Parent" then
			p[k] = v
		end
	end
	p.Parent = props.Parent
	return p
end

-- 1. Écran géant au-dessus de l'arche
local ecran = Instance.new("Model")
ecran.Name = "EcranGeant"
local Y_BAS, HAUT, LARGE = 37, 14, 28
local yc = Y_BAS + HAUT / 2
local surface = bloc({
	Name = "Surface",
	Size = Vector3.new(1.6, HAUT, LARGE),
	CFrame = CFrame.new(0, yc, 0),
	Color = NUIT,
	CanCollide = false,
	Parent = ecran,
})
CollectionService:AddTag(surface, "EcranGeant")
for _, face in { Enum.NormalId.Left, Enum.NormalId.Right } do
	local g = Instance.new("SurfaceGui")
	g.Name = "Affichage" .. face.Name
	g.Face = face
	g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	g.PixelsPerStud = 20
	g.LightInfluence = 0
	g.Parent = surface
	local fond = Instance.new("Frame")
	fond.Name = "Fond"
	fond.Size = UDim2.fromScale(1, 1)
	fond.BackgroundColor3 = NUIT
	fond.Parent = g
	local titre = Instance.new("TextLabel")
	titre.Name = "Titre"
	titre.Size = UDim2.fromScale(0.9, 0.5)
	titre.Position = UDim2.fromScale(0.05, 0.08)
	titre.BackgroundTransparency = 1
	titre.Font = Enum.Font.FredokaOne
	titre.TextScaled = true
	titre.TextColor3 = OR
	titre.Text = "SAUT !"
	titre.Parent = fond
	local info = Instance.new("TextLabel")
	info.Name = "Info"
	info.Size = UDim2.fromScale(0.9, 0.3)
	info.Position = UDim2.fromScale(0.05, 0.62)
	info.BackgroundTransparency = 1
	info.Font = Enum.Font.FredokaOne
	info.TextScaled = true
	info.TextColor3 = BLANC
	info.Text = "Record du stade : —"
	info.Parent = fond
end
-- Cadre bleu et or, et deux pieds posés sur l'arche
for _, s in { 1, -1 } do
	bloc({
		Name = "Cadre",
		Size = Vector3.new(2.2, HAUT + 2, 1),
		CFrame = CFrame.new(0, yc, s * (LARGE / 2 + 0.5)),
		Color = BLEU,
		CanCollide = false,
		Parent = ecran,
	})
	bloc({
		Name = "Cadre",
		Size = Vector3.new(2.2, 1, LARGE + 2),
		CFrame = CFrame.new(0, yc + s * (HAUT / 2 + 0.5), 0),
		Color = BLEU,
		CanCollide = false,
		Parent = ecran,
	})
	bloc({
		Name = "Pied",
		Size = Vector3.new(1.5, Y_BAS - 34, 1.5),
		CFrame = CFrame.new(0, (Y_BAS + 34) / 2, s * 9),
		Color = GRIS,
		CanCollide = false,
		Parent = ecran,
	})
end
bloc({
	Name = "Liseré",
	Size = Vector3.new(2.4, 0.4, LARGE + 2.4),
	CFrame = CFrame.new(0, Y_BAS - 1.2, 0),
	Color = OR,
	Material = Enum.Material.Neon,
	CanCollide = false,
	Parent = ecran,
})
ecran.PrimaryPart = surface
ecran.Parent = m.Piste

-- 2. Projecteurs : mât, tête orientée vers l'axe du bac, lampe avec SpotLight
local projecteurs = dossier(m.Decor, "Projecteurs")
local HAUT_MAT = 45
local n = 0
for _, x in { 10, 250, 490 } do
	for _, z in { 50, -50 } do
		n += 1
		local p = Instance.new("Model")
		p.Name = "Projecteur" .. n
		bloc({
			Name = "Mat",
			Size = Vector3.new(2, HAUT_MAT, 2),
			CFrame = CFrame.new(x, HAUT_MAT / 2, z),
			Color = GRIS,
			Material = Enum.Material.Metal,
			CanCollide = true,
			Parent = p,
		})
		local cible = Vector3.new(x + (x < 250 and 60 or (x > 250 and -60 or 0)), 0, 0)
		local centre = Vector3.new(x, HAUT_MAT + 3, z)
		local vise = CFrame.lookAt(centre, cible)
		local tete = bloc({
			Name = "Tete",
			Size = Vector3.new(12, 7, 2.5),
			CFrame = vise,
			Color = NUIT,
			CanCollide = false,
			Parent = p,
		})
		local lampe = bloc({
			Name = "Lampe",
			Size = Vector3.new(11, 6, 0.3),
			CFrame = vise * CFrame.new(0, 0, -1.35),
			Color = BLANC,
			Material = Enum.Material.Neon,
			CanCollide = false,
			Parent = p,
		})
		local spot = Instance.new("SpotLight")
		spot.Face = Enum.NormalId.Front
		spot.Range = 60
		spot.Angle = 50
		spot.Brightness = 2
		spot.Color = BLANC
		spot.Parent = lampe
		p.PrimaryPart = tete
		CollectionService:AddTag(p, "Projecteur")
		p.Parent = projecteurs
	end
end

-- 3. Public : 6 gradins par module (marches de 2 studs de profondeur et 1,4 de haut), 4 places par rang
local COULEURS = {
	BLEU,
	OR,
	Color3.fromHex("FF7A1A"),
	Color3.fromHex("E5484D"),
	Color3.fromHex("2BB673"),
	BLANC,
	Color3.fromHex("8E5CF7"),
}
local PEAUX = { Color3.fromHex("F2C9A0"), Color3.fromHex("D9A066"), Color3.fromHex("A86B3C"), Color3.fromHex("6B4226") }
local alea = Random.new(106)
local modules = {}
for _, t in m.Decor.Tribunes:GetChildren() do
	if t:IsA("Model") then
		table.insert(modules, t)
	end
end
table.sort(modules, function(a, b)
	return a:GetPivot().X < b:GetPivot().X
end)
local rangs = {}
for _, t in modules do
	local x = math.floor(t:GetPivot().X + 0.5)
	if not table.find(rangs, x) then
		table.insert(rangs, x)
	end
end
table.sort(rangs)

local total = 0
for i, t in modules do
	local pivot = t:GetPivot()
	local public = Instance.new("Model")
	public.Name = "Public"
	public:SetAttribute("Rang", table.find(rangs, math.floor(pivot.X + 0.5)))
	for r = 0, 5 do
		for c = 0, 3 do
			if alea:NextNumber() < 0.82 then
				-- En repère du module : X le long de la piste, Z vers l'arrière de la tribune
				local lx = -7.5 + c * 5 + alea:NextNumber(-1, 1)
				local lz = 0.7 + r * 2 -- milieu du gradin r (le premier commence 0,3 stud derrière le pivot)
				local base = 1.4 * (r + 1)
				local corps = bloc({
					Name = "Corps",
					Size = Vector3.new(1.4, 2, 1),
					CFrame = pivot * CFrame.new(lx, base + 1, lz),
					Color = COULEURS[alea:NextInteger(1, #COULEURS)],
					CanCollide = false,
					CastShadow = false,
					Parent = public,
				})
				bloc({
					Name = "Tete",
					Shape = Enum.PartType.Ball,
					Size = Vector3.new(1.1, 1.1, 1.1),
					CFrame = corps.CFrame * CFrame.new(0, 1.5, 0),
					Color = PEAUX[alea:NextInteger(1, #PEAUX)],
					CanCollide = false,
					CastShadow = false,
					Parent = public,
				})
				total += 1
			end
		end
	end
	CollectionService:AddTag(public, "Public")
	public.Parent = t
	if i % 8 == 0 then
		task.wait()
	end
end

if enregistrement then
	CHS:FinishRecording(enregistrement, Enum.FinishRecordingOperation.Commit)
end
return string.format(
	"Écran géant, %d projecteurs et %d spectateurs dans %d blocs de public posés",
	n,
	total,
	#modules
)
