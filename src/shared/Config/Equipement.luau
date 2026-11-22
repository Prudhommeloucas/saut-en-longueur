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

-- Matériel d'entraînement du monde 1 (T-202) : paliers achetés dans l'ordre au stand Matériel (attribut Objet
-- = "Materiel"). Le palier atteint multiplie tous les gains d'entraînement. Prix réglés par la simulation T-201
-- (25 pièces, puis × 5) ; le catalogue complet de l'équipement vient avec T-203.
Equipement.MATERIEL = {
	{ id = "Halteres", nom = "Haltères", multiplicateur = 2, prix = 25 },
	{ id = "Elastiques", nom = "Élastiques", multiplicateur = 4, prix = 125 },
	{ id = "Kettlebell", nom = "Kettlebell", multiplicateur = 8, prix = 625 },
	{ id = "GiletLeste", nom = "Gilet lesté", multiplicateur = 16, prix = 3125 },
	{ id = "ChevillesLestees", nom = "Chevilles lestées", multiplicateur = 32, prix = 15625 },
	{ id = "MedecineBall", nom = "Medecine-ball", multiplicateur = 64, prix = 78125 },
	{ id = "Traineau", nom = "Traîneau de poussée", multiplicateur = 128, prix = 390625 },
	{ id = "BarreOr", nom = "Barre en or", multiplicateur = 256, prix = 1953125 },
}

-- Multiplicateur d'entraînement du palier de matériel atteint (0 = aucun matériel)
function Equipement.multiplicateurMateriel(palier: number?): number
	local m = Equipement.MATERIEL[palier or 0]
	return m and m.multiplicateur or 1
end

return Equipement
