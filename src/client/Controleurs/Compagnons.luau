-- Compagnons (joueur) : affiche les compagnons équipés de chaque joueur, les fait suivre en bondissant
-- et sauter avec lui. Lit l'attribut « Equipe » des joueurs ; tout est local à ce client (aucune physique).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"):WaitForChild("Compagnons"))
local Apparence = require(Shared:WaitForChild("Util"):WaitForChild("Apparence"))
local Remotes = require(Shared:WaitForChild("Remotes"))

local SUIVI = Config.SUIVI

local Compagnons = {}

local dossier: Folder
local suivis = {} -- [player] = { modeles = {Model}, positions = {CFrame} }
local etat = nil -- dernier état de l'inventaire du joueur local (pour les futurs écrans, T-305)

-- Inventaire du joueur local, tel qu'envoyé par le serveur
function Compagnons.etat()
	return etat
end

local function preparer(modele: Model)
	for _, p in modele:GetDescendants() do
		if p:IsA("BasePart") then
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.CastShadow = false
		end
	end
end

local function vider(player: Player)
	local s = suivis[player]
	if s then
		for _, m in s.modeles do
			m:Destroy()
		end
		suivis[player] = nil
	end
end

local function construire(player: Player)
	vider(player)
	local equipe = player:GetAttribute("Equipe")
	if type(equipe) ~= "string" or equipe == "" then
		return
	end
	local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Compagnons")
	local s = { modeles = {}, positions = {} }
	for morceau in string.gmatch(equipe, "[^,]+") do
		local espece, version = string.match(morceau, "^([^:]+):(.+)$")
		local source = espece and assets:FindFirstChild(espece)
		if source then
			local m = source:Clone()
			Apparence.appliquerVersion(m, version)
			preparer(m)
			m.Parent = dossier
			table.insert(s.modeles, m)
		end
	end
	suivis[player] = s
end

local function suivreJoueur(player: Player)
	player:GetAttributeChangedSignal("Equipe"):Connect(function()
		construire(player)
	end)
	construire(player)
end

local function chaqueImage(dt: number)
	local temps = os.clock()
	local camera = workspace.CurrentCamera
	local lissage = 1 - math.exp(-SUIVI.douceur * dt)
	for player, s in suivis do
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local loin = camera and hrp and (hrp.Position - camera.CFrame.Position).Magnitude > SUIVI.distanceAffichage
		for i, m in s.modeles do
			if not (hrp and hum) or loin then
				m.Parent = nil
				s.positions[i] = nil
				continue
			end
			m.Parent = dossier
			-- Place derrière le joueur, en éventail, au niveau de ses pieds (ils sautent donc avec lui)
			local n = #s.modeles
			local cote = (i - (n + 1) / 2) * SUIVI.ecart
			local base = hrp.CFrame * CFrame.new(cote, 0, SUIVI.distance)
			local sol = hrp.Position.Y - hrp.Size.Y / 2 - hum.HipHeight
			local v = hrp.AssemblyLinearVelocity
			local bond = 0
			if Vector3.new(v.X, 0, v.Z).Magnitude > 1 and hum.FloorMaterial ~= Enum.Material.Air then
				bond = math.abs(math.sin(temps * SUIVI.frequenceBond + i)) * SUIVI.hauteurBond
			end
			local _, lacet, _ = hrp.CFrame:ToOrientation()
			local cible = CFrame.new(base.Position.X, sol + bond, base.Position.Z) * CFrame.Angles(0, lacet, 0)
			local actuelle = s.positions[i] or cible
			actuelle = actuelle:Lerp(cible, lissage)
			s.positions[i] = actuelle
			m:PivotTo(actuelle)
		end
	end
end

function Compagnons.demarrer()
	dossier = Instance.new("Folder")
	dossier.Name = "CompagnonsVisibles"
	dossier.Parent = workspace

	Players.PlayerAdded:Connect(suivreJoueur)
	for _, p in Players:GetPlayers() do
		suivreJoueur(p)
	end
	Players.PlayerRemoving:Connect(vider)

	Remotes.CompagnonsEtat.OnClientEvent:Connect(function(nouveau)
		etat = nouveau
	end)

	RunService.Heartbeat:Connect(chaqueImage)
end

return Compagnons
