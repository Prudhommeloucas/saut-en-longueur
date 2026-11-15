-- Toutes les valeurs d'équilibrage du jeu. Modifier ici, pas dans les autres scripts.
local Config = {}

-- Distances
Config.STUDS_PAR_METRE = 4 -- 1 mètre affiché = 4 studs
Config.LIGNE_X = 120 -- position X de la planche d'appel (début du sable)
Config.DEBUT_PISTE_X = 0 -- au-delà de ce X, les bonus de vitesse et de saut s'appliquent
Config.RETOUR_PISTE = Vector3.new(8, 4, 0) -- où le joueur est renvoyé après un saut
Config.DELAI_RETOUR = 2 -- secondes entre l'atterrissage et le retour

-- Personnage
Config.VITESSE_BASE = 16 -- au spawn
Config.SAUT_BASE = 50 -- au spawn
Config.VITESSE_PISTE_BASE = 26 -- sur la piste, sans entraînement
Config.SAUT_PISTE_BASE = 62 -- sur la piste, sans entraînement
Config.VITESSE_MAX = 300
Config.SAUT_MAX = 600

-- Entraînement : gain toutes les X secondes passées dans une zone
Config.ENTRAINEMENT_INTERVALLE = 0.5
Config.ENTRAINEMENT_GAIN = 1

-- Récompense : pièces gagnées par mètre sauté (au moins PIECES_MIN si on atteint le sable)
Config.PIECES_PAR_METRE = 1
Config.PIECES_MIN = 1

-- Rebirth : remet Pièces, Puissance et Vitesse à zéro, garde objets et pets
Config.REBIRTH = {
	prixBase = 1000, -- prix du 1er rebirth en pièces
	prixParRebirth = 1000, -- ajouté à chaque rebirth suivant
	bonusEntrainement = 0.5, -- +50 % de gain d'entraînement par rebirth
}

function Config.prixRebirth(rebirths: number): number
	return Config.REBIRTH.prixBase + rebirths * Config.REBIRTH.prixParRebirth
end

-- Œufs et pets : chaque pet multiplie le gain d'entraînement
Config.OEUF_PRIX = 250
Config.PETS_EQUIPES_MAX = 3 -- les meilleurs sont équipés automatiquement
Config.PETS = {
	-- poids = chances relatives de sortir de l'œuf
	{ id = "Vert", nom = "Cube vert", rarete = "Commun", poids = 60, bonus = 0.2, couleur = "Bright green" },
	{ id = "Bleu", nom = "Cube bleu", rarete = "Rare", poids = 30, bonus = 0.5, couleur = "Bright blue" },
	{ id = "Violet", nom = "Cube violet", rarete = "Épique", poids = 8, bonus = 1, couleur = "Bright violet" },
	{ id = "Dore", nom = "Cube doré", rarete = "Légendaire", poids = 2, bonus = 3, couleur = "Bright yellow" },
}

function Config.petParId(id: string)
	for _, p in Config.PETS do
		if p.id == id then
			return p
		end
	end
	return nil
end

-- Les meilleurs pets d'une liste d'ids, dans la limite de PETS_EQUIPES_MAX
function Config.petsEquipes(ids: { string }): { string }
	local tri = table.clone(ids)
	table.sort(tri, function(a, b)
		local pa, pb = Config.petParId(a), Config.petParId(b)
		return (pa and pa.bonus or 0) > (pb and pb.bonus or 0)
	end)
	local res = {}
	for i = 1, math.min(#tri, Config.PETS_EQUIPES_MAX) do
		table.insert(res, tri[i])
	end
	return res
end

-- Multiplicateur total d'entraînement (rebirths + pets équipés)
function Config.multiplicateur(rebirths: number, petIds: { string }): number
	local m = 1 + rebirths * Config.REBIRTH.bonusEntrainement
	local bonusPets = 0
	for _, id in Config.petsEquipes(petIds) do
		local p = Config.petParId(id)
		if p then
			bonusPets += p.bonus
		end
	end
	return m * (1 + bonusPets)
end

-- Objets de la boutique
Config.OBJETS = {
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

-- Sons
Config.SONS = {
	Atterrissage = "rbxassetid://9118767941",
	Pieces = "rbxassetid://135483737426662",
	Record = "rbxassetid://9067124098",
	Jetpack = "rbxasset://sounds/action_falling.ogg",
}

-- Caméra : le champ de vision s'élargit avec la vitesse
Config.FOV_BASE = 70
Config.FOV_MAX = 100

-- Vitesse de course sur la piste selon la stat Vitesse (mollets)
function Config.vitesseCourse(vitesse: number): number
	return math.min(Config.VITESSE_PISTE_BASE + 4 * math.sqrt(vitesse), Config.VITESSE_MAX)
end

-- Puissance de saut sur la piste selon la stat Puissance (squat)
function Config.puissanceSaut(puissance: number, chaussures: boolean): number
	local p = Config.SAUT_PISTE_BASE + 5 * math.sqrt(puissance)
	if chaussures then
		p *= Config.OBJETS.Chaussures.bonusSaut
	end
	return math.min(p, Config.SAUT_MAX)
end

return Config
