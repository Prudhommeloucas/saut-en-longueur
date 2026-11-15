-- Logique serveur : données des joueurs, entraînement, mesure des sauts, boutique.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Config = require(RS:WaitForChild("Config"))
local remotes = RS:WaitForChild("Remotes")
local evResultat = remotes:WaitForChild("SautResultat")
local evNotif = remotes:WaitForChild("Notif")
local evJetpack = remotes:WaitForChild("JetpackEtat")
local Debris = game:GetService("Debris")

local map = workspace:WaitForChild("Map")
local sable = map:WaitForChild("Sable")
local zoneSquat = map:WaitForChild("Entrainement"):WaitForChild("ZoneSquat")
local zoneMollets = map.Entrainement:WaitForChild("ZoneMollets")
local boutique = map:WaitForChild("Boutique")

-- Sauvegarde (ne fonctionne que dans une place publiée avec l'accès API activé)
local store
pcall(function()
	store = DataStoreService:GetDataStore("SautEnLongueur_v1")
end)

local charge = {} -- [player] = true quand ses données sont prêtes
local peutSauvegarder = {} -- [player] = true si le chargement a réussi
local enAtterrissage = {} -- [player] = true entre l'atterrissage et le retour piste
local surPiste = {} -- [player] = dernier état connu, pour n'activer la traînée qu'au changement

---------------------------------------------------------------------
-- Données
---------------------------------------------------------------------
local function chargerDonnees(player: Player)
	local data = {}
	if store then
		local ok, res = pcall(function()
			return store:GetAsync("joueur_" .. player.UserId)
		end)
		if ok then
			peutSauvegarder[player] = true
			if type(res) == "table" then
				data = res
			end
		end
	end
	if not player.Parent then
		return
	end

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local pieces = Instance.new("IntValue")
	pieces.Name = "Pièces"
	pieces.Value = data.Pieces or 0
	pieces.Parent = ls
	local record = Instance.new("IntValue")
	record.Name = "Record (m)"
	record.Value = math.floor(data.Record or 0)
	record.Parent = ls
	ls.Parent = player

	player:SetAttribute("Record", data.Record or 0)
	player:SetAttribute("Puissance", data.Puissance or 0)
	player:SetAttribute("Vitesse", data.Vitesse or 0)
	player:SetAttribute("Chaussures", data.Chaussures == true)
	player:SetAttribute("Jetpack", data.Jetpack == true)
	charge[player] = true
end

local function sauvegarder(player: Player)
	if not (store and charge[player] and peutSauvegarder[player]) then
		return
	end
	local data = {
		Pieces = player.leaderstats["Pièces"].Value,
		Record = player:GetAttribute("Record"),
		Puissance = player:GetAttribute("Puissance"),
		Vitesse = player:GetAttribute("Vitesse"),
		Chaussures = player:GetAttribute("Chaussures"),
		Jetpack = player:GetAttribute("Jetpack"),
	}
	pcall(function()
		store:SetAsync("joueur_" .. player.UserId, data)
	end)
end

---------------------------------------------------------------------
-- Apparence des objets sur le personnage
---------------------------------------------------------------------
local function decor(nom: string, taille: Vector3, couleur: Color3, materiau: Enum.Material): Part
	local p = Instance.new("Part")
	p.Name = nom
	p.Size = taille
	-- Style blocs à studs : plastique classique, studs dessus, couleur BrickColor la plus proche.
	-- Le néon reste pour ce qui doit briller (tuyères, semelles).
	p.BrickColor = BrickColor.new(couleur)
	p.Material = if materiau == Enum.Material.Neon then Enum.Material.Neon else Enum.Material.Plastic
	p.TopSurface = Enum.SurfaceType.Studs
	p.BottomSurface = Enum.SurfaceType.Inlet
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	return p
end

local function souder(p: Part, cible: BasePart, decalage: CFrame, parent: Instance)
	p.CFrame = cible.CFrame * decalage
	local w = Instance.new("WeldConstraint")
	w.Part0 = cible
	w.Part1 = p
	w.Parent = p
	p.Parent = parent
end

-- Flamme, lueur et son dans une tuyère de jetpack (éteints par défaut)
local function ajouterFlamme(tuyere: Part, avecSon: boolean)
	local f = Instance.new("ParticleEmitter")
	f.Name = "Flamme"
	f.Enabled = false
	f.Texture = "rbxasset://textures/particles/fire_main.dds"
	f.EmissionDirection = Enum.NormalId.Bottom
	f.Color = ColorSequence.new(Color3.fromRGB(255, 230, 120), Color3.fromRGB(255, 90, 20))
	f.LightEmission = 1
	f.Rate = 90
	f.Lifetime = NumberRange.new(0.25, 0.45)
	f.Speed = NumberRange.new(10, 16)
	f.SpreadAngle = Vector2.new(8, 8)
	f.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.1), NumberSequenceKeypoint.new(1, 0) })
	f.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
	f.Parent = tuyere
	local l = Instance.new("PointLight")
	l.Name = "Lueur"
	l.Enabled = false
	l.Color = Color3.fromRGB(255, 150, 50)
	l.Range = 14
	l.Brightness = 2
	l.Parent = tuyere
	if avecSon then
		local s = Instance.new("Sound")
		s.Name = "SonJetpack"
		s.SoundId = Config.SONS.Jetpack
		s.Looped = true
		s.Volume = 1.2
		s.PlaybackSpeed = 1.6
		s.RollOffMaxDistance = 150
		s.Parent = tuyere
	end
end

-- Traînée lumineuse derrière une semelle (éteinte par défaut)
local function ajouterTrainee(semelle: Part)
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(-semelle.Size.X / 2, 0, 0)
	a0.Parent = semelle
	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(semelle.Size.X / 2, 0, 0)
	a1.Parent = semelle
	local t = Instance.new("Trail")
	t.Name = "Trainee"
	t.Enabled = false
	t.Attachment0 = a0
	t.Attachment1 = a1
	t.Lifetime = 0.5
	t.LightEmission = 1
	t.Color = ColorSequence.new(Color3.fromRGB(255, 190, 60), Color3.fromRGB(255, 90, 20))
	t.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	t.Parent = semelle
end

local function activerJetpack(char: Model, actif: boolean)
	local obj = char:FindFirstChild("ObjetsSaut")
	if not obj then
		return
	end
	for _, d in obj:GetDescendants() do
		if d.Name == "Flamme" or d.Name == "Lueur" then
			d.Enabled = actif
		elseif d.Name == "SonJetpack" then
			if actif then
				d:Play()
			else
				d:Stop()
			end
		end
	end
end

local function activerTrainees(char: Model, actif: boolean)
	local obj = char:FindFirstChild("ObjetsSaut")
	if not obj then
		return
	end
	for _, d in obj:GetDescendants() do
		if d:IsA("Trail") then
			d.Enabled = actif
		end
	end
end

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
	son.SoundId = Config.SONS.Atterrissage
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
		fanfare.SoundId = Config.SONS.Record
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

local function equiperVisuels(player: Player)
	local char = player.Character
	if not char then
		return
	end
	local ancien = char:FindFirstChild("ObjetsSaut")
	if ancien then
		ancien:Destroy()
	end
	local dossier = Instance.new("Model")
	dossier.Name = "ObjetsSaut"
	dossier.Parent = char

	if player:GetAttribute("Jetpack") then
		local torse = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		if torse then
			local gris = Color3.fromRGB(90, 90, 100)
			souder(
				decor("JetpackG", Vector3.new(0.7, 1.6, 0.7), gris, Enum.Material.Metal),
				torse,
				CFrame.new(-0.45, 0, 0.85),
				dossier
			)
			souder(
				decor("JetpackD", Vector3.new(0.7, 1.6, 0.7), gris, Enum.Material.Metal),
				torse,
				CFrame.new(0.45, 0, 0.85),
				dossier
			)
			local feu = Color3.fromRGB(255, 140, 30)
			local tuyereG = decor("TuyereG", Vector3.new(0.5, 0.3, 0.5), feu, Enum.Material.Neon)
			souder(tuyereG, torse, CFrame.new(-0.45, -0.95, 0.85), dossier)
			ajouterFlamme(tuyereG, true)
			local tuyereD = decor("TuyereD", Vector3.new(0.5, 0.3, 0.5), feu, Enum.Material.Neon)
			souder(tuyereD, torse, CFrame.new(0.45, -0.95, 0.85), dossier)
			ajouterFlamme(tuyereD, false)
		end
	end

	if player:GetAttribute("Chaussures") then
		local orange = Color3.fromRGB(255, 150, 40)
		for _, nom in { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" } do
			local pied = char:FindFirstChild(nom)
			if pied and pied:IsA("BasePart") then
				local bas = -pied.Size.Y / 2
				local semelle =
					decor("Semelle", Vector3.new(pied.Size.X + 0.2, 0.3, pied.Size.Z + 0.3), orange, Enum.Material.Neon)
				souder(semelle, pied, CFrame.new(0, bas, 0), dossier)
				ajouterTrainee(semelle)
			end
		end
	end
	surPiste[player] = nil -- force la boucle à réappliquer l'état des traînées
end

---------------------------------------------------------------------
-- Joueurs
---------------------------------------------------------------------
local function surPersonnage(player: Player, char: Model)
	local hum = char:WaitForChild("Humanoid", 10)
	if not hum then
		return
	end
	hum.UseJumpPower = true
	char:WaitForChild("HumanoidRootPart", 10)
	task.wait(0.5) -- laisse le temps aux membres d'arriver
	while not charge[player] and player.Parent do
		task.wait(0.1)
	end
	if player.Character == char then
		equiperVisuels(player)
	end
end

local function surJoueur(player: Player)
	player.CharacterAdded:Connect(function(char)
		surPersonnage(player, char)
	end)
	if player.Character then
		task.spawn(surPersonnage, player, player.Character)
	end
	chargerDonnees(player)
end

Players.PlayerAdded:Connect(surJoueur)
for _, p in Players:GetPlayers() do
	task.spawn(surJoueur, p)
end

Players.PlayerRemoving:Connect(function(player)
	sauvegarder(player)
	charge[player] = nil
	peutSauvegarder[player] = nil
	enAtterrissage[player] = nil
	surPiste[player] = nil
end)

game:BindToClose(function()
	for _, p in Players:GetPlayers() do
		sauvegarder(p)
	end
end)

---------------------------------------------------------------------
-- Boucle : bonus sur la piste et entraînement au spawn
---------------------------------------------------------------------
local function dansZone(zone: BasePart, pos: Vector3): boolean
	local l = zone.CFrame:PointToObjectSpace(pos)
	return math.abs(l.X) <= zone.Size.X / 2 and math.abs(l.Z) <= zone.Size.Z / 2 and l.Y > -1 and l.Y < 12
end

task.spawn(function()
	local accum = 0
	while true do
		accum += task.wait(0.2)
		local tic = false
		if accum >= Config.ENTRAINEMENT_INTERVALLE then
			accum -= Config.ENTRAINEMENT_INTERVALLE
			tic = true
		end
		for _, player in Players:GetPlayers() do
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if charge[player] and hum and hrp and hum.Health > 0 then
				local pos = hrp.Position
				if pos.X > Config.DEBUT_PISTE_X then
					hum.WalkSpeed = Config.vitesseCourse(player:GetAttribute("Vitesse"))
					hum.JumpPower =
						Config.puissanceSaut(player:GetAttribute("Puissance"), player:GetAttribute("Chaussures"))
				else
					hum.WalkSpeed = Config.VITESSE_BASE
					hum.JumpPower = Config.SAUT_BASE
				end
				local sp = pos.X > Config.DEBUT_PISTE_X
				if surPiste[player] ~= sp then
					surPiste[player] = sp
					activerTrainees(char, sp)
				end
				if tic then
					if dansZone(zoneSquat, pos) then
						player:SetAttribute("Puissance", player:GetAttribute("Puissance") + Config.ENTRAINEMENT_GAIN)
					elseif dansZone(zoneMollets, pos) then
						player:SetAttribute("Vitesse", player:GetAttribute("Vitesse") + Config.ENTRAINEMENT_GAIN)
					end
				end
			end
		end
	end
end)

---------------------------------------------------------------------
-- Mesure du saut : le premier contact avec le sable donne la distance
---------------------------------------------------------------------
sable.Touched:Connect(function(hit)
	local char = hit:FindFirstAncestorOfClass("Model")
	local player = char and Players:GetPlayerFromCharacter(char)
	if not player or not charge[player] or enAtterrissage[player] then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health <= 0 then
		return
	end
	enAtterrissage[player] = true

	local metres = math.max(0, hrp.Position.X - Config.LIGNE_X) / Config.STUDS_PAR_METRE
	metres = math.floor(metres * 10 + 0.5) / 10
	local gain = math.floor(metres * Config.PIECES_PAR_METRE)
	local ls = player.leaderstats
	ls["Pièces"].Value += gain

	local estRecord = metres > player:GetAttribute("Record")
	if estRecord then
		player:SetAttribute("Record", metres)
		ls["Record (m)"].Value = math.floor(metres)
	end
	evResultat:FireClient(player, metres, gain, estRecord)
	effetAtterrissage(hrp.Position, estRecord)
	activerJetpack(char, false)

	task.delay(Config.DELAI_RETOUR, function()
		if player.Parent and player.Character == char and char.Parent then
			local p = Config.RETOUR_PISTE
			char:PivotTo(CFrame.lookAt(p, p + Vector3.xAxis))
		end
		enAtterrissage[player] = nil
	end)
end)

---------------------------------------------------------------------
-- Jetpack : le client signale quand il pousse, le serveur montre les flammes à tous
---------------------------------------------------------------------
evJetpack.OnServerEvent:Connect(function(player, actif)
	if type(actif) ~= "boolean" or not player:GetAttribute("Jetpack") then
		return
	end
	local char = player.Character
	if char then
		activerJetpack(char, actif)
	end
end)

---------------------------------------------------------------------
-- Boutique
---------------------------------------------------------------------
for cle, info in Config.OBJETS do
	local stand = boutique:WaitForChild("Stand" .. cle)
	local prompt = stand:WaitForChild("Prompt")
	prompt.ObjectText = info.nom .. " : " .. info.prix .. " pièces"
	prompt.Triggered:Connect(function(player)
		if not charge[player] then
			return
		end
		if player:GetAttribute(cle) then
			evNotif:FireClient(player, "Tu as déjà : " .. info.nom)
			return
		end
		local pieces = player.leaderstats["Pièces"]
		if pieces.Value < info.prix then
			evNotif:FireClient(player, "Il te manque " .. (info.prix - pieces.Value) .. " pièces")
			return
		end
		pieces.Value -= info.prix
		player:SetAttribute(cle, true)
		equiperVisuels(player)
		evNotif:FireClient(player, "Acheté : " .. info.nom .. " !")
	end)
end
