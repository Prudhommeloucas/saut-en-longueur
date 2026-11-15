-- Démarre les contrôleurs du joueur, dans l'ordre.
local Controleurs = script:WaitForChild("Controleurs")
require(script:WaitForChild("Interface")).demarrer()

local ORDRE = {
	"Audio", -- sons d'interface
	"Hud", -- affichage : stats, distance, messages
	"Saut", -- jetpack, caméra, distance en direct
	"Compagnons", -- compagnons qui suivent les joueurs
	"EcranCompagnons", -- inventaire, équipe, index
	"EcranOeuf", -- chances et achat d'un œuf
	"EcranEclosion", -- animation d'éclosion
}

for _, nom in ORDRE do
	require(Controleurs:WaitForChild(nom)).demarrer()
end
