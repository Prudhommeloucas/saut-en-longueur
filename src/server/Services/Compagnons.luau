-- Compagnons : inventaire, équipe, bonus, expérience et niveaux.
-- Les compagnons équipés sont annoncés à tous par l'attribut « Equipe » du joueur (« espece:version,… ») ;
-- chaque client les affiche et les fait suivre (contrôleur Compagnons).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"):WaitForChild("Compagnons"))
local OeufsConfig = require(Shared.Config:WaitForChild("Oeufs"))
local Textes = require(Shared.Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Donnees = require(script.Parent.Donnees)
local Index = require(script.Parent.Index)

local Compagnons = {}

local DELAI_DEMANDES = 0.2 -- secondes minimum entre deux demandes d'un même joueur
local derniereDemande = {} -- [player] = os.clock()

local function trop(player: Player): boolean
	local maintenant = os.clock()
	if maintenant - (derniereDemande[player] or 0) < DELAI_DEMANDES then
		return true
	end
	derniereDemande[player] = maintenant
	return false
end

local function etat(player: Player)
	local d = Donnees.donnees(player)
	return d and d.compagnons
end

-- Envoie l'inventaire au joueur et annonce son équipe à tous
local function publier(player: Player)
	local c = etat(player)
	if not c then
		return
	end
	local morceaux = {}
	for _, uid in c.equipes do
		local comp = c.liste[uid]
		if comp then
			table.insert(morceaux, comp.espece .. ":" .. comp.version)
		end
	end
	player:SetAttribute("Equipe", table.concat(morceaux, ","))
	Remotes.CompagnonsEtat:FireClient(player, {
		liste = c.liste,
		equipes = c.equipes,
		emplacements = Config.EMPLACEMENTS,
		inventaireMax = Config.INVENTAIRE_MAX,
	})
end

local function nombre(c): number
	local n = 0
	for _ in c.liste do
		n += 1
	end
	return n
end

-- Ajoute un compagnon ; renvoie son uid, ou nil si l'inventaire est plein ou l'espèce inconnue
function Compagnons.ajouter(player: Player, espece: string, version: string?): string?
	local c = etat(player)
	if not (c and Config.ESPECES[espece]) or nombre(c) >= Config.INVENTAIRE_MAX then
		return nil
	end
	local uid = tostring(c.prochainId)
	c.prochainId += 1
	c.liste[uid] = { espece = espece, version = version or "Normal", niveau = 1, xp = 0 }
	publier(player)
	return uid
end

-- Retire un compagnon de l'inventaire (et de l'équipe)
function Compagnons.retirer(player: Player, uid: string, sansPublier: boolean?)
	local c = etat(player)
	if not (c and c.liste[uid]) then
		return
	end
	c.liste[uid] = nil
	local i = table.find(c.equipes, uid)
	if i then
		table.remove(c.equipes, i)
	end
	if not sansPublier then
		publier(player)
	end
end

function Compagnons.publier(player: Player)
	publier(player)
end

function Compagnons.inventairePlein(player: Player): boolean
	local c = etat(player)
	return c == nil or nombre(c) >= Config.INVENTAIRE_MAX
end

function Compagnons.equiper(player: Player, uid: string, equipe: boolean): boolean
	local c = etat(player)
	if not (c and c.liste[uid]) then
		return false
	end
	local i = table.find(c.equipes, uid)
	if equipe and not i then
		if #c.equipes >= Config.EMPLACEMENTS then
			return false
		end
		table.insert(c.equipes, uid)
	elseif not equipe and i then
		table.remove(c.equipes, i)
	end
	publier(player)
	return true
end

-- Force d'un compagnon pour le classement « meilleurs » : son bonus ramené à l'échelle des Coachs
local function force(comp): number
	local e = Config.ESPECES[comp.espece]
	if not e then
		return 0
	end
	return (Config.BONUS.Coach[e.rarete] or 0)
		* (Config.VERSIONS[comp.version] or 1)
		* (1 + Config.BONUS_PAR_NIVEAU * (comp.niveau - 1))
end

function Compagnons.equiperMeilleurs(player: Player)
	local c = etat(player)
	if not c then
		return
	end
	local uids = {}
	for uid in c.liste do
		table.insert(uids, uid)
	end
	table.sort(uids, function(a, b)
		return force(c.liste[a]) > force(c.liste[b])
	end)
	table.clear(c.equipes)
	for i = 1, math.min(#uids, Config.EMPLACEMENTS) do
		table.insert(c.equipes, uids[i])
	end
	publier(player)
end

-- 1 + somme des bonus des compagnons équipés qui ont ce rôle (Coach, Tresorier, PorteBonheur)
function Compagnons.multiplicateur(player: Player, role: string): number
	local c = etat(player)
	local m = 1
	if c then
		for _, uid in c.equipes do
			local comp = c.liste[uid]
			local e = comp and Config.ESPECES[comp.espece]
			if e and e.role == role then
				m += Config.bonus(comp.espece, comp.version, comp.niveau)
			end
		end
	end
	return m
end

-- Expérience donnée aux compagnons équipés à chaque saut
function Compagnons.gagnerExperience(player: Player)
	local c = etat(player)
	if not c then
		return
	end
	local monte = false
	for _, uid in c.equipes do
		local comp = c.liste[uid]
		if comp and comp.niveau < Config.NIVEAU_MAX then
			comp.xp += Config.XP_PAR_SAUT
			while comp.niveau < Config.NIVEAU_MAX and comp.xp >= Config.xpPourNiveauSuivant(comp.niveau) do
				comp.xp -= Config.xpPourNiveauSuivant(comp.niveau)
				comp.niveau += 1
				monte = true
			end
		end
	end
	if monte then
		publier(player)
	end
end

-- Fusionne FUSION_NOMBRE compagnons identiques (espèce et version) en un seul de la version suivante.
-- Garde le plus haut niveau des trois ; si l'un d'eux était équipé, le nouveau prend sa place.
function Compagnons.fusionner(player: Player, espece: string, version: string): string?
	local c = etat(player)
	local rang = table.find(Config.ORDRE_VERSIONS, version)
	local suivante = rang and Config.ORDRE_VERSIONS[rang + 1]
	if not (c and suivante and Config.ESPECES[espece]) then
		return nil
	end
	local candidats = {}
	for uid, comp in c.liste do
		if comp.espece == espece and comp.version == version then
			table.insert(candidats, uid)
		end
	end
	if #candidats < OeufsConfig.FUSION_NOMBRE then
		Remotes.Notif:FireClient(player, string.format(Textes.FUSION_MANQUE, tostring(OeufsConfig.FUSION_NOMBRE)))
		return nil
	end
	-- Prend d'abord ceux qui ne sont pas équipés, puis les plus hauts niveaux
	table.sort(candidats, function(a, b)
		local ea, eb = table.find(c.equipes, a) ~= nil, table.find(c.equipes, b) ~= nil
		if ea ~= eb then
			return not ea
		end
		return c.liste[a].niveau > c.liste[b].niveau
	end)
	local niveau = 1
	local placeEquipe = nil
	for i = 1, OeufsConfig.FUSION_NOMBRE do
		local uid = candidats[i]
		niveau = math.max(niveau, c.liste[uid].niveau)
		placeEquipe = placeEquipe or table.find(c.equipes, uid)
		Compagnons.retirer(player, uid, true)
	end
	local nouveau = tostring(c.prochainId)
	c.prochainId += 1
	c.liste[nouveau] = { espece = espece, version = suivante, niveau = niveau, xp = 0 }
	if placeEquipe then
		table.insert(c.equipes, math.min(placeEquipe, #c.equipes + 1), nouveau)
	end
	Index.enregistrer(player, espece, suivante)
	publier(player)
	Remotes.Notif:FireClient(player, string.format(Textes.FUSION_FAITE, Config.ESPECES[espece].nom, suivante))
	return nouveau
end

function Compagnons.demarrer()
	Remotes.Fusionner.OnServerEvent:Connect(function(player, espece, version)
		if type(espece) ~= "string" or type(version) ~= "string" or trop(player) then
			return
		end
		Compagnons.fusionner(player, espece, version)
	end)

	Donnees.auChargement(function(player)
		local c = etat(player)
		if not c then
			return
		end
		-- Nettoie une équipe qui pointerait vers un compagnon disparu
		for i = #c.equipes, 1, -1 do
			if not c.liste[c.equipes[i]] then
				table.remove(c.equipes, i)
			end
		end
		publier(player)
	end)

	Remotes.EquiperCompagnon.OnServerEvent:Connect(function(player, uid, equipe)
		if type(uid) ~= "string" or type(equipe) ~= "boolean" or trop(player) then
			return
		end
		Compagnons.equiper(player, uid, equipe)
	end)

	Remotes.EquiperMeilleurs.OnServerEvent:Connect(function(player)
		if trop(player) then
			return
		end
		Compagnons.equiperMeilleurs(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		derniereDemande[player] = nil
	end)
end

return Compagnons
