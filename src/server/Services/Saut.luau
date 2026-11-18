-- Saut : appel, atterrissage détecté par la position, borne de plausibilité, sauts rares,
-- effets d'atterrissage, flammes du jetpack dans la limite du carburant.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local StatsConfig = require(Config:WaitForChild("Stats"))
local Equipement = require(Config:WaitForChild("Equipement"))
local Sons = require(Config:WaitForChild("Sons"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Donnees = require(script.Parent.Donnees)
local Personnage = require(script.Parent.Personnage)
local Compagnons = require(script.Parent.Compagnons)
local Anneaux = require(script.Parent.Anneaux)
local Textes = require(Config:WaitForChild("Textes"))

local Saut = {}

local enAtterrissage = {} -- [player] = true entre l'atterrissage et le retour piste

-- Gerbe de sable à l'atterrissage, confettis et fanfare en cas de record
local function effetAtterrissage(position: Vector3, estRecord: boolean)
	local p = Instance.new("Part")
	p.Name = "EffetAtterrissage"
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Transparency = 1
	p.Size = Vector3.new(3, 0.2, 3)
	p.Position = Vector3.new(position.X, 0.2, position.Z)

	local s = Instance.new("ParticleEmitter")
	s.Texture = "rbxasset://textures/particles/smoke_main.dds"
	s.Enabled = false
	s.EmissionDirection = Enum.NormalId.Top
	s.Color = ColorSequence.new(Color3.fromRGB(232, 205, 140))
	s.Lifetime = NumberRange.new(0.6, 1.1)
	s.Speed = NumberRange.new(12, 26)
	s.SpreadAngle = Vector2.new(55, 55)
	s.Acceleration = Vector3.new(0, -50, 0)
	s.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 3.5) })
	s.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	s.Parent = p

	local son = Instance.new("Sound")
	son.SoundId = Sons.Atterrissage
	son.Volume = 1.5
	son.RollOffMaxDistance = 200
	son.Parent = p

	local confettis, fanfare
	if estRecord then
		confettis = Instance.new("ParticleEmitter")
		confettis.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		confettis.Enabled = false
		confettis.EmissionDirection = Enum.NormalId.Top
		confettis.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 170, 255)),
		})
		confettis.LightEmission = 0.7
		confettis.Lifetime = NumberRange.new(1.5, 2.5)
		confettis.Speed = NumberRange.new(25, 45)
		confettis.SpreadAngle = Vector2.new(35, 35)
		confettis.Acceleration = Vector3.new(0, -40, 0)
		confettis.Size = NumberSequence.new(1.2)
		confettis.Parent = p
		fanfare = Instance.new("Sound")
		fanfare.SoundId = Sons.Record
		fanfare.Volume = 0.8
		fanfare.RollOffMaxDistance = 200
		fanfare.Parent = p
	end

	p.Parent = workspace
	s:Emit(35)
	son:Play()
	if confettis then
		confettis:Emit(70)
		fanfare:Play()
	end
	Debris:AddItem(p, 6)
end

-- Sauts rares ---------------------------------------------------------
local rare = {} -- [player] = identifiant du saut rare tiré pour le saut en cours
local forces = {} -- [player] = saut rare imposé au prochain passage de planche (tests)
local dernierX = {} -- [player] = position X à l'image précédente
local aleatoire = Random.new()

-- Appel ----------------------------------------------------------------
local appel = {} -- [player] = { id = qualité, temps = os.clock() } du dernier appel jugé

-- Position retenue pour l'appel : celle du joueur si elle est plausible, sinon celle que voit le serveur.
-- Le serveur voit le joueur avec un peu de retard (ping, réplication) : la marge en tient compte.
local function positionAppel(player: Player, hrp: BasePart, xJoueur: unknown): number
	local xServeur = hrp.Position.X
	if type(xJoueur) ~= "number" or xJoueur ~= xJoueur then
		return xServeur
	end
	local vitesse = math.abs(hrp.AssemblyLinearVelocity.X)
	local marge = vitesse * (player:GetNetworkPing() * 2 + SautConfig.APPEL_MARGE_TEMPS) + SautConfig.APPEL_MARGE_STUDS
	return if math.abs(xJoueur - xServeur) <= marge then xJoueur else xServeur
end

-- Le joueur annonce qu'il saute et sa position ; le serveur la vérifie avant de juger l'appel
local function surAppel(player: Player, xJoueur: unknown)
	if not Donnees.estCharge(player) or enAtterrissage[player] then
		return
	end
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local ligne = Map.ligneX(Map.mondeDe(player))
	if not (hrp and ligne) then
		return
	end
	local precedent = appel[player]
	if precedent and os.clock() - precedent.temps < 0.3 then
		return -- un seul appel par saut
	end
	local avant = (ligne - positionAppel(player, hrp, xJoueur)) / SautConfig.STUDS_PAR_METRE
	local q = SautConfig.qualiteAppel(avant, player:GetAttribute("BonusZoneParfait"))
	if q then
		appel[player] = { id = q.id, temps = os.clock() }
		player:SetAttribute("Appel", q.id)
	end
end

-- Réception et série -------------------------------------------------------
local essaiReception = {} -- [player] = os.clock() du premier appui de réception du saut en cours
local serie = {} -- [player] = sauts parfaits consécutifs

-- Premier appui de réception du saut : gardé s'il arrive pendant le vol, au-dessus du sable
local function surReception(player: Player)
	if essaiReception[player] or enAtterrissage[player] or not Donnees.estCharge(player) then
		return
	end
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local ligne = Map.ligneX(Map.mondeDe(player))
	if hrp and ligne and hrp.Position.X > ligne then
		essaiReception[player] = os.clock()
	end
end

-- La réception est réussie si l'appui est arrivé dans la fenêtre avant l'atterrissage
local function receptionReussie(player: Player): boolean
	local t = essaiReception[player]
	if not t then
		return false
	end
	local avance = os.clock() - t
	return avance >= 0 and avance <= SautConfig.RECEPTION_FENETRE + SautConfig.RECEPTION_TOLERANCE
end

-- Nombre de sauts parfaits consécutifs du joueur
function Saut.serieDe(player: Player): number
	return serie[player] or 0
end

-- Qualité de l'appel du saut en cours (nil sans appel)
function Saut.appelDe(player: Player): string?
	local a = appel[player]
	return a and a.id
end

-- Jetpack ----------------------------------------------------------------
-- Le client pilote la poussée ; le serveur compte le temps annoncé et coupe les flammes au-delà du carburant.
local jetpack = {} -- [player] = { utilise = secondes, depuis = os.clock() si la poussée est en cours }

local function surJetpack(player: Player, actif: unknown)
	if type(actif) ~= "boolean" or not player:GetAttribute("Jetpack") then
		return
	end
	local char = player.Character
	if not char then
		return
	end
	local j = jetpack[player] or { utilise = 0 }
	jetpack[player] = j
	if j.depuis then
		j.utilise += os.clock() - j.depuis
		j.depuis = nil
	end
	local reste = Equipement.OBJETS.Jetpack.carburant + SautConfig.JETPACK_TOLERANCE - j.utilise
	if actif and reste > 0 then
		j.depuis = os.clock()
		Personnage.activerJetpack(char, true)
	else
		Personnage.activerJetpack(char, false)
	end
end

-- Coupe les flammes quand le carburant compté par le serveur est épuisé ; recharge au sol
local function surveillerJetpack(player: Player, hum: Humanoid)
	local j = jetpack[player]
	if not j then
		return
	end
	if hum.FloorMaterial ~= Enum.Material.Air and not j.depuis then
		jetpack[player] = nil
	elseif
		j.depuis
		and j.utilise + os.clock() - j.depuis > Equipement.OBJETS.Jetpack.carburant + SautConfig.JETPACK_TOLERANCE
	then
		j.utilise += os.clock() - j.depuis
		j.depuis = nil
		if player.Character then
			Personnage.activerJetpack(player.Character, false)
		end
	end
end

-- Borne de plausibilité --------------------------------------------------
-- Portée maximale du saut en cours, en mètres, d'après ce que le serveur sait du joueur
local function porteeMax(player: Player): number
	return SautConfig.porteeMax({
		vitesse = StatsConfig.vitesseCourse(player:GetAttribute("Vitesse") or 0),
		saut = StatsConfig.puissanceSaut(player:GetAttribute("Puissance") or 0, player:GetAttribute("Chaussures")),
		gravite = workspace.Gravity,
		jetpack = if player:GetAttribute("Jetpack") then Equipement.OBJETS.Jetpack else nil,
		pousseeAnneaux = Anneaux.pousseeDuSaut(player),
	})
end

local function infoRare(id: string)
	for _, r in SautConfig.SAUTS_RARES do
		if r.id == id then
			return r
		end
	end
	return nil
end

-- Impose le saut rare du prochain passage de planche (tests : « un saut doré forcé »)
function Saut.forcerProchain(player: Player, id: string)
	forces[player] = id
end

local function tirerRare(player: Player): string?
	if forces[player] then
		local id = forces[player]
		forces[player] = nil
		return id
	end
	local chance = Compagnons.multiplicateur(player, "PorteBonheur")
	for _, r in SautConfig.SAUTS_RARES do
		if aleatoire:NextNumber() < r.chance * chance then
			return r.id
		end
	end
	return nil
end

-- Tire le saut rare au passage de la planche d'appel ; l'annule si le joueur revient sur la piste
local function surveillerPlanche()
	for _, player in Players:GetPlayers() do
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local ligne = Map.ligneX(Map.mondeDe(player))
		if hrp and ligne and Donnees.estCharge(player) and not enAtterrissage[player] then
			local x = hrp.Position.X
			local avant = dernierX[player]
			if avant and avant < ligne and x >= ligne then
				rare[player] = tirerRare(player)
				player:SetAttribute("SautRare", rare[player] or "")
				-- Un appel trop ancien (sauté trop tôt puis retombé sur la piste) ne compte plus
				local a = appel[player]
				if a and os.clock() - a.temps > SautConfig.APPEL_VALIDITE then
					appel[player] = nil
					player:SetAttribute("Appel", "")
				end
			elseif x < ligne - 2 and rare[player] then
				rare[player] = nil
				player:SetAttribute("SautRare", "")
			end
			dernierX[player] = x
		else
			dernierX[player] = nil
		end
	end
end

-- Atterrissage --------------------------------------------------------------
-- Le joueur a-t-il les pieds sur le sable ? On regarde sous lui (plus fiable que le contact à grande vitesse).
local filtreBac = RaycastParams.new()
filtreBac.FilterType = Enum.RaycastFilterType.Include

local function piedsSurLeSable(hum: Humanoid, hrp: BasePart, monde: number): boolean
	if hrp.AssemblyLinearVelocity.Y > 1 then
		return false -- encore en train de monter
	end
	filtreBac.FilterDescendantsInstances = Map.tous("Bac", monde)
	local longueur = hum.HipHeight + hrp.Size.Y / 2 + SautConfig.ATTERRISSAGE_MARGE
	return workspace:Raycast(hrp.Position, Vector3.new(0, -longueur, 0), filtreBac) ~= nil
end

local function atterrir(player: Player, char: Model, hrp: BasePart, monde: number, ligne: number)
	enAtterrissage[player] = true

	local metres = math.max(0, hrp.Position.X - ligne) / SautConfig.STUDS_PAR_METRE
	metres = math.floor(metres * 10 + 0.5) / 10

	-- Saut impossible pour les stats et l'équipement du joueur : refusé, sans pièces ni record
	local borne = porteeMax(player)
	if metres > borne then
		warn(string.format("[Saut] refusé pour %s : %.1f m pour %.1f m au plus", player.Name, metres, borne))
		rare[player] = nil
		player:SetAttribute("SautRare", "")
		appel[player] = nil
		player:SetAttribute("Appel", "")
		jetpack[player] = nil
		essaiReception[player] = nil
		Anneaux.finDuSaut(player)
		Personnage.activerJetpack(char, false)
		Remotes.Notif:FireClient(player, Textes.SAUT_REFUSE)
		task.delay(SautConfig.DELAI_RETOUR, function()
			local p =
				Map.retourPiste(monde, SautConfig.RETOUR_AVANCE, SautConfig.RETOUR_COTE, SautConfig.RETOUR_HAUTEUR)
			if p and player.Parent and player.Character == char and char.Parent then
				char:PivotTo(CFrame.lookAt(p, p + Vector3.xAxis))
			end
			enAtterrissage[player] = nil
		end)
		return
	end
	-- Maîtrise : réception, saut parfait (appel Parfait + réception), série de sauts parfaits
	local idAppel = Saut.appelDe(player)
	local reception = receptionReussie(player)
	local parfait = reception and idAppel == SautConfig.APPEL_QUALITES[1].id
	if parfait then
		serie[player] = Saut.serieDe(player) + 1
	elseif not reception or idAppel == SautConfig.APPEL_MORDU.id then
		serie[player] = 0 -- appel mordu ou réception ratée : la série s'arrête
	end
	player:SetAttribute("Serie", Saut.serieDe(player))
	local bonus = SautConfig.bonusMaitrise(reception, if parfait then Saut.serieDe(player) else 0)
	local maitrise = { reception = reception, parfait = parfait, serie = Saut.serieDe(player), bonus = bonus }

	-- Les Trésoriers équipés, le saut rare et la maîtrise multiplient les pièces
	local idRare = rare[player]
	local infoR = idRare and infoRare(idRare)
	local gain = math.floor(
		metres
			* SautConfig.PIECES_PAR_METRE
			* Compagnons.multiplicateur(player, "Tresorier")
			* (infoR and infoR.multiplicateur or 1)
			* (1 + bonus)
			* (if parfait then SautConfig.PARFAIT_MULTIPLICATEUR else 1)
	)
	rare[player] = nil
	player:SetAttribute("SautRare", "")
	essaiReception[player] = nil
	appel[player] = nil
	jetpack[player] = nil
	player:SetAttribute("Appel", "")
	Anneaux.finDuSaut(player)
	if infoR and infoR.annonce then
		Remotes.Notif:FireAllClients(string.format(Textes.ANNONCE_LEGENDAIRE, player.DisplayName))
	end
	local ls = player.leaderstats
	ls["Pièces"].Value += gain

	local estRecord = metres > player:GetAttribute("Record")
	if estRecord then
		player:SetAttribute("Record", metres)
		ls["Record (m)"].Value = math.floor(metres)
	end
	Remotes.SautResultat:FireClient(player, metres, gain, estRecord, idRare, idAppel, maitrise)
	effetAtterrissage(hrp.Position, estRecord)
	Personnage.activerJetpack(char, false)
	Compagnons.gagnerExperience(player)

	task.delay(SautConfig.DELAI_RETOUR, function()
		local p = Map.retourPiste(monde, SautConfig.RETOUR_AVANCE, SautConfig.RETOUR_COTE, SautConfig.RETOUR_HAUTEUR)
		if p and player.Parent and player.Character == char and char.Parent then
			char:PivotTo(CFrame.lookAt(p, p + Vector3.xAxis))
		end
		enAtterrissage[player] = nil
	end)
end

-- À chaque image : atterrissage au-delà de la zone où l'on peut mordre, et carburant du jetpack
local function surveillerVol()
	for _, player in Players:GetPlayers() do
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		if hum and hrp and hum.Health > 0 and Donnees.estCharge(player) then
			surveillerJetpack(player, hum)
			local monde = Map.mondeDe(player)
			local ligne = Map.ligneX(monde)
			-- Le premier mètre de sable reste la zone où l'on peut encore mordre : les pas qui y tombent ne comptent pas
			if
				ligne
				and not enAtterrissage[player]
				and hrp.Position.X - ligne >= SautConfig.APPEL_MORDU_MAX * SautConfig.STUDS_PAR_METRE
				and piedsSurLeSable(hum, hrp, monde)
			then
				atterrir(player, char, hrp, monde, ligne)
			end
		end
	end
end

function Saut.demarrer()
	-- Jetpack : le client signale quand il pousse, le serveur montre les flammes à tous dans la limite du carburant
	Remotes.JetpackEtat.OnServerEvent:Connect(surJetpack)

	RunService.Heartbeat:Connect(surveillerPlanche)
	RunService.Heartbeat:Connect(surveillerVol)
	Remotes.Appel.OnServerEvent:Connect(surAppel)
	Remotes.Reception.OnServerEvent:Connect(surReception)

	Players.PlayerRemoving:Connect(function(player)
		enAtterrissage[player] = nil
		appel[player] = nil
		jetpack[player] = nil
		essaiReception[player] = nil
		serie[player] = nil
		rare[player] = nil
		forces[player] = nil
		dernierX[player] = nil
	end)
end

return Saut
