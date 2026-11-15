-- Œufs : prix, contenu et chances, index. Voir Conception/Compagnons.md.
-- Les chances sont affichées avant l'achat (EcranOeuf, T-305) : c'est une obligation de Roblox.
local Oeufs = {}

-- monnaie : "pieces" ou "gemmes". payant = tirage dont la monnaie s'achète en Robux :
-- interdit dans les pays où PolicyService l'indique (ArePaidRandomItemsRestricted).
-- contenu : poids relatifs (ici, des pourcentages qui font 100).
Oeufs.LISTE = {
	oeuf_stade = {
		nom = "Œuf du stade",
		prix = 500,
		monnaie = "pieces",
		payant = false,
		contenu = {
			{ espece = "compagnon_grenouille", poids = 50 },
			{ espece = "compagnon_lapin", poids = 30 },
			{ espece = "compagnon_sauterelle", poids = 14 },
			{ espece = "compagnon_kangourou", poids = 5 },
			{ espece = "compagnon_puce", poids = 1 },
		},
	},
	oeuf_champion = {
		nom = "Œuf du champion",
		prix = 25000,
		monnaie = "pieces",
		payant = false,
		contenu = {
			{ espece = "compagnon_lievre", poids = 45 },
			{ espece = "compagnon_ecureuil", poids = 30 },
			{ espece = "compagnon_gazelle", poids = 18 },
			{ espece = "compagnon_dauphin", poids = 6 },
			{ espece = "compagnon_puma", poids = 1 },
		},
	},
	-- Provisoire (2026-11-15) : pas encore d'espèce exclusive, à ajouter quand elle sera choisie et modélisée.
	oeuf_or = {
		nom = "Œuf d'or",
		prix = 150,
		monnaie = "gemmes",
		payant = true,
		contenu = {
			{ espece = "compagnon_kangourou", poids = 35 },
			{ espece = "compagnon_dauphin", poids = 35 },
			{ espece = "compagnon_puce", poids = 15 },
			{ espece = "compagnon_puma", poids = 15 },
		},
	},
}

-- Raretés touchées par le bonus de chance de l'index (leurs poids sont multipliés par 1 + chance)
Oeufs.RARETES_CHANCEUSES = { ["Épique"] = true, ["Légendaire"] = true, Mythique = true }

-- Index : récompense quand toutes les espèces d'un œuf sont trouvées dans une version
Oeufs.RECOMPENSES_PAGE = {
	Normal = { gemmes = 50, chance = 0.02 },
	Argent = { gemmes = 150, chance = 0.03 },
	Or = { gemmes = 500, chance = 0.05 },
}

-- Fusion : nombre de compagnons identiques pour passer à la version suivante
Oeufs.FUSION_NOMBRE = 3

-- Chances en pour cent de chaque espèce d'un œuf, dans l'ordre du contenu (pour l'affichage)
function Oeufs.chances(oeufId: string): { { espece: string, pourcentage: number } }
	local oeuf = Oeufs.LISTE[oeufId]
	local res = {}
	if not oeuf then
		return res
	end
	local total = 0
	for _, c in oeuf.contenu do
		total += c.poids
	end
	for _, c in oeuf.contenu do
		table.insert(res, { espece = c.espece, pourcentage = 100 * c.poids / total })
	end
	return res
end

return Oeufs
