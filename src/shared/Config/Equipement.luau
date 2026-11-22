-- Équipement (T-203) : catalogue des objets par identifiant stable (le nom du modèle dans Assets.Equipement),
-- niveaux, et effet de l'objet porté. Le joueur porte un objet par famille : attributs « <Famille> » (identifiant)
-- et « <Famille>Niveau » (1 à NIVEAU_MAX), posés par la boutique d'après le profil (equipement.possede, .porte).
-- Le matériel d'entraînement est à part (MATERIEL, paliers sans niveau). Voir la note Équipement.
local Equipement = {}

export type Objet = {
	famille: string,
	monde: number,
	nom: string,
	prix: number,
	appel: number?, -- Chaussures : multiplie la puissance de l'appel
	carburant: number?, -- Propulseur : secondes de poussée par saut
	poussee: number?, -- Propulseur : accélération vers le haut (la gravité vaut 196)
	vitesseMontee: number?, -- Propulseur : vitesse verticale maximale donnée par la poussée
	pieces: number?, -- Tenue : multiplie les pièces d'un saut
}

-- Familles portées, dans l'ordre d'affichage (Ailes arrive avec le monde 2)
Equipement.FAMILLES = { "Chaussures", "Propulseur", "Tenue" }

-- Niveaux : chaque niveau au-delà du premier ajoute BONUS_NIVEAU à l'effet ; le niveau 2 coûte la moitié du prix
-- d'achat, puis chaque niveau coûte le double du précédent
Equipement.NIVEAU_MAX = 5
Equipement.BONUS_NIVEAU = 0.10

-- Catalogue. Prix de départ de la note Équipement, réglés par la simulation (outils/equilibrage).
Equipement.CATALOGUE = {
	chaussures_ressorts = { famille = "Chaussures", monde = 1, nom = "Semelles à ressorts", prix = 100, appel = 1.3 },
	chaussures_turbo = { famille = "Chaussures", monde = 1, nom = "Baskets turbo", prix = 2500, appel = 1.7 },
	chaussures_reaction = { famille = "Chaussures", monde = 1, nom = "Bottes à réaction", prix = 40000, appel = 2.2 },
	propulseur_soda = {
		famille = "Propulseur",
		monde = 1,
		nom = "Bouteille de soda",
		prix = 200, -- 500 dans la note ; 200 et 1,3 s réglés par la simulation (T-203)
		carburant = 1.3,
		poussee = 300,
		vitesseMontee = 40,
	},
	propulseur_extincteur = {
		famille = "Propulseur",
		monde = 1,
		nom = "Extincteur",
		prix = 8000,
		carburant = 2.5,
		poussee = 360,
		vitesseMontee = 50,
	},
	propulseur_reacteur = {
		famille = "Propulseur",
		monde = 1,
		nom = "Réacteur de poche",
		prix = 120000,
		carburant = 4,
		poussee = 420,
		vitesseMontee = 60,
	},
	tenue_club = { famille = "Tenue", monde = 1, nom = "Maillot du club", prix = 400, pieces = 1.25 },
	tenue_regionale = { famille = "Tenue", monde = 1, nom = "Tenue régionale", prix = 15000, pieces = 1.5 },
	tenue_champion = { famille = "Tenue", monde = 1, nom = "Tenue de champion", prix = 250000, pieces = 2 },
} :: { [string]: Objet }

-- Anciens identifiants (avant T-203) → nouveaux, pour la migration des profils
Equipement.ANCIENS = { Chaussures = "chaussures_ressorts", Jetpack = "propulseur_soda" }

-- Objets d'une famille dans un monde, du moins cher au plus cher
function Equipement.objetsDe(famille: string, monde: number?): { string }
	local liste = {}
	for id, o in Equipement.CATALOGUE do
		if o.famille == famille and (monde == nil or o.monde == monde) then
			table.insert(liste, id)
		end
	end
	table.sort(liste, function(a, b)
		return Equipement.CATALOGUE[a].prix < Equipement.CATALOGUE[b].prix
	end)
	return liste
end

-- Prix pour passer au niveau `niveau` (2 à NIVEAU_MAX) ; nil au-delà
function Equipement.prixNiveau(id: string, niveau: number): number?
	local o = Equipement.CATALOGUE[id]
	if not o or niveau < 2 or niveau > Equipement.NIVEAU_MAX then
		return nil
	end
	return math.floor(o.prix / 2 * 2 ^ (niveau - 2))
end

-- Facteur d'un niveau : 1 au niveau 1, + BONUS_NIVEAU par niveau au-delà
function Equipement.facteurNiveau(niveau: number?): number
	return 1 + Equipement.BONUS_NIVEAU * math.max((niveau or 1) - 1, 0)
end

-- Multiplicateur d'appel des chaussures portées (1 sans chaussures) : le bonus grandit avec le niveau
function Equipement.appel(id: string?, niveau: number?): number
	local o = id and Equipement.CATALOGUE[id]
	if not (o and o.appel) then
		return 1
	end
	return 1 + (o.appel - 1) * Equipement.facteurNiveau(niveau)
end

-- Multiplicateur de pièces de la tenue portée (1 sans tenue)
function Equipement.pieces(id: string?, niveau: number?): number
	local o = id and Equipement.CATALOGUE[id]
	if not (o and o.pieces) then
		return 1
	end
	return 1 + (o.pieces - 1) * Equipement.facteurNiveau(niveau)
end

-- Réglages du propulseur porté (nil sans propulseur) : le niveau allonge la durée de poussée
function Equipement.propulseur(
	id: string?,
	niveau: number?
): { carburant: number, poussee: number, vitesseMontee: number }?
	local o = id and Equipement.CATALOGUE[id]
	if not (o and o.carburant) then
		return nil
	end
	return {
		carburant = o.carburant * Equipement.facteurNiveau(niveau),
		poussee = o.poussee :: number,
		vitesseMontee = o.vitesseMontee :: number,
	}
end

-- Effets de ce que porte un joueur, d'après ses attributs
function Equipement.appelDe(player: Player): number
	return Equipement.appel(player:GetAttribute("Chaussures"), player:GetAttribute("ChaussuresNiveau"))
end
function Equipement.piecesDe(player: Player): number
	return Equipement.pieces(player:GetAttribute("Tenue"), player:GetAttribute("TenueNiveau"))
end
function Equipement.propulseurDe(player: Player)
	return Equipement.propulseur(player:GetAttribute("Propulseur"), player:GetAttribute("PropulseurNiveau"))
end

-- Matériel d'entraînement du monde 1 (T-202) : paliers achetés dans l'ordre au stand Matériel (attribut Objet
-- = "Materiel"). Le palier atteint multiplie tous les gains d'entraînement. Prix réglés par la simulation T-201
-- (25 pièces, puis × 5).
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
