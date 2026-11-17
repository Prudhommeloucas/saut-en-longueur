-- Objets de la boutique, par identifiant (le nom de l'attribut sur le joueur, et l'attribut Objet du stand tagué « Stand »).
local Equipement = {}

Equipement.OBJETS = {
	Chaussures = {
		nom = "Chaussures propulsantes",
		prix = 100,
		bonusSaut = 1.3, -- multiplie la puissance de saut sur la piste
	},
	Jetpack = {
		nom = "Jetpack",
		prix = 500,
		carburant = 1.5, -- secondes de poussée par saut
		poussee = 300, -- accélération vers le haut (la gravité vaut 196)
		vitesseMontee = 40, -- vitesse verticale maximale donnée par le jetpack
	},
}

return Equipement
