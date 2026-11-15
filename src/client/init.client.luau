-- Démarre les contrôleurs du joueur, dans l'ordre.
local Controleurs = script:WaitForChild("Controleurs")

local ORDRE = {
	"Audio", -- sons d'interface
	"Hud", -- affichage : stats, distance, messages
	"Saut", -- jetpack, caméra, distance en direct
	"Compagnons", -- compagnons qui suivent les joueurs
}

for _, nom in ORDRE do
	require(Controleurs:WaitForChild(nom)).demarrer()
end
