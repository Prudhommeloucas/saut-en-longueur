-- Rythme (joueur, T-202) : entraînement actif. Pendant l'entraînement (attribut « Entraine » posé par le serveur),
-- un cercle se referme sur une cible une fois par seconde, calé sur l'heure du serveur. Appuyer (bouton, touche E,
-- bouton X de la manette) quand il touche la cible envoie l'appui au serveur, qui le juge (Parfait × 3, Bon × 2).
-- Provisoire : l'écran est créé par le code ; le vrai HudEntrainement viendra avec T-209.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local StatsConfig = require(Config:WaitForChild("Stats"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))

local player = Players.LocalPlayer
local RYTHME = StatsConfig.RYTHME

local Rythme = {}

local TAILLE_CIBLE = 70 -- px
local TAILLE_DEPART = 230 -- px : taille du cercle juste après un battement
local COULEURS = {
	Parfait = Color3.fromRGB(255, 200, 61),
	Bon = Color3.fromRGB(43, 182, 115),
	Rate = Color3.fromRGB(229, 72, 77),
	Cercle = Color3.fromRGB(255, 255, 255),
}

local gui, cadre, cible, cercle, bouton, lblResultat, lblBonus
local finResultat = 0
local dernierAppui = -1

local function anneau(parent: Instance, nom: string, couleur: Color3, epaisseur: number): Frame
	local f = Instance.new("Frame")
	f.Name = nom
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = UDim2.fromScale(0.5, 0.5)
	f.BackgroundTransparency = 1
	local coin = Instance.new("UICorner")
	coin.CornerRadius = UDim.new(1, 0)
	coin.Parent = f
	local trait = Instance.new("UIStroke")
	trait.Color = couleur
	trait.Thickness = epaisseur
	trait.Parent = f
	f.Parent = parent
	return f
end

local function texte(parent: Instance, nom: string, position: UDim2, taille: number): TextLabel
	local t = Instance.new("TextLabel")
	t.Name = nom
	t.AnchorPoint = Vector2.new(0.5, 0.5)
	t.Position = position
	t.Size = UDim2.fromOffset(320, taille)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0.4
	t.Text = ""
	t.Parent = parent
	return t
end

local function construire()
	gui = Instance.new("ScreenGui")
	gui.Name = "RythmeProvisoire"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	cadre = Instance.new("Frame")
	cadre.Name = "Cadre"
	cadre.AnchorPoint = Vector2.new(0.5, 1)
	cadre.Position = UDim2.new(0.5, 0, 1, -150)
	cadre.Size = UDim2.fromOffset(TAILLE_DEPART, TAILLE_DEPART)
	cadre.BackgroundTransparency = 1
	cadre.Visible = false
	cadre.Parent = gui
	cible = anneau(cadre, "Cible", COULEURS.Parfait, 6)
	cible.Size = UDim2.fromOffset(TAILLE_CIBLE, TAILLE_CIBLE)
	cercle = anneau(cadre, "Cercle", COULEURS.Cercle, 4)
	bouton = Instance.new("TextButton")
	bouton.Name = "Pousser"
	bouton.AnchorPoint = Vector2.new(0.5, 0.5)
	bouton.Position = UDim2.fromScale(0.5, 0.5)
	bouton.Size = UDim2.fromOffset(TAILLE_CIBLE - 14, TAILLE_CIBLE - 14)
	bouton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
	bouton.Font = Enum.Font.FredokaOne
	bouton.TextScaled = true
	bouton.TextColor3 = Color3.new(1, 1, 1)
	bouton.Text = Textes.RYTHME_BOUTON
	local coin = Instance.new("UICorner")
	coin.CornerRadius = UDim.new(1, 0)
	coin.Parent = bouton
	bouton.Parent = cadre
	lblResultat = texte(cadre, "Resultat", UDim2.new(0.5, 0, 0, -20), 34)
	lblBonus = texte(gui, "BonusDebutant", UDim2.new(0.5, 0, 1, -110), 26)
	lblBonus.TextColor3 = COULEURS.Parfait
	local aide = texte(cadre, "Aide", UDim2.new(0.5, 0, 1, 18), 20)
	aide.Text = Textes.RYTHME_AIDE
	gui.Parent = player:WaitForChild("PlayerGui")
end

local function rythmeOuvert(): boolean
	return player:GetAttribute("Entraine") ~= nil and (player:GetAttribute("Record") or 0) >= RYTHME.recordRequis
end

local function appuyer()
	if not rythmeOuvert() then
		return
	end
	local t = workspace:GetServerTimeNow()
	local battement = math.floor(t / RYTHME.periode + 0.5)
	if battement == dernierAppui then
		return
	end
	dernierAppui = battement
	Remotes.Rythme:FireServer(t)
end

local function chaqueImage()
	local ouvert = rythmeOuvert()
	cadre.Visible = ouvert
	local bonus = StatsConfig.bonusDebutant(player:GetAttribute("Record"))
	lblBonus.Visible = player:GetAttribute("Entraine") ~= nil and bonus > 1.01
	if lblBonus.Visible then
		lblBonus.Text = string.format(Textes.BONUS_DEBUTANT, Nombres.abreger(bonus))
	end
	if not ouvert then
		return
	end
	-- Phase dans la seconde : 0 juste après un battement, 1 au battement suivant
	local phase = (workspace:GetServerTimeNow() % RYTHME.periode) / RYTHME.periode
	local taille = TAILLE_CIBLE + (TAILLE_DEPART - TAILLE_CIBLE) * (1 - phase)
	cercle.Size = UDim2.fromOffset(taille, taille)
	if os.clock() > finResultat then
		lblResultat.Text = ""
	end
end

local function surResultat(qualite: string?, gain: number)
	if qualite == "Parfait" then
		lblResultat.Text = string.format(Textes.RYTHME_PARFAIT, Nombres.abreger(gain))
		lblResultat.TextColor3 = COULEURS.Parfait
	elseif qualite == "Bon" then
		lblResultat.Text = string.format(Textes.RYTHME_BON, Nombres.abreger(gain))
		lblResultat.TextColor3 = COULEURS.Bon
	else
		lblResultat.Text = Textes.RYTHME_RATE
		lblResultat.TextColor3 = COULEURS.Rate
	end
	finResultat = os.clock() + 0.7
end

function Rythme.demarrer()
	construire()
	bouton.Activated:Connect(appuyer)
	UserInputService.InputBegan:Connect(function(input, traite)
		if traite then
			return
		end
		if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.ButtonX then
			appuyer()
		end
	end)
	Remotes.RythmeResultat.OnClientEvent:Connect(surResultat)
	RunService.RenderStepped:Connect(chaqueImage)
end

return Rythme
