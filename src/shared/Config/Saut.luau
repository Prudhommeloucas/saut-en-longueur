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

return Saut
