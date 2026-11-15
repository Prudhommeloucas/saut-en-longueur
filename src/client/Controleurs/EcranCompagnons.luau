-- EcranCompagnons : inventaire, équipe, bonus, « les meilleurs », fusion, index. Écran construit dans StarterGui (HUD.md).
-- S'ouvre par BoutonsProvisoires.BoutonCompagnons, en attendant HudPrincipal (T-109).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local CompagnonsConfig = require(Config:WaitForChild("Compagnons"))
local OeufsConfig = require(Config:WaitForChild("Oeufs"))
local Textes = require(Config:WaitForChild("Textes"))
local Remotes = require(Shared:WaitForChild("Remotes"))
local Interface = require(script.Parent.Parent:WaitForChild("Interface"))
local Compagnons = require(script.Parent.Compagnons)

local player = Players.LocalPlayer

local EcranCompagnons = {}

local ecran: ScreenGui
local fenetre: Frame
local etatIndex = nil
local ongletIndex = false

local COULEUR_ONGLET_ACTIF = Color3.fromHex("FFC83D")
local COULEUR_ONGLET = Color3.fromHex("2A3A66")
local TEXTE_ONGLET_ACTIF = Color3.fromHex("16213E")
local ARGENT = Color3.fromHex("D5DCE4")
local OR = Color3.fromHex("FFC83D")
local VIDE = Color3.fromHex("2A3A66")

-- Même classement que le serveur (« les meilleurs ») : bonus ramené à l'échelle des Coachs
local function force(comp): number
	local e = CompagnonsConfig.ESPECES[comp.espece]
	if not e then
		return 0
	end
	return (CompagnonsConfig.BONUS.Coach[e.rarete] or 0)
		* (CompagnonsConfig.VERSIONS[comp.version] or 1)
		* (1 + CompagnonsConfig.BONUS_PAR_NIVEAU * (comp.niveau - 1))
end

local function vider(liste: Instance)
	for _, enfant in liste:GetChildren() do
		if enfant:IsA("GuiObject") and enfant.Name ~= "ModeleLigne" then
			enfant:Destroy()
		end
	end
end

local function detail(comp): string
	local t = string.format(Textes.ECRAN_NIVEAU, tostring(comp.niveau))
	if comp.version ~= "Normal" then
		t ..= " · " .. comp.version
	end
	return t
end

local function remplirCompagnons(etat)
	local page = fenetre.PageCompagnons
	local liste = page.ListeCompagnons
	local equipe = page.ListeEquipe
	vider(liste)
	vider(equipe)

	local uids = {}
	local n = 0
	for uid in etat.liste do
		table.insert(uids, uid)
		n += 1
	end
	local estEquipe = {}
	for _, uid in etat.equipes do
		estEquipe[uid] = true
	end
	table.sort(uids, function(a, b)
		if (estEquipe[a] == true) ~= (estEquipe[b] == true) then
			return estEquipe[a] == true
		end
		return force(etat.liste[a]) > force(etat.liste[b])
	end)

	fenetre.TexteInventaire.Text = string.format(Textes.ECRAN_INVENTAIRE, tostring(n), tostring(etat.inventaireMax))
	page.TexteEquipe.Text = string.format(Textes.ECRAN_EQUIPE, tostring(#etat.equipes), tostring(etat.emplacements))

	-- Cartes de l'inventaire
	for i, uid in uids do
		local comp = etat.liste[uid]
		local e = CompagnonsConfig.ESPECES[comp.espece]
		local carte = liste.ModeleLigne:Clone()
		carte.Name = uid
		carte.LayoutOrder = i
		carte.Visible = true
		carte.Rarete.Color = Interface.couleurRarete(e and e.rarete or "Commun")
		Interface.pastille(carte.Pastille, comp.espece)
		carte.TexteNiveau.Text = detail(comp)
		carte.Badge.Visible = estEquipe[uid] == true
		carte.Activated:Connect(function()
			Remotes.EquiperCompagnon:FireServer(uid, not estEquipe[uid])
		end)
		carte.Parent = liste
	end

	-- Équipe
	local mult = { Coach = 1, Tresorier = 1, PorteBonheur = 1 }
	for i, uid in etat.equipes do
		local comp = etat.liste[uid]
		local e = comp and CompagnonsConfig.ESPECES[comp.espece]
		if e then
			mult[e.role] += CompagnonsConfig.bonus(comp.espece, comp.version, comp.niveau)
			local ligne = equipe.ModeleLigne:Clone()
			ligne.Name = uid
			ligne.LayoutOrder = i
			ligne.Visible = true
			ligne.Rarete.Color = Interface.couleurRarete(e.rarete)
			Interface.pastille(ligne.Pastille, comp.espece)
			ligne.TexteNom.Text = e.nom
			ligne.TexteDetail.Text = detail(comp)
			ligne.Activated:Connect(function()
				Remotes.EquiperCompagnon:FireServer(uid, false)
			end)
			ligne.Parent = equipe
		end
	end
	page.TexteBonus.Text = string.format(
		Textes.ECRAN_BONUS,
		Interface.nombre(mult.Coach),
		Interface.nombre(mult.Tresorier),
		Interface.nombre(mult.PorteBonheur)
	)
end

-- Ordre de l'index : espèces dans l'ordre des œufs
local function especesIndex(): { string }
	local res = {}
	for _, oeufId in { "oeuf_stade", "oeuf_champion", "oeuf_or" } do
		local oeuf = OeufsConfig.LISTE[oeufId]
		if oeuf then
			for _, c in oeuf.contenu do
				if not table.find(res, c.espece) then
					table.insert(res, c.espece)
				end
			end
		end
	end
	return res
end

local function remplirIndex()
	local page = fenetre.PageIndex
	local liste = page.ListeIndex
	vider(liste)
	local trouves = etatIndex and etatIndex.trouves or {}
	local pages = 0
	for _ in (etatIndex and etatIndex.pages or {}) do
		pages += 1
	end
	page.TexteIndex.Text = string.format(
		Textes.ECRAN_INDEX,
		tostring(pages),
		Interface.nombre(100 * (etatIndex and etatIndex.chance or 0))
	)
	for i, espece in especesIndex() do
		local e = CompagnonsConfig.ESPECES[espece]
		local t = trouves[espece] or {}
		local connu = next(t) ~= nil
		local cellule = liste.ModeleLigne:Clone()
		cellule.Name = espece
		cellule.LayoutOrder = i
		cellule.Visible = true
		cellule.Rarete.Color = Interface.couleurRarete(e.rarete)
		Interface.pastille(cellule.Pastille, if connu then espece else nil)
		cellule.TexteNom.Text = if connu then e.nom else Textes.ECRAN_INCONNU
		cellule.PointNormal.BackgroundColor3 = if t.Normal then Interface.couleurRarete(e.rarete) else VIDE
		cellule.PointArgent.BackgroundColor3 = if t.Argent then ARGENT else VIDE
		cellule.PointOr.BackgroundColor3 = if t.Or then OR else VIDE
		cellule.Parent = liste
	end
end

local function afficherOnglet()
	fenetre.PageCompagnons.Visible = not ongletIndex
	fenetre.PageIndex.Visible = ongletIndex
	fenetre.OngletCompagnons.BackgroundColor3 = if ongletIndex then COULEUR_ONGLET else COULEUR_ONGLET_ACTIF
	fenetre.OngletCompagnons.TextColor3 = if ongletIndex then Color3.new(1, 1, 1) else TEXTE_ONGLET_ACTIF
	fenetre.OngletIndex.BackgroundColor3 = if ongletIndex then COULEUR_ONGLET_ACTIF else COULEUR_ONGLET
	fenetre.OngletIndex.TextColor3 = if ongletIndex then TEXTE_ONGLET_ACTIF else Color3.new(1, 1, 1)
	if ongletIndex then
		remplirIndex()
	end
end

-- Fusionne tous les groupes de trois compagnons identiques (le serveur vérifie et refuse le reste)
local function fusionnerTout()
	local etat = Compagnons.etat()
	if not etat then
		return
	end
	local groupes = {}
	for _, comp in etat.liste do
		if comp.version ~= "Or" then
			local cle = comp.espece .. ":" .. comp.version
			groupes[cle] = (groupes[cle] or 0) + 1
		end
	end
	local envoye = false
	for cle, nb in groupes do
		local espece, version = string.match(cle, "^(.+):(.+)$")
		for _ = 1, math.floor(nb / OeufsConfig.FUSION_NOMBRE) do
			Remotes.Fusionner:FireServer(espece, version)
			envoye = true
			task.wait(0.25)
		end
	end
	if not envoye then
		local _, comp = next(etat.liste)
		if comp then
			Remotes.Fusionner:FireServer(comp.espece, comp.version) -- le serveur explique ce qui manque
		end
	end
end

function EcranCompagnons.demarrer()
	ecran = Interface.ecran("EcranCompagnons")
	fenetre = ecran:WaitForChild("Fenetre")
	Interface.suivreEchelle(fenetre:WaitForChild("Echelle"))

	local provisoire = player.PlayerGui:WaitForChild("BoutonsProvisoires")
	provisoire:WaitForChild("BoutonCompagnons").Activated:Connect(function()
		if ecran.Enabled then
			Interface.fermer(ecran)
		else
			Interface.ouvrir(ecran, fenetre.BoutonFermer)
		end
	end)
	fenetre.BoutonFermer.Activated:Connect(function()
		Interface.fermer(ecran)
	end)
	fenetre.OngletCompagnons.Activated:Connect(function()
		ongletIndex = false
		afficherOnglet()
	end)
	fenetre.OngletIndex.Activated:Connect(function()
		ongletIndex = true
		afficherOnglet()
	end)
	fenetre.PageCompagnons.BoutonMeilleurs.Activated:Connect(function()
		Remotes.EquiperMeilleurs:FireServer()
	end)
	fenetre.PageCompagnons.BoutonFusionner.Activated:Connect(fusionnerTout)

	Compagnons.surEtat(remplirCompagnons)
	Remotes.IndexEtat.OnClientEvent:Connect(function(index)
		etatIndex = index
		if ongletIndex then
			remplirIndex()
		end
	end)
	afficherOnglet()
end

return EcranCompagnons
