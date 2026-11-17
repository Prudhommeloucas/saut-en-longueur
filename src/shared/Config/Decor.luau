-- Décor animé (tag « DecorAnime ») : distance d'animation et valeurs par défaut de chaque type.
-- Les attributs posés sur l'objet dans Studio remplacent ces valeurs (voir la note Contrats).
local Decor = {}

-- Au-delà de cette distance de la caméra (studs), l'objet reste immobile
Decor.DISTANCE = 300

-- Vitesse : degrés par seconde pour Rotation, allers-retours par seconde pour les autres types.
-- Amplitude : studs pour Flottement, degrés pour Balancement, part de la taille pour Pulsation (0,05 = ±5 %).
-- AxeRotation : axe dans le repère du pivot de l'objet.
Decor.TYPES = {
	Rotation = { Vitesse = 30, AxeRotation = Vector3.new(0, 1, 0) },
	Flottement = { Vitesse = 0.4, Amplitude = 1 },
	Balancement = { Vitesse = 0.5, Amplitude = 8, AxeRotation = Vector3.new(0, 0, 1) },
	Pulsation = { Vitesse = 1, Amplitude = 0.05 },
}

return Decor
