-- Stats du personnage : vitesses et puissance de saut, entraînement.
-- Formules (T-201) : capacité = base + k × stat^EXPOSANT, plafonnée par monde (Config/Mondes).
-- Rendement décroissant sans plafond dur : doubler une stat déjà forte donne au moins 8 % de distance.
-- Coefficients réglés par la simulation (outils/equilibrage, note Économie).
local Equipement = require(script.Parent.Equipement)
local Mondes = require(script.Parent.Mondes)

local Stats = {}

-- Personnage
Stats.VITESSE_BASE = 16 -- au spawn
Stats.SAUT_BASE = 50 -- au spawn
Stats.VITESSE_PISTE_BASE = 26 -- sur la piste, sans entraînement
Stats.SAUT_PISTE_BASE = 62 -- sur la piste, sans entraînement

Stats.EXPOSANT = 0.25
Stats.K_VITESSE = 4.4
Stats.K_SAUT = 6.6

-- Entraînement : gain toutes les X secondes passées dans une zone
Stats.ENTRAINEMENT_INTERVALLE = 0.5
Stats.ENTRAINEMENT_GAIN = 1

-- Bonus de débutant : les premières minutes avancent vite. Le gain d'entraînement est multiplié par
-- `multiplicateur` avec un record nul, puis le bonus baisse en ligne droite jusqu'à × 1 au record `recordFin` (m).
Stats.BONUS_DEBUTANT = { multiplicateur = 10, recordFin = 60 }

function Stats.bonusDebutant(record: number?): number
	local b = Stats.BONUS_DEBUTANT
	local part = math.clamp((record or 0) / b.recordFin, 0, 1)
	return b.multiplicateur + (1 - b.multiplicateur) * part
end

-- Vitesse de course sur la piste selon la stat Vitesse (mollets)
function Stats.vitesseCourse(vitesse: number, monde: number?): number
	local v = Stats.VITESSE_PISTE_BASE + Stats.K_VITESSE * math.max(vitesse or 0, 0) ^ Stats.EXPOSANT
	return math.min(v, Mondes.get(monde).plafondVitesse)
end

-- Puissance de saut sur la piste selon la stat Puissance (squat) et les chaussures
function Stats.puissanceSaut(puissance: number, chaussures: boolean?, monde: number?): number
	local p = Stats.SAUT_PISTE_BASE + Stats.K_SAUT * math.max(puissance or 0, 0) ^ Stats.EXPOSANT
	if chaussures then
		p *= Equipement.OBJETS.Chaussures.bonusSaut
	end
	return math.min(p, Mondes.get(monde).plafondSaut)
end

return Stats
