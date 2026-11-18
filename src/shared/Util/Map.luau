-- Map : retrouve les objets de la map par leurs tags (voir la note Contrats), jamais par leur nom ou leur chemin.
-- Les positions sont relues à chaque appel : déplacer une piste ou une planche dans Studio suffit.
-- Côté joueur, le streaming peut décharger une Part lointaine : on garde alors la dernière valeur connue.
local CollectionService = game:GetService("CollectionService")

local Map = {}

local MONDE_PAR_DEFAUT = 1

local connu = {} -- [cle] = dernière valeur lue, pour quand la Part n'est pas chargée chez le joueur

-- Monde où se trouve le joueur (attribut « Monde » posé par le futur système de portails, 1 sinon)
function Map.mondeDe(player: Player?): number
	local m = player and player:GetAttribute("Monde")
	return if type(m) == "number" then m else MONDE_PAR_DEFAUT
end

-- Objets portant ce tag, dans le Workspace, et pour ce monde si l'attribut « Monde » est posé
function Map.tous(tag: string, monde: number?): { Instance }
	local liste = {}
	for _, objet in CollectionService:GetTagged(tag) do
		if objet:IsDescendantOf(workspace) then
			local m = objet:GetAttribute("Monde")
			if monde == nil or m == nil or m == monde then
				table.insert(liste, objet)
			end
		end
	end
	return liste
end

-- Premier objet portant ce tag pour ce monde (nil s'il n'existe pas ou n'est pas chargé)
function Map.premier(tag: string, monde: number?): Instance?
	return Map.tous(tag, monde)[1]
end

-- Appelle fn pour chaque objet portant ce tag, présent ou ajouté plus tard (Part chargée par le streaming, copie posée en jeu)
-- Un même objet n'est donné qu'une fois, même s'il sort du Workspace puis y revient.
function Map.surChaque(tag: string, fn: (Instance) -> ())
	local vus = setmetatable({}, { __mode = "k" })
	local function donner(objet: Instance)
		if objet:IsDescendantOf(workspace) and not vus[objet] then
			vus[objet] = true
			task.spawn(fn, objet)
		end
	end
	CollectionService:GetInstanceAddedSignal(tag):Connect(donner)
	for _, objet in CollectionService:GetTagged(tag) do
		donner(objet)
	end
end

local function memoriser(cle: string, valeur: any?): any?
	if valeur ~= nil then
		connu[cle] = valeur
	end
	return connu[cle]
end

-- X de la ligne d'appel : bord avant (côté sable) de la planche ; la distance se mesure à partir d'ici
function Map.ligneX(monde: number?): number?
	monde = monde or MONDE_PAR_DEFAUT
	local planche = Map.premier("PlancheAppel", monde) :: BasePart?
	return memoriser("ligne" .. monde, planche and planche.Position.X + planche.Size.X / 2)
end

-- X du début de la piste d'élan : au-delà, les bonus de vitesse et de saut s'appliquent
function Map.debutPisteX(monde: number?): number?
	monde = monde or MONDE_PAR_DEFAUT
	local piste = Map.premier("Piste", monde) :: BasePart?
	return memoriser("debut" .. monde, piste and piste.Position.X - piste.Size.X / 2)
end

-- Point de retour après un saut : près du début de la piste (avance négative = avant le début),
-- décalé sur le côté de « cote » studs au-delà du bord (0 = sur l'axe), au-dessus du sol de la piste
function Map.retourPiste(monde: number?, avance: number, cote: number, hauteur: number): Vector3?
	monde = monde or MONDE_PAR_DEFAUT
	local piste = Map.premier("Piste", monde) :: BasePart?
	if not piste then
		return connu["retour" .. monde]
	end
	local p = piste.Position
	local z = if cote > 0 then p.Z + piste.Size.Z / 2 + cote else p.Z
	local point = Vector3.new(p.X - piste.Size.X / 2 + avance, p.Y + piste.Size.Y / 2 + hauteur, z)
	return memoriser("retour" .. monde, point)
end

return Map
