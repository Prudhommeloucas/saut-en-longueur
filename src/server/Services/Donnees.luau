-- Données des joueurs : profil ProfileStore (verrou de session, sauvegarde automatique), leaderstats, attributs.
-- Les autres services lisent et modifient les leaderstats et les attributs ; ce service les recopie dans le profil.
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ProfileStore = require(ServerStorage:WaitForChild("ServerPackages"):WaitForChild("ProfileStore"))
local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local DonneesConfig = require(Config:WaitForChild("Donnees"))
local Equipement = require(Config:WaitForChild("Equipement"))
local Textes = require(Config:WaitForChild("Textes"))

local Donnees = {}

local magasin = ProfileStore.New(DonneesConfig.MAGASIN, DonneesConfig.MODELE)
local profils = {} -- [player] = profil actif

-- Migrations numérotées : MIGRATIONS[n] fait passer les données de la version n à n + 1.
local MIGRATIONS: { [number]: (data: any) -> () } = {
	-- 1 → 2 (T-203) : « Chaussures » et « Jetpack » deviennent les premiers objets du catalogue, portés
	[1] = function(data)
		local eq = data.equipement
		eq.porte = eq.porte or {}
		for ancien, nouveau in Equipement.ANCIENS do
			if eq.possede[ancien] then
				eq.possede[nouveau] = math.max(eq.possede[nouveau] or 1, 1)
				eq.possede[ancien] = nil
				local famille = Equipement.CATALOGUE[nouveau].famille
				eq.porte[famille] = eq.porte[famille] or nouveau
			end
		end
	end,
}

local auChargement = {} -- fonctions appelées quand un joueur est chargé

function Donnees.estCharge(player: Player): boolean
	return profils[player] ~= nil
end

-- Données sauvegardées du joueur (à modifier directement), ou nil s'il n'est pas chargé.
-- Pour ce qui a un attribut ou une leaderstat (pièces, stats…), passer par l'attribut : il est recopié ici.
function Donnees.donnees(player: Player)
	local profil = profils[player]
	return profil and profil.Data
end

-- Appelle fn(player) pour chaque joueur chargé, déjà présent ou à venir
function Donnees.auChargement(fn: (Player) -> ())
	table.insert(auChargement, fn)
	for player in profils do
		task.spawn(fn, player)
	end
end

local function migrer(data)
	while data.version < DonneesConfig.VERSION do
		MIGRATIONS[data.version](data)
		data.version += 1
	end
end

-- Reprend une seule fois les données de l'ancien magasin (avant T-006), sans les effacer.
local function reprendreV1(player: Player, data)
	if data.repriseV1 then
		return true
	end
	local ok, ancien = pcall(function()
		return DataStoreService:GetDataStore(DonneesConfig.MAGASIN_V1):GetAsync("joueur_" .. player.UserId)
	end)
	if not ok then
		return false -- ancien magasin injoignable : on réessaiera à la prochaine session
	end
	if type(ancien) == "table" then
		data.pieces = math.max(data.pieces, tonumber(ancien.Pieces) or 0)
		data.record = math.max(data.record, tonumber(ancien.Record) or 0)
		data.stats.Puissance = math.max(data.stats.Puissance, tonumber(ancien.Puissance) or 0)
		data.stats.Vitesse = math.max(data.stats.Vitesse, tonumber(ancien.Vitesse) or 0)
		for id, nouveau in Equipement.ANCIENS do
			if ancien[id] == true then
				data.equipement.possede[nouveau] = data.equipement.possede[nouveau] or 1
				local famille = Equipement.CATALOGUE[nouveau].famille
				data.equipement.porte[famille] = data.equipement.porte[famille] or nouveau
			end
		end
	end
	data.repriseV1 = true
	return true
end

-- Recopie l'état visible du joueur (leaderstats, attributs) dans son profil
local function ecrire(player: Player)
	local profil = profils[player]
	local ls = player:FindFirstChild("leaderstats")
	if not (profil and ls) then
		return
	end
	local data = profil.Data
	data.pieces = ls["Pièces"].Value
	data.record = player:GetAttribute("Record") or data.record
	data.stats.Puissance = player:GetAttribute("Puissance") or data.stats.Puissance
	data.stats.Vitesse = player:GetAttribute("Vitesse") or data.stats.Vitesse
	data.gemmes = player:GetAttribute("Gemmes") or data.gemmes
	data.equipement.materiel = player:GetAttribute("Materiel") or data.equipement.materiel
	-- Les objets possédés et leurs niveaux sont écrits directement dans le profil par la boutique
end

local function afficher(player: Player, data)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local pieces = Instance.new("IntValue")
	pieces.Name = "Pièces"
	pieces.Value = data.pieces
	pieces.Parent = ls
	local record = Instance.new("IntValue")
	record.Name = "Record (m)"
	record.Value = math.floor(data.record)
	record.Parent = ls
	ls.Parent = player

	player:SetAttribute("Record", data.record)
	player:SetAttribute("Puissance", data.stats.Puissance)
	player:SetAttribute("Vitesse", data.stats.Vitesse)
	player:SetAttribute("Gemmes", data.gemmes)
	player:SetAttribute("Materiel", data.equipement.materiel or 0)
	for _, famille in Equipement.FAMILLES do
		local id = data.equipement.porte[famille]
		local niveau = id and data.equipement.possede[id]
		player:SetAttribute(famille, if niveau then id else nil)
		player:SetAttribute(famille .. "Niveau", niveau)
	end

	pieces.Changed:Connect(function()
		ecrire(player)
	end)
	player.AttributeChanged:Connect(function()
		ecrire(player)
	end)
end

local function chargerDonnees(player: Player)
	local profil = magasin:StartSessionAsync("joueur_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	if not profil then
		-- Un autre serveur tient encore la session, ou Roblox ne répond pas : on ne joue pas sans données.
		if player.Parent == Players then
			player:Kick(Textes.DONNEES_INDISPONIBLES)
		end
		return
	end

	profil:AddUserId(player.UserId) -- RGPD : permet d'effacer les données à la demande de Roblox
	profil:Reconcile()
	migrer(profil.Data)
	reprendreV1(player, profil.Data)

	profil.OnSessionEnd:Connect(function()
		profils[player] = nil
		if player.Parent == Players then
			player:Kick(Textes.DONNEES_AILLEURS)
		end
	end)

	if player.Parent ~= Players then
		profil:EndSession()
		return
	end
	afficher(player, profil.Data)
	profils[player] = profil
	for _, fn in auChargement do
		task.spawn(fn, player)
	end
end

function Donnees.demarrer()
	Players.PlayerAdded:Connect(chargerDonnees)
	for _, p in Players:GetPlayers() do
		task.spawn(chargerDonnees, p)
	end

	Players.PlayerRemoving:Connect(function(player)
		local profil = profils[player]
		if profil then
			ecrire(player)
			profils[player] = nil
			profil:EndSession() -- sauvegarde finale et libération du verrou
		end
	end)
end

return Donnees
