-- EcranEclosion : l'œuf tremble, sa moitié Haut s'envole avec ses décors, le compagnon apparaît.
-- Déclenché par l'événement ResultatOeuf ; BoutonContinuer revient à l'écran de l'œuf.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local CompagnonsConfig = require(Config:WaitForChild("Compagnons"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Apparence = require(Shared:WaitForChild("Util"):WaitForChild("Apparence"))
local Interface = require(script.Parent.Parent:WaitForChild("Interface"))
local EcranOeuf = require(script.Parent.EcranOeuf)

local EcranEclosion = {}

local ecran: ScreenGui
local contenu: Frame
local animation: RBXScriptConnection? = nil
local oeufARouvrir: string? = nil

local DUREE_TREMBLE = 1.2
local DUREE_ENVOL = 0.6

-- Parties qui partent avec le haut de la coquille : Haut et tout ce qui y est soudé
local function partiesDuHaut(oeuf: Model): { BasePart }
	local haut = oeuf:FindFirstChild("Haut")
	local res = { haut }
	for _, p in oeuf:GetDescendants() do
		if p:IsA("BasePart") and p ~= haut then
			local w = p:FindFirstChildOfClass("WeldConstraint")
			if w and w.Part0 == haut then
				table.insert(res, p)
			end
		end
	end
	return res
end

local function lancer(res)
	local vue = contenu.Vue :: ViewportFrame
	local e = CompagnonsConfig.ESPECES[res.espece]
	local couleur = Interface.couleurRarete(e and e.rarete or "Commun")
	local sourceOeuf = ReplicatedStorage.Assets.Oeufs:FindFirstChild(res.oeuf)
	local sourceComp = ReplicatedStorage.Assets.Compagnons:FindFirstChild(res.espece)
	if not (sourceOeuf and sourceComp and e) then
		return
	end

	-- Textes, cachés jusqu'à l'apparition du compagnon
	contenu.TexteEspece.Text = e.nom
	local bonus = CompagnonsConfig.bonus(res.espece, res.version, 1)
	contenu.TexteRarete.Text = string.format(
		Textes.ECRAN_RARETE_ROLE,
		e.rarete,
		CompagnonsConfig.NOMS_ROLES[e.role] or e.role,
		Interface.nombre(100 * bonus)
	)
	contenu.TexteRarete.TextColor3 = couleur
	for _, t in { contenu.TexteEspece, contenu.TexteRarete, contenu.TexteNouveau, contenu.BoutonContinuer } do
		t.Visible = false
	end
	-- Lueur de la couleur de la rareté au centre, nuit sur les bords
	local nuit = Color3.fromHex("16213E")
	ecran.Fond.Degrade.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, nuit),
		ColorSequenceKeypoint.new(0.5, couleur:Lerp(Color3.fromHex("2A1F5C"), 0.35)),
		ColorSequenceKeypoint.new(1, nuit),
	})

	-- Scène : l'œuf, et le compagnon caché à sa place
	local oeuf = sourceOeuf:Clone()
	local camera = Interface.vue(vue, oeuf, 1.6)
	local comp = sourceComp:Clone()
	Apparence.appliquerVersion(comp, res.version)
	comp:PivotTo(CFrame.new()) -- les compagnons regardent vers -Z, donc vers la caméra
	comp:ScaleTo(0.05)
	comp.Parent = vue
	camera.CFrame = CFrame.lookAt(Vector3.new(2.2, 2.4, -5.5), Vector3.new(0, 1.2, 0))

	local haut = partiesDuHaut(oeuf)
	local depart = {}
	for _, p in haut do
		depart[p] = p.CFrame
	end
	local tous = {}
	for _, p in oeuf:GetDescendants() do
		if p:IsA("BasePart") then
			table.insert(tous, p)
		end
	end

	Interface.ouvrir(ecran)
	if animation then
		animation:Disconnect()
	end
	local t0 = os.clock()
	animation = RunService.RenderStepped:Connect(function()
		local t = os.clock() - t0
		if t < DUREE_TREMBLE then
			-- Tremblement de plus en plus fort
			local a = math.sin(t * 40) * math.rad(4 + 10 * t / DUREE_TREMBLE)
			oeuf:PivotTo(CFrame.Angles(0, 0, a))
		elseif t < DUREE_TREMBLE + DUREE_ENVOL then
			-- Le haut s'envole et disparaît, le bas s'efface, le compagnon grandit
			local k = (t - DUREE_TREMBLE) / DUREE_ENVOL
			oeuf:PivotTo(CFrame.new())
			for _, p in haut do
				p.CFrame = CFrame.new(0, 3 * k, 0) * CFrame.Angles(0, 0, -k * 0.8) * depart[p]
			end
			for _, p in tous do
				p.LocalTransparencyModifier = k
			end
			comp:ScaleTo(math.max(0.05, k))
		else
			comp:ScaleTo(1)
			oeuf:Destroy()
			local spin = (t - DUREE_TREMBLE - DUREE_ENVOL) * 0.8
			comp:PivotTo(CFrame.Angles(0, math.sin(spin) * 0.5, 0))
			if not contenu.TexteEspece.Visible then
				contenu.TexteEspece.Visible = true
				contenu.TexteRarete.Visible = true
				contenu.TexteNouveau.Visible = res.nouveau == true
				contenu.BoutonContinuer.Visible = true
			end
		end
	end)
end

local function fermer()
	if animation then
		animation:Disconnect()
		animation = nil
	end
	Interface.fermer(ecran)
	if oeufARouvrir then
		EcranOeuf.ouvrir(oeufARouvrir)
	end
end

function EcranEclosion.demarrer()
	ecran = Interface.ecran("EcranEclosion")
	contenu = ecran:WaitForChild("Contenu")
	Interface.suivreEchelle(contenu:WaitForChild("Echelle"))
	contenu.BoutonContinuer.Activated:Connect(fermer)
	Remotes.ResultatOeuf.OnClientEvent:Connect(function(res)
		oeufARouvrir = EcranOeuf.oeuf()
		lancer(res)
	end)
end

return EcranEclosion
