-- Paliers (joueur, T-204) : mise en scène quand une fonction s'ouvre (événement Deblocage), message quand un
-- palier de record est franchi (PalierFranchi), prochain palier affiché en haut de l'écran, bouton des compagnons
-- caché tant qu'ils ne sont pas ouverts.
-- Provisoire : écran créé par le code (PaliersProvisoire) ; TextePalier et BarrePalier iront dans HudPrincipal
-- (T-109), l'échelle complète dans EcranPaliers (T-209).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local PaliersConfig = require(Config:WaitForChild("Paliers"))
local Textes = require(Config:WaitForChild("Textes"))
local Sons = require(Config:WaitForChild("Sons"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))

local player = Players.LocalPlayer

local Paliers = {}

local OR = Color3.fromRGB(255, 200, 61)
local gui, cadrePalier, barre, remplissage, textePalier, banniere
local file = {} -- bannières en attente (plusieurs ouvertures au même saut)
local enCours = false

local function construire()
	gui = Instance.new("ScreenGui")
	gui.Name = "PaliersProvisoire"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	cadrePalier = Instance.new("Frame")
	cadrePalier.Name = "Palier"
	cadrePalier.AnchorPoint = Vector2.new(0.5, 0)
	cadrePalier.Position = UDim2.new(0.5, 0, 0, 8)
	cadrePalier.Size = UDim2.fromOffset(280, 44)
	cadrePalier.BackgroundTransparency = 1
	cadrePalier.Parent = gui
	textePalier = Instance.new("TextLabel")
	textePalier.Name = "TextePalier"
	textePalier.Size = UDim2.new(1, 0, 0, 24)
	textePalier.BackgroundTransparency = 1
	textePalier.Font = Enum.Font.FredokaOne
	textePalier.TextScaled = true
	textePalier.TextColor3 = Color3.new(1, 1, 1)
	textePalier.TextStrokeTransparency = 0.4
	textePalier.Parent = cadrePalier
	barre = Instance.new("Frame")
	barre.Name = "BarrePalier"
	barre.Position = UDim2.fromOffset(0, 28)
	barre.Size = UDim2.new(1, 0, 0, 10)
	barre.BackgroundColor3 = Color3.fromRGB(22, 33, 62)
	barre.BackgroundTransparency = 0.3
	local coin = Instance.new("UICorner")
	coin.CornerRadius = UDim.new(1, 0)
	coin.Parent = barre
	barre.Parent = cadrePalier
	remplissage = Instance.new("Frame")
	remplissage.Name = "Remplissage"
	remplissage.Size = UDim2.fromScale(0, 1)
	remplissage.BackgroundColor3 = OR
	coin:Clone().Parent = remplissage
	remplissage.Parent = barre

	banniere = Instance.new("TextLabel")
	banniere.Name = "Deblocage"
	banniere.AnchorPoint = Vector2.new(0.5, 0.5)
	banniere.Position = UDim2.fromScale(0.5, 0.3)
	banniere.Size = UDim2.fromOffset(520, 70)
	banniere.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
	banniere.Font = Enum.Font.FredokaOne
	banniere.TextScaled = true
	banniere.TextColor3 = Color3.new(1, 1, 1)
	banniere.TextStrokeTransparency = 0.5
	banniere.Visible = false
	local coinB = Instance.new("UICorner")
	coinB.CornerRadius = UDim.new(0, 16)
	coinB.Parent = banniere
	local trait = Instance.new("UIStroke")
	trait.Color = OR
	trait.Thickness = 4
	trait.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	trait.Parent = banniere
	banniere.Parent = gui
end

-- Prochain palier et barre de progression depuis le palier précédent
local function majPalier()
	local record = player:GetAttribute("Record") or 0
	local monde = Map.mondeDe(player)
	local p = PaliersConfig.prochain(monde, record)
	if not p then
		textePalier.Text = Textes.PALIER_SOMMET
		remplissage.Size = UDim2.fromScale(1, 1)
		return
	end
	local precedent = 0
	for _, q in PaliersConfig.ECHELLE[monde] do
		if q.record < p.record then
			precedent = q.record
		end
	end
	textePalier.Text = string.format(Textes.PALIER_PROCHAIN, Nombres.distance(p.record))
		.. string.format("  (+%s gemmes)", Nombres.abreger(p.gemmes))
	remplissage.Size = UDim2.fromScale(math.clamp((record - precedent) / (p.record - precedent), 0, 1), 1)
end

-- Bouton des compagnons (provisoire, en attendant HudPrincipal) caché tant qu'ils ne sont pas ouverts
local function majBoutons()
	local provisoire = player.PlayerGui:FindFirstChild("BoutonsProvisoires")
	local bouton = provisoire and provisoire:FindFirstChild("BoutonCompagnons")
	if bouton and bouton:IsA("GuiObject") then
		bouton.Visible = PaliersConfig.estOuvert(player, "Compagnons")
	end
end

local function jouerSon(id: string)
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = 0.8
	s.Parent = gui
	s:Play()
	s.Ended:Once(function()
		s:Destroy()
	end)
end

-- Bannière « Nouveau : … ! » : grossit, reste 2,5 s, s'efface ; les suivantes attendent leur tour
local function suivante()
	if enCours or #file == 0 then
		return
	end
	enCours = true
	local texte = table.remove(file, 1)
	banniere.Text = texte
	banniere.Size = UDim2.fromOffset(260, 35)
	banniere.TextTransparency = 0
	banniere.BackgroundTransparency = 0
	banniere.Visible = true
	jouerSon(Sons.Record)
	TweenService:Create(banniere, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(520, 70) })
		:Play()
	task.delay(2.5, function()
		local fin =
			TweenService:Create(banniere, TweenInfo.new(0.4), { TextTransparency = 1, BackgroundTransparency = 1 })
		fin:Play()
		fin.Completed:Wait()
		banniere.Visible = false
		enCours = false
		suivante()
	end)
end

function Paliers.demarrer()
	construire()
	majPalier()
	majBoutons()
	player:GetAttributeChangedSignal("Record"):Connect(function()
		majPalier()
		majBoutons()
	end)
	task.spawn(function()
		-- le bouton provisoire est créé par un autre contrôleur : on le cache dès qu'il apparaît
		local provisoire = player.PlayerGui:WaitForChild("BoutonsProvisoires", 30)
		if provisoire then
			provisoire:WaitForChild("BoutonCompagnons", 30)
			majBoutons()
		end
	end)
	Remotes.Deblocage.OnClientEvent:Connect(function(_, nom)
		table.insert(file, string.format(Textes.DEBLOCAGE, nom))
		suivante()
	end)
	Remotes.PalierFranchi.OnClientEvent:Connect(function(_, record, gemmes, pieces, recu)
		local message = if recu
			then string.format(
				Textes.PALIER_FRANCHI,
				Nombres.distance(record),
				Nombres.abreger(gemmes),
				Nombres.abreger(pieces)
			)
			else string.format(Textes.PALIER_A_RECLAMER, Nombres.distance(record))
		table.insert(file, message)
		suivante()
	end)
end

return Paliers
