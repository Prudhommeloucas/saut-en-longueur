-- Stats du personnage : vitesses et puissance de saut, entraînement.
local Equipement = require(script.Parent.Equipement)

local Stats = {}

-- Personnage
Stats.VITESSE_BASE = 16 -- au spawn
Stats.SAUT_BASE = 50 -- au spawn
Stats.VITESSE_PISTE_BASE = 26 -- sur la piste, sans entraînement
Stats.SAUT_PISTE_BASE = 62 -- sur la piste, sans entraînement
Stats.VITESSE_MAX = 300
Stats.SAUT_MAX = 600

-- Entraînement : gain toutes les X secondes passées dans une zone
Stats.ENTRAINEMENT_INTERVALLE = 0.5
Stats.ENTRAINEMENT_GAIN = 1

-- Vitesse de course sur la piste selon la stat Vitesse (mollets)
function Stats.vitesseCourse(vitesse: number): number
	return math.min(Stats.VITESSE_PISTE_BASE + 4 * math.sqrt(vitesse), Stats.VITESSE_MAX)
end

-- Puissance de saut sur la piste selon la stat Puissance (squat)
function Stats.puissanceSaut(puissance: number, chaussures: boolean): number
	local p = Stats.SAUT_PISTE_BASE + 5 * math.sqrt(puissance)
	if chaussures then
		p *= Equipement.OBJETS.Chaussures.bonusSaut
	end
	return math.min(p, Stats.SAUT_MAX)
end

return Stats
