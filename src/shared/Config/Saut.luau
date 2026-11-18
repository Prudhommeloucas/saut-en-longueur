-- Saut : mesure de la distance, retour sur la piste, récompense.
local Saut = {}

Saut.STUDS_PAR_METRE = 4 -- 1 mètre affiché = 4 studs
-- La planche (tag PlancheAppel) et la piste (tag Piste) sont lues dans la map par Util/Map.
Saut.RETOUR_AVANCE = 8 -- après un saut, renvoyé à 8 studs du début de la piste…
Saut.RETOUR_HAUTEUR = 4 -- … et 4 studs au-dessus de son sol
Saut.DELAI_RETOUR = 2 -- secondes entre l'atterrissage et le retour

-- Récompense : pièces gagnées par mètre sauté
Saut.PIECES_PAR_METRE = 1
Saut.PIECES_MIN = 1 -- prévu : minimum si on atteint le sable (pas encore utilisé)

-- Appel : qualité selon la position (centre du personnage) au moment de l'appui, en mètres avant le bord de la planche.
-- La planche du monde 1 fait 0,5 m : la zone Parfait est la planche elle-même.
Saut.APPEL_QUALITES = {
	{ id = "Parfait", avantMax = 0.5, multiplicateur = 1.25 },
	{ id = "Bon", avantMax = 1.5, multiplicateur = 1.10 },
	{ id = "Correct", avantMax = 6, multiplicateur = 1.00 }, -- plus tôt que 6 m : simple saut, pas un appel
}
Saut.APPEL_MORDU = { id = "Mordu", multiplicateur = 0.80 }
Saut.APPEL_MORDU_MAX = 1 -- m après le bord où un appel compte encore (Mordu) ; le sable ne compte qu'au-delà
-- Le serveur accepte la position annoncée par le joueur si elle est à moins de
-- vitesse × (2 × ping + APPEL_MARGE_TEMPS) + APPEL_MARGE_STUDS de celle qu'il voit (T-102 bornera le reste)
Saut.APPEL_MARGE_TEMPS = 0.15
Saut.APPEL_MARGE_STUDS = 2
Saut.APPEL_VALIDITE = 2 -- s : un appel plus ancien au passage de la planche ne compte plus (appel trop tôt, retombé sur la piste)
-- Les talents élargiront la zone Parfait par l'attribut « BonusZoneParfait » du joueur (mètres en plus).

-- Qualité d'un appel fait à « avant » mètres du bord (négatif : après le bord) ; nil si ce n'est pas un appel
function Saut.qualiteAppel(avant: number, bonusParfait: number?)
	if avant < 0 then
		return if -avant <= Saut.APPEL_MORDU_MAX then Saut.APPEL_MORDU else nil
	end
	for i, q in Saut.APPEL_QUALITES do
		local borne = if i == 1 then q.avantMax + (bonusParfait or 0) else q.avantMax
		if avant <= borne then
			return q
		end
	end
	return nil
end

-- Qualité d'appel d'après son identifiant (« Parfait »…), nil si inconnu
function Saut.qualiteAppelParId(id: string)
	if id == Saut.APPEL_MORDU.id then
		return Saut.APPEL_MORDU
	end
	for _, q in Saut.APPEL_QUALITES do
		if q.id == id then
			return q
		end
	end
	return nil
end

-- Sauts rares : tirés quand le joueur passe la planche d'appel, du plus rare au plus courant.
-- La chance est multipliée par (1 + bonus des Porte-bonheur équipés).
Saut.SAUTS_RARES = {
	{ id = "Legendaire", chance = 1 / 1000, multiplicateur = 100, annonce = true },
	{ id = "Dore", chance = 1 / 100, multiplicateur = 10, annonce = false },
}

-- Anneaux (tag « Anneau ») : valeurs par défaut si l'anneau n'a pas d'attribut Pieces ou Poussee
Saut.ANNEAU_PIECES = 5
Saut.ANNEAU_POUSSEE = 30 -- vitesse ajoutée : vers le haut, et la moitié vers l'avant
Saut.ANNEAUX_SERIE = 3 -- anneaux traversés dans un même saut pour le bonus
Saut.ANNEAUX_BONUS_SERIE = 25 -- pièces en plus à la série

-- Vol (T-102) -------------------------------------------------------------
-- Atterrissage : le serveur regarde sous les pieds du joueur ; le sable touché à moins de cette marge compte
Saut.ATTERRISSAGE_MARGE = 1 -- studs
-- Jetpack : le serveur compte le temps de poussée annoncé ; au-delà du carburant + tolérance, plus de flammes
Saut.JETPACK_TOLERANCE = 0.3 -- s
-- Borne de plausibilité : un saut plus long que la portée maximale (× marge + plus) est refusé
Saut.BORNE_MARGE = 1.2
Saut.BORNE_PLUS = 3 -- m

-- Portée maximale d'un saut, en mètres, pour les stats et l'équipement donnés : le meilleur appel,
-- toute la poussée des anneaux traversés, et le jetpack poussé du début à la fin (même règle que le contrôleur Saut).
-- p = { vitesse, saut, gravite, jetpack = { carburant, poussee, vitesseMontee }?, pousseeAnneaux }
function Saut.porteeMax(p): number
	local dt = 1 / 120
	local vy = p.saut * Saut.APPEL_QUALITES[1].multiplicateur + p.pousseeAnneaux
	local y, t = 0, 0
	local carburant = p.jetpack and p.jetpack.carburant or 0
	repeat
		if carburant > 0 then
			vy = math.min(vy + p.jetpack.poussee * dt, math.max(vy, p.jetpack.vitesseMontee))
			carburant -= dt
		end
		vy -= p.gravite * dt
		y += vy * dt
		t += dt
	until y < 0 or t > 60
	local vx = p.vitesse + p.pousseeAnneaux / 2
	return vx * t / Saut.STUDS_PAR_METRE * Saut.BORNE_MARGE + Saut.BORNE_PLUS
end

return Saut
