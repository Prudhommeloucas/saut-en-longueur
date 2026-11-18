-- Anneaux : chaque Part taguée « Anneau » dans le Workspace donne des pièces une fois par saut ;
-- une série d'anneaux dans le même saut donne un bonus. La poussée est donnée par le client (contrôleur Saut),
-- car c'est lui qui pilote son personnage ; le serveur ne compte que les pièces.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local SautConfig = require(Config:WaitForChild("Saut"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Donnees = require(script.Parent.Donnees)

local Anneaux = {}

local traverses = {} -- [player] = { [anneau] = true } pendant le saut en cours

-- Poussée totale des anneaux traversés pendant le saut en cours (pour la borne de plausibilité)
function Anneaux.pousseeDuSaut(player: Player): number
	local total = 0
	for anneau in traverses[player] or {} do
		total += anneau:GetAttribute("Poussee") or SautConfig.ANNEAU_POUSSEE
	end
	return total
end

-- À l'atterrissage : on repart à zéro pour le saut suivant
function Anneaux.finDuSaut(player: Player)
	traverses[player] = nil
end

local function surContact(anneau: BasePart, hit: BasePart)
	local char = hit:FindFirstAncestorOfClass("Model")
	local player = char and Players:GetPlayerFromCharacter(char)
	if not (player and Donnees.estCharge(player)) then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 or hum.FloorMaterial ~= Enum.Material.Air then
		return -- seulement en vol
	end
	local t = traverses[player]
	if not t then
		t = {}
		traverses[player] = t
	end
	if t[anneau] then
		return
	end
	t[anneau] = true
	local serie = 0
	for _ in t do
		serie += 1
	end

	local pieces = anneau:GetAttribute("Pieces") or SautConfig.ANNEAU_PIECES
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		ls["Pièces"].Value += pieces
		if serie == SautConfig.ANNEAUX_SERIE then
			ls["Pièces"].Value += SautConfig.ANNEAUX_BONUS_SERIE
			Remotes.Notif:FireClient(
				player,
				string.format(Textes.ANNEAU_SERIE, tostring(serie), tostring(SautConfig.ANNEAUX_BONUS_SERIE))
			)
		end
	end
	Remotes.AnneauTraverse:FireClient(player, pieces, serie)
end

local function brancher(anneau: Instance)
	if not (anneau:IsA("BasePart") and anneau:IsDescendantOf(workspace)) or anneau:GetAttribute("_Branche") then
		return
	end
	anneau:SetAttribute("_Branche", true)
	anneau.CanTouch = true
	anneau.Touched:Connect(function(hit)
		surContact(anneau, hit)
	end)
end

function Anneaux.demarrer()
	CollectionService:GetInstanceAddedSignal("Anneau"):Connect(brancher)
	for _, a in CollectionService:GetTagged("Anneau") do
		brancher(a)
	end
	Players.PlayerRemoving:Connect(function(player)
		traverses[player] = nil
	end)
end

return Anneaux
