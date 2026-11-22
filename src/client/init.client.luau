-- Démarre les contrôleurs du joueur, dans l'ordre.
local Controleurs = script:WaitForChild("Controleurs")
require(script:WaitForChild("Interface")).demarrer()

local ORDRE = {
	"Audio", -- sons d'interface
	"Hud", -- affichage : stats, distance, messages
	"Saut", -- jetpack, caméra, distance en direct
	"Rythme", -- entraînement actif : cercle et appuis
	"Paliers", -- prochain palier, fonctions qui s'ouvrent
	"Recompenses", -- panneau provisoire des quêtes, cadeaux, roue, codes
	"Compagnons", -- compagnons qui suivent les joueurs
	"EcranCompagnons", -- inventaire, équipe, index
	"EcranOeuf", -- chances et achat d'un œuf
	"EcranEclosion", -- animation d'éclosion
	"DecorAnime", -- décor qui tourne, flotte, se balance ou pulse
}

for _, nom in ORDRE do
	require(Controleurs:WaitForChild(nom)).demarrer()
end
