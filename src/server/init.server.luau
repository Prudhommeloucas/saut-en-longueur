-- Démarre les services du serveur, dans l'ordre.
local Services = script:WaitForChild("Services")

local ORDRE = {
	"Donnees", -- chargement et sauvegarde des joueurs
	"Personnage", -- objets portés sur le personnage
	"Compagnons", -- inventaire, équipe, bonus, niveaux
	"Stats", -- vitesse et saut selon la zone
	"Entrainement", -- gains dans les zones d'entraînement
	"Saut", -- mesure du saut, effets, jetpack
	"Boutique", -- stands d'achat
}

for _, nom in ORDRE do
	require(Services:WaitForChild(nom)).demarrer()
end
