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
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))
local Audio = require(script.Parent.Audio)

local player = Players.LocalPlayer

local Hud = {}

local gui: ScreenGui
local lblPuissance, lblVitesse, lblDistance, lblDetail, lblNotif
local jauge, jaugePleine
local jaugeAppel, curseurAppel, zoneParfait, lblQualite
local finResultat = 0
local finNotif = 0
local finQualite = 0
local lblSerie
local indiceReception, traitReception, cibleReception
local TAILLE_CIBLE = 60 -- px : l'anneau a cette taille au moment du contact
local REPERE_RECEPTION = 1.2 -- s : l'anneau commence à se refermer à cette durée avant le contact

-- Jauge d'appel : de JAUGE_AVANT mètres avant le bord jusqu'à la fin de la zone Mordu
local JAUGE_AVANT = 8
local COULEURS_APPEL = {
	Parfait = Color3.fromRGB(255, 205, 50),
	Bon = Color3.fromRGB(90, 210, 110),
	Correct = Color3.fromRGB(200, 200, 210),
	Mordu = Color3.fromRGB(235, 70, 70),
}

-- Position dans la jauge (0 à gauche, 1 à droite) de « avant » mètres avant le bord
local function fractionJauge(avant: number): number
	local total = JAUGE_AVANT + SautConfig.APPEL_MORDU_MAX
	return math.clamp((JAUGE_AVANT - avant) / total, 0, 1)
end

local function construireJaugeAppel()
	jaugeAppel = Instance.new("Frame")
	jaugeAppel.Name = "JaugeAppel"
	jaugeAppel.AnchorPoint = Vector2.new(0.5, 1)
	jaugeAppel.Position = UDim2.new(0.5, 0, 1, -150)
	jaugeAppel.Size = UDim2.fromOffset(360, 22)
	jaugeAppel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	jaugeAppel.BackgroundTransparency = 0.3
	jaugeAppel.BorderSizePixel = 0
	jaugeAppel.Visible = false
	jaugeAppel.Parent = gui

	local function zone(nom: string, debut: number, fin: number, couleur: Color3)
		local z = Instance.new("Frame")
		z.Name = nom
		z.Position = UDim2.fromScale(fractionJauge(debut), 0)
		z.Size = UDim2.fromScale(fractionJauge(fin) - fractionJauge(debut), 1)
		z.BackgroundColor3 = couleur
		z.BackgroundTransparency = 0.25
		z.BorderSizePixel = 0
		z.Parent = jaugeAppel
		return z
	end
	local q = SautConfig.APPEL_QUALITES
	zone("Correct", q[3].avantMax, q[2].avantMax, COULEURS_APPEL.Correct)
	zone("Bon", q[2].avantMax, q[1].avantMax, COULEURS_APPEL.Bon)
	zoneParfait = zone("Parfait", q[1].avantMax, 0, COULEURS_APPEL.Parfait)
	zone("Mordu", 0, -SautConfig.APPEL_MORDU_MAX, COULEURS_APPEL.Mordu)

	curseurAppel = Instance.new("Frame")
	curseurAppel.Name = "Curseur"
	curseurAppel.AnchorPoint = Vector2.new(0.5, 0.5)
	curseurAppel.Position = UDim2.fromScale(0, 0.5)
	curseurAppel.Size = UDim2.new(0, 4, 1, 10)
	curseurAppel.BackgroundColor3 = Color3.new(1, 1, 1)
	curseurAppel.BorderSizePixel = 0
	curseurAppel.ZIndex = 2
	curseurAppel.Parent = jaugeAppel
end

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

	construireJaugeAppel()
	lblQualite = texte("TexteQualite", UDim2.fromScale(0.5, 0.62), UDim2.fromScale(0.4, 0.07))

	-- Le détail du résultat tient sur plusieurs lignes : taille fixe plutôt que mise à l'échelle
	lblDetail.AnchorPoint = Vector2.new(0.5, 0)
	lblDetail.Position = UDim2.fromScale(0.5, 0.21)
	lblDetail.Size = UDim2.fromScale(0.6, 0.2)
	lblDetail.TextScaled = false
	lblDetail.TextSize = 22
	lblDetail.TextYAlignment = Enum.TextYAlignment.Top

	lblSerie = texte("TexteSerie", UDim2.new(0, 12, 0.5, 52), UDim2.fromOffset(210, 28), Vector2.new(0, 0))
	lblSerie.TextColor3 = Color3.fromRGB(255, 205, 50)

	-- Indice de réception : un anneau qui se referme sur une cible ; vert dans la fenêtre de réception
	indiceReception = Instance.new("Frame")
	indiceReception.Name = "IndiceReception"
	indiceReception.AnchorPoint = Vector2.new(0.5, 0.5)
	indiceReception.Position = UDim2.fromScale(0.5, 0.5)
	indiceReception.BackgroundTransparency = 1
	indiceReception.Visible = false
	indiceReception.Parent = gui
	Instance.new("UICorner", indiceReception).CornerRadius = UDim.new(0.5, 0)
	traitReception = Instance.new("UIStroke")
	traitReception.Thickness = 4
	traitReception.Parent = indiceReception
	local cible = Instance.new("Frame")
	cible.Name = "Cible"
	cible.AnchorPoint = Vector2.new(0.5, 0.5)
	cible.Position = UDim2.fromScale(0.5, 0.5)
	cible.Size = UDim2.fromOffset(TAILLE_CIBLE, TAILLE_CIBLE)
	cible.BackgroundTransparency = 1
	cible.Visible = false
	cible.Parent = gui
	Instance.new("UICorner", cible).CornerRadius = UDim.new(0.5, 0)
	local traitCible = Instance.new("UIStroke")
	traitCible.Thickness = 2
	traitCible.Color = Color3.new(1, 1, 1)
	traitCible.Transparency = 0.3
	traitCible.Parent = cible
	cibleReception = cible
end

local function majStats()
	lblPuissance.Text =
		string.format(Textes.STAT_PUISSANCE, Nombres.abreger(math.floor(player:GetAttribute("Puissance") or 0)))
	lblVitesse.Text =
		string.format(Textes.STAT_VITESSE, Nombres.abreger(math.floor(player:GetAttribute("Vitesse") or 0)))
	jauge.Visible = (player:GetAttribute("Propulseur") or "") ~= ""
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
			popup(string.format(Textes.GAIN_STAT, Nombres.abreger(gain)), couleur)
		end
		ancien = nouveau
	end)
end

-- Remplit la jauge du jetpack (fraction de 0 à 1)
function Hud.majCarburant(fraction: number)
	jaugePleine.Size = UDim2.fromScale(fraction, 1)
end

-- Jauge d'appel : visible à l'approche de la planche (avant : mètres avant le bord, négatif après)
function Hud.majJaugeAppel(avant: number)
	local visible = avant <= JAUGE_AVANT and avant >= -SautConfig.APPEL_MORDU_MAX and os.clock() > finResultat
	jaugeAppel.Visible = visible
	if visible then
		curseurAppel.Position = UDim2.fromScale(fractionJauge(avant), 0.5)
		-- Zone Parfait élargie par les talents
		local largeur = SautConfig.APPEL_QUALITES[1].avantMax + (player:GetAttribute("BonusZoneParfait") or 0)
		zoneParfait.Position = UDim2.fromScale(fractionJauge(largeur), 0)
		zoneParfait.Size = UDim2.fromScale(fractionJauge(0) - fractionJauge(largeur), 1)
	end
	if os.clock() > finQualite then
		lblQualite.Text = ""
	end
end

-- Indice de réception : t = secondes estimées avant le contact (nil : caché) ; essaiFait grise l'anneau
function Hud.majIndiceReception(t: number?, essaiFait: boolean)
	local visible = t ~= nil and t <= REPERE_RECEPTION
	indiceReception.Visible = visible
	cibleReception.Visible = visible
	if not visible then
		return
	end
	local taille = TAILLE_CIBLE * (1 + 3 * (t :: number) / REPERE_RECEPTION)
	indiceReception.Size = UDim2.fromOffset(taille, taille)
	if essaiFait then
		traitReception.Color = Color3.fromRGB(150, 150, 160)
	elseif (t :: number) <= SautConfig.RECEPTION_FENETRE then
		traitReception.Color = Color3.fromRGB(90, 210, 110)
	else
		traitReception.Color = Color3.new(1, 1, 1)
	end
end

-- « PARFAIT ! », « BON »… au moment de l'appel
function Hud.afficherAppel(id: string)
	finQualite = os.clock() + 1.2
	lblQualite.Text = Textes["APPEL_" .. id] or ""
	lblQualite.TextColor3 = COULEURS_APPEL[id] or Color3.new(1, 1, 1)
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

	for _, attr in { "Puissance", "Vitesse", "Propulseur" } do
		player:GetAttributeChangedSignal(attr):Connect(majStats)
	end
	majStats()
	suivreGain("Puissance", Color3.fromRGB(255, 120, 120))
	suivreGain("Vitesse", Color3.fromRGB(130, 180, 255))

	-- Série de sauts parfaits, à gauche (provisoire, futur `TexteSerie` de HudPrincipal)
	local function majSerie()
		local n = player:GetAttribute("Serie") or 0
		lblSerie.Text = if n > 0 then string.format(Textes.SERIE, tostring(n)) else ""
	end
	player:GetAttributeChangedSignal("Serie"):Connect(majSerie)
	majSerie()

	Remotes.SautResultat.OnClientEvent:Connect(function(metres, gain, estRecord, rare, idAppel, maitrise)
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
		local texteAppel = ""
		local qAppel = idAppel and SautConfig.qualiteAppelParId(idAppel)
		if qAppel then
			texteAppel = string.format(
				Textes.RESULTAT_APPEL,
				Textes["APPEL_" .. idAppel],
				(string.gsub(string.format("%.2f", qAppel.multiplicateur), "%.", ","))
			)
		end
		-- Maîtrise : réception, saut parfait, série (T-103)
		local texteMaitrise = ""
		if maitrise then
			if maitrise.reception then
				texteMaitrise ..= string.format(
					Textes.RESULTAT_RECEPTION,
					tostring(math.floor(SautConfig.RECEPTION_BONUS * 100 + 0.5))
				)
			else
				texteMaitrise ..= Textes.RESULTAT_RECEPTION_RATEE
			end
			if maitrise.parfait then
				texteMaitrise ..= string.format(
					Textes.RESULTAT_PARFAIT,
					(string.gsub(tostring(SautConfig.PARFAIT_MULTIPLICATEUR), "%.", ","))
				)
				local bonusSerie = math.min(maitrise.serie * SautConfig.SERIE_BONUS, SautConfig.SERIE_BONUS_MAX)
				texteMaitrise ..= string.format(
					Textes.RESULTAT_SERIE,
					tostring(maitrise.serie),
					tostring(math.floor(bonusSerie * 100 + 0.5))
				)
			end
		end
		lblDetail.Text = texteAppel
			.. texteMaitrise
			.. texteRare
			.. (estRecord and Textes.NOUVEAU_RECORD or "")
			.. string.format(Textes.GAIN_PIECES, Nombres.abreger(gain))
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
		popup(string.format(Textes.ANNEAU_GAIN, Nombres.abreger(pieces)), Color3.fromRGB(255, 220, 80))
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
