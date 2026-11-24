-- Effets visuels rangés dans ReplicatedStorage.Assets.Effets (construits dans Studio, T-111, voir [[Contrats]]).
-- ParticleEmitter:Emit ne se voit que là où il est appelé : sur le serveur, Effets.jouer envoie l'événement
-- « Effet » à tous les joueurs, dont le contrôleur Effets joue les particules chez lui (Effets.jouerIci).
-- Le serveur garde un support invisible au même endroit, pour y accrocher les sons (entendus de tous).
-- Un effet manquant ne bloque rien : le support existe quand même, sans particules.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local Shared = script.Parent.Parent
local Config = require(Shared:WaitForChild("Config"):WaitForChild("Effets"))

local Effets = {}

local function modele(nom: string): Instance?
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local dossier = assets and assets:FindFirstChild("Effets")
	return dossier and dossier:FindFirstChild(nom)
end

local function support(nom: string, position: Vector3): BasePart
	local s = Instance.new("Part")
	s.Name = "Effet" .. nom
	s.Anchored = true
	s.CanCollide = false
	s.CanTouch = false
	s.CanQuery = false
	s.Transparency = 1
	s.Size = Vector3.one
	s.CFrame = CFrame.new(position)
	s.Parent = workspace
	Debris:AddItem(s, Config.DUREE)
	return s
end

-- Côté joueur : joue l'effet « nom » (une Attachment d'Assets.Effets) à cette position ; chaque ParticleEmitter
-- émet son attribut Emission × echelle.
function Effets.jouerIci(nom: string, position: Vector3, echelle: number?): BasePart
	local s = support(nom, position)
	local m = modele(nom)
	if not (m and m:IsA("Attachment")) then
		return s
	end
	local a = m:Clone()
	a.Parent = s
	for _, d in a:GetDescendants() do
		local n = d:GetAttribute("Emission")
		if d:IsA("ParticleEmitter") and type(n) == "number" then
			d:Emit(math.max(1, math.round(n * (echelle or 1))))
		end
	end
	return s
end

-- Côté serveur : fait jouer l'effet chez tous les joueurs ; renvoie un support invisible au même endroit
-- (retiré après Config.DUREE secondes) où accrocher les sons
function Effets.jouer(nom: string, position: Vector3, echelle: number?): BasePart
	if RunService:IsServer() then
		local Remotes = require(Shared:WaitForChild("Remotes"))
		Remotes.Effet:FireAllClients(nom, position, echelle)
		return support(nom, position)
	end
	return Effets.jouerIci(nom, position, echelle)
end

-- Attache l'effet continu « nom » (Attachment d'Assets.Effets) à une pièce ; le détruire pour l'arrêter.
-- Les émetteurs allumés (Rate) se voient chez tous les joueurs.
function Effets.attacher(nom: string, piece: BasePart): Attachment?
	local m = modele(nom)
	if not (m and m:IsA("Attachment")) then
		return nil
	end
	local a = m:Clone()
	a.Name = nom
	a.Parent = piece
	return a
end

-- Traînée « nom » (Trail d'Assets.Effets) tendue entre deux attaches de la pièce, écartées de `hauteur`
-- studs à la verticale. Les attaches s'appellent « nom .. 'Haut' » et « nom .. 'Bas' ».
function Effets.trainee(nom: string, piece: BasePart, hauteur: number, parent: Instance): Trail?
	local m = modele(nom)
	if not (m and m:IsA("Trail")) then
		return nil
	end
	for _, ancien in { piece:FindFirstChild(nom .. "Haut"), piece:FindFirstChild(nom .. "Bas") } do
		ancien:Destroy()
	end
	local a0 = Instance.new("Attachment")
	a0.Name = nom .. "Haut"
	a0.Position = Vector3.new(0, hauteur / 2, 0)
	a0.Parent = piece
	local a1 = Instance.new("Attachment")
	a1.Name = nom .. "Bas"
	a1.Position = Vector3.new(0, -hauteur / 2, 0)
	a1.Parent = piece
	local t = m:Clone()
	t.Name = nom
	t.Enabled = false
	t.Attachment0 = a0
	t.Attachment1 = a1
	t.Parent = parent
	return t
end

return Effets
