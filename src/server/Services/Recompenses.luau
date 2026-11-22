-- Récompenses (T-205) : quêtes du jour et de la semaine, défis de carrière, connexion, cadeaux de temps de jeu,
-- roue, coffre du groupe, codes et boosts. Chaque récompense se gagne et se réclame une seule fois : tout est
-- noté dans le profil (recompenses), sauf les cadeaux de temps de jeu, qui valent pour la session.
-- Les autres services appellent Recompenses.compter(player, compteur, n) quand le joueur saute, réussit un appel
-- parfait, traverse un anneau, gagne des stats, fait éclore un œuf, bat son record.
-- Le joueur agit par l'événement ActionRecompense ; son écran reçoit l'état par RecompensesEtat.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local RC = require(Config:WaitForChild("Recompenses"))
local PaliersConfig = require(Config:WaitForChild("Paliers"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))
local Donnees = require(script.Parent.Donnees)

local Recompenses = {}

-- Codes publiés avec les mises à jour (côté serveur seulement). À changer à chaque annonce.
local CODES = {
	LANCEMENT = { gemmes = 50 },
	SAUTDORE = { pieces = 1000, boost = { type = "Pieces", minutes = 15 } },
}

local debutSession = {} -- [player] = os.clock() à l'arrivée
local cadeauxPris = {} -- [player] = { [index] = true } pour la session
local aleatoire = Random.new()

local function notif(player: Player, message: string)
	Remotes.Notif:FireClient(player, message)
end

local function rec(player: Player)
	local d = Donnees.donnees(player)
	return d and d.recompenses
end

-- Texte court d'une récompense : « +200 pièces, +5 gemmes, Boost pièces × 2 (15 min) »
local function decrire(r): string
	local morceaux = {}
	if r.pieces then
		table.insert(morceaux, "+" .. Nombres.abreger(r.pieces) .. " pièces")
	end
	if r.gemmes then
		table.insert(morceaux, "+" .. Nombres.abreger(r.gemmes) .. " gemmes")
	end
	if r.boost then
		table.insert(morceaux, Textes["BOOST_NOM_" .. r.boost.type] .. " (" .. r.boost.minutes .. " min)")
	end
	return table.concat(morceaux, ", ")
end

-- Donne une récompense et prévient le joueur
local function donner(player: Player, r, titre: string)
	if r.pieces then
		player.leaderstats["Pièces"].Value += r.pieces
	end
	if r.gemmes then
		player:SetAttribute("Gemmes", (player:GetAttribute("Gemmes") or 0) + r.gemmes)
	end
	if r.boost then
		local b = rec(player).boosts
		b[r.boost.type] = (b[r.boost.type] or 0) + r.boost.minutes * 60
		player:SetAttribute("Boost" .. r.boost.type, b[r.boost.type])
	end
	notif(player, string.format(Textes.RECOMPENSE, titre, decrire(r)))
end

-- Quêtes du jour et de la semaine : nouvelles quand le jour ou la semaine change
local function majQuetes(player: Player)
	local r = rec(player)
	local jour, semaine = RC.jour(), RC.semaine()
	if r.jour.numero ~= jour then
		local joueur = {
			puissance = player:GetAttribute("Puissance") or 0,
			vitesse = player:GetAttribute("Vitesse") or 0,
			record = player:GetAttribute("Record") or 0,
		}
		local modeles = table.clone(RC.QUETES_JOUR)
		local quetes = {}
		for _ = 1, RC.QUETES_JOUR_NOMBRE do
			local m = table.remove(modeles, aleatoire:NextInteger(1, #modeles))
			table.insert(quetes, { modele = table.find(RC.QUETES_JOUR, m), cible = m.cible(joueur), progres = 0 })
		end
		r.jour = { numero = jour, quetes = quetes, coffre = false, remplacee = false }
	end
	if r.semaine.numero ~= semaine then
		local quetes = {}
		for i, m in RC.QUETES_SEMAINE do
			quetes[i] = { modele = i, cible = m.cible, progres = 0 }
		end
		r.semaine = { numero = semaine, quetes = quetes }
	end
end

-- État envoyé à l'écran du joueur
local function etat(player: Player)
	local r = rec(player)
	if not r then
		return nil
	end
	majQuetes(player)
	local record = player:GetAttribute("Record") or 0
	local jour = {}
	for i, q in r.jour.quetes do
		local m = RC.QUETES_JOUR[q.modele]
		jour[i] = {
			texte = string.format(m.texte, Nombres.abreger(q.cible)),
			progres = q.progres,
			cible = q.cible,
			reclamee = q.reclamee == true,
			recompense = decrire(RC.recompenseJour(record)),
		}
	end
	local semaine = {}
	for i, q in r.semaine.quetes do
		local m = RC.QUETES_SEMAINE[q.modele]
		semaine[i] = {
			texte = string.format(m.texte, Nombres.abreger(q.cible)),
			progres = q.progres,
			cible = q.cible,
			reclamee = q.reclamee == true,
			recompense = decrire(m.recompense),
		}
	end
	local defis = {}
	for _, d in RC.DEFIS do
		local total = r.compteurs[d.compteur] or 0
		for rang, palier in d.paliers do
			if not r.defis[d.compteur .. ":" .. palier] then
				table.insert(defis, {
					compteur = d.compteur,
					palier = palier,
					texte = string.format(d.texte, Nombres.abreger(palier)),
					progres = total,
					recompense = decrire({ gemmes = RC.GEMMES_DEFI[rang] }),
				})
				break
			end
		end
	end
	local session = os.clock() - (debutSession[player] or os.clock())
	local cadeaux = {}
	for i, c in RC.CADEAUX do
		cadeaux[i] = {
			minutes = c.minutes,
			reste = math.max(0, c.minutes * 60 - session),
			pris = (cadeauxPris[player] or {})[i] == true,
			recompense = decrire(c.recompense),
		}
	end
	local c = r.connexion
	return {
		quetesOuvertes = PaliersConfig.estOuvert(player, "Quetes"),
		jour = jour,
		coffre = r.jour.coffre,
		coffreRecompense = decrire(RC.coffreJour(record)),
		remplacee = r.jour.remplacee,
		semaine = semaine,
		defis = defis,
		connexion = {
			jour = c.serie,
			pris = c.reclameJour == RC.jour(),
			recompense = decrire(RC.CONNEXION[math.max(c.serie, 1)]),
		},
		cadeaux = cadeaux,
		roue = r.roueJour ~= RC.jour(),
		groupe = math.max(0, r.groupe + RC.COFFRE_GROUPE_DELAI - os.time()),
		boosts = table.clone(r.boosts),
	}
end

local function envoyer(player: Player)
	local e = etat(player)
	if e then
		Remotes.RecompensesEtat:FireClient(player, e)
	end
end

-- Compte une action du joueur (n fois) : quêtes du jour et de la semaine, défis. « Serie » garde le maximum.
function Recompenses.compter(player: Player, compteur: string, n: number?)
	local r = rec(player)
	if not r then
		return
	end
	n = n or 1
	majQuetes(player)
	if compteur == "Serie" then
		r.compteurs.Serie = math.max(r.compteurs.Serie or 0, n)
	else
		r.compteurs[compteur] = (r.compteurs[compteur] or 0) + n
		if PaliersConfig.estOuvert(player, "Quetes") then
			for _, q in r.jour.quetes do
				if RC.QUETES_JOUR[q.modele].compteur == compteur then
					q.progres = math.min(q.progres + n, q.cible)
				end
			end
			for _, q in r.semaine.quetes do
				if RC.QUETES_SEMAINE[q.modele].compteur == compteur then
					q.progres = math.min(q.progres + n, q.cible)
				end
			end
		end
	end
end

-- Actions du joueur -----------------------------------------------------------------------------------------
local ACTIONS = {}

function ACTIONS.Quete(player: Player, periode: unknown, index: unknown)
	local r = rec(player)
	local liste = if periode == "Semaine" then r.semaine.quetes else r.jour.quetes
	local q = type(index) == "number" and liste[index]
	if not q then
		return
	end
	if not PaliersConfig.estOuvert(player, "Quetes") then
		notif(player, string.format(Textes.QUETES_FERMEES, Nombres.distance(PaliersConfig.deblocage("Quetes").record)))
		return
	end
	if q.reclamee then
		return notif(player, Textes.RECOMPENSE_DEJA)
	end
	if q.progres < q.cible then
		return notif(player, Textes.RECOMPENSE_PAS_ENCORE)
	end
	q.reclamee = true
	if periode == "Semaine" then
		local m = RC.QUETES_SEMAINE[q.modele]
		donner(player, m.recompense, string.format(m.texte, Nombres.abreger(q.cible)))
	else
		local m = RC.QUETES_JOUR[q.modele]
		donner(
			player,
			RC.recompenseJour(player:GetAttribute("Record") or 0),
			string.format(m.texte, Nombres.abreger(q.cible))
		)
	end
end

-- Remplace une quête du jour pas encore finie, une fois par jour
function ACTIONS.Remplacer(player: Player, index: unknown)
	local r = rec(player)
	local q = type(index) == "number" and r.jour.quetes[index]
	if not q or r.jour.remplacee or q.reclamee then
		return
	end
	local pris = {}
	for _, autre in r.jour.quetes do
		pris[autre.modele] = true
	end
	local libres = {}
	for i in RC.QUETES_JOUR do
		if not pris[i] then
			table.insert(libres, i)
		end
	end
	if #libres == 0 then
		return
	end
	local m = libres[aleatoire:NextInteger(1, #libres)]
	local joueur = {
		puissance = player:GetAttribute("Puissance") or 0,
		vitesse = player:GetAttribute("Vitesse") or 0,
		record = player:GetAttribute("Record") or 0,
	}
	r.jour.quetes[index] = { modele = m, cible = RC.QUETES_JOUR[m].cible(joueur), progres = 0 }
	r.jour.remplacee = true
end

-- Coffre bonus : les trois quêtes du jour réclamées
function ACTIONS.Coffre(player: Player)
	local r = rec(player)
	if r.jour.coffre then
		return notif(player, Textes.RECOMPENSE_DEJA)
	end
	for _, q in r.jour.quetes do
		if not q.reclamee then
			return notif(player, Textes.RECOMPENSE_PAS_ENCORE)
		end
	end
	r.jour.coffre = true
	donner(player, RC.coffreJour(player:GetAttribute("Record") or 0), "Coffre du jour")
end

function ACTIONS.Defi(player: Player, compteur: unknown, palier: unknown)
	local r = rec(player)
	for _, d in RC.DEFIS do
		if d.compteur == compteur then
			local rang = table.find(d.paliers, palier)
			if not rang then
				return
			end
			local cle = d.compteur .. ":" .. palier
			if r.defis[cle] then
				return notif(player, Textes.RECOMPENSE_DEJA)
			end
			if (r.compteurs[d.compteur] or 0) < (palier :: number) then
				return notif(player, Textes.RECOMPENSE_PAS_ENCORE)
			end
			r.defis[cle] = true
			donner(player, { gemmes = RC.GEMMES_DEFI[rang] }, string.format(d.texte, Nombres.abreger(palier)))
			return
		end
	end
end

function ACTIONS.Connexion(player: Player)
	local c = rec(player).connexion
	if c.reclameJour == RC.jour() then
		return notif(player, Textes.RECOMPENSE_DEJA)
	end
	c.reclameJour = RC.jour()
	donner(player, RC.CONNEXION[c.serie], "Connexion, jour " .. c.serie)
end

function ACTIONS.Cadeau(player: Player, index: unknown)
	local c = type(index) == "number" and RC.CADEAUX[index]
	if not c then
		return
	end
	local pris = cadeauxPris[player]
	if pris[index] then
		return notif(player, Textes.RECOMPENSE_DEJA)
	end
	if os.clock() - debutSession[player] < c.minutes * 60 then
		return notif(player, Textes.RECOMPENSE_PAS_ENCORE)
	end
	pris[index] = true
	donner(player, c.recompense, "Cadeau des " .. c.minutes .. " minutes")
end

function ACTIONS.Roue(player: Player)
	local r = rec(player)
	if r.roueJour == RC.jour() then
		return notif(player, Textes.ROUE_DEJA)
	end
	r.roueJour = RC.jour()
	local total = 0
	for _, s in RC.ROUE do
		total += s.poids
	end
	local x = aleatoire:NextNumber() * total
	for i, s in RC.ROUE do
		x -= s.poids
		if x < 0 or i == #RC.ROUE then
			Remotes.ResultatRoue:FireClient(player, i, s.nom)
			donner(player, s.recompense, "Roue : " .. s.nom)
			return
		end
	end
end

function ACTIONS.Groupe(player: Player)
	local r = rec(player)
	local ok, membre = pcall(function()
		return player:IsInGroup(RC.GROUPE_ID)
	end)
	if not (ok and membre) then
		return notif(player, Textes.GROUPE_PAS_MEMBRE)
	end
	local reste = r.groupe + RC.COFFRE_GROUPE_DELAI - os.time()
	if reste > 0 then
		return notif(
			player,
			string.format(Textes.GROUPE_ATTENDRE, string.format("%d h %02d", reste // 3600, reste % 3600 // 60))
		)
	end
	r.groupe = os.time()
	donner(player, RC.COFFRE_GROUPE, "Coffre du groupe")
end

function ACTIONS.Code(player: Player, texte: unknown)
	if type(texte) ~= "string" or #texte > 40 then
		return
	end
	local code = string.upper((texte:gsub("%s", "")))
	local r = rec(player)
	local recompense = CODES[code]
	if not recompense then
		return notif(player, Textes.CODE_INCONNU)
	end
	if r.codes[code] then
		return notif(player, Textes.CODE_DEJA)
	end
	r.codes[code] = true
	donner(player, recompense, "Code " .. code)
end

-- Connexion : la série avance d'un jour, ou reprend au jour 1 après un jour manqué ; elle boucle sur 7 jours
local function majConnexion(player: Player)
	local c = rec(player).connexion
	local aujourdhui = RC.jour()
	if c.dernierJour == aujourdhui then
		return
	end
	c.serie = if c.dernierJour == aujourdhui - 1 then c.serie % #RC.CONNEXION + 1 else 1
	c.dernierJour = aujourdhui
end

-- Les boosts s'usent en temps de jeu : on retire les secondes écoulées une fois par seconde
local function userBoosts()
	for _, player in Players:GetPlayers() do
		local r = rec(player)
		if r then
			for type, reste in r.boosts do
				if reste > 0 then
					r.boosts[type] = math.max(0, reste - 1)
					player:SetAttribute("Boost" .. type, r.boosts[type])
				end
			end
		end
	end
end

function Recompenses.demarrer()
	Donnees.auChargement(function(player)
		debutSession[player] = os.clock()
		cadeauxPris[player] = {}
		majConnexion(player)
		majQuetes(player)
		for type, reste in rec(player).boosts do
			player:SetAttribute("Boost" .. type, reste)
		end
		envoyer(player)
	end)
	Remotes.ActionRecompense.OnServerEvent:Connect(function(player, action, a, b)
		local f = type(action) == "string" and ACTIONS[action]
		if f and rec(player) and debutSession[player] then
			majQuetes(player)
			f(player, a, b)
			envoyer(player)
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
		debutSession[player] = nil
		cadeauxPris[player] = nil
	end)
	task.spawn(function()
		local n = 0
		while true do
			task.wait(1)
			userBoosts()
			n += 1
			if n % 10 == 0 then
				for _, player in Players:GetPlayers() do
					envoyer(player) -- progression des quêtes et minuteries des cadeaux
				end
			end
		end
	end)
end

return Recompenses
