-- Côté joueur : affichage (stats, distance, messages) et pilotage du jetpack.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Config = require(RS:WaitForChild("Config"))
local remotes = RS:WaitForChild("Remotes")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local evJetpack = remotes:WaitForChild("JetpackEtat")

local sonPieces = Instance.new("Sound")
sonPieces.Name = "SonPieces"
sonPieces.SoundId = Config.SONS.Pieces
sonPieces.Volume = 0.7
sonPieces.Parent = SoundService

---------------------------------------------------------------------
-- Interface
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "HUDSaut"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

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

local panneau = Instance.new("Frame")
panneau.Name = "Stats"
panneau.AnchorPoint = Vector2.new(0, 0.5)
panneau.Position = UDim2.new(0, 12, 0.5, 0)
panneau.Size = UDim2.new(0, 210, 0, 84)
panneau.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panneau.BackgroundTransparency = 0.3
panneau.Parent = gui
local coin = Instance.new("UICorner")
coin.CornerRadius = UDim.new(0, 10)
coin.Parent = panneau

local function ligneStat(nom, y, couleur)
	local t = Instance.new("TextLabel")
	t.Name = nom
	t.Position = UDim2.new(0, 12, 0, y)
	t.Size = UDim2.new(1, -24, 0, 30)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.Arcade
	t.TextSize = 20
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextColor3 = couleur
	t.Parent = panneau
	return t
end
local lblPuissance = ligneStat("Puissance", 8, Color3.fromRGB(255, 120, 120))
local lblVitesse = ligneStat("Vitesse", 44, Color3.fromRGB(130, 180, 255))

local lblDistance = texte("Distance", UDim2.fromScale(0.5, 0.16), UDim2.fromScale(0.5, 0.09))
local lblDetail = texte("Detail", UDim2.fromScale(0.5, 0.25), UDim2.fromScale(0.5, 0.045))
local lblNotif = texte("Notif", UDim2.fromScale(0.5, 0.78), UDim2.fromScale(0.6, 0.05))

local jauge = Instance.new("Frame")
jauge.Name = "Carburant"
jauge.AnchorPoint = Vector2.new(0.5, 1)
jauge.Position = UDim2.new(0.5, 0, 1, -110)
jauge.Size = UDim2.new(0, 220, 0, 16)
jauge.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
jauge.BackgroundTransparency = 0.3
jauge.Visible = false
jauge.Parent = gui
local jaugePleine = Instance.new("Frame")
jaugePleine.Name = "Niveau"
jaugePleine.Size = UDim2.fromScale(1, 1)
jaugePleine.BackgroundColor3 = Color3.fromRGB(255, 150, 40)
jaugePleine.BorderSizePixel = 0
jaugePleine.Parent = jauge
local jaugeTexte = Instance.new("TextLabel")
jaugeTexte.Size = UDim2.new(1, 0, 0, 18)
jaugeTexte.Position = UDim2.new(0, 0, 0, -20)
jaugeTexte.BackgroundTransparency = 1
jaugeTexte.Font = Enum.Font.Arcade
jaugeTexte.TextSize = 14
jaugeTexte.TextColor3 = Color3.new(1, 1, 1)
jaugeTexte.TextStrokeTransparency = 0
jaugeTexte.Text = "JETPACK : maintiens Saut en l'air"
jaugeTexte.Parent = jauge

local function majStats()
	lblPuissance.Text = "Puissance : " .. (player:GetAttribute("Puissance") or 0)
	lblVitesse.Text = "Vitesse : " .. (player:GetAttribute("Vitesse") or 0)
	jauge.Visible = player:GetAttribute("Jetpack") == true
end
for _, attr in { "Puissance", "Vitesse", "Jetpack" } do
	player:GetAttributeChangedSignal(attr):Connect(majStats)
end
majStats()

-- Petit "+1" qui s'envole au-dessus de la tête pendant l'entraînement
local function popup(message: string, couleur: Color3)
	local char = player.Character
	local tete = char and char:FindFirstChild("Head")
	if not tete then
		return
	end
	local bg = Instance.new("BillboardGui")
	bg.Size = UDim2.new(4, 0, 1.5, 0)
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
		if ancien and nouveau and nouveau > ancien and nouveau - ancien <= 10 then
			popup("+" .. (nouveau - ancien), couleur)
		end
		ancien = nouveau
	end)
end
suivreGain("Puissance", Color3.fromRGB(255, 120, 120))
suivreGain("Vitesse", Color3.fromRGB(130, 180, 255))

---------------------------------------------------------------------
-- Messages du serveur
---------------------------------------------------------------------
local finResultat = 0
remotes:WaitForChild("SautResultat").OnClientEvent:Connect(function(metres, gain, estRecord)
	finResultat = os.clock() + Config.DELAI_RETOUR + 0.5
	lblDistance.Text = string.format("%.1f m", metres)
	lblDistance.TextColor3 = estRecord and Color3.fromRGB(255, 220, 80) or Color3.new(1, 1, 1)
	lblDetail.Text = (estRecord and "NOUVEAU RECORD !  " or "") .. "+" .. gain .. " pièces"
	if gain > 0 then
		sonPieces:Play()
	end
end)

local finNotif = 0
remotes:WaitForChild("Notif").OnClientEvent:Connect(function(message)
	finNotif = os.clock() + 3
	lblNotif.Text = message
end)

---------------------------------------------------------------------
-- Jetpack : maintenir Saut en l'air, sur la piste
---------------------------------------------------------------------
local infoJetpack = Config.OBJETS.Jetpack
local carburant = infoJetpack.carburant
local dernierSaut = 0
local jetActif = false
UIS.JumpRequest:Connect(function()
	dernierSaut = os.clock()
end)

RunService.Heartbeat:Connect(function(dt)
	local maintenant = os.clock()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	local pousse = false
	if hum and hrp and hum.Health > 0 then
		local enLAir = hum.FloorMaterial == Enum.Material.Air
		if not enLAir then
			carburant = infoJetpack.carburant
		elseif player:GetAttribute("Jetpack") and carburant > 0 and hrp.Position.X > Config.DEBUT_PISTE_X then
			local maintenu = (maintenant - dernierSaut) < 0.15 or UIS:IsKeyDown(Enum.KeyCode.Space)
			if maintenu then
				pousse = true
				carburant = math.max(0, carburant - dt)
				local v = hrp.AssemblyLinearVelocity
				local vy = math.min(v.Y + infoJetpack.poussee * dt, math.max(v.Y, infoJetpack.vitesseMontee))
				hrp.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
			end
		end
		jaugePleine.Size = UDim2.fromScale(carburant / infoJetpack.carburant, 1)

		-- Champ de vision plus large quand on va vite
		local cam = workspace.CurrentCamera
		if cam then
			local v = hrp.AssemblyLinearVelocity
			local vitesse = Vector3.new(v.X, 0, v.Z).Magnitude
			local cible = math.min(Config.FOV_BASE + math.max(0, vitesse - Config.VITESSE_BASE) / 4, Config.FOV_MAX)
			cam.FieldOfView += (cible - cam.FieldOfView) * math.min(1, dt * 5)
		end

		-- Distance en direct au-dessus du sable
		if maintenant > finResultat then
			local x = hrp.Position.X - Config.LIGNE_X
			if x > 0 then
				lblDistance.TextColor3 = Color3.new(1, 1, 1)
				lblDistance.Text = string.format("%.1f m", x / Config.STUDS_PAR_METRE)
			else
				lblDistance.Text = ""
			end
			lblDetail.Text = ""
		end
	end

	-- Prévient le serveur quand la poussée démarre ou s'arrête (flammes visibles par tous)
	if pousse ~= jetActif then
		jetActif = pousse
		evJetpack:FireServer(pousse)
	end

	if maintenant > finNotif then
		lblNotif.Text = ""
	end
end)
