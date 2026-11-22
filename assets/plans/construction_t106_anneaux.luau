-- T-106 : anneaux du monde 1 en blocs, au-dessus du bac (Workspace.Mondes.Monde1.Anneaux).
-- À lancer en mode Édition (MCP ou barre de commande). Ne fait rien si les anneaux existent déjà (Anneaux.Serie1).
-- Ctrl+Z annule tout.
--
-- Chaque anneau est un Model : une Part « Zone » invisible en disque (taguée Anneau, seule à toucher),
-- et un cercle de 16 segments en Neon, décoratif, sans collision ni contact.
-- Repère : X vers l'est (piste), planche à X = 120, 1 m = 4 studs, axe de la piste à Z = 0, sol à Y = 0.
-- Hauteurs = centre du personnage (HumanoidRootPart, 3 studs au-dessus des pieds) au passage.
local CHS = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")

local m = workspace.Mondes.Monde1
local racine = m:FindFirstChild("Anneaux")
if racine and racine:FindFirstChild("Serie1") then
	return "Les anneaux T-106 existent déjà : rien à faire."
end
local enregistrement = CHS:TryBeginRecording("T-106 anneaux en blocs")
if not racine then
	racine = Instance.new("Folder")
	racine.Name = "Anneaux"
	racine.Parent = m
end

local OR = Color3.fromHex("FFC83D")
local BLEU = Color3.fromHex("1E90FF")
local ORANGE = Color3.fromHex("FF7A1A")

-- Séries : la première est faite pour un joueur sans entraînement (saut Bon ou Parfait) ;
-- chaque anneau relance le joueur (+30 vers le haut, +15 vers l'avant) vers le suivant.
-- Les deux autres sont pour les joueurs entraînés, plus loin et plus haut : provisoires, à recaler
-- quand T-201 aura fixé la courbe des stats (un joueur fort frôle aussi l'anneau 1 et part très haut).
local SERIES = {
	{
		nom = "Serie1",
		couleur = OR,
		rayon = 6,
		anneaux = {
			-- Mesuré dans la copie : appel Parfait ou Bon → les 3 anneaux, 10 à 11 m, +50 pièces environ ;
			-- appel loin de la planche → 1 anneau, moins de 3 m. La poussée vers l'avant est annulée par le
			-- Humanoid (vitesse ramenée à WalkSpeed), d'où des anneaux serrés.
			{ x = 128, y = 17 }, -- 2 m
			{ x = 143, y = 15 }, -- 5,75 m
			{ x = 150, y = 15 }, -- 7,5 m
		},
	},
	{
		nom = "Serie2",
		couleur = BLEU,
		rayon = 6,
		anneaux = {
			-- Recalée dans la place partagée sur un joueur entraîné (WalkSpeed 69, JumpPower 151) : il frôle
			-- l'anneau or 1, culmine à 108 studs vers X 191 et redescend vite ; chaque anneau le relance
			-- vers 57 studs. Mesuré : 4 anneaux, 57,9 m au lieu de 35,7 m, +102 pièces.
			{ x = 245, y = 52 }, -- 31 m
			{ x = 268, y = 50 }, -- 37 m
			{ x = 291, y = 50 }, -- 43 m
		},
	},
	{
		nom = "Serie3",
		couleur = ORANGE,
		rayon = 7,
		anneaux = {
			{ x = 380, y = 34 }, -- 65 m
			{ x = 410, y = 36 }, -- 72,5 m
			{ x = 442, y = 30 }, -- 80,5 m
		},
	},
}

local SEGMENTS = 16
local EPAISSEUR = 1.2

local function anneau(parent, nom, x, y, rayon, couleur)
	local modele = Instance.new("Model")
	modele.Name = nom

	-- Disque de contact : un cylindre a son axe sur X, il fait donc face à la piste sans rotation
	local zone = Instance.new("Part")
	zone.Name = "Zone"
	zone.Shape = Enum.PartType.Cylinder
	zone.Size = Vector3.new(2, rayon * 2, rayon * 2)
	zone.CFrame = CFrame.new(x, y, 0)
	zone.Anchored = true
	zone.CanCollide = false
	zone.CanQuery = false
	zone.CanTouch = true
	zone.Transparency = 1
	zone.Parent = modele
	CollectionService:AddTag(zone, "Anneau")

	local corde = 2 * math.pi * rayon / SEGMENTS * 1.08
	for i = 0, SEGMENTS - 1 do
		local a = i / SEGMENTS * 2 * math.pi
		local s = Instance.new("Part")
		s.Name = "Segment"
		s.Size = Vector3.new(EPAISSEUR, EPAISSEUR, corde)
		s.CFrame = CFrame.new(x, y, 0) * CFrame.Angles(a, 0, 0) * CFrame.new(0, rayon, 0)
		s.Anchored = true
		s.CanCollide = false
		s.CanQuery = false
		s.CanTouch = false
		s.CastShadow = false
		s.Material = Enum.Material.Neon
		s.Color = couleur
		s.Parent = modele
	end
	modele.PrimaryPart = zone
	modele.Parent = parent
end

local total = 0
for _, serie in SERIES do
	local d = Instance.new("Folder")
	d.Name = serie.nom
	for i, a in serie.anneaux do
		anneau(d, string.format("Anneau%d", i), a.x, a.y, serie.rayon, serie.couleur)
		total += 1
	end
	d.Parent = racine
end

if enregistrement then
	CHS:FinishRecording(enregistrement, Enum.FinishRecordingOperation.Commit)
end
return string.format("%d anneaux posés en 3 séries dans Monde1.Anneaux", total)
