-- T-115 : assemble la mascotte Bondo en personnage R15 animable, à partir du modèle importé
-- (Workspace.mascotte_bondo, Fichier → Importer). Articulations : assets/modeles/source/mascotte_bondo_articulations.json
-- (repère de Studio, origine au sol sous la mascotte, X inversé par l'import).
-- Résultat : ReplicatedStorage.Assets.Decor.mascotte_bondo (rig à l'échelle 1, pour générer les animations) et
-- Workspace.Mondes.Monde1.Decor.Mascotte (×10, ≈ 65 studs, tag Mascotte), tournée vers la place.
-- Chaque membre R15 est la MeshPart principale renommée (Head, UpperTorso…) ; les autres meshes du membre
-- y sont soudés. HumanoidRootPart ancrée, Motor6D nommés comme sur un R15, Humanoid + Animator.
-- Le premier import (fait avec le côté gauche en -X dans Blender) arrive avec Left et Right inversés : le script
-- échange alors les noms (ECHANGER_COTES). Relançable sur un nouvel import, annulable par Ctrl+Z.
local CHS = game:GetService("ChangeHistoryService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")

local ECHANGER_COTES = true -- false pour un .fbx exporté par la version actuelle de t115_mascotte.py
local POSE = CFrame.lookAt(Vector3.new(-15, -0.2, -62), Vector3.new(-60, -0.2, 0)) -- à côté de l'arche, face à la place
local ECHELLE = 10

local COUL = {
	Fourrure = "E08A3C",
	Creme = "FFE7C2",
	Rose = "FFB3A7",
	Noir = "1F2229",
	Bouche = "8A2232",
	Blanc = "FFFFFF",
	Bleu = "1E90FF",
	Orange = "FF7A1A",
	Or = "FFC83D",
}
local PRINCIPALES = {
	Head = "Fourrure",
	UpperTorso = "Bleu",
	LowerTorso = "Fourrure",
	LeftUpperArm = "Fourrure",
	LeftLowerArm = "Fourrure",
	LeftHand = "Fourrure",
	RightUpperArm = "Fourrure",
	RightLowerArm = "Fourrure",
	RightHand = "Fourrure",
	LeftUpperLeg = "Fourrure",
	LeftLowerLeg = "Fourrure",
	LeftFoot = "Blanc",
	RightUpperLeg = "Fourrure",
	RightLowerLeg = "Fourrure",
	RightFoot = "Blanc",
}
-- position des articulations, comptée depuis l'origine au sol : Head_Fourrure y est centrée en CENTRE_TETE
-- (Head = (0, 5.23, 0) dans le fichier) ; valeurs du fichier JSON
local CENTRE_TETE = Vector3.new(0, 5.23, 0)
local J = {
	Root = Vector3.new(0, 2.55, 0),
	Waist = Vector3.new(0, 2.85, 0),
	Neck = Vector3.new(0, 4.0, 0),
	LeftShoulder = Vector3.new(-0.95, 3.75, 0),
	RightShoulder = Vector3.new(0.95, 3.75, 0),
	LeftElbow = Vector3.new(-1.3, 3.1438, 0),
	RightElbow = Vector3.new(1.3, 3.1438, 0),
	LeftWrist = Vector3.new(-1.61, 2.6069, 0),
	RightWrist = Vector3.new(1.61, 2.6069, 0),
	LeftHip = Vector3.new(-0.42, 2.3, 0),
	RightHip = Vector3.new(0.42, 2.3, 0),
	LeftKnee = Vector3.new(-0.45, 1.35, 0.05),
	RightKnee = Vector3.new(0.45, 1.35, 0.05),
	LeftAnkle = Vector3.new(-0.45, 0.45, 0),
	RightAnkle = Vector3.new(0.45, 0.45, 0),
}
-- articulation, pièce 0, pièce 1
local MOTEURS = {
	{ "Root", "HumanoidRootPart", "LowerTorso" },
	{ "Waist", "LowerTorso", "UpperTorso" },
	{ "Neck", "UpperTorso", "Head" },
	{ "LeftShoulder", "UpperTorso", "LeftUpperArm" },
	{ "LeftElbow", "LeftUpperArm", "LeftLowerArm" },
	{ "LeftWrist", "LeftLowerArm", "LeftHand" },
	{ "RightShoulder", "UpperTorso", "RightUpperArm" },
	{ "RightElbow", "RightUpperArm", "RightLowerArm" },
	{ "RightWrist", "RightLowerArm", "RightHand" },
	{ "LeftHip", "LowerTorso", "LeftUpperLeg" },
	{ "LeftKnee", "LeftUpperLeg", "LeftLowerLeg" },
	{ "LeftAnkle", "LeftLowerLeg", "LeftFoot" },
	{ "RightHip", "LowerTorso", "RightUpperLeg" },
	{ "RightKnee", "RightUpperLeg", "RightLowerLeg" },
	{ "RightAnkle", "RightLowerLeg", "RightFoot" },
}

local function assembler(importe: Model): Model
	local rig = Instance.new("Model")
	rig.Name = "mascotte_bondo"
	local meshes = {}
	for _, p in importe:GetDescendants() do
		if p:IsA("MeshPart") then
			table.insert(meshes, p)
		end
	end
	local origine
	for _, p in meshes do
		p.Name = string.gsub(p.Name, "^mascotte_bondo_", "")
		if ECHANGER_COTES then
			if string.sub(p.Name, 1, 4) == "Left" then
				p.Name = "Right" .. string.sub(p.Name, 5)
			elseif string.sub(p.Name, 1, 5) == "Right" then
				p.Name = "Left" .. string.sub(p.Name, 6)
			end
		end
		local couleur = string.match(p.Name, "_(%a+)$")
		p.Color = Color3.fromHex(COUL[couleur] or "FFFFFF")
		p.Material = Enum.Material.SmoothPlastic
		p.Anchored = false
		p.CanCollide = false
		p.CanTouch = false
		p.CanQuery = false
		p.Massless = true
		p.Parent = rig
		if p.Name == "Head_Fourrure" then
			origine = p.Position - CENTRE_TETE
		end
	end
	assert(origine, "Head_Fourrure introuvable")
	importe:Destroy()
	-- membres R15 : une petite Part invisible (l'« os ») porte le nom du membre et les articulations ; tous les
	-- meshes du membre y sont soudés. Une MeshPart visible nommée UpperTorso, Head… serait recolorée en gris
	-- par l'Humanoid (constaté le 2026-11-24).
	for membre, couleur in PRINCIPALES do
		local principale = rig:FindFirstChild(membre .. "_" .. couleur)
		assert(principale, membre .. " : pièce principale introuvable")
		local os_ = Instance.new("Part")
		os_.Name = membre
		os_.Size = Vector3.one * 0.2
		os_.CFrame = principale.CFrame
		os_.Transparency = 1
		os_.CanCollide = false
		os_.CanTouch = false
		os_.CanQuery = false
		os_.Parent = rig
		for _, p in rig:GetChildren() do
			if p:IsA("MeshPart") and string.sub(p.Name, 1, #membre + 1) == membre .. "_" then
				local w = Instance.new("WeldConstraint")
				w.Part0 = os_
				w.Part1 = p
				w.Parent = p
			end
		end
	end
	local hrp = Instance.new("Part")
	hrp.Name = "HumanoidRootPart"
	hrp.Size = Vector3.new(2, 2, 1)
	hrp.CFrame = CFrame.new(origine + J.Root)
	hrp.Transparency = 1
	hrp.CanCollide = false
	hrp.CanTouch = false
	hrp.CanQuery = false
	hrp.Anchored = true
	hrp.Parent = rig
	rig.PrimaryPart = hrp
	-- le pivot d'un Model à PrimaryPart est celui de la PrimaryPart : on le descend au sol
	hrp.PivotOffset = CFrame.new(0, -J.Root.Y, 0)
	for _, m in MOTEURS do
		local p0, p1 = rig[m[2]], rig[m[3]]
		local pos = origine + J[m[1]]
		local a0 = Instance.new("Attachment")
		a0.Name = m[1] .. "RigAttachment"
		a0.WorldCFrame = CFrame.new(pos)
		a0.Parent = p0
		local a1 = a0:Clone()
		a1.Parent = p1
		a1.WorldCFrame = CFrame.new(pos)
		local mo = Instance.new("Motor6D")
		mo.Name = m[1]
		mo.Part0 = p0
		mo.Part1 = p1
		mo.C0 = p0.CFrame:Inverse() * CFrame.new(pos)
		mo.C1 = p1.CFrame:Inverse() * CFrame.new(pos)
		mo.Parent = p1
	end
	local hum = Instance.new("Humanoid")
	hum.RigType = Enum.HumanoidRigType.R15
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	hum.Parent = rig
	Instance.new("Animator").Parent = hum
	rig:PivotTo(CFrame.new())
	return rig
end

local rec = CHS:TryBeginRecording("T-115 mascotte R15")
local decor = RS.Assets.Decor
local source = decor:FindFirstChild("mascotte_bondo")
if not source then
	local importe = workspace:FindFirstChild("mascotte_bondo")
	assert(importe, "importer d'abord mascotte_bondo.fbx")
	source = assembler(importe)
	source.Parent = decor
end
local dossier = workspace.Mondes.Monde1.Decor
local ancienne = dossier:FindFirstChild("Mascotte")
if ancienne then
	ancienne:Destroy()
end
local mascotte = source:Clone()
mascotte.Name = "Mascotte"
mascotte:ScaleTo(ECHELLE)
mascotte:PivotTo(POSE)
CS:AddTag(mascotte, "Mascotte")
mascotte.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
-- collision : une colonne invisible autour du corps
local col = Instance.new("Part")
col.Name = "Collision"
col.Size = Vector3.new(26, 60, 20)
col.CFrame = POSE * CFrame.new(0, 30, 3)
col.Anchored = true
col.Transparency = 1
col.CanTouch = false
col.CanQuery = false
col.Parent = mascotte
mascotte.Parent = dossier
if rec then
	CHS:FinishRecording(rec, Enum.FinishRecordingOperation.Commit)
end
local _, t = mascotte:GetBoundingBox()
return "Mascotte posée, taille " .. tostring(t)
