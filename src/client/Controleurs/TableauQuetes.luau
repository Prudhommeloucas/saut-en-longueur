-- Tableau des quêtes (joueur, T-218) : le tableau posé sur la place centrale (tag « TableauQuetes ») affiche sur sa
-- Part « Ecran » les quêtes du jour et le coffre du jour, les quêtes de la semaine et les défis de carrière, avec
-- leurs barres et un bouton par ligne (Réclamer, Changer, Ouvrir, Pris). Une pastille rouge au-dessus se voit de
-- loin quand quelque chose est à réclamer. L'interface est une SurfaceGui du joueur, posée sur l'écran du tableau :
-- chaque joueur y voit ses propres quêtes. Elle suit RecompensesEtat et agit par ActionRecompense.
-- Il remplace le bouton Quêtes du HUD et la partie quêtes du panneau provisoire des récompenses (T-205).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))

local player = Players.LocalPlayer

local TableauQuetes = {}

local OR = Color3.fromRGB(255, 200, 61)
local BLEU = Color3.fromRGB(30, 144, 255)
local VERT = Color3.fromRGB(43, 182, 115)
local ORANGE = Color3.fromRGB(255, 122, 26)
local ROUGE = Color3.fromRGB(229, 72, 77)
local LIGNE = Color3.fromRGB(36, 52, 92)
local GRIS = Color3.fromRGB(58, 69, 102)
local CLAIR = Color3.fromRGB(207, 214, 230)

local PIXELS_PAR_STUD = 55
local LIGNES_MAX = 5

local etat
local tableaux = {} -- [modele] = { gui, colonnes = { Frame }, ferme = TextLabel, pastille = BillboardGui }

local function coin(o: GuiObject, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
end

local function texte(
	parent: Instance,
	t: string,
	pos: UDim2,
	taille: UDim2,
	couleur: Color3?,
	maxTaille: number?
): TextLabel
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Position = pos
	l.Size = taille
	l.Font = Enum.Font.FredokaOne
	l.TextScaled = true
	l.TextWrapped = true
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextColor3 = couleur or Color3.new(1, 1, 1)
	l.Text = t
	local c = Instance.new("UITextSizeConstraint")
	c.MaxTextSize = maxTaille or 30
	c.Parent = l
	l.Parent = parent
	return l
end

-- Une ligne : texte, récompense, barre de progression (si cible), bouton
local function ligne(
	colonne: Frame,
	ordre: number,
	t: string,
	recompense: string,
	progres: number?,
	cible: number?,
	libelle: string,
	couleur: Color3,
	actif: boolean,
	...
)
	local cadre = Instance.new("Frame")
	cadre.LayoutOrder = ordre
	cadre.Size = UDim2.new(1, 0, 0, 86)
	cadre.BackgroundColor3 = LIGNE
	coin(cadre, 12)
	cadre.Parent = colonne
	texte(cadre, t, UDim2.fromOffset(10, 4), UDim2.new(1, -130, 0, 40), nil, 24)
	texte(cadre, recompense, UDim2.fromOffset(10, 44), UDim2.new(1, -130, 0, 20), OR, 20)
	if progres and cible then
		local barre = Instance.new("Frame")
		barre.Position = UDim2.fromOffset(10, 68)
		barre.Size = UDim2.new(1, -130, 0, 10)
		barre.BackgroundColor3 = GRIS
		coin(barre, 5)
		barre.Parent = cadre
		local plein = Instance.new("Frame")
		plein.Size = UDim2.fromScale(math.clamp(progres / math.max(cible, 1), 0, 1), 1)
		plein.BackgroundColor3 = if progres >= cible then VERT else BLEU
		coin(plein, 5)
		plein.Parent = barre
		local chiffres = texte(
			cadre,
			Nombres.abreger(progres) .. " / " .. Nombres.abreger(cible),
			UDim2.new(1, -230, 0, 44),
			UDim2.fromOffset(100, 20),
			CLAIR,
			18
		)
		chiffres.TextXAlignment = Enum.TextXAlignment.Right
	end
	local b = Instance.new("TextButton")
	b.AnchorPoint = Vector2.new(1, 0.5)
	b.Position = UDim2.new(1, -8, 0.5, 0)
	b.Size = UDim2.fromOffset(108, 50)
	b.BackgroundColor3 = if actif then couleur else GRIS
	b.AutoButtonColor = actif
	b.Font = Enum.Font.FredokaOne
	b.TextScaled = true
	b.TextColor3 = if actif then Color3.new(1, 1, 1) else CLAIR
	b.Text = libelle
	coin(b, 10)
	local c = Instance.new("UITextSizeConstraint")
	c.MaxTextSize = 24
	c.Parent = b
	b.Parent = cadre
	if actif then
		local args = table.pack(...)
		b.Activated:Connect(function()
			Remotes.ActionRecompense:FireServer(table.unpack(args, 1, args.n))
		end)
	end
end

local function vider(colonne: Frame)
	for _, c in colonne:GetChildren() do
		if c:IsA("Frame") then
			c:Destroy()
		end
	end
end

-- Remplit les trois colonnes ; renvoie le nombre de choses à réclamer
local function remplir(t): number
	local aReclamer = 0
	local jour, semaine, defis = t.colonnes[1], t.colonnes[2], t.colonnes[3]
	for _, c in t.colonnes do
		vider(c)
	end
	t.ferme.Visible = not etat.quetesOuvertes
	jour.Visible = etat.quetesOuvertes
	semaine.Visible = etat.quetesOuvertes
	if etat.quetesOuvertes then
		local coffrePret = not etat.coffre
		for _, q in etat.jour do
			if not q.reclamee then
				coffrePret = false
			end
		end
		if coffrePret then
			aReclamer += 1
		end
		local n = 0
		for i, q in etat.jour do
			n += 1
			local fini = q.progres >= q.cible
			if q.reclamee then
				ligne(jour, n, q.texte, q.recompense, q.progres, q.cible, "Pris", VERT, false)
			elseif fini then
				aReclamer += 1
				ligne(jour, n, q.texte, q.recompense, q.progres, q.cible, "Réclamer", VERT, true, "Quete", "Jour", i)
			elseif not etat.remplacee then
				ligne(jour, n, q.texte, q.recompense, q.progres, q.cible, "Changer", BLEU, true, "Remplacer", i)
			else
				ligne(jour, n, q.texte, q.recompense, q.progres, q.cible, "En cours", BLEU, false)
			end
		end
		ligne(
			jour,
			n + 1,
			"Coffre du jour (toutes les quêtes du jour prises)",
			etat.coffreRecompense,
			nil,
			nil,
			if etat.coffre then "Pris" elseif coffrePret then "Ouvrir" else "Fermé",
			ORANGE,
			coffrePret,
			"Coffre"
		)
		for i, q in etat.semaine do
			if i > LIGNES_MAX then
				break
			end
			local fini = q.progres >= q.cible
			if fini and not q.reclamee then
				aReclamer += 1
			end
			ligne(
				semaine,
				i,
				q.texte,
				q.recompense,
				q.progres,
				q.cible,
				if q.reclamee then "Pris" elseif fini then "Réclamer" else "En cours",
				VERT,
				fini and not q.reclamee,
				"Quete",
				"Semaine",
				i
			)
		end
	end
	for i, d in etat.defis do
		if i > LIGNES_MAX then
			break
		end
		local fini = d.progres >= d.palier
		if fini then
			aReclamer += 1
		end
		ligne(
			defis,
			i,
			d.texte,
			d.recompense,
			d.progres,
			d.palier,
			if fini then "Réclamer" else "En cours",
			VERT,
			fini,
			"Defi",
			d.compteur,
			d.palier
		)
	end
	return aReclamer
end

local function maj()
	if not etat then
		return
	end
	for modele, t in tableaux do
		if not modele.Parent then
			t.gui:Destroy()
			t.pastille:Destroy()
			tableaux[modele] = nil
			continue
		end
		t.pastille.Enabled = remplir(t) > 0
	end
end

local function construire(modele: Model)
	-- Le modèle peut arriver par morceaux (streaming) : on attend son écran
	local ecran = modele:FindFirstChild("Ecran", true) or modele:WaitForChild("Ecran", 15)
	if not (ecran and ecran:IsA("BasePart")) then
		warn("Tableau des quêtes sans Part « Ecran » :", modele:GetFullName())
		return
	end
	local gui = Instance.new("SurfaceGui")
	gui.Name = "TableauQuetes"
	gui.Adornee = ecran
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = PIXELS_PAR_STUD
	gui.LightInfluence = 0
	gui.MaxDistance = 150
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local titres = { "Quêtes du jour", "Quêtes de la semaine", "Défis de carrière" }
	local colonnes = {}
	for i, nom in titres do
		local x = (i - 1) / 3
		local titre = texte(gui, nom, UDim2.new(x, 14, 0, 10), UDim2.new(1 / 3, -28, 0, 40), OR, 34)
		titre.TextXAlignment = Enum.TextXAlignment.Center
		local c = Instance.new("Frame")
		c.Name = "Colonne" .. i
		c.BackgroundTransparency = 1
		c.Position = UDim2.new(x, 12, 0, 58)
		c.Size = UDim2.new(1 / 3, -24, 1, -66)
		c.Parent = gui
		local l = Instance.new("UIListLayout")
		l.Padding = UDim.new(0, 6)
		l.SortOrder = Enum.SortOrder.LayoutOrder
		l.Parent = c
		colonnes[i] = c
	end
	local ferme = texte(
		gui,
		"Les quêtes s'ouvrent à 10 m de record",
		UDim2.fromOffset(20, 200),
		UDim2.new(2 / 3, -40, 0, 80),
		CLAIR,
		40
	)
	ferme.TextXAlignment = Enum.TextXAlignment.Center
	ferme.Visible = false

	-- Pastille rouge au-dessus du tableau, visible de loin
	local pastille = Instance.new("BillboardGui")
	pastille.Name = "PastilleQuetes"
	pastille.Adornee = ecran
	pastille.Size = UDim2.fromOffset(56, 56)
	pastille.StudsOffsetWorldSpace = Vector3.new(0, ecran.Size.Y / 2 + 7, 0)
	pastille.MaxDistance = 250
	pastille.Enabled = false
	pastille.Parent = player.PlayerGui
	local rond = Instance.new("TextLabel")
	rond.Size = UDim2.fromScale(1, 1)
	rond.BackgroundColor3 = ROUGE
	rond.Font = Enum.Font.FredokaOne
	rond.TextScaled = true
	rond.TextColor3 = Color3.new(1, 1, 1)
	rond.Text = "!"
	coin(rond, 28)
	local s = Instance.new("UIStroke")
	s.Thickness = 3
	s.Color = Color3.new(1, 1, 1)
	s.Parent = rond
	rond.Parent = pastille

	tableaux[modele] = { gui = gui, colonnes = colonnes, ferme = ferme, pastille = pastille }
	maj()
end

function TableauQuetes.demarrer()
	Map.surChaque("TableauQuetes", function(modele)
		if modele:IsA("Model") then
			construire(modele)
		end
	end)
	Remotes.RecompensesEtat.OnClientEvent:Connect(function(e)
		etat = e
		maj()
	end)
end

return TableauQuetes
