-- Saut : mesure de la distance, retour sur la piste, récompense.
local Saut = {}

Saut.STUDS_PAR_METRE = 4 -- 1 mètre affiché = 4 studs
Saut.LIGNE_X = 120 -- position X de la planche d'appel (début du sable)
Saut.DEBUT_PISTE_X = 0 -- au-delà de ce X, les bonus de vitesse et de saut s'appliquent
Saut.RETOUR_PISTE = Vector3.new(8, 4, 0) -- où le joueur est renvoyé après un saut
Saut.DELAI_RETOUR = 2 -- secondes entre l'atterrissage et le retour

-- Récompense : pièces gagnées par mètre sauté
Saut.PIECES_PAR_METRE = 1
Saut.PIECES_MIN = 1 -- prévu : minimum si on atteint le sable (pas encore utilisé)

return Saut
