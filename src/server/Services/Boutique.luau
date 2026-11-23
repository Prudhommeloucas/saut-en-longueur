-- Boutique (T-203) : achat, amélioration et port des objets du catalogue (Config/Equipement), et matériel
-- d'entraînement (T-202). Le profil garde equipement.possede ([id] = niveau) et equipement.porte ([famille] = id) ;
-- les attributs « <Famille> » et « <Famille>Niveau » du joueur en sont la copie, lue par le reste du jeu.
-- Stands tagués « Stand » :
--   - Objet = « Materiel » : vend le palier de matériel suivant ;
--   - Famille = Chaussures, Propulseur ou Tenue : invite « Acheter » (E) pour l'objet suivant de la famille dans le
--     monde du joueur, et invite « Améliorer » (R) pour l'objet porté de cette famille (créées si absentes).
-- L'écran de boutique (T-209) passera par les événements AcheterObjet, AmeliorerObjet et PorterObjet.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local Equipement = require(Config:WaitForChild("Equipement"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Map = require(Shared:WaitForChild("Util"):WaitForChild("Map"))
local Nombres = require(Shared:WaitForChild("Util"):WaitForChild("Nombres"))
local Donnees = require(script.Parent.Donnees)
local Personnage = require(script.Parent.Personnage)
local PaliersConfig = require(Config:WaitForChild("Paliers"))

local Boutique = {}

local function notif(player: Player, message: string)
	Remotes.Notif:FireClient(player, message)
end

-- Recopie le profil dans les attributs, met à jour l'apparence et prévient l'écran du joueur
local function appliquer(player: Player)
	local data = Donnees.donnees(player)
	if not data then
		return
	end
	local eq = data.equipement
	for _, famille in Equipement.FAMILLES do
		local id = eq.porte[famille]
		local niveau = id and eq.possede[id]
		player:SetAttribute(famille, if niveau then id else nil)
		player:SetAttribute(famille .. "Niveau", niveau)
	end
	Personnage.equiperVisuels(player)
	Remotes.EquipementEtat:FireClient(player, { possede = eq.possede, porte = eq.porte })
end

local function payer(player: Player, prix: number, nom: string): boolean
	if not PaliersConfig.estOuvert(player, "Boutique") then
		notif(player, Textes.FERME_BOUTIQUE)
		return false
	end
	local pieces = player.leaderstats["Pièces"]
	if pieces.Value < prix then
		notif(player, string.format(Textes.OBJET_MANQUE, Nombres.abreger(prix - pieces.Value), nom))
		return false
	end
	pieces.Value -= prix
	return true
end

-- Achète un objet du catalogue ; il est porté s'il est meilleur (plus cher) que celui de sa famille
function Boutique.acheter(player: Player, id: unknown)
	local data = Donnees.donnees(player)
	local o = type(id) == "string" and Equipement.CATALOGUE[id]
	if not (data and o) then
		return
	end
	local eq = data.equipement
	if eq.possede[id] then
		notif(player, string.format(Textes.BOUTIQUE_DEJA, o.nom))
		return
	end
	if not payer(player, o.prix, o.nom) then
		return
	end
	eq.possede[id] = 1
	local actuel = eq.porte[o.famille]
	local infoActuel = actuel and Equipement.CATALOGUE[actuel]
	if not infoActuel or o.prix > infoActuel.prix then
		eq.porte[o.famille] = id
		notif(player, string.format(Textes.OBJET_ACHETE, o.nom))
	else
		notif(player, string.format(Textes.OBJET_ACHETE_GARDE, o.nom, infoActuel.nom))
	end
	appliquer(player)
end

-- Monte un objet possédé d'un niveau
function Boutique.ameliorer(player: Player, id: unknown)
	local data = Donnees.donnees(player)
	local o = type(id) == "string" and Equipement.CATALOGUE[id]
	if not (data and o) then
		return
	end
	local niveau = data.equipement.possede[id]
	if not niveau then
		return
	end
	local prix = Equipement.prixNiveau(id :: string, niveau + 1)
	if not prix then
		notif(player, string.format(Textes.OBJET_NIVEAU_MAX, o.nom))
		return
	end
	if not payer(player, prix, o.nom .. " niveau " .. (niveau + 1)) then
		return
	end
	data.equipement.possede[id] = niveau + 1
	notif(player, string.format(Textes.OBJET_NIVEAU, o.nom, tostring(niveau + 1)))
	appliquer(player)
end

-- Porte un objet possédé
function Boutique.porter(player: Player, id: unknown)
	local data = Donnees.donnees(player)
	local o = type(id) == "string" and Equipement.CATALOGUE[id]
	if not (data and o and data.equipement.possede[id]) then
		return
	end
	data.equipement.porte[o.famille] = id
	notif(player, string.format(Textes.OBJET_PORTE, o.nom))
	appliquer(player)
end

-- Stand d'une famille : l'objet suivant (le moins cher pas encore possédé) dans le monde du joueur
local function acheterSuivant(player: Player, famille: string)
	local data = Donnees.donnees(player)
	if not data then
		return
	end
	for _, id in Equipement.objetsDe(famille, Map.mondeDe(player)) do
		if not data.equipement.possede[id] then
			Boutique.acheter(player, id)
			return
		end
	end
	notif(player, Textes.OBJET_DEJA_TOUT)
end

local function ameliorerPorte(player: Player, famille: string)
	local data = Donnees.donnees(player)
	local id = data and data.equipement.porte[famille]
	if not id then
		notif(player, Textes.OBJET_RIEN_A_AMELIORER)
		return
	end
	Boutique.ameliorer(player, id)
end

-- Matériel d'entraînement (T-202) : le stand vend le palier suivant celui du joueur (attribut Materiel)
local function acheterMateriel(player: Player)
	if not Donnees.estCharge(player) then
		return
	end
	local palier = player:GetAttribute("Materiel") or 0
	local suivant = Equipement.MATERIEL[palier + 1]
	if not suivant then
		notif(player, Textes.MATERIEL_MAX)
		return
	end
	if not payer(player, suivant.prix, suivant.nom) then
		return
	end
	player:SetAttribute("Materiel", palier + 1)
	notif(player, string.format(Textes.MATERIEL_ACHETE, suivant.nom, Nombres.abreger(suivant.multiplicateur)))
end

-- Invite d'un stand : celle qui existe (la première), ou une nouvelle posée sur le stand
local function invite(stand: Instance, nom: string, modele: ProximityPrompt?): ProximityPrompt?
	local existante = stand:FindFirstChild(nom, true)
	if existante and existante:IsA("ProximityPrompt") then
		return existante
	end
	local hote = if stand:IsA("BasePart") then stand else stand:FindFirstChildWhichIsA("BasePart", true)
	if not hote then
		return nil
	end
	local p = if modele then modele:Clone() else Instance.new("ProximityPrompt")
	p.Name = nom
	p.HoldDuration = 0.3
	p.MaxActivationDistance = 12
	p.RequiresLineOfSight = false
	p.Parent = hote
	return p
end

local function brancherStand(stand: Instance)
	local objet = stand:GetAttribute("Objet")
	local famille = stand:GetAttribute("Famille")
	if objet == "Materiel" then
		local prompt = stand:FindFirstChildWhichIsA("ProximityPrompt", true)
		if prompt then
			prompt.ObjectText = Textes.STAND_MATERIEL
			prompt.Triggered:Connect(acheterMateriel)
		end
		return
	end
	if not table.find(Equipement.FAMILLES, famille) then
		return -- stand d'une famille pas encore en jeu (Ailes)
	end
	local acheterP = stand:FindFirstChildWhichIsA("ProximityPrompt", true) or invite(stand, "Prompt", nil)
	if not acheterP then
		warn("Stand sans pièce pour poser une invite :", stand:GetFullName())
		return
	end
	acheterP.ActionText = Textes.BOUTIQUE_ACHETER
	acheterP.ObjectText = string.format(Textes.STAND_FAMILLE, famille)
	acheterP.KeyboardKeyCode = Enum.KeyCode.E
	acheterP.Triggered:Connect(function(player)
		acheterSuivant(player, famille)
	end)
	local ameliorerP = invite(stand, "PromptAmeliorer", acheterP)
	if ameliorerP then
		ameliorerP.ActionText = Textes.STAND_AMELIORER
		ameliorerP.ObjectText = famille
		ameliorerP.KeyboardKeyCode = Enum.KeyCode.R
		ameliorerP.GamepadKeyCode = Enum.KeyCode.ButtonY
		ameliorerP.UIOffset = Vector2.new(0, 70)
		ameliorerP.Triggered:Connect(function(player)
			ameliorerPorte(player, famille)
		end)
	end
end

-- Magasin de la place centrale (T-217) : l'invite du comptoir ouvre la boutique du joueur
local function brancherMagasin(magasin: Instance)
	-- L'invite se pose sur la pièce « Comptoir » du magasin s'il en a une
	local prompt = invite(magasin:FindFirstChild("Comptoir", true) or magasin, "PromptBoutique", nil)
	if not prompt then
		warn("Magasin sans pièce pour poser une invite :", magasin:GetFullName())
		return
	end
	prompt.ActionText = Textes.MAGASIN_OUVRIR
	prompt.ObjectText = Textes.MAGASIN_NOM
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 14
	prompt.Triggered:Connect(function(player)
		if not PaliersConfig.estOuvert(player, "Boutique") then
			notif(player, Textes.FERME_BOUTIQUE)
			return
		end
		Remotes.OuvrirBoutique:FireClient(player)
	end)
end

function Boutique.demarrer()
	Map.surChaque("Stand", brancherStand)
	Map.surChaque("Magasin", brancherMagasin)
	Remotes.AcheterObjet.OnServerEvent:Connect(function(player, id)
		if id == "Materiel" then
			acheterMateriel(player)
		else
			Boutique.acheter(player, id)
		end
	end)
	Remotes.AmeliorerObjet.OnServerEvent:Connect(Boutique.ameliorer)
	Remotes.PorterObjet.OnServerEvent:Connect(Boutique.porter)
	Donnees.auChargement(function(player)
		local data = Donnees.donnees(player)
		if data then
			Remotes.EquipementEtat:FireClient(
				player,
				{ possede = data.equipement.possede, porte = data.equipement.porte }
			)
		end
	end)
end

return Boutique
