-- Index : album des espèces trouvées, par version. Une page (toutes les espèces d'un œuf dans une version)
-- complète donne des gemmes et un bonus permanent de chance aux œufs.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local OeufsConfig = require(Config:WaitForChild("Oeufs"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Donnees = require(script.Parent.Donnees)

local Index = {}

local function publier(player: Player)
	local d = Donnees.donnees(player)
	if d then
		Remotes.IndexEtat:FireClient(player, d.index)
	end
end

-- Vérifie les pages complétées par cette espèce dans cette version, et les récompense
local function verifierPages(player: Player, d, espece: string, version: string)
	for oeufId, oeuf in OeufsConfig.LISTE do
		local cle = oeufId .. ":" .. version
		local concerne = false
		local complete = true
		for _, c in oeuf.contenu do
			if c.espece == espece then
				concerne = true
			end
			local t = d.index.trouves[c.espece]
			if not (t and t[version]) then
				complete = false
			end
		end
		if concerne and complete and not d.index.pages[cle] then
			local recompense = OeufsConfig.RECOMPENSES_PAGE[version]
			d.index.pages[cle] = true
			if recompense then
				player:SetAttribute("Gemmes", (player:GetAttribute("Gemmes") or 0) + recompense.gemmes)
				d.index.chance += recompense.chance
				Remotes.Notif:FireClient(player, string.format(Textes.PAGE_COMPLETE, tostring(recompense.gemmes)))
			end
		end
	end
end

-- Note une espèce trouvée dans une version ; renvoie vrai si c'est la première fois
function Index.enregistrer(player: Player, espece: string, version: string): boolean
	local d = Donnees.donnees(player)
	if not d then
		return false
	end
	local t = d.index.trouves[espece]
	if not t then
		t = {}
		d.index.trouves[espece] = t
	end
	if t[version] then
		return false
	end
	t[version] = true
	verifierPages(player, d, espece, version)
	publier(player)
	return true
end

-- Bonus de chance aux œufs du joueur (0 si non chargé)
function Index.chance(player: Player): number
	local d = Donnees.donnees(player)
	return d and d.index.chance or 0
end

function Index.demarrer()
	Donnees.auChargement(publier)
end

return Index
