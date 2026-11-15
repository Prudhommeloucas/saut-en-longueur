-- Sauvegarde des joueurs (ProfileStore). Voir Réalisation/Architecture du code.md, « Données d'un joueur ».
local Donnees = {}

-- Magasin des profils. Ne jamais renommer : ce serait repartir de zéro pour tous les joueurs.
Donnees.MAGASIN = "SautEnLongueur_Profils"

-- Ancien magasin (avant T-006), lu une seule fois par joueur pour reprendre ses données.
Donnees.MAGASIN_V1 = "SautEnLongueur_v1"

-- Version de la forme des données. À chaque changement de forme : +1 et une migration dans le service Donnees.
Donnees.VERSION = 1

-- Forme d'un profil neuf. Une clé ajoutée ici est remplie toute seule chez les anciens joueurs (Reconcile).
Donnees.MODELE = {
	version = Donnees.VERSION,
	repriseV1 = false, -- vrai une fois l'ancien magasin lu
	pieces = 0,
	record = 0, -- en mètres
	stats = { Puissance = 0, Vitesse = 0 },
	equipement = { possede = {} }, -- [identifiant] = niveau
}

return Donnees
