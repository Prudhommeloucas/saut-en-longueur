-- Stats du personnage : vitesses et puissance de saut, entraînement.
-- Formules (T-201) : capacité = base + k × stat^EXPOSANT, plafonnée par monde (Config/Mondes).
-- Rendement décroissant sans plafond dur : doubler une stat déjà forte donne au moins 8 % de distance.
-- Coefficients réglés par la simulation (outils/equilibrage, note Économie).
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

-- Entraînement actif (T-202) : un battement par seconde, calé sur l'heure du serveur (secondes entières de
-- workspace:GetServerTimeNow()). Appuyer près du battement multiplie le gain de cette seconde ; ne rien faire
-- laisse le gain passif. Le passe « Entraînement automatique » (attribut PasseEntrainementAuto) joue `auto`.
Stats.RYTHME = {
	periode = 1, -- s entre deux battements
	recordRequis = 5, -- m : le rythme s'ouvre à ce record (note Boucles de gameplay)
	qualites = {
		{ id = "Parfait", ecart = 0.08, multiplicateur = 3 }, -- écart au battement, en secondes
		{ id = "Bon", ecart = 0.2, multiplicateur = 2 },
	},
	auto = "Bon",
	retardMax = 1, -- s : un appui annoncé plus vieux que ça est ignoré
}

-- Qualité d'un appui fait à `ecart` secondes du battement le plus proche (nil : raté)
function Stats.qualiteRythme(ecart: number)
	for _, q in Stats.RYTHME.qualites do
		if math.abs(ecart) <= q.ecart then
			return q
		end
	end
	return nil
end

function Stats.qualiteRythmeParId(id: string)
	for _, q in Stats.RYTHME.qualites do
		if q.id == id then
			return q
		end
	end
	return nil
end

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
-- `appel` : multiplicateur des chaussures portées (Equipement.appelDe), 1 sans chaussures
function Stats.puissanceSaut(puissance: number, appel: number?, monde: number?): number
	local p = (Stats.SAUT_PISTE_BASE + Stats.K_SAUT * math.max(puissance or 0, 0) ^ Stats.EXPOSANT) * (appel or 1)
	return math.min(p, Mondes.get(monde).plafondSaut)
end

return Stats
