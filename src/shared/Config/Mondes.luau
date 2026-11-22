-- Mondes : ce qui change d'un monde à l'autre (T-201). Valeurs de départ, réglées par la simulation
-- (outils/equilibrage) puis en test. Voir les notes Mondes et Économie.
-- Le numéro d'un monde est son index dans Mondes.LISTE ; l'attribut « Monde » du joueur le porte (1 par défaut).
local Mondes = {}

export type Zone = { multiplicateur: number, recordRequis: number?, passe: string? }
export type Monde = {
	nom: string,
	studsParMetre: number, -- échelle des distances (au-delà de ~50 000 studs, l'affichage se dégrade)
	pieces: number, -- multiplicateur des pièces d'un saut
	gravite: number, -- gravité du Workspace pendant le saut (196,2 = celle de Roblox)
	plafondVitesse: number, -- vitesse de course maximale sur la piste (studs/s)
	plafondSaut: number, -- puissance de saut maximale (studs/s vers le haut)
	longueurBac: number, -- m
	acces: { monde: number, record: number, categorie: string? }?, -- record à battre dans le monde précédent
	zones: { Zone }, -- paliers d'entraînement, du plus faible au plus fort
}

local GRAVITE = 196.2

Mondes.LISTE = {
	{
		nom = "Stade des Débuts",
		studsParMetre = 4,
		pieces = 1,
		gravite = GRAVITE,
		plafondVitesse = 300,
		plafondSaut = 600,
		longueurBac = 500,
		acces = nil,
		zones = {
			{ multiplicateur = 1 },
			{ multiplicateur = 2, recordRequis = 25 },
			{ multiplicateur = 12, recordRequis = 80 },
			{ multiplicateur = 20, passe = "PasseVIP" },
		},
	},
	{
		nom = "Plage des Alizés",
		studsParMetre = 4,
		pieces = 5,
		gravite = GRAVITE,
		plafondVitesse = 520,
		plafondSaut = 900,
		longueurBac = 1500,
		acces = { monde = 1, record = 150 },
		zones = {
			{ multiplicateur = 60 },
			{ multiplicateur = 300, recordRequis = 400 },
			{ multiplicateur = 1500, recordRequis = 900 },
			{ multiplicateur = 2400, passe = "PasseVIP" },
		},
	},
	{
		nom = "Canyon du Vertige",
		studsParMetre = 2,
		pieces = 25,
		gravite = GRAVITE,
		plafondVitesse = 800,
		plafondSaut = 1300,
		longueurBac = 4000,
		acces = { monde = 2, record = 600, categorie = "Amateur" },
		zones = {
			{ multiplicateur = 4000 },
			{ multiplicateur = 20000, recordRequis = 1500 },
			{ multiplicateur = 100000, recordRequis = 3000 },
			{ multiplicateur = 160000, passe = "PasseVIP" },
		},
	},
	{
		nom = "Pic Givré",
		studsParMetre = 2,
		pieces = 150,
		gravite = GRAVITE,
		plafondVitesse = 1100,
		plafondSaut = 1700,
		longueurBac = 8000,
		acces = { monde = 3, record = 2000 },
		zones = {
			{ multiplicateur = 3e5 },
			{ multiplicateur = 1.5e6, recordRequis = 3500 },
			{ multiplicateur = 7.5e6, recordRequis = 6000 },
			{ multiplicateur = 1.2e7, passe = "PasseVIP" },
		},
	},
	{
		nom = "Métropole Néon",
		studsParMetre = 1,
		pieces = 1000,
		gravite = GRAVITE,
		plafondVitesse = 1500,
		plafondSaut = 2300,
		longueurBac = 15000,
		acces = { monde = 4, record = 5000, categorie = "National" },
		zones = {
			{ multiplicateur = 2e7 },
			{ multiplicateur = 1e8, recordRequis = 8000 },
			{ multiplicateur = 5e8, recordRequis = 12000 },
			{ multiplicateur = 8e8, passe = "PasseVIP" },
		},
	},
	{
		nom = "Base Lunaire",
		studsParMetre = 0.5,
		pieces = 8000,
		gravite = GRAVITE / 6,
		plafondVitesse = 1800,
		plafondSaut = 2000,
		longueurBac = 40000,
		acces = { monde = 5, record = 10000 },
		zones = {
			{ multiplicateur = 1.5e9 },
			{ multiplicateur = 7.5e9, recordRequis = 20000 },
			{ multiplicateur = 3.75e10, recordRequis = 30000 },
			{ multiplicateur = 6e10, passe = "PasseVIP" },
		},
	},
} :: { Monde }

-- Configuration d'un monde (le monde 1 si le numéro est inconnu)
function Mondes.get(numero: number?): Monde
	return Mondes.LISTE[numero or 1] or Mondes.LISTE[1]
end

return Mondes
