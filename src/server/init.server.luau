-- Démarre les services du serveur, dans l'ordre.
local Services = script:WaitForChild("Services")

local ORDRE = {
	"Donnees", -- chargement et sauvegarde des joueurs
	"Personnage", -- objets portés sur le personnage
	"Index", -- album des espèces trouvées
	"Compagnons", -- inventaire, équipe, bonus, niveaux, fusion
	"Oeufs", -- achat et éclosion des œufs
	"Stats", -- vitesse et saut selon la zone
	"Entrainement", -- gains dans les zones d'entraînement
	"Anneaux", -- pièces des anneaux traversés
	"Saut", -- mesure du saut, sauts rares, effets, jetpack
	"Boutique", -- stands d'achat
	"Paliers", -- paliers de record et fonctions qui s'ouvrent
	"Recompenses", -- quêtes, défis, connexion, cadeaux, roue, codes, boosts
}

for _, nom in ORDRE do
	require(Services:WaitForChild(nom)).demarrer()
end
