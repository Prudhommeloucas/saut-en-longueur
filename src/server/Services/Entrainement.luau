-- Entraînement : chaque Part taguée « ZoneEntrainement » fait gagner sa stat (attribut Stat) à intervalle régulier.
-- Attributs lus sur la zone : Stat (Puissance, Vitesse…), Multiplicateur (1 par défaut), RecordRequis (m, 0 par défaut).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local StatsConfig = require(Shared:WaitForChild("Config"):WaitForChild("Stats"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Donnees = require(script.Parent.Donnees)
local Compagnons = require(script.Parent.Compagnons)

local Entrainement = {}

local function dansZone(zone: BasePart, pos: Vector3): boolean
	local l = zone.CFrame:PointToObjectSpace(pos)
	return math.abs(l.X) <= zone.Size.X / 2 and math.abs(l.Z) <= zone.Size.Z / 2 and l.Y > -1 and l.Y < 12
end

-- La zone est-elle ouverte à ce joueur ? Record suffisant et, si la zone demande un passe (PasseRequis = "VIP"),
-- attribut « Passe<nom> » à vrai sur le joueur (posé par le futur service des passes ; fermée sans lui).
local function ouverte(player: Player, zone: BasePart): boolean
	local requis = zone:GetAttribute("RecordRequis") or 0
	if (player:GetAttribute("Record") or 0) < requis then
		return false
	end
	local passe = zone:GetAttribute("PasseRequis")
	return passe == nil or passe == "" or player:GetAttribute("Passe" .. passe) == true
end

-- Zone où se trouve le joueur, si elle lui est ouverte
local function zoneDe(player: Player, pos: Vector3): BasePart?
	for _, zone in Map.tous("ZoneEntrainement", Map.mondeDe(player)) do
		if zone:IsA("BasePart") and dansZone(zone, pos) and ouverte(player, zone) then
			return zone
		end
	end
	return nil
end

local function entrainer(player: Player)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (Donnees.estCharge(player) and hum and hrp and hum.Health > 0) then
		return
	end
	local zone = zoneDe(player, hrp.Position)
	local stat = zone and zone:GetAttribute("Stat")
	local actuelle = stat and player:GetAttribute(stat)
	if type(actuelle) ~= "number" then
		return -- pas de zone, ou stat que le joueur n'a pas encore (Aero)
	end
	-- Le multiplicateur de la zone, les Coachs équipés et le bonus de débutant multiplient le gain
	local gain = StatsConfig.ENTRAINEMENT_GAIN
		* (zone:GetAttribute("Multiplicateur") or 1)
		* Compagnons.multiplicateur(player, "Coach")
		* StatsConfig.bonusDebutant(player:GetAttribute("Record"))
	player:SetAttribute(stat, actuelle + gain)
end

function Entrainement.demarrer()
	task.spawn(function()
		local accum = 0
		while true do
			accum += task.wait(0.2)
			if accum >= StatsConfig.ENTRAINEMENT_INTERVALLE then
				accum -= StatsConfig.ENTRAINEMENT_INTERVALLE
				for _, player in Players:GetPlayers() do
					entrainer(player)
				end
			end
		end
	end)
end

return Entrainement
