-- Œufs : achat, tirage, éclosion. Ouverture par l'événement OuvrirOeuf (écran T-305)
-- ou par le ProximityPrompt créé sur chaque incubateur tagué « Incubateur » posé dans le Workspace.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local PolicyService = game:GetService("PolicyService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local OeufsConfig = require(Config:WaitForChild("Oeufs"))
local CompagnonsConfig = require(Config:WaitForChild("Compagnons"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Donnees = require(script.Parent.Donnees)
local Compagnons = require(script.Parent.Compagnons)
local Index = require(script.Parent.Index)

local Oeufs = {}

local DELAI_DEMANDES = 0.5
local derniereDemande = {} -- [player] = os.clock()
local tiragesInterdits = {} -- [player] = true si les tirages payants sont interdits dans son pays
local aleatoire = Random.new()

-- Tire une espèce dans un œuf. chance : bonus de l'index (multiplie les poids des raretés chanceuses).
function Oeufs.tirer(oeufId: string, chance: number?, rng: Random?): string?
	local oeuf = OeufsConfig.LISTE[oeufId]
	if not oeuf then
		return nil
	end
	local poids = {}
	local total = 0
	for i, c in oeuf.contenu do
		local e = CompagnonsConfig.ESPECES[c.espece]
		local p = c.poids
		if chance and e and OeufsConfig.RARETES_CHANCEUSES[e.rarete] then
			p *= 1 + chance
		end
		poids[i] = p
		total += p
	end
	local x = (rng or aleatoire):NextNumber() * total
	for i, c in oeuf.contenu do
		x -= poids[i]
		if x < 0 then
			return c.espece
		end
	end
	return oeuf.contenu[#oeuf.contenu].espece
end

-- Simule n tirages et renvoie { [espece] = nombre } (contrôle des chances)
function Oeufs.simuler(oeufId: string, n: number, chance: number?): { [string]: number }
	local rng = Random.new()
	local compte = {}
	for _ = 1, n do
		local e = Oeufs.tirer(oeufId, chance, rng) :: string
		compte[e] = (compte[e] or 0) + 1
	end
	return compte
end

local function notifier(player: Player, message: string)
	Remotes.Notif:FireClient(player, message)
end

local function nomMonnaie(monnaie: string): string
	return if monnaie == "gemmes" then Textes.MONNAIE_GEMMES else Textes.MONNAIE_PIECES
end

-- Ouvre un œuf pour le joueur ; renvoie l'uid du compagnon obtenu, ou nil (avec un message au joueur)
function Oeufs.ouvrir(player: Player, oeufId: string): string?
	local d = Donnees.donnees(player)
	local oeuf = OeufsConfig.LISTE[oeufId]
	if not (d and oeuf) then
		return nil
	end
	if oeuf.payant and tiragesInterdits[player] ~= false then
		notifier(player, Textes.OEUF_INTERDIT) -- interdit, ou pas encore vérifié
		return nil
	end
	if Compagnons.inventairePlein(player) then
		notifier(player, Textes.INVENTAIRE_PLEIN)
		return nil
	end

	-- Paiement
	if oeuf.monnaie == "gemmes" then
		local gemmes = player:GetAttribute("Gemmes") or 0
		if gemmes < oeuf.prix then
			notifier(player, string.format(Textes.OEUF_MANQUE, tostring(oeuf.prix - gemmes), Textes.MONNAIE_GEMMES))
			return nil
		end
		player:SetAttribute("Gemmes", gemmes - oeuf.prix)
	else
		local pieces = player.leaderstats["Pièces"]
		if pieces.Value < oeuf.prix then
			notifier(
				player,
				string.format(Textes.OEUF_MANQUE, tostring(oeuf.prix - pieces.Value), Textes.MONNAIE_PIECES)
			)
			return nil
		end
		pieces.Value -= oeuf.prix
	end

	-- Éclosion
	local espece = Oeufs.tirer(oeufId, Index.chance(player)) :: string
	local uid = Compagnons.ajouter(player, espece, "Normal")
	local nouveau = Index.enregistrer(player, espece, "Normal")
	d.oeufsOuverts += 1
	Remotes.ResultatOeuf:FireClient(player, {
		oeuf = oeufId,
		espece = espece,
		version = "Normal",
		uid = uid,
		nouveau = nouveau,
	})
	return uid
end

local function trop(player: Player): boolean
	local maintenant = os.clock()
	if maintenant - (derniereDemande[player] or 0) < DELAI_DEMANDES then
		return true
	end
	derniereDemande[player] = maintenant
	return false
end

-- Lit dans PolicyService si les tirages payants sont interdits pour ce joueur (interdits en cas d'erreur)
local function verifierPolitique(player: Player)
	local ok, info = pcall(function()
		return PolicyService:GetPolicyInfoForPlayerAsync(player)
	end)
	local interdit = not ok or info.ArePaidRandomItemsRestricted == true
	tiragesInterdits[player] = interdit
	player:SetAttribute("TiragesPayantsInterdits", interdit) -- pour que les écrans masquent ces œufs
end

-- Prompt « Ouvrir » sur un incubateur posé dans la map
local function brancherIncubateur(incubateur: Instance)
	if not incubateur:IsDescendantOf(workspace) or not incubateur:IsA("Model") then
		return
	end
	local oeufId = incubateur:GetAttribute("Oeuf")
	local oeuf = OeufsConfig.LISTE[oeufId]
	local support = incubateur.PrimaryPart
	if not (oeuf and support) or support:FindFirstChild("PromptOeuf") then
		return
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "PromptOeuf"
	prompt.ActionText = Textes.OEUF_ACTION
	prompt.ObjectText = string.format(Textes.OEUF_PRIX, oeuf.nom, tostring(oeuf.prix), nomMonnaie(oeuf.monnaie))
	prompt.HoldDuration = 0.3
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	-- Le prompt ouvre EcranOeuf côté joueur (chances affichées avant l'achat) ; l'achat passe par OuvrirOeuf
	prompt.Parent = support
end

function Oeufs.demarrer()
	Players.PlayerAdded:Connect(verifierPolitique)
	for _, p in Players:GetPlayers() do
		task.spawn(verifierPolitique, p)
	end
	Players.PlayerRemoving:Connect(function(player)
		tiragesInterdits[player] = nil
		derniereDemande[player] = nil
	end)

	Remotes.OuvrirOeuf.OnServerEvent:Connect(function(player, oeufId)
		if type(oeufId) ~= "string" or trop(player) then
			return
		end
		Oeufs.ouvrir(player, oeufId)
	end)

	-- Un incubateur peut être cloné dans la map, ou déplacé depuis Assets : on réessaie à chaque déplacement
	local function surveiller(inc: Instance)
		brancherIncubateur(inc)
		inc.AncestryChanged:Connect(function()
			brancherIncubateur(inc)
		end)
	end
	CollectionService:GetInstanceAddedSignal("Incubateur"):Connect(surveiller)
	for _, inc in CollectionService:GetTagged("Incubateur") do
		surveiller(inc)
	end
end

return Oeufs
