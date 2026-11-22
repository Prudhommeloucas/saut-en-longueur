-- Sauvegarde des joueurs (ProfileStore). Voir Réalisation/Architecture du code.md, « Données d'un joueur ».
local Donnees = {}

-- Magasin des profils. Ne jamais renommer : ce serait repartir de zéro pour tous les joueurs.
Donnees.MAGASIN = "SautEnLongueur_Profils"

-- Ancien magasin (avant T-006), lu une seule fois par joueur pour reprendre ses données.
Donnees.MAGASIN_V1 = "SautEnLongueur_v1"

-- Version de la forme des données. À chaque changement de forme : +1 et une migration dans le service Donnees.
Donnees.VERSION = 2 -- 2 : catalogue d'équipement (T-203), objets portés par famille

-- Forme d'un profil neuf. Une clé ajoutée ici est remplie toute seule chez les anciens joueurs (Reconcile).
Donnees.MODELE = {
	version = Donnees.VERSION,
	repriseV1 = false, -- vrai une fois l'ancien magasin lu
	pieces = 0,
	record = 0, -- en mètres
	stats = { Puissance = 0, Vitesse = 0 },
	-- possede : [identifiant du catalogue] = niveau ; porte : [famille] = identifiant ; materiel : palier (T-202)
	equipement = { possede = {}, porte = {}, materiel = 0 },
	compagnons = {
		liste = {}, -- [uid] = { espece, version, niveau, xp }
		equipes = {}, -- liste d'uid, dans l'ordre d'affichage
		prochainId = 1,
	},
	gemmes = 0,
	index = {
		trouves = {}, -- [espece] = { Normal = true, Argent = true, Or = true }
		pages = {}, -- ["oeuf_stade:Normal"] = true quand la page est complète
		chance = 0, -- bonus permanent de chance aux œufs (0,05 = +5 %)
	},
	oeufsOuverts = 0,
	paliers = { reclames = {} }, -- T-204 : [« monde:record »] = true quand la récompense du palier est prise
	-- T-205 : quêtes, défis, connexion, roue, coffre du groupe, codes, boosts (secondes de jeu restantes)
	recompenses = {
		jour = { numero = -1, quetes = {}, coffre = false, remplacee = false },
		semaine = { numero = -1, quetes = {} },
		compteurs = {}, -- [compteur] = total depuis toujours (défis)
		defis = {}, -- ["compteur:palier"] = true quand réclamé
		connexion = { dernierJour = -1, serie = 0, reclameJour = -1 },
		roueJour = -1,
		groupe = 0, -- os.time() du dernier coffre
		codes = {}, -- [code] = true
		boosts = { Pieces = 0, Entrainement = 0, Chance = 0 },
	},
}

return Donnees
