-- Entraînement : chaque Part taguée « ZoneEntrainement » fait gagner sa stat (attribut Stat) à intervalle régulier.
-- Attributs lus sur la zone : Stat (Puissance, Vitesse…) et Palier (1, 2, 3… : le palier de Config/Mondes, qui donne
-- multiplicateur, record requis et passe). Sans Palier, on lit les anciens attributs Multiplicateur, RecordRequis et
-- PasseRequis. Le joueur qui s'entraîne porte l'attribut « Entraine » (nom de la stat), lu par le contrôleur Rythme.
-- Entraînement actif (T-202) : un battement par seconde ; un appui près du battement (remote Rythme) multiplie le
-- gain de cette seconde par 2 (Bon) ou 3 (Parfait). Ne rien faire laisse le gain passif.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local StatsConfig = require(Config:WaitForChild("Stats"))
local Mondes = require(Config:WaitForChild("Mondes"))
local Equipement = require(Config:WaitForChild("Equipement"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Donnees = require(script.Parent.Donnees)
local Compagnons = require(script.Parent.Compagnons)
local Recompenses = require(script.Parent.Recompenses)
local RecompensesConfig = require(Config:WaitForChild("Recompenses"))

local Entrainement = {}

local RYTHME = StatsConfig.RYTHME
local dernierBattement = {} -- [player] = numéro du dernier battement joué (un appui par battement)

-- Règles d'une zone : son palier dans Config/Mondes, sinon ses propres attributs
local function regles(zone: BasePart, monde: number): (number, number, string?)
	local palier = zone:GetAttribute("Palier")
	local z = palier and Mondes.get(monde).zones[palier]
	if z then
		return z.multiplicateur, z.recordRequis or 0, z.passe
	end
	local passe = zone:GetAttribute("PasseRequis")
	return zone:GetAttribute("Multiplicateur") or 1,
		zone:GetAttribute("RecordRequis") or 0,
		if passe and passe ~= "" then "Passe" .. passe else nil
end

local function dansZone(zone: BasePart, pos: Vector3): boolean
	local l = zone.CFrame:PointToObjectSpace(pos)
	return math.abs(l.X) <= zone.Size.X / 2 and math.abs(l.Z) <= zone.Size.Z / 2 and l.Y > -1 and l.Y < 12
end

-- Zone où se trouve le joueur, si elle lui est ouverte (record suffisant, passe possédé : attribut à vrai),
-- et son multiplicateur
local function zoneDe(player: Player, pos: Vector3): (BasePart?, number)
	local monde = Map.mondeDe(player)
	for _, zone in Map.tous("ZoneEntrainement", monde) do
		if zone:IsA("BasePart") and dansZone(zone, pos) then
			local mult, requis, passe = regles(zone, monde)
			if
				(player:GetAttribute("Record") or 0) >= requis and (passe == nil or player:GetAttribute(passe) == true)
			then
				return zone, mult
			end
		end
	end
	return nil, 1
end

-- Gain d'un battement passif (toutes les ENTRAINEMENT_INTERVALLE secondes) dans cette zone
local function gainPassif(player: Player, multiplicateurZone: number): number
	return StatsConfig.ENTRAINEMENT_GAIN
		* multiplicateurZone
		* Equipement.multiplicateurMateriel(player:GetAttribute("Materiel"))
		* Compagnons.multiplicateur(player, "Coach")
		* StatsConfig.bonusDebutant(player:GetAttribute("Record"))
		* RecompensesConfig.boost(player, "Entrainement")
end

-- Zone et stat où le joueur s'entraîne en ce moment (nil s'il ne s'entraîne pas)
local function etatEntrainement(player: Player): (string?, number)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not (Donnees.estCharge(player) and hum and hrp and hum.Health > 0) then
		return nil, 1
	end
	local zone, mult = zoneDe(player, hrp.Position)
	local stat = zone and zone:GetAttribute("Stat")
	if not stat or type(player:GetAttribute(stat)) ~= "number" then
		return nil, 1 -- pas de zone, ou stat que le joueur n'a pas encore (Aero)
	end
	return stat, mult
end

local function entrainer(player: Player)
	local stat, mult = etatEntrainement(player)
	if player:GetAttribute("Entraine") ~= stat then
		player:SetAttribute("Entraine", stat)
	end
	if stat then
		local gain = gainPassif(player, mult)
		player:SetAttribute(stat, player:GetAttribute(stat) + gain)
		Recompenses.compter(player, "Stats", gain)
	end
end

-- Bonus d'une seconde jouée avec la qualité q : le gain passif de la seconde × (multiplicateur - 1)
local function jouer(player: Player, q, battement: number): number
	local stat, mult = etatEntrainement(player)
	if not stat or (player:GetAttribute("Record") or 0) < RYTHME.recordRequis then
		return 0
	end
	dernierBattement[player] = battement
	local parSeconde = gainPassif(player, mult) * RYTHME.periode / StatsConfig.ENTRAINEMENT_INTERVALLE
	local bonus = parSeconde * (q.multiplicateur - 1)
	player:SetAttribute(stat, player:GetAttribute(stat) + bonus)
	Recompenses.compter(player, "Stats", bonus)
	return bonus
end

-- Appui du joueur : `temps` est l'heure du serveur (GetServerTimeNow) vue par le joueur au moment de l'appui.
-- Le serveur l'accepte si elle n'est ni dans le futur ni trop vieille, puis juge l'écart au battement le plus proche.
local function surAppui(player: Player, temps: unknown)
	if type(temps) ~= "number" or temps ~= temps then
		return
	end
	local maintenant = workspace:GetServerTimeNow()
	if temps > maintenant + 0.05 or maintenant - temps > RYTHME.retardMax then
		return
	end
	local battement = math.floor(temps / RYTHME.periode + 0.5)
	if dernierBattement[player] == battement then
		return -- un seul appui par battement
	end
	local q = StatsConfig.qualiteRythme(temps - battement * RYTHME.periode)
	if not q then
		dernierBattement[player] = battement -- raté : le battement est perdu
		Remotes.RythmeResultat:FireClient(player, nil, 0)
		return
	end
	local bonus = jouer(player, q, battement)
	Remotes.RythmeResultat:FireClient(player, q.id, bonus)
end

-- Passe « Entraînement automatique » : chaque battement non joué est joué avec la qualité RYTHME.auto
local function battementAuto()
	local q = StatsConfig.qualiteRythmeParId(RYTHME.auto)
	local battement = math.floor(workspace:GetServerTimeNow() / RYTHME.periode + 0.5) - 1
	for _, player in Players:GetPlayers() do
		if player:GetAttribute("PasseEntrainementAuto") == true and dernierBattement[player] ~= battement then
			jouer(player, q, battement)
		end
	end
end

function Entrainement.demarrer()
	Remotes.Rythme.OnServerEvent:Connect(surAppui)
	Players.PlayerRemoving:Connect(function(player)
		dernierBattement[player] = nil
	end)
	task.spawn(function()
		local accum, accumAuto = 0, 0
		while true do
			local dt = task.wait(0.2)
			accum += dt
			accumAuto += dt
			if accum >= StatsConfig.ENTRAINEMENT_INTERVALLE then
				accum -= StatsConfig.ENTRAINEMENT_INTERVALLE
				for _, player in Players:GetPlayers() do
					entrainer(player)
				end
			end
			if accumAuto >= RYTHME.periode then
				accumAuto -= RYTHME.periode
				battementAuto()
			end
		end
	end)
end

return Entrainement
