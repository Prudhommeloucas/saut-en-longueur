-- Effets visuels du saut (T-111). Les effets eux-mêmes (particules, traînée) sont construits dans Studio
-- et rangés dans ReplicatedStorage.Assets.Effets ; ici, seulement les réglages lus par le code.
local Effets = {}

-- Secondes avant de retirer un effet ponctuel (le temps que ses particules retombent)
Effets.DUREE = 6

-- La gerbe de sable grossit avec la vitesse à l'atterrissage : échelle = vitesse / VITESSE_REF, bornée
Effets.SABLE_VITESSE_REF = 60 -- studs/s pour une gerbe d'échelle 1
Effets.SABLE_ECHELLE_MIN = 0.6
Effets.SABLE_ECHELLE_MAX = 2.5

-- Hauteur des pieds sous le centre du personnage (HumanoidRootPart)
Effets.PIEDS = 2.8

-- Éclat d'appel : échelle selon la qualité (nil : pas d'éclat)
Effets.APPEL = { Parfait = 1, Bon = 0.4 }

-- Traînée du corps, de la tête aux hanches : écart entre ses deux attaches (studs)
Effets.TRAINEE_HAUTEUR = 2.2

-- Couleurs de la traînée du corps : normale, puis pendant un saut rare
Effets.TRAINEE_NORMALE = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 160, 60))
Effets.TRAINEE_RARE = {
	Dore = ColorSequence.new(Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 190, 40)),
	Legendaire = ColorSequence.new(Color3.fromRGB(200, 150, 255), Color3.fromRGB(255, 120, 220)),
}

return Effets
