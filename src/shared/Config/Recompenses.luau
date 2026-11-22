-- Récompenses (T-205) : quêtes du jour et de la semaine, défis de carrière, connexion, cadeaux de temps de jeu,
-- roue, coffre du groupe, boosts. Voir la note Quêtes et récompenses. Les codes sont côté serveur seulement
-- (service Recompenses), pour qu'ils ne se lisent pas depuis le jeu.
-- Une récompense : { pieces = n?, gemmes = n?, boost = { type = "Pieces" | "Entrainement" | "Chance", minutes = n }? }
local Recompenses = {}

Recompenses.GROUPE_ID = 763605593 -- groupe OGC Studio (D-04)

-- Compteurs suivis par le jeu (appelés depuis les services) :
-- Sauts, Parfaits (appels parfaits), Anneaux, Stats (points de stats gagnés), Oeufs, Records (records battus),
-- Distance (mètres sautés au total), Serie (plus longue série de sauts parfaits, valeur maximale)

-- Quêtes du jour : 3 tirées au sort parmi ces modèles, chaque jour à minuit UTC. `cible` dépend du joueur.
Recompenses.QUETES_JOUR = {
	{
		compteur = "Sauts",
		texte = "Fais %s sauts",
		cible = function()
			return 20
		end,
	},
	{
		compteur = "Parfaits",
		texte = "Réussis %s appels parfaits",
		cible = function()
			return 5
		end,
	},
	{
		compteur = "Anneaux",
		texte = "Traverse %s anneaux",
		cible = function()
			return 15
		end,
	},
	{
		compteur = "Stats",
		texte = "Gagne %s points de stats",
		cible = function(j)
			-- un cinquième des stats du joueur, arrondi à deux chiffres significatifs
			local v = math.max(500, (j.puissance + j.vitesse) / 5)
			local p = 10 ^ math.max(math.floor(math.log10(v)) - 1, 0)
			return math.floor(v / p + 0.5) * p
		end,
	},
	{
		compteur = "Oeufs",
		texte = "Fais éclore %s œufs",
		cible = function()
			return 3
		end,
	},
	{
		compteur = "Records",
		texte = "Bats ton record %s fois",
		cible = function()
			return 1
		end,
	},
}
Recompenses.QUETES_JOUR_NOMBRE = 3
-- Récompense d'une quête du jour : gemmes fixes et pièces selon le record du joueur
function Recompenses.recompenseJour(record: number)
	return { gemmes = 10, pieces = math.max(50, math.floor(record * 10)) }
end
-- Coffre bonus quand les trois quêtes du jour sont réclamées
function Recompenses.coffreJour(record: number)
	return { gemmes = 20, pieces = math.max(100, math.floor(record * 20)), boost = { type = "Pieces", minutes = 15 } }
end

-- Quêtes de la semaine : les cinq, remises à zéro le lundi (UTC)
Recompenses.QUETES_SEMAINE = {
	{ compteur = "Sauts", texte = "Fais %s sauts", cible = 300, recompense = { gemmes = 40, pieces = 2000 } },
	{ compteur = "Parfaits", texte = "Réussis %s appels parfaits", cible = 60, recompense = { gemmes = 50 } },
	{ compteur = "Anneaux", texte = "Traverse %s anneaux", cible = 200, recompense = { gemmes = 40 } },
	{
		compteur = "Oeufs",
		texte = "Fais éclore %s œufs",
		cible = 20,
		recompense = { gemmes = 30, boost = { type = "Chance", minutes = 15 } },
	},
	{
		compteur = "Records",
		texte = "Bats ton record %s fois",
		cible = 10,
		recompense = { gemmes = 60, boost = { type = "Entrainement", minutes = 15 } },
	},
}

-- Défis de carrière : paliers sans limite de temps, chacun donne des gemmes
Recompenses.DEFIS = {
	{
		compteur = "Distance",
		texte = "Distance totale sautée : %s m",
		paliers = { 100, 1000, 10000, 100000, 1000000 },
	},
	{ compteur = "Parfaits", texte = "Appels parfaits : %s", paliers = { 10, 50, 200, 1000, 5000 } },
	{ compteur = "Serie", texte = "Série de sauts parfaits : %s", paliers = { 3, 5, 10 } },
	{ compteur = "Oeufs", texte = "Œufs éclos : %s", paliers = { 5, 25, 100, 500 } },
}
Recompenses.GEMMES_DEFI = { 10, 20, 40, 80, 150 } -- par rang de palier

-- Connexion : calendrier de 7 jours qui se répète ; une série interrompue reprend au jour 1.
-- Jour 7 : 150 gemmes, le prix d'un œuf d'or.
Recompenses.CONNEXION = {
	{ pieces = 100 },
	{ gemmes = 10 },
	{ pieces = 500 },
	{ boost = { type = "Pieces", minutes = 15 } },
	{ gemmes = 25 },
	{ pieces = 2000, boost = { type = "Entrainement", minutes = 15 } },
	{ gemmes = 150 },
}

-- Cadeaux de temps de jeu : minutes de présence dans la session, et récompense
Recompenses.CADEAUX = {
	{ minutes = 5, recompense = { pieces = 50 } },
	{ minutes = 10, recompense = { gemmes = 3 } },
	{ minutes = 20, recompense = { pieces = 300 } },
	{ minutes = 30, recompense = { gemmes = 5 } },
	{ minutes = 45, recompense = { boost = { type = "Entrainement", minutes = 15 } } },
	{ minutes = 60, recompense = { gemmes = 8 } },
	{ minutes = 90, recompense = { pieces = 3000 } },
	{ minutes = 120, recompense = { gemmes = 14, boost = { type = "Chance", minutes = 15 } } },
}

-- Roue quotidienne : un tour gratuit par jour. `poids` relatifs ; « gros lot » : 150 gemmes (un œuf d'or).
Recompenses.ROUE = {
	{ nom = "Pièces", poids = 30, recompense = { pieces = 200 } },
	{ nom = "Beaucoup de pièces", poids = 15, recompense = { pieces = 1000 } },
	{ nom = "Gemmes", poids = 25, recompense = { gemmes = 5 } },
	{ nom = "Plein de gemmes", poids = 8, recompense = { gemmes = 20 } },
	{ nom = "Boost pièces", poids = 8, recompense = { boost = { type = "Pieces", minutes = 15 } } },
	{ nom = "Boost entraînement", poids = 8, recompense = { boost = { type = "Entrainement", minutes = 15 } } },
	{ nom = "Boost chance", poids = 5, recompense = { boost = { type = "Chance", minutes = 15 } } },
	{ nom = "Gros lot", poids = 1, recompense = { gemmes = 150 } },
}

-- Coffre du groupe : membres du groupe, toutes les 24 heures
Recompenses.COFFRE_GROUPE = { gemmes = 15, pieces = 500 }
Recompenses.COFFRE_GROUPE_DELAI = 24 * 3600

-- Boosts : chacun double un gain ; la durée se compte en temps de jeu et s'empile, pas la puissance
Recompenses.BOOSTS = { Pieces = 2, Entrainement = 2, Chance = 2 }

-- Jour et semaine en cours (UTC). Le 1er janvier 1970 était un jeudi : +3 jours pour commencer au lundi.
function Recompenses.jour(t: number?): number
	return (t or os.time()) // 86400
end
function Recompenses.semaine(t: number?): number
	return (Recompenses.jour(t) + 3) // 7
end

-- Multiplicateur d'un boost pour un joueur (attribut « Boost<Type> » : secondes restantes)
function Recompenses.boost(player: Player, type: string): number
	return if (player:GetAttribute("Boost" .. type) or 0) > 0 then Recompenses.BOOSTS[type] else 1
end

return Recompenses
