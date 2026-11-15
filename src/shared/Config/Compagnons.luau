-- Compagnons : espèces, rôles, bonus, emplacements, niveaux. Voir Conception/Compagnons.md.
local Compagnons = {}

Compagnons.EMPLACEMENTS = 3 -- compagnons équipés au départ
Compagnons.INVENTAIRE_MAX = 50

-- Bonus de base selon le rôle et la rareté (0,5 = +50 %). Les bonus des compagnons équipés s'additionnent.
-- Coach : gain d'entraînement. Trésorier : pièces par saut. Porte-bonheur : chance de saut doré (utilisé à T-104).
Compagnons.BONUS = {
	Coach = { Commun = 0.15, Rare = 0.5, ["Épique"] = 1.5, ["Légendaire"] = 5, Mythique = 20 },
	Tresorier = { Commun = 0.08, Rare = 0.25, ["Épique"] = 0.75, ["Légendaire"] = 2.5, Mythique = 10 },
	PorteBonheur = { Commun = 0.05, Rare = 0.15, ["Épique"] = 0.4, ["Légendaire"] = 1, Mythique = 3 },
}

-- Versions obtenues par fusion : multiplicateur du bonus. L'apparence est dans Assets.Versions.
Compagnons.VERSIONS = { Normal = 1, Argent = 2, Or = 4 }
Compagnons.ORDRE_VERSIONS = { "Normal", "Argent", "Or" }

-- Niveaux : un compagnon équipé gagne XP_PAR_SAUT à chaque saut du joueur.
Compagnons.NIVEAU_MAX = 25
Compagnons.BONUS_PAR_NIVEAU = 0.02 -- +2 % du bonus par niveau au-delà du premier
Compagnons.XP_PAR_SAUT = 1
function Compagnons.xpPourNiveauSuivant(niveau: number): number
	return 3 + 2 * niveau -- 5 sauts pour le niveau 2, 51 pour passer du 24 au 25
end

-- Espèces : identifiant = nom du modèle dans ReplicatedStorage.Assets.Compagnons.
-- couleur : teinte principale du modèle, pour les pastilles des écrans en attendant les icônes (T-306)
Compagnons.ESPECES = {
	compagnon_grenouille = { nom = "Grenouille", rarete = "Commun", role = "Coach", couleur = "5BD06A" },
	compagnon_lapin = { nom = "Lapin", rarete = "Commun", role = "PorteBonheur", couleur = "FFFFFF" },
	compagnon_sauterelle = { nom = "Sauterelle", rarete = "Rare", role = "Coach", couleur = "8EE04E" },
	compagnon_kangourou = { nom = "Kangourou", rarete = "Épique", role = "Tresorier", couleur = "D9822B" },
	compagnon_puce = { nom = "Puce savante", rarete = "Légendaire", role = "PorteBonheur", couleur = "6E3A70" },
	compagnon_lievre = { nom = "Lièvre", rarete = "Commun", role = "Coach", couleur = "C8955A" },
	compagnon_ecureuil = { nom = "Écureuil volant", rarete = "Rare", role = "Tresorier", couleur = "9A8678" },
	compagnon_gazelle = { nom = "Gazelle", rarete = "Rare", role = "Coach", couleur = "D9A15B" },
	compagnon_dauphin = { nom = "Dauphin", rarete = "Épique", role = "Tresorier", couleur = "4FA8E8" },
	compagnon_puma = { nom = "Puma", rarete = "Légendaire", role = "Coach", couleur = "D69A4A" },
}

-- Couleurs des raretés (Direction artistique) et noms affichés des rôles
Compagnons.COULEURS_RARETE = {
	Commun = "9AA4B2",
	Rare = "1E90FF",
	["Épique"] = "9B5CFF",
	["Légendaire"] = "FFC83D",
	Mythique = "FF4F8B",
}
Compagnons.NOMS_ROLES = { Coach = "Coach", Tresorier = "Trésorier", PorteBonheur = "Porte-bonheur" }

-- Bonus d'un compagnon précis (espèce, version, niveau), pour son rôle
function Compagnons.bonus(espece: string, version: string, niveau: number): number
	local e = Compagnons.ESPECES[espece]
	if not e then
		return 0
	end
	local base = Compagnons.BONUS[e.role][e.rarete] or 0
	local mult = Compagnons.VERSIONS[version] or 1
	return base * mult * (1 + Compagnons.BONUS_PAR_NIVEAU * (niveau - 1))
end

-- Suivi à l'écran (côté joueur)
Compagnons.SUIVI = {
	distance = 4, -- studs derrière le joueur
	ecart = 3, -- studs entre deux compagnons, de côté
	hauteurBond = 0.8, -- hauteur des petits bonds quand le joueur avance
	frequenceBond = 7, -- bonds par seconde (en radians/s divisé par pi)
	douceur = 8, -- plus c'est grand, plus ils collent au joueur
	distanceAffichage = 200, -- au-delà, les compagnons d'un autre joueur ne sont pas affichés
}

return Compagnons
