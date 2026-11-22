-- Simulation d'équilibrage du monde 1 (T-201) : un joueur automatique s'entraîne, saute et achète le meilleur
-- objet abordable ; on relève le record, les stats et les pièces au fil du temps.
-- À lancer dans Studio (barre de commande ou MCP, mode Édition) : la simulation lit les vrais modules
-- ReplicatedStorage.Shared.Config (Stats, Saut, Mondes, Equipement). Elle renvoie un texte JSON
-- (série toutes les 30 s, événements, jalons) que outils/equilibrage/tableur.py met en classeur et en courbe.
-- `_G.SIMULATION_REGLAGES` peut remplacer des valeurs pour essayer un réglage sans toucher à la configuration.
local HttpService = game:GetService("HttpService")
-- `_G.SIMULATION_CONFIG` : un autre dossier de configuration (par exemple les modules du dépôt pas encore
-- synchronisés), sinon celui de la place
-- selene: allow(global_usage)
local Config = _G.SIMULATION_CONFIG or game:GetService("ReplicatedStorage").Shared.Config
-- Copie du dossier : la barre de commande garde les modules en cache d'une exécution à l'autre,
-- et chaque module retrouve ses voisins (script.Parent) dans la copie
local copie = Config:Clone()
local function charger(nom)
	return require(copie[nom])
end
local Mondes = charger("Mondes")
local Saut = charger("Saut")
local Equipement = charger("Equipement")
local Stats = charger("Stats")

-- selene: allow(global_usage)
local R = _G.SIMULATION_REGLAGES or {}
for cle, valeur in R.stats or {} do -- par exemple { K_SAUT = 6, BONUS_DEBUTANT = { multiplicateur = 10, recordFin = 60 } }
	Stats[cle] = valeur
end

-- Hypothèses du joueur type (à remplacer par la configuration de T-202 et T-203 quand elle existera)
local H = {
	duree = R.duree or 2 * 3600, -- s simulées
	monde = 1,
	appel = Saut.APPEL_QUALITES[2].multiplicateur, -- appel Bon en moyenne
	reception = true, -- réception réussie (+10 %)
	rythme = R.rythme or 2.5, -- entraînement actif : × 3 parfait, × 2 bon ; moyenne 2,5
	partEntrainement = R.partEntrainement or 0.75, -- part du temps passée à s'entraîner, le reste à sauter
	dureeSaut = 15, -- s pour un saut : élan, vol, retour sur la place
	-- Matériel d'entraînement (note Entraînement) : 8 paliers, chacun double le gain ; prix provisoire
	-- (25 pièces, puis × 5 à chaque palier) en attendant le catalogue de T-203
	materiel = R.materiel or (function()
		local liste = {}
		for i = 1, 8 do
			table.insert(liste, { nom = "Materiel" .. i, multiplicateur = 2 ^ i, prix = math.floor(25 * 5 ^ (i - 1)) })
		end
		return liste
	end)(),
}

local monde = Mondes.get(H.monde)
if R.zones then -- essai d'autres paliers de zones
	monde = table.clone(monde)
	monde.zones = R.zones
end
local etat = {
	t = 0,
	puissance = 0,
	vitesse = 0,
	pieces = 0,
	record = 0,
	materiel = 0, -- palier acheté
	chaussures = false,
	jetpack = false,
	sauts = 0,
}
local serie, evenements = {}, {}

local function capacites(puissance, vitesse)
	return Stats.vitesseCourse(vitesse, H.monde), Stats.puissanceSaut(puissance, etat.chaussures, H.monde)
end

local function distance(puissance, vitesse)
	local vx, vy = capacites(puissance, vitesse)
	return Saut.portee({
		vitesse = vx,
		saut = vy,
		gravite = monde.gravite,
		appel = H.appel,
		jetpack = if etat.jetpack then Equipement.OBJETS.Jetpack else nil,
		studsParMetre = monde.studsParMetre,
	})
end

local function multiplicateurZone()
	local m = 1
	for _, z in monde.zones do
		if not z.passe and (z.recordRequis or 0) <= etat.record then
			m = math.max(m, z.multiplicateur)
		end
	end
	return m
end

local function noter(quoi)
	table.insert(evenements, { t = etat.t, quoi = quoi, record = etat.record })
end

-- Achat du meilleur objet abordable, un par un (chaussures, jetpack, puis le palier de matériel suivant)
local function acheter()
	local achete = true
	while achete do
		achete = false
		local choix = {}
		if not etat.chaussures then
			table.insert(choix, { prix = Equipement.OBJETS.Chaussures.prix, nom = "Chaussures" })
		end
		if not etat.jetpack then
			table.insert(choix, { prix = Equipement.OBJETS.Jetpack.prix, nom = "Jetpack" })
		end
		local suivant = H.materiel[etat.materiel + 1]
		if suivant then
			table.insert(choix, { prix = suivant.prix, nom = suivant.nom })
		end
		table.sort(choix, function(a, b)
			return a.prix < b.prix
		end)
		local c = choix[1]
		if c and c.prix <= etat.pieces then
			etat.pieces -= c.prix
			if c.nom == "Chaussures" then
				etat.chaussures = true
			elseif c.nom == "Jetpack" then
				etat.jetpack = true
			else
				etat.materiel += 1
			end
			noter("achat " .. c.nom .. " (" .. c.prix .. ")")
			achete = true
		end
	end
end

local zonePrecedente = 1
local prochainSaut = 0
local dt = Stats.ENTRAINEMENT_INTERVALLE
local cycle = H.dureeSaut / (1 - H.partEntrainement) -- un saut toutes les `cycle` secondes
while etat.t < H.duree do
	if etat.t >= prochainSaut then
		-- un saut
		local d = distance(etat.puissance, etat.vitesse)
		local gain = math.floor(d * monde.pieces * (1 + (if H.reception then Saut.RECEPTION_BONUS else 0)))
		etat.pieces += gain
		etat.sauts += 1
		if d > etat.record then
			etat.record = d
		end
		acheter()
		local z = multiplicateurZone()
		if z ~= zonePrecedente then
			noter("zone × " .. z)
			zonePrecedente = z
		end
		etat.t += H.dureeSaut
		prochainSaut = etat.t + cycle - H.dureeSaut
	else
		-- une minute d'entraînement au plus (jusqu'au prochain saut), dans la stat qui fait gagner le plus
		-- de distance, choisie au début de la minute
		local mat = H.materiel[etat.materiel]
		local g = Stats.ENTRAINEMENT_GAIN
			* multiplicateurZone()
			* (mat and mat.multiplicateur or 1)
			* H.rythme
			* Stats.bonusDebutant(etat.record)
		local battements = math.max(1, math.floor(math.min(60, prochainSaut - etat.t) / dt))
		local total = g * battements
		local dP = distance(etat.puissance + total, etat.vitesse)
		local dV = distance(etat.puissance, etat.vitesse + total)
		if dP >= dV then
			etat.puissance += total
		else
			etat.vitesse += total
		end
		etat.t += battements * dt
	end
	if #serie == 0 or etat.t - serie[#serie].t >= 30 then
		local vx, vy = capacites(etat.puissance, etat.vitesse)
		table.insert(serie, {
			t = math.floor(etat.t),
			record = math.floor(etat.record * 10) / 10,
			puissance = math.floor(etat.puissance),
			vitesse = math.floor(etat.vitesse),
			vx = math.floor(vx),
			vy = math.floor(vy),
			pieces = math.floor(etat.pieces),
			zone = multiplicateurZone(),
			materiel = etat.materiel,
		})
	end
end

-- Jalons de la note Boucles de gameplay : record visé → temps visé (min). Les 20 premières minutes vont vite
-- (bonus de débutant), la suite plus lentement (décision de Loucas, 2026-11-22).
local JALONS = R.jalons
	or {
		{ record = 10, minutes = 2 },
		{ record = 15, minutes = 4 },
		{ record = 25, minutes = 8 },
		{ record = 40, minutes = 13 },
		{ record = 60, minutes = 20 },
		{ record = 80, minutes = 45 },
		{ record = 150, minutes = 90 },
	}
local jalons = {}
for _, j in JALONS do
	local atteint
	for _, s in serie do
		if s.record >= j.record then
			atteint = s.t / 60
			break
		end
	end
	table.insert(jalons, { record = j.record, vise = j.minutes, obtenu = atteint and math.floor(atteint * 10) / 10 })
end

-- Intervalles entre achats (règle de confort : 5 min au plus pendant la première heure)
local precedent, pireAttente = 0, 0
for _, e in evenements do
	if e.quoi:sub(1, 5) == "achat" and e.t <= 3600 then
		pireAttente = math.max(pireAttente, e.t - precedent)
		precedent = e.t
	end
end

return HttpService:JSONEncode({
	hypotheses = {
		duree = H.duree,
		appel = H.appel,
		rythme = H.rythme,
		partEntrainement = H.partEntrainement,
		dureeSaut = H.dureeSaut,
		materiel = H.materiel,
		exposant = Stats.EXPOSANT,
		kVitesse = Stats.K_VITESSE,
		kSaut = Stats.K_SAUT,
	},
	jalons = jalons,
	pireAttenteAchat = pireAttente,
	evenements = evenements,
	serie = serie,
})
