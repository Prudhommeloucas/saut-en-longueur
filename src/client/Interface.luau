-- Interface : outils communs aux écrans construits dans StarterGui (HUD.md).
-- Un seul écran de menu ouvert à la fois ; mise à l'échelle selon la taille de l'écran ; manette.
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CompagnonsConfig =
	require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Compagnons"))

local player = Players.LocalPlayer

local Interface = {}

local menus = {} -- ScreenGui de menu ouverts par Interface.ouvrir
local echelles = {} -- UIScale à tenir à jour

-- Taille de conception des écrans : téléphone en paysage
local LARGEUR, HAUTEUR = 844, 390
local ECHELLE_MAX = 1.5

function Interface.ecran(nom: string): ScreenGui
	return player:WaitForChild("PlayerGui"):WaitForChild(nom) :: ScreenGui
end

local function majEchelles()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end
	local taille = camera.ViewportSize
	local s = math.clamp(math.min(taille.X / LARGEUR, taille.Y / HAUTEUR), 0.5, ECHELLE_MAX)
	for _, e in echelles do
		e.Scale = s
	end
end

-- Inscrit un UIScale (« Echelle ») pour qu'il suive la taille de l'écran
function Interface.suivreEchelle(echelle: UIScale)
	table.insert(echelles, echelle)
	majEchelles()
end

-- Ouvre un écran de menu et ferme les autres ; cible : élément sélectionné à la manette
function Interface.ouvrir(ecran: ScreenGui, cible: GuiObject?)
	for _, autre in menus do
		if autre ~= ecran then
			autre.Enabled = false
		end
	end
	if not table.find(menus, ecran) then
		table.insert(menus, ecran)
	end
	ecran.Enabled = true
	if cible and UserInputService.GamepadEnabled then
		GuiService.SelectedObject = cible
	end
end

function Interface.fermer(ecran: ScreenGui)
	ecran.Enabled = false
	if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ecran) then
		GuiService.SelectedObject = nil
	end
end

function Interface.couleurRarete(rarete: string): Color3
	return Color3.fromHex(CompagnonsConfig.COULEURS_RARETE[rarete] or "9AA4B2")
end

-- Remplit une pastille (Frame ronde avec un TextLabel « Lettre ») pour une espèce, ou en « inconnu »
function Interface.pastille(pastille: Frame, espece: string?)
	local e = espece and CompagnonsConfig.ESPECES[espece]
	pastille.BackgroundColor3 = if e then Color3.fromHex(e.couleur) else Color3.fromHex("2A3A66")
	local lettre = pastille:FindFirstChild("Lettre") :: TextLabel?
	if lettre then
		lettre.Text = if e then string.sub(e.nom, 1, utf8.offset(e.nom, 2) - 1) else "?"
	end
end

-- Nombre avec une virgule et au plus deux décimales (21,15)
function Interface.nombre(x: number): string
	local t = string.format("%.2f", x):gsub("%.?0+$", "")
	return (t:gsub("%.", ","))
end

-- Place un modèle au centre d'un ViewportFrame, vu de trois quarts face
function Interface.vue(vue: ViewportFrame, modele: Model, recul: number?)
	for _, enfant in vue:GetChildren() do
		if enfant:IsA("Model") or enfant:IsA("Camera") or enfant:IsA("WorldModel") then
			enfant:Destroy()
		end
	end
	modele:PivotTo(CFrame.new())
	modele.Parent = vue
	local cf, taille = modele:GetBoundingBox()
	local camera = Instance.new("Camera")
	local d = taille.Magnitude * (recul or 1.1)
	local centre = cf.Position
	camera.CFrame = CFrame.lookAt(centre + Vector3.new(d * 0.35, d * 0.25, -d), centre)
	camera.FieldOfView = 40
	camera.Parent = vue
	vue.CurrentCamera = camera
	return camera
end

function Interface.demarrer()
	local camera = workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(majEchelles)
	end
end

return Interface
