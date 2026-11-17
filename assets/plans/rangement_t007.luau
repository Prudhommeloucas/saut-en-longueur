-- T-007 : range Workspace.Map dans Workspace.Mondes.Monde1 et pose les tags de Contrats.
-- Relançable : ne fait que ce qui manque. Renvoie un compte rendu.
local CS = game:GetService("CollectionService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local log = {}

local map = workspace:FindFirstChild("Map")
local mondes = workspace:FindFirstChild("Mondes")
if not mondes then
	mondes = Instance.new("Folder")
	mondes.Name = "Mondes"
	mondes.Parent = workspace
end
local monde = mondes:FindFirstChild("Monde1")
if not monde then
	monde = Instance.new("Folder")
	monde.Name = "Monde1"
	monde.Parent = mondes
end

local function dossier(nom)
	local d = monde:FindFirstChild(nom)
	if not d then
		d = Instance.new("Folder")
		d.Name = nom
		d.Parent = monde
	end
	return d
end

local spawnF = dossier("Spawn")
local entrainementF = dossier("Entrainement")
local boutiqueF = dossier("Boutique")
local pisteF = dossier("Piste")
local bacF = dossier("Bac")
local decorF = dossier("Decor")
dossier("Anneaux")
dossier("Portails")

local function deplacer(objet, parent)
	if objet then
		objet.Parent = parent
		table.insert(log, objet.Name .. " -> " .. parent.Name)
	end
end

if map then
	local recording = ChangeHistoryService:TryBeginRecording("T-007 rangement")
	-- Contenu des dossiers qui gardent leur nom
	for _, nom in { "Entrainement", "Boutique" } do
		local src = map:FindFirstChild(nom)
		if src then
			for _, c in src:GetChildren() do
				c.Parent = monde[nom]
			end
			src:Destroy()
			table.insert(log, nom .. " (contenu) -> " .. nom)
		end
	end
	local decorSrc = map:FindFirstChild("Decor")
	if decorSrc then
		for _, c in decorSrc:GetChildren() do
			c.Parent = decorF
		end
		decorSrc:Destroy()
		table.insert(log, "Decor (contenu) -> Decor")
	end
	deplacer(map:FindFirstChild("Spawn"), spawnF)
	deplacer(map:FindFirstChild("SolSpawn"), spawnF)
	deplacer(map:FindFirstChild("Arche"), pisteF)
	deplacer(map:FindFirstChild("Piste"), pisteF)
	deplacer(map:FindFirstChild("PlancheAppel"), pisteF)
	while map:FindFirstChild("LignePiste") do
		deplacer(map.LignePiste, pisteF)
	end
	deplacer(map:FindFirstChild("Sable"), bacF)
	deplacer(map:FindFirstChild("Marqueurs"), bacF)
	deplacer(map:FindFirstChild("Murs"), bacF)
	-- Grande pelouse autour du spawn : avec les autres sols du décor
	local sol = decorF:FindFirstChild("Sol")
	deplacer(map:FindFirstChild("Herbe"), sol or decorF)

	local reste = map:GetChildren()
	if #reste == 0 then
		map:Destroy()
		table.insert(log, "Workspace.Map supprimée (vide)")
	else
		for _, c in reste do
			table.insert(log, "RESTE dans Map : " .. c:GetFullName())
		end
	end
	if recording then
		ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
	end
end

-- Tags et attributs
local function tag(objet, nom, attrs)
	if not objet then
		table.insert(log, "MANQUE pour le tag " .. nom)
		return
	end
	CS:AddTag(objet, nom)
	for k, v in attrs or {} do
		objet:SetAttribute(k, v)
	end
	table.insert(log, "tag " .. nom .. " sur " .. objet:GetFullName())
end

tag(entrainementF:FindFirstChild("ZoneSquat"), "ZoneEntrainement", { Stat = "Puissance", Multiplicateur = 1, RecordRequis = 0 })
tag(entrainementF:FindFirstChild("ZoneMollets"), "ZoneEntrainement", { Stat = "Vitesse", Multiplicateur = 1, RecordRequis = 0 })
tag(pisteF:FindFirstChild("Piste"), "Piste", { Monde = 1 })
tag(pisteF:FindFirstChild("PlancheAppel"), "PlancheAppel", { Monde = 1 })
tag(bacF:FindFirstChild("Sable"), "Bac", { Monde = 1 })
tag(spawnF:FindFirstChild("Spawn"), "PointApparition", { Monde = 1 })
tag(boutiqueF:FindFirstChild("StandChaussures"), "Stand", { Famille = "Chaussures" })
tag(boutiqueF:FindFirstChild("StandJetpack"), "Stand", { Famille = "Propulseur" })

return table.concat(log, "\n")
