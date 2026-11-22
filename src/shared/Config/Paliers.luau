-- Paliers de record et ouverture progressive des fonctions (T-204). Voir les notes Boucles de gameplay
-- (« Ce qui s'ouvre, et quand ») et Quêtes et récompenses (« Paliers de record »).
-- Le record du joueur est l'attribut « Record » (m). Une fonction est ouverte quand sa condition est remplie ;
-- le serveur prévient le joueur une fois, au saut qui la franchit (mise en scène côté joueur).
local Mondes = require(script.Parent.Mondes)
local Stats = require(script.Parent.Stats)

local Paliers = {}

local zones = Mondes.get(1).zones

-- Fonctions du jeu, dans l'ordre où elles s'ouvrent. `record` en mètres (le premier saut : record > 0).
-- Les fonctions pas encore construites sont déjà listées : leur tâche appellera Paliers.estOuvert.
Paliers.DEBLOCAGES = {
	{ id = "Boutique", nom = "Boutique d'équipement", record = 0.01 },
	{ id = "Rythme", nom = "Entraînement actif (rythme)", record = Stats.RYTHME.recordRequis },
	{ id = "Quetes", nom = "Quêtes du jour", record = 10 }, -- T-205
	{ id = "Compagnons", nom = "Compagnons et œufs", record = 15 },
	{ id = "ZoneConfirme", nom = "Zone d'entraînement Confirmé", record = zones[2].recordRequis },
	{ id = "Concours", nom = "Concours de serveur", record = 30 }, -- T-502
	{ id = "Categorie", nom = "Changement de catégorie", record = 60 }, -- T-401
	{ id = "ZoneElite", nom = "Zone d'entraînement Élite", record = zones[3].recordRequis },
	{ id = "Monde2", nom = "Monde 2 : Plage des Alizés", record = Mondes.get(2).acces.record }, -- T-403
	-- Arbre de talents : à la première médaille (T-402), pas au record
}

-- Échelle des paliers de record du monde 1 : chaque palier franchi donne des gemmes et des pièces
Paliers.ECHELLE = {
	[1] = {
		{ record = 10, gemmes = 5, pieces = 20 },
		{ record = 25, gemmes = 10, pieces = 50 },
		{ record = 50, gemmes = 15, pieces = 150 },
		{ record = 75, gemmes = 20, pieces = 300 },
		{ record = 100, gemmes = 30, pieces = 600 },
		{ record = 150, gemmes = 50, pieces = 1500 },
		{ record = 200, gemmes = 60, pieces = 3000 },
		{ record = 300, gemmes = 80, pieces = 8000 },
		{ record = 400, gemmes = 100, pieces = 20000 },
		{ record = 500, gemmes = 150, pieces = 50000 },
	},
}

-- Vrai tant que l'écran des paliers (EcranPaliers, T-209) n'existe pas : la récompense est donnée tout de suite.
-- Ensuite, elle attendra que le joueur la réclame (événement ReclamerPalier).
Paliers.RECLAMATION_AUTO = true

local parId = {}
for _, d in Paliers.DEBLOCAGES do
	parId[d.id] = d
end

function Paliers.deblocage(id: string)
	return parId[id]
end

-- Une fonction est-elle ouverte pour ce record ? (les identifiants inconnus sont ouverts)
function Paliers.ouvertPour(id: string, record: number?): boolean
	local d = parId[id]
	return d == nil or (record or 0) >= d.record
end

function Paliers.estOuvert(player: Player, id: string): boolean
	return Paliers.ouvertPour(id, player:GetAttribute("Record"))
end

-- Fonctions ouvertes en passant de l'ancien record au nouveau
function Paliers.nouveauxDeblocages(ancien: number, nouveau: number): { any }
	local liste = {}
	for _, d in Paliers.DEBLOCAGES do
		if ancien < d.record and nouveau >= d.record then
			table.insert(liste, d)
		end
	end
	return liste
end

-- Clé d'un palier dans le profil (paliers.reclames) : « monde:record »
function Paliers.cle(monde: number, record: number): string
	return monde .. ":" .. record
end

-- Prochain palier de l'échelle au-dessus de ce record (nil au sommet)
function Paliers.prochain(monde: number, record: number?)
	for _, p in Paliers.ECHELLE[monde] or {} do
		if (record or 0) < p.record then
			return p
		end
	end
	return nil
end

return Paliers
