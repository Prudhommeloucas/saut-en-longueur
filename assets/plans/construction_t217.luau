-- T-217 : magasin de la place centrale. Prépare le modèle importé (Workspace.place_magasin, sinon le paquet
-- 73209698561012 du compte de Loucas), le range dans ReplicatedStorage.Assets.Decor, puis pose une copie
-- « Magasin » taguée dans Workspace.Mondes.Monde1.Boutique, au point POSE, ouverte vers CIBLE.
-- Relançable : l'ancien magasin posé est remplacé. Annulable par Ctrl+Z.
-- Dans la place partagée (2026-11-23) : le Model du compte de Loucas ne se charge pas (place du groupe), le FBX a été
-- réimporté sous OGC Studio (Model 77419986787196). Les quatre stands ont ensuite été posés devant le magasin, à 26 studs
-- de son pivot vers l'avant et à x = -27, -13, 13, 27 (repère du magasin), et un arbre de ArbresPlace reculé.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local POSE = _G.MAGASIN_POSE or Vector3.new(-162.6, -0.2, -42.2) -- au sol, au nord-ouest, à 84 studs du centre
local CIBLE = _G.MAGASIN_CIBLE or Vector3.new(-90, 0, 0) -- centre de la place

local COUL = {
	Blanc = Color3.fromHex("FFFFFF"),
	Bleu = Color3.fromHex("1E90FF"),
	Orange = Color3.fromHex("FF7A1A"),
	Or = Color3.fromHex("FFC83D"),
	Nuit = Color3.fromHex("16213E"),
	Gris = Color3.fromHex("5B6577"),
}

local rec = CHS:TryBeginRecording("T-217 magasin")
local decor = game.ReplicatedStorage.Assets.Decor
local modele = decor:FindFirstChild("place_magasin")
if not modele then
	local importe = workspace:FindFirstChild("place_magasin")
	if not importe then
		importe = game:GetService("InsertService"):LoadAsset(73209698561012):GetChildren()[1]
	end
	-- 1. Préparer : meshes nommés par couleur, lisses, ancrés, sans contact (les blocs invisibles portent les collisions)
	for _, p in importe:GetDescendants() do
		if p:IsA("MeshPart") then
			local couleur = string.match(p.Name, "_(%a+)$")
			p.Name = couleur
			p.Color = COUL[couleur] or p.Color
			p.Material = Enum.Material.SmoothPlastic
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.CastShadow = true
		end
	end
	-- pivot au sol, au centre (l'origine du .blend) ; avant vers -Z
	local cf, taille = importe:GetBoundingBox()
	local sol = Vector3.new(importe.WorldPivot.X, cf.Y - taille.Y / 2, importe.WorldPivot.Z)
	importe.WorldPivot = CFrame.new(sol)
	importe:PivotTo(CFrame.new(0, 0, 0))
	-- 2. Collisions : Parts invisibles « Collision » (socle, murs, toit) et « Comptoir », qui porte aussi l'invite de la boutique
	local function bloc(nom, taille: Vector3, pos: Vector3)
		local b = Instance.new("Part")
		b.Name = nom
		b.Size = taille
		b.CFrame = CFrame.new(pos)
		b.Anchored = true
		b.Transparency = 1
		b.CanTouch = false
		b.Parent = importe
		return b
	end
	-- Blender (x, y, z) → Roblox (x, z, y) ; l'avant -Y de Blender est -Z dans Roblox
	bloc("Collision", Vector3.new(34, 1.2, 20), Vector3.new(0, 0.6, 0))
	bloc("Collision", Vector3.new(32, 13, 1.5), Vector3.new(0, 7.7, 8.25))
	bloc("Collision", Vector3.new(1.5, 13, 18), Vector3.new(-15.25, 7.7, 0))
	bloc("Collision", Vector3.new(1.5, 13, 18), Vector3.new(15.25, 7.7, 0))
	bloc("Collision", Vector3.new(35, 1.6, 21), Vector3.new(0, 15, 0))
	bloc("Comptoir", Vector3.new(25, 4.6, 3.6), Vector3.new(0, 3.5, -5.5))
	importe.Name = "place_magasin"
	importe.Parent = decor
	modele = importe
end

-- 3. Poser le magasin, tourné vers la place
local boutique = workspace.Mondes.Monde1:FindFirstChild("Boutique")
local ancien = boutique:FindFirstChild("Magasin")
if ancien then
	ancien:Destroy()
end
local m = modele:Clone()
m.Name = "Magasin"
CS:AddTag(m, "Magasin")
local vers = Vector3.new(CIBLE.X, POSE.Y, CIBLE.Z)
-- l'avant du modèle est -Z : CFrame.lookAt oriente -Z vers la cible
m:PivotTo(CFrame.lookAt(POSE, vers))
m.Parent = boutique
if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
return m:GetFullName() .. " en " .. tostring(POSE)
