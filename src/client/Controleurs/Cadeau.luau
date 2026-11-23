-- Cadeau (joueur, T-219) : le cadeau de temps de jeu posé sur la place centrale (tag « Cadeau »). Au-dessus, un
-- compte à rebours jusqu'au prochain cadeau de la session, ou « Cadeau prêt ! » qui rebondit. L'invite du cadeau
-- (posée par le serveur) l'ouvre ; à l'ouverture (CadeauOuvert), le couvercle saute et des confettis jaillissent.
-- Les meshes du couvercle s'appellent « Couvercle_<Couleur> ». L'état vient de RecompensesEtat (cadeaux, toutes les 10 s).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Textes = require(Shared:WaitForChild("Config"):WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))

local player = Players.LocalPlayer

local Cadeau = {}

local OR = Color3.fromRGB(255, 200, 61)
local NUIT = Color3.fromRGB(22, 33, 62)
local VERT = Color3.fromRGB(43, 182, 115)

local cadeaux = {} -- etat.cadeaux reçu
local recu = os.clock() -- heure de réception de cet état
local affichages = {} -- [modele] = { texte, cadre }

-- Secondes avant le prochain cadeau non pris (0 s'il est prêt, nil s'il n'en reste aucun)
local function prochain(): number?
	for _, c in cadeaux do
		if not c.pris then
			return math.max(0, c.reste - (os.clock() - recu))
		end
	end
	return nil
end

local function afficher(modele: Model)
	-- Le modèle peut arriver par morceaux (streaming) : on attend son socle
	local hote = modele:FindFirstChild("Socle", true) or modele:WaitForChild("Socle", 15)
	if not hote then
		return
	end
	local b = Instance.new("BillboardGui")
	b.Name = "CompteCadeau"
	b.Adornee = hote
	b.Size = UDim2.fromOffset(220, 56)
	b.StudsOffsetWorldSpace = Vector3.new(0, 12, 0)
	b.MaxDistance = 140
	b.AlwaysOnTop = false
	b.Parent = player:WaitForChild("PlayerGui")
	local cadre = Instance.new("Frame")
	cadre.Size = UDim2.fromScale(1, 1)
	cadre.BackgroundColor3 = NUIT
	cadre.BackgroundTransparency = 0.1
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 14)
	c.Parent = cadre
	local s = Instance.new("UIStroke")
	s.Thickness = 3
	s.Color = OR
	s.Parent = cadre
	cadre.Parent = b
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = UDim2.new(1, -16, 1, -8)
	t.Position = UDim2.fromOffset(8, 4)
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = Color3.new(1, 1, 1)
	t.Parent = cadre
	affichages[modele] = { texte = t, cadre = cadre, gui = b, trait = s }
end

local function majAffichages()
	local reste = prochain()
	local saut = math.abs(math.sin(os.clock() * 4)) * 1.2
	for modele, a in affichages do
		if not modele.Parent then
			a.gui:Destroy()
			affichages[modele] = nil
			continue
		end
		if reste == nil then
			a.gui.Enabled = false
		else
			a.gui.Enabled = true
			if reste <= 0 then
				a.texte.Text = Textes.CADEAU_PRET
				a.trait.Color = VERT
				a.gui.StudsOffsetWorldSpace = Vector3.new(0, 12 + saut, 0)
			else
				a.texte.Text =
					string.format(Textes.CADEAU_DANS, string.format("%d:%02d", reste // 60, math.floor(reste % 60)))
				a.trait.Color = OR
				a.gui.StudsOffsetWorldSpace = Vector3.new(0, 12, 0)
			end
		end
	end
end

-- Couvercle qui saute et retombe, confettis
local function ouvrir()
	for modele in affichages do
		local couvercle = {}
		for _, p in modele:GetDescendants() do
			if p:IsA("BasePart") and string.sub(p.Name, 1, 10) == "Couvercle_" then
				table.insert(couvercle, p)
			end
		end
		for _, p in couvercle do
			local depart = p.CFrame
			local haut = depart * CFrame.new(0, 7, 0) * CFrame.Angles(0, math.rad(180), math.rad(20))
			local monte = TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				CFrame = haut,
			})
			monte:Play()
			task.delay(1.2, function()
				TweenService:Create(p, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
					CFrame = depart,
				}):Play()
			end)
		end
		local hote = modele:FindFirstChild("Socle", true) or modele:FindFirstChildWhichIsA("BasePart", true)
		if hote then
			local e = Instance.new("ParticleEmitter")
			e.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, OR),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 92, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 144, 255)),
			})
			e.Size = NumberSequence.new(0.5)
			e.Speed = NumberRange.new(20, 30)
			e.SpreadAngle = Vector2.new(35, 35)
			e.Lifetime = NumberRange.new(1.2, 1.8)
			e.Acceleration = Vector3.new(0, -30, 0)
			e.Rate = 0
			e.EmissionDirection = Enum.NormalId.Top
			e.Parent = hote
			e:Emit(60)
			task.delay(3, function()
				e:Destroy()
			end)
		end
	end
end

function Cadeau.demarrer()
	Map.surChaque("Cadeau", function(modele)
		if modele:IsA("Model") then
			afficher(modele)
		end
	end)
	Remotes.RecompensesEtat.OnClientEvent:Connect(function(e)
		cadeaux = e.cadeaux or {}
		recu = os.clock()
	end)
	Remotes.CadeauOuvert.OnClientEvent:Connect(ouvrir)
	RunService.Heartbeat:Connect(majAffichages)
end

return Cadeau
