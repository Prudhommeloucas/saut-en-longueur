-- EcranOeuf : contenu et chances d'un œuf, prix, bouton Ouvrir. S'ouvre par le prompt « Ouvrir » d'un incubateur :
-- les chances sont donc toujours affichées avant l'achat (règle de Roblox pour les tirages).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local CompagnonsConfig = require(Config:WaitForChild("Compagnons"))
local OeufsConfig = require(Config:WaitForChild("Oeufs"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Interface = require(script.Parent.Parent:WaitForChild("Interface"))

local player = Players.LocalPlayer

local EcranOeuf = {}

local ecran: ScreenGui
local fenetre: Frame
local oeufCourant: string? = nil

-- L'œuf affiché à l'écran, ou nil s'il est fermé
function EcranOeuf.oeuf(): string?
	return if ecran and ecran.Enabled then oeufCourant else nil
end

local function interdit(oeuf): boolean
	return oeuf.payant and player:GetAttribute("TiragesPayantsInterdits") ~= false
end

function EcranOeuf.ouvrir(oeufId: string)
	local oeuf = OeufsConfig.LISTE[oeufId]
	if not oeuf then
		return
	end
	oeufCourant = oeufId
	fenetre.TexteNomOeuf.Text = oeuf.nom
	fenetre.TextePrix.Text = string.format(
		"%s %s",
		tostring(oeuf.prix),
		if oeuf.monnaie == "gemmes" then Textes.MONNAIE_GEMMES else Textes.MONNAIE_PIECES
	)

	-- Chances
	local liste = fenetre.ListeChances
	for _, enfant in liste:GetChildren() do
		if enfant:IsA("GuiObject") and enfant.Name ~= "ModeleLigne" then
			enfant:Destroy()
		end
	end
	for i, c in OeufsConfig.chances(oeufId) do
		local e = CompagnonsConfig.ESPECES[c.espece]
		local couleur = Interface.couleurRarete(e.rarete)
		local ligne = liste.ModeleLigne:Clone()
		ligne.Name = c.espece
		ligne.LayoutOrder = i
		ligne.Visible = true
		ligne.Rarete.Color = couleur
		ligne.Pastille.BackgroundColor3 = Color3.fromHex(e.couleur)
		ligne.TexteNom.Text = e.nom
		ligne.TexteRarete.Text = e.rarete
		ligne.TexteRarete.TextColor3 = couleur
		ligne.Barre.Remplissage.Size = UDim2.fromScale(c.pourcentage / 100, 1)
		ligne.Barre.Remplissage.BackgroundColor3 = couleur
		ligne.TextePourcent.Text = Interface.nombre(c.pourcentage) .. " %"
		ligne.Parent = liste
	end

	-- Tirage payant interdit dans le pays du joueur : l'œuf reste visible mais ne s'ouvre pas
	local bloque = interdit(oeuf)
	fenetre.TexteInterdit.Visible = bloque
	fenetre.BoutonOuvrir1.Active = not bloque
	fenetre.BoutonOuvrir1.AutoButtonColor = not bloque
	fenetre.BoutonOuvrir1.BackgroundTransparency = if bloque then 0.6 else 0

	-- Ouvrir × 3 et automatique : passes à venir (Monétisation)
	for _, b in { fenetre.BoutonOuvrir3, fenetre.BoutonAuto } do
		b.Active = false
		b.AutoButtonColor = false
	end

	local modele = ReplicatedStorage.Assets.Oeufs:FindFirstChild(oeufId)
	if modele then
		Interface.vue(fenetre.VueOeuf, modele:Clone(), 0.9)
	end
	Interface.ouvrir(ecran, fenetre.BoutonOuvrir1)
end

function EcranOeuf.demarrer()
	ecran = Interface.ecran("EcranOeuf")
	fenetre = ecran:WaitForChild("Fenetre")
	Interface.suivreEchelle(fenetre:WaitForChild("Echelle"))

	fenetre.BoutonFermer.Activated:Connect(function()
		Interface.fermer(ecran)
	end)
	fenetre.BoutonOuvrir1.Activated:Connect(function()
		local oeuf = oeufCourant and OeufsConfig.LISTE[oeufCourant]
		if oeuf and not interdit(oeuf) then
			Remotes.OuvrirOeuf:FireServer(oeufCourant)
		end
	end)

	-- Prompt « Ouvrir » d'un incubateur (créé par le serveur) : montre l'écran au lieu d'acheter directement
	ProximityPromptService.PromptTriggered:Connect(function(prompt)
		if prompt.Name ~= "PromptOeuf" then
			return
		end
		local incubateur = prompt:FindFirstAncestorOfClass("Model")
		local oeufId = incubateur and incubateur:GetAttribute("Oeuf")
		if type(oeufId) == "string" then
			EcranOeuf.ouvrir(oeufId)
		end
	end)
end

return EcranOeuf
