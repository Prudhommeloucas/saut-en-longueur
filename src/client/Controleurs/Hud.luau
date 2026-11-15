-- Hud : panneau des stats, distance et résultat du saut, messages, jauge du jetpack, « +1 » d'entraînement.
-- Provisoire : l'écran est encore créé par le code ; il sera construit dans Studio (T-108, T-109).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Audio = require(script.Parent.Audio)

local player = Players.LocalPlayer

local Hud = {}

local gui: ScreenGui
local lblPuissance, lblVitesse, lblDistance, lblDetail, lblNotif
local jauge, jaugePleine
local finResultat = 0
local finNotif = 0

local function texte(nom, pos, taille, ancre)
	local t = Instance.new("TextLabel")
	t.Name = nom
	t.AnchorPoint = ancre or Vector2.new(0.5, 0.5)
	t.Position = pos
	t.Size = taille
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.Arcade
	t.TextScaled = true
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0
	t.Text = ""
	t.Parent = gui
	return t
end

local function construire()
	gui = Instance.new("ScreenGui")
	gui.Name = "HUDSaut"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local panneau = Instance.new("Frame")
	panneau.Name = "Stats"
	panneau.AnchorPoint = Vector2.new(0, 0.5)
	panneau.Position = UDim2.new(0, 12, 0.5, 0)
	panneau.Size = UDim2.fromOffset(210, 84)
	panneau.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	panneau.BackgroundTransparency = 0.3
	panneau.Parent = gui
	local coin = Instance.new("UICorner")
	coin.CornerRadius = UDim.new(0, 10)
	coin.Parent = panneau

	local function ligneStat(nom, y, couleur)
		local t = Instance.new("TextLabel")
		t.Name = nom
		t.Position = UDim2.fromOffset(12, y)
		t.Size = UDim2.new(1, -24, 0, 30)
		t.BackgroundTransparency = 1
		t.Font = Enum.Font.Arcade
		t.TextSize = 20
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.TextColor3 = couleur
		t.Parent = panneau
		return t
	end
	lblPuissance = ligneStat("Puissance", 8, Color3.fromRGB(255, 120, 120))
	lblVitesse = ligneStat("Vitesse", 44, Color3.fromRGB(130, 180, 255))

	lblDistance = texte("Distance", UDim2.fromScale(0.5, 0.16), UDim2.fromScale(0.5, 0.09))
	lblDetail = texte("Detail", UDim2.fromScale(0.5, 0.25), UDim2.fromScale(0.5, 0.045))
	lblNotif = texte("Notif", UDim2.fromScale(0.5, 0.78), UDim2.fromScale(0.6, 0.05))

	jauge = Instance.new("Frame")
	jauge.Name = "Carburant"
	jauge.AnchorPoint = Vector2.new(0.5, 1)
	jauge.Position = UDim2.new(0.5, 0, 1, -110)
	jauge.Size = UDim2.fromOffset(220, 16)
	jauge.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	jauge.BackgroundTransparency = 0.3
	jauge.Visible = false
	jauge.Parent = gui
	jaugePleine = Instance.new("Frame")
	jaugePleine.Name = "Niveau"
	jaugePleine.Size = UDim2.fromScale(1, 1)
	jaugePleine.BackgroundColor3 = Color3.fromRGB(255, 150, 40)
	jaugePleine.BorderSizePixel = 0
	jaugePleine.Parent = jauge
	local jaugeTexte = Instance.new("TextLabel")
	jaugeTexte.Size = UDim2.new(1, 0, 0, 18)
	jaugeTexte.Position = UDim2.fromOffset(0, -20)
	jaugeTexte.BackgroundTransparency = 1
	jaugeTexte.Font = Enum.Font.Arcade
	jaugeTexte.TextSize = 14
	jaugeTexte.TextColor3 = Color3.new(1, 1, 1)
	jaugeTexte.TextStrokeTransparency = 0
	jaugeTexte.Text = Textes.AIDE_JETPACK
	jaugeTexte.Parent = jauge
end

local function majStats()
	lblPuissance.Text =
		string.format(Textes.STAT_PUISSANCE, tostring(math.floor(player:GetAttribute("Puissance") or 0)))
	lblVitesse.Text = string.format(Textes.STAT_VITESSE, tostring(math.floor(player:GetAttribute("Vitesse") or 0)))
	jauge.Visible = player:GetAttribute("Jetpack") == true
end

-- Petit "+1" qui s'envole au-dessus de la tête pendant l'entraînement
local function popup(message: string, couleur: Color3)
	local char = player.Character
	local tete = char and char:FindFirstChild("Head")
	if not tete then
		return
	end
	local bg = Instance.new("BillboardGui")
	bg.Size = UDim2.fromScale(4, 1.5)
	bg.StudsOffset = Vector3.new(math.random(-15, 15) / 10, 2, 0)
	bg.AlwaysOnTop = true
	bg.Adornee = tete
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.Arcade
	t.TextScaled = true
	t.TextColor3 = couleur
	t.TextStrokeTransparency = 0
	t.Text = message
	t.Parent = bg
	bg.Parent = gui
	local info = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(bg, info, { StudsOffset = bg.StudsOffset + Vector3.new(0, 3, 0) }):Play()
	TweenService:Create(t, info, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	task.delay(0.85, function()
		bg:Destroy()
	end)
end

local function suivreGain(attr: string, couleur: Color3)
	local ancien = player:GetAttribute(attr)
	player:GetAttributeChangedSignal(attr):Connect(function()
		local nouveau = player:GetAttribute(attr)
		-- Pas de « + » pour un saut de valeur (chargement des données)
		if ancien and nouveau and nouveau > ancien and nouveau - ancien <= 1000 then
			local gain = math.floor((nouveau - ancien) * 10 + 0.5) / 10
			popup(string.format(Textes.GAIN_STAT, string.format("%g", gain)), couleur)
		end
		ancien = nouveau
	end)
end

-- Remplit la jauge du jetpack (fraction de 0 à 1)
function Hud.majCarburant(fraction: number)
	jaugePleine.Size = UDim2.fromScale(fraction, 1)
end

-- Distance en direct au-dessus du sable (x : studs au-delà de la planche), sauf pendant l'affichage du résultat
function Hud.distanceEnDirect(x: number)
	if os.clock() > finResultat then
		if x > 0 then
			lblDistance.TextColor3 = Color3.new(1, 1, 1)
			lblDistance.Text = string.format(Textes.DISTANCE, x / SautConfig.STUDS_PAR_METRE)
		else
			lblDistance.Text = ""
		end
		lblDetail.Text = ""
	end
end

function Hud.demarrer()
	construire()

	for _, attr in { "Puissance", "Vitesse", "Jetpack" } do
		player:GetAttributeChangedSignal(attr):Connect(majStats)
	end
	majStats()
	suivreGain("Puissance", Color3.fromRGB(255, 120, 120))
	suivreGain("Vitesse", Color3.fromRGB(130, 180, 255))

	Remotes.SautResultat.OnClientEvent:Connect(function(metres, gain, estRecord, rare)
		finResultat = os.clock() + SautConfig.DELAI_RETOUR + 0.5
		lblDistance.Text = string.format(Textes.DISTANCE, metres)
		lblDistance.TextColor3 = estRecord and Color3.fromRGB(255, 220, 80) or Color3.new(1, 1, 1)
		local texteRare = ""
		for _, r in SautConfig.SAUTS_RARES do
			if r.id == rare then
				texteRare =
					string.format(Textes.RESULTAT_RARE, Textes["SAUT_RARE_" .. r.id], tostring(r.multiplicateur))
			end
		end
		lblDetail.Text = texteRare
			.. (estRecord and Textes.NOUVEAU_RECORD or "")
			.. string.format(Textes.GAIN_PIECES, tostring(gain))
		if gain > 0 then
			Audio.pieces()
		end
	end)

	-- Saut rare annoncé dès le passage de la planche (le sable et la caméra viendront avec T-111)
	player:GetAttributeChangedSignal("SautRare"):Connect(function()
		local id = player:GetAttribute("SautRare")
		if type(id) == "string" and id ~= "" then
			finNotif = os.clock() + 2.5
			lblNotif.Text = Textes["SAUT_RARE_" .. id] or ""
			lblNotif.TextColor3 = Color3.fromRGB(255, 200, 40)
		end
	end)

	-- Anneau traversé : « +5 » au-dessus de la tête
	Remotes.AnneauTraverse.OnClientEvent:Connect(function(pieces)
		popup(string.format(Textes.ANNEAU_GAIN, tostring(pieces)), Color3.fromRGB(255, 220, 80))
		Audio.pieces()
	end)

	Remotes.Notif.OnClientEvent:Connect(function(message)
		finNotif = os.clock() + 3
		lblNotif.Text = message
		lblNotif.TextColor3 = Color3.new(1, 1, 1)
	end)

	RunService.Heartbeat:Connect(function()
		if os.clock() > finNotif then
			lblNotif.Text = ""
		end
	end)
end

return Hud
