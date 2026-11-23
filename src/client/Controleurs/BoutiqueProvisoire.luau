-- Boutique provisoire (joueur, T-217) : panneau ouvert par le comptoir du magasin de la place centrale
-- (événement OuvrirBoutique). Quatre onglets (Chaussures, Propulseur, Tenue, Matériel), une ligne par objet avec un
-- bouton Acheter, Améliorer, Porter ou Porté, selon l'état envoyé par le serveur (EquipementEtat). Il agit par
-- AcheterObjet (« Materiel » pour le palier de matériel suivant), AmeliorerObjet et PorterObjet.
-- Provisoire : le vrai écran EcranBoutique (maquette T-009) le remplacera avec T-209.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Equipement = require(Shared:WaitForChild("Config"):WaitForChild("Equipement"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))
local Interface = require(script.Parent.Parent:WaitForChild("Interface"))

local player = Players.LocalPlayer

local BoutiqueProvisoire = {}

local ORANGE = Color3.fromRGB(255, 122, 26)
local VERT = Color3.fromRGB(43, 182, 115)
local BLEU = Color3.fromRGB(30, 144, 255)
local NUIT = Color3.fromRGB(22, 33, 62)
local LIGNE = Color3.fromRGB(36, 52, 92)
local GRIS = Color3.fromRGB(58, 69, 102)
local OR = Color3.fromRGB(255, 200, 61)
local CLAIR = Color3.fromRGB(207, 214, 230)

local ONGLETS = { "Chaussures", "Propulseur", "Tenue", "Materiel" }
local LIBELLES = { Chaussures = "Chaussures", Propulseur = "Propulseurs", Tenue = "Tenues", Materiel = "Matériel" }

local gui: ScreenGui, liste: ScrollingFrame, textePieces: TextLabel
local boutonsOnglets = {}
local onglet = "Chaussures"
local etat = { possede = {}, porte = {} }

local function coin(o: GuiObject, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
end

local function bord(o: GuiObject, couleur: Color3?)
	local s = Instance.new("UIStroke")
	s.Thickness = 3
	s.Color = couleur or Color3.fromRGB(11, 18, 38)
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = o
end

local function texte(parent: Instance, t: string, pos: UDim2, taille: UDim2, couleur: Color3?): TextLabel
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Position = pos
	l.Size = taille
	l.Font = Enum.Font.FredokaOne
	l.TextScaled = true
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextColor3 = couleur or Color3.new(1, 1, 1)
	l.Text = t
	l.Parent = parent
	return l
end

local function bouton(parent: Instance, t: string, couleur: Color3, pos: UDim2, taille: UDim2): TextButton
	local b = Instance.new("TextButton")
	b.Position = pos
	b.Size = taille
	b.BackgroundColor3 = couleur
	b.Font = Enum.Font.FredokaOne
	b.TextScaled = true
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Text = t
	coin(b, 10)
	bord(b)
	local limite = Instance.new("UITextSizeConstraint")
	limite.MaxTextSize = 18
	limite.Parent = b
	b.Parent = parent
	return b
end

local function pieces(): number
	local ls = player:FindFirstChild("leaderstats")
	local p = ls and ls:FindFirstChild("Pièces")
	return if p and p:IsA("ValueBase") then (p :: any).Value else 0
end

local function effet(id: string, niveau: number?): string
	local o = Equipement.CATALOGUE[id]
	if o.appel then
		return "Appel × " .. Interface.nombre(Equipement.appel(id, niveau))
	elseif o.pieces then
		return "Pièces × " .. Interface.nombre(Equipement.pieces(id, niveau))
	end
	local p = Equipement.propulseur(id, niveau)
	return if p then "Poussée " .. Interface.nombre(p.carburant) .. " s" else ""
end

-- Une ligne : pastille, nom et effet, prix, bouton d'action
local function ligne(
	ordre: number,
	nom: string,
	detail: string,
	prix: string,
	action: string,
	couleur: Color3,
	actif: boolean,
	rappel: (() -> ())?
)
	local cadre = Instance.new("Frame")
	cadre.Name = "Ligne" .. ordre
	cadre.LayoutOrder = ordre
	cadre.Size = UDim2.new(1, -10, 0, 56)
	cadre.BackgroundColor3 = if actif or action == "Porté" then LIGNE else Color3.fromRGB(27, 39, 71)
	coin(cadre, 12)
	bord(cadre, if action == "Porté" then OR else nil)
	cadre.Parent = liste
	local pastille = Instance.new("Frame")
	pastille.Position = UDim2.fromOffset(8, 8)
	pastille.Size = UDim2.fromOffset(40, 40)
	pastille.BackgroundColor3 = if action == "Porté" or action == "Améliorer" then BLEU else GRIS
	coin(pastille, 10)
	pastille.Parent = cadre
	texte(cadre, nom, UDim2.fromOffset(58, 6), UDim2.new(1, -280, 0, 24))
	texte(cadre, detail, UDim2.fromOffset(58, 30), UDim2.new(1, -280, 0, 18), CLAIR)
	local lp = texte(cadre, prix, UDim2.new(1, -212, 0, 18), UDim2.fromOffset(96, 20), OR)
	lp.TextXAlignment = Enum.TextXAlignment.Center
	local b =
		bouton(cadre, action, if actif then couleur else GRIS, UDim2.new(1, -108, 0, 8), UDim2.fromOffset(100, 40))
	b.AutoButtonColor = actif
	if not actif then
		b.TextColor3 = CLAIR
	end
	if actif and rappel then
		b.Activated:Connect(rappel)
	end
end

local function reconstruire()
	if not liste then
		return
	end
	for _, c in liste:GetChildren() do
		if c:IsA("GuiObject") then
			c:Destroy()
		end
	end
	for nom, b in boutonsOnglets do
		b.BackgroundColor3 = if nom == onglet then ORANGE else Color3.fromRGB(44, 58, 99)
	end
	local argent = pieces()
	textePieces.Text = Nombres.abreger(argent)
	if onglet == "Materiel" then
		local palier = player:GetAttribute("Materiel") or 0
		for i, m in Equipement.MATERIEL do
			local detail = "Entraînement × " .. Nombres.abreger(m.multiplicateur)
			if i <= palier then
				ligne(i, m.nom, detail, "", if i == palier then "Porté" else "Acquis", VERT, false)
			elseif i == palier + 1 then
				local assez = argent >= m.prix
				ligne(
					i,
					m.nom,
					detail,
					Nombres.abreger(m.prix),
					if assez then "Acheter" else "Trop cher",
					ORANGE,
					assez,
					function()
						Remotes.AcheterObjet:FireServer("Materiel")
					end
				)
			else
				ligne(i, m.nom, detail, Nombres.abreger(m.prix), "Plus tard", GRIS, false)
			end
		end
		return
	end
	local monde = player:GetAttribute("Monde") or 1
	for i, id in Equipement.objetsDe(onglet, monde) do
		local o = Equipement.CATALOGUE[id]
		local niveau = etat.possede[id]
		if not niveau then
			local assez = argent >= o.prix
			ligne(
				i,
				o.nom,
				effet(id, 1),
				Nombres.abreger(o.prix),
				if assez then "Acheter" else "Trop cher",
				ORANGE,
				assez,
				function()
					Remotes.AcheterObjet:FireServer(id)
				end
			)
		else
			local detail = effet(id, niveau) .. " · niveau " .. niveau .. " / " .. Equipement.NIVEAU_MAX
			local prixNiv = Equipement.prixNiveau(id, niveau + 1)
			if etat.porte[onglet] ~= id then
				ligne(i, o.nom, detail, "", "Porter", BLEU, true, function()
					Remotes.PorterObjet:FireServer(id)
				end)
			elseif prixNiv then
				local assez = argent >= prixNiv
				ligne(
					i,
					o.nom,
					detail,
					Nombres.abreger(prixNiv),
					if assez then "Améliorer" else "Trop cher",
					VERT,
					assez,
					function()
						Remotes.AmeliorerObjet:FireServer(id)
					end
				)
			else
				ligne(i, o.nom, detail, "Niveau max", "Porté", VERT, false)
			end
		end
	end
end

local function construire()
	gui = Instance.new("ScreenGui")
	gui.Name = "BoutiqueProvisoire"
	gui.ResetOnSpawn = false
	gui.Enabled = false
	gui.DisplayOrder = 10
	gui.Parent = player:WaitForChild("PlayerGui")

	local fenetre = Instance.new("Frame")
	fenetre.Name = "Fenetre"
	fenetre.AnchorPoint = Vector2.new(0.5, 0.5)
	fenetre.Position = UDim2.fromScale(0.5, 0.5)
	fenetre.Size = UDim2.fromOffset(600, 354)
	fenetre.BackgroundColor3 = NUIT
	fenetre.BackgroundTransparency = 0.05
	coin(fenetre, 22)
	bord(fenetre)
	fenetre.Parent = gui
	local echelle = Instance.new("UIScale")
	echelle.Name = "Echelle"
	echelle.Parent = fenetre
	Interface.suivreEchelle(echelle)

	texte(fenetre, "Boutique", UDim2.fromOffset(16, 10), UDim2.fromOffset(110, 30))
	for i, nom in ONGLETS do
		local b =
			bouton(fenetre, LIBELLES[nom], ORANGE, UDim2.fromOffset(16 + (i - 1) * 100, 48), UDim2.fromOffset(94, 34))
		b.Name = "Onglet" .. nom
		b.Activated:Connect(function()
			onglet = nom
			reconstruire()
		end)
		boutonsOnglets[nom] = b
	end
	textePieces = texte(fenetre, "", UDim2.new(1, -170, 0, 14), UDim2.fromOffset(100, 24), OR)
	textePieces.Name = "TextePieces"
	textePieces.TextXAlignment = Enum.TextXAlignment.Right
	local fermer = bouton(fenetre, "X", Color3.fromRGB(229, 72, 77), UDim2.new(1, -54, 0, 10), UDim2.fromOffset(40, 40))
	fermer.Name = "BoutonFermer"
	fermer.Activated:Connect(function()
		Interface.fermer(gui)
	end)

	liste = Instance.new("ScrollingFrame")
	liste.Name = "ListeObjets"
	liste.Position = UDim2.fromOffset(14, 92)
	liste.Size = UDim2.new(1, -28, 1, -104)
	liste.BackgroundTransparency = 1
	liste.BorderSizePixel = 0
	liste.ScrollBarThickness = 6
	liste.AutomaticCanvasSize = Enum.AutomaticSize.Y
	liste.CanvasSize = UDim2.new()
	liste.Parent = fenetre
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, 6)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Parent = liste
end

function BoutiqueProvisoire.demarrer()
	construire()
	Remotes.EquipementEtat.OnClientEvent:Connect(function(nouvel)
		etat = nouvel
		if gui.Enabled then
			reconstruire()
		end
	end)
	Remotes.OuvrirBoutique.OnClientEvent:Connect(function()
		reconstruire()
		Interface.ouvrir(gui, boutonsOnglets[onglet])
	end)
	-- Les prix passent de « Trop cher » à « Acheter » quand les pièces montent, et le matériel suit son attribut
	local function suivrePieces()
		local ls = player:WaitForChild("leaderstats")
		ls:WaitForChild("Pièces").Changed:Connect(function()
			if gui.Enabled then
				reconstruire()
			end
		end)
	end
	task.spawn(suivrePieces)
	player:GetAttributeChangedSignal("Materiel"):Connect(function()
		if gui.Enabled then
			reconstruire()
		end
	end)
end

return BoutiqueProvisoire
