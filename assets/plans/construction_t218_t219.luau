-- T-218 et T-219 : tableau des quêtes et cadeau de la place centrale. Prépare les modèles importés
-- (Workspace.place_tableau et Workspace.place_cadeau, importés par Fichier → Importer), les range dans
-- ReplicatedStorage.Assets.Decor, puis pose « TableauQuetes » (tag TableauQuetes) et « Cadeau » (tag Cadeau)
-- dans Workspace.Mondes.Monde1.Decor, aux points POSES, tournés vers CIBLE. Relançable, annulable par Ctrl+Z.
-- Blender (x, y, z) → Roblox (x, z, y) ; l'avant -Y de Blender est -Z dans Roblox.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local POSES = _G.POSES_T218 or {
	TableauQuetes = Vector3.new(-130, -0.2, -80), -- bord nord-ouest de la place, entre l'Élite Puissance et le magasin
	Cadeau = Vector3.new(-122, 0.05, 12), -- derrière le point d'apparition, entre les chemins du portail et des œufs
}
local CIBLE = _G.CIBLE_T218 or Vector3.new(-90, 0, 0) -- centre de la place

local COUL = {
	Blanc = Color3.fromHex("FFFFFF"),
	Bleu = Color3.fromHex("1E90FF"),
	Orange = Color3.fromHex("FF7A1A"),
	Or = Color3.fromHex("FFC83D"),
	Nuit = Color3.fromHex("16213E"),
	Violet = Color3.fromHex("9B5CFF"),
}

local function bloc(parent, nom, taille: Vector3, cf: CFrame, collision: boolean)
	local b = Instance.new("Part")
	b.Name = nom
	b.Size = taille
	b.CFrame = cf
	b.Anchored = true
	b.Transparency = 1
	b.CanTouch = false
	b.CanCollide = collision
	b.Parent = parent
	return b
end

-- Meshes renommés (« place_cadeau_Couvercle_Or » → « Couvercle_Or »), colorés, sans collision ; pivot au sol
local function preparer(nom: string)
	local decor = game.ReplicatedStorage.Assets.Decor
	local deja = decor:FindFirstChild(nom)
	if deja then
		return deja
	end
	local importe = workspace:FindFirstChild(nom)
	assert(importe, nom .. " : importer d'abord le .fbx dans le Workspace")
	for _, p in importe:GetDescendants() do
		if p:IsA("MeshPart") then
			p.Name = string.gsub(p.Name, "^" .. nom .. "_", "")
			local couleur = string.match(p.Name, "(%a+)$")
			p.Color = COUL[couleur] or p.Color
			p.Material = Enum.Material.SmoothPlastic
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
		end
	end
	local cf, taille = importe:GetBoundingBox()
	importe.WorldPivot = CFrame.new(importe.WorldPivot.X, cf.Y - taille.Y / 2, importe.WorldPivot.Z)
	importe:PivotTo(CFrame.new())
	if nom == "place_tableau" then
		for _, x in { -10, 10 } do
			bloc(importe, "Collision", Vector3.new(3, 15, 3), CFrame.new(x, 7.5, 0), true)
		end
		bloc(importe, "Collision", Vector3.new(18.6, 10.8, 0.9), CFrame.new(0, 8.6, 0.1), true)
		-- écran lu par le code : la SurfaceGui des quêtes se pose sur sa face avant (-Z)
		bloc(importe, "Ecran", Vector3.new(17.4, 9.6, 0.1), CFrame.new(0, 8.6, -0.6), false)
	else
		-- Socle : collision du piédestal, porte l'invite « Ouvrir » ; Collision : la boîte
		local socle = bloc(
			importe,
			"Socle",
			Vector3.new(1.2, 11, 11),
			CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90)),
			true
		)
		socle.Shape = Enum.PartType.Cylinder
		bloc(importe, "Collision", Vector3.new(7.6, 7.6, 7.6), CFrame.new(0, 1.2 + 3.8, 0), true)
	end
	importe.Parent = decor
	return importe
end

local rec = CHS:TryBeginRecording("T-218 T-219 tableau et cadeau")
local decor = workspace.Mondes.Monde1.Decor
local poses = {}
for nom, source in { TableauQuetes = "place_tableau", Cadeau = "place_cadeau" } do
	local modele = preparer(source)
	local ancien = decor:FindFirstChild(nom)
	if ancien then
		ancien:Destroy()
	end
	local m = modele:Clone()
	m.Name = nom
	CS:AddTag(m, nom)
	m.ModelStreamingMode = Enum.ModelStreamingMode.Atomic -- arrive en entier chez le joueur
	local pos = POSES[nom]
	m:PivotTo(CFrame.lookAt(pos, Vector3.new(CIBLE.X, pos.Y, CIBLE.Z)))
	m.Parent = decor
	table.insert(poses, m:GetFullName() .. " en " .. tostring(pos))
end
if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
return table.concat(poses, "\n")
