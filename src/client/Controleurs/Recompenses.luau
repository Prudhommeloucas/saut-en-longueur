-- Récompenses (joueur, T-205) : panneau provisoire qui liste les boosts, la connexion, la roue, le coffre du groupe et
-- la saisie d'un code, avec un bouton par récompense. Les quêtes, le coffre du jour et les défis sont sur le tableau
-- des quêtes de la place centrale (T-218, contrôleur TableauQuetes), les cadeaux de temps de jeu sur le cadeau de la
-- place (T-219, contrôleur Cadeau). Il suit l'état envoyé par le serveur (RecompensesEtat) et agit par
-- ActionRecompense. Provisoire : les vrais écrans (EcranQuetes, EcranJour, EcranRoue, EcranReglages) viendront
-- avec T-210.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Textes = require(Shared:WaitForChild("Config"):WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))

local player = Players.LocalPlayer

local Recompenses = {}

local OR = Color3.fromRGB(255, 200, 61)
local BLEU = Color3.fromRGB(30, 144, 255)
local NUIT = Color3.fromRGB(22, 33, 62)
local GRIS = Color3.fromRGB(110, 115, 125)

local gui, bouton, panneau, liste, saisie
local etat

local function coin(o: GuiObject, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
end

local function texte(parent: Instance, t: string, taille: number, couleur: Color3?): TextLabel
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = UDim2.new(1, -110, 0, taille)
	l.Font = Enum.Font.FredokaOne
	l.TextScaled = true
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextColor3 = couleur or Color3.new(1, 1, 1)
	l.Text = t
	l.Parent = parent
	return l
end

local function minutes(s: number): string
	return string.format("%d:%02d", s // 60, math.floor(s % 60))
end

local function action(...)
	Remotes.ActionRecompense:FireServer(...)
end

-- Une ligne : texte à gauche, bouton à droite (actif ou grisé)
local ordre = 0
local function ligne(t: string, libelle: string?, actif: boolean?, ...)
	ordre += 1
	local cadre = Instance.new("Frame")
	cadre.Name = "Ligne" .. ordre
	cadre.LayoutOrder = ordre
	cadre.Size = UDim2.new(1, -8, 0, 34)
	cadre.BackgroundTransparency = 1
	cadre.Parent = liste
	texte(cadre, t, 30)
	if libelle then
		local b = Instance.new("TextButton")
		b.AnchorPoint = Vector2.new(1, 0)
		b.Position = UDim2.new(1, 0, 0, 2)
		b.Size = UDim2.fromOffset(100, 30)
		b.BackgroundColor3 = if actif then BLEU else GRIS
		b.Font = Enum.Font.FredokaOne
		b.TextScaled = true
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Text = libelle
		b.AutoButtonColor = actif == true
		coin(b, 8)
		b.Parent = cadre
		local args = table.pack(...)
		b.Activated:Connect(function()
			if actif then
				action(table.unpack(args, 1, args.n))
			end
		end)
	end
end

local function titre(t: string)
	ordre += 1
	local l = texte(liste, t, 30, OR)
	l.LayoutOrder = ordre
end

local function reconstruire()
	if not (etat and liste) then
		return
	end
	for _, c in liste:GetChildren() do
		if c:IsA("GuiObject") then
			c:Destroy()
		end
	end
	ordre = 0
	local boosts = {}
	for type, reste in etat.boosts do
		if reste > 0 then
			table.insert(boosts, Textes["BOOST_NOM_" .. type] .. " " .. minutes(reste))
		end
	end
	if #boosts > 0 then
		titre("Boosts : " .. table.concat(boosts, " · "))
	end

	titre("Connexion : jour " .. etat.connexion.jour .. " sur 7")
	ligne(
		etat.connexion.recompense,
		if etat.connexion.pris then "Pris" else "Prendre",
		not etat.connexion.pris,
		"Connexion"
	)

	titre("Roue et coffre du groupe")
	ligne("Roue du jour : un tour gratuit", if etat.roue then "Tourner" else "Demain", etat.roue, "Roue")
	ligne(
		if etat.groupe > 0
			then string.format("Coffre du groupe (dans %d h %02d)", etat.groupe // 3600, etat.groupe % 3600 // 60)
			else "Coffre du groupe OGC Studio",
		"Ouvrir",
		etat.groupe <= 0,
		"Groupe"
	)
end

local function construire()
	gui = Instance.new("ScreenGui")
	gui.Name = "RecompensesProvisoire"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	bouton = Instance.new("TextButton")
	bouton.Name = "BoutonRecompenses"
	bouton.AnchorPoint = Vector2.new(1, 1)
	bouton.Position = UDim2.new(1, -16, 1, -84)
	bouton.Size = UDim2.fromOffset(190, 56)
	bouton.BackgroundColor3 = OR
	bouton.Font = Enum.Font.FredokaOne
	bouton.TextScaled = true
	bouton.TextColor3 = NUIT
	bouton.Text = "Récompenses"
	coin(bouton, 14)
	bouton.Parent = gui

	panneau = Instance.new("Frame")
	panneau.Name = "Panneau"
	panneau.AnchorPoint = Vector2.new(0.5, 0.5)
	panneau.Position = UDim2.fromScale(0.5, 0.5)
	panneau.Size = UDim2.fromScale(0.9, 0.8)
	panneau.BackgroundColor3 = NUIT
	panneau.BackgroundTransparency = 0.05
	panneau.Visible = false
	coin(panneau, 16)
	local taille = Instance.new("UISizeConstraint")
	taille.MaxSize = Vector2.new(720, 620)
	taille.Parent = panneau
	panneau.Parent = gui

	local fermer = Instance.new("TextButton")
	fermer.Name = "BoutonFermer"
	fermer.AnchorPoint = Vector2.new(1, 0)
	fermer.Position = UDim2.new(1, -8, 0, 8)
	fermer.Size = UDim2.fromOffset(40, 40)
	fermer.BackgroundColor3 = Color3.fromRGB(229, 72, 77)
	fermer.Font = Enum.Font.FredokaOne
	fermer.TextScaled = true
	fermer.TextColor3 = Color3.new(1, 1, 1)
	fermer.Text = "X"
	coin(fermer, 10)
	fermer.Parent = panneau
	fermer.Activated:Connect(function()
		panneau.Visible = false
	end)

	saisie = Instance.new("TextBox")
	saisie.Name = "SaisieCode"
	saisie.Position = UDim2.fromOffset(12, 10)
	saisie.Size = UDim2.new(1, -190, 0, 36)
	saisie.BackgroundColor3 = Color3.new(1, 1, 1)
	saisie.PlaceholderText = "Code"
	saisie.Text = ""
	saisie.Font = Enum.Font.FredokaOne
	saisie.TextScaled = true
	saisie.ClearTextOnFocus = false
	coin(saisie, 8)
	saisie.Parent = panneau
	local valider = Instance.new("TextButton")
	valider.Name = "BoutonCode"
	valider.Position = UDim2.new(1, -170, 0, 10)
	valider.Size = UDim2.fromOffset(110, 36)
	valider.BackgroundColor3 = BLEU
	valider.Font = Enum.Font.FredokaOne
	valider.TextScaled = true
	valider.TextColor3 = Color3.new(1, 1, 1)
	valider.Text = "Valider"
	coin(valider, 8)
	valider.Parent = panneau
	valider.Activated:Connect(function()
		if saisie.Text ~= "" then
			action("Code", saisie.Text)
			saisie.Text = ""
		end
	end)

	liste = Instance.new("ScrollingFrame")
	liste.Name = "Liste"
	liste.Position = UDim2.fromOffset(12, 56)
	liste.Size = UDim2.new(1, -24, 1, -68)
	liste.BackgroundTransparency = 1
	liste.AutomaticCanvasSize = Enum.AutomaticSize.Y
	liste.CanvasSize = UDim2.new()
	liste.ScrollBarThickness = 8
	liste.Parent = panneau
	local disposition = Instance.new("UIListLayout")
	disposition.SortOrder = Enum.SortOrder.LayoutOrder
	disposition.Padding = UDim.new(0, 4)
	disposition.Parent = liste

	bouton.Activated:Connect(function()
		panneau.Visible = not panneau.Visible
		reconstruire()
	end)
end

function Recompenses.demarrer()
	construire()
	Remotes.RecompensesEtat.OnClientEvent:Connect(function(e)
		etat = e
		if panneau.Visible then
			reconstruire()
		end
	end)
end

return Recompenses
