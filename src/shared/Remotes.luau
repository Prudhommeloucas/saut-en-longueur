-- Liste unique des événements réseau. Le serveur les crée dans ReplicatedStorage.Remotes,
-- le client les attend. Tout nouvel événement s'ajoute ici, avec son sens et ses arguments.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local EVENEMENTS = {
	-- serveur → joueur : (metres: number, gain: number, estRecord: boolean, rare: string?, appel: string?)
	-- rare = "Dore", "Legendaire" ou nil ; appel = "Parfait", "Bon", "Correct", "Mordu" ou nil (pas d'appel)
	"SautResultat",
	-- joueur → serveur : (x: number) le joueur vient de décoller, à cette position X ; le serveur la vérifie et juge l'appel
	"Appel",
	-- serveur → joueur : (pieces: number, serie: number) un anneau vient d'être traversé
	"AnneauTraverse",
	-- serveur → joueur : (message: string)
	"Notif",
	-- joueur → serveur : (actif: boolean), vrai quand la poussée du jetpack démarre
	"JetpackEtat",
	-- serveur → joueur : (etat: { liste = { [uid] = {espece, version, niveau, xp} }, equipes = {uid}, emplacements, inventaireMax })
	"CompagnonsEtat",
	-- joueur → serveur : (uid: string, equipe: boolean)
	"EquiperCompagnon",
	-- joueur → serveur : () équipe les meilleurs compagnons
	"EquiperMeilleurs",
	-- joueur → serveur : (oeufId: string) ouvrir un œuf
	"OuvrirOeuf",
	-- serveur → joueur : (resultat: { oeuf, espece, version, uid, nouveau: boolean })
	"ResultatOeuf",
	-- joueur → serveur : (espece: string, version: string) fusionner trois compagnons identiques
	"Fusionner",
	-- serveur → joueur : (index: { trouves, pages, chance })
	"IndexEtat",
}

local Remotes = {} :: { [string]: RemoteEvent }

if RunService:IsServer() then
	local dossier = ReplicatedStorage:FindFirstChild("Remotes")
	if not dossier then
		dossier = Instance.new("Folder")
		dossier.Name = "Remotes"
		dossier.Parent = ReplicatedStorage
	end
	for _, nom in EVENEMENTS do
		local ev = dossier:FindFirstChild(nom)
		if not ev then
			ev = Instance.new("RemoteEvent")
			ev.Name = nom
			ev.Parent = dossier
		end
		Remotes[nom] = ev
	end
else
	local dossier = ReplicatedStorage:WaitForChild("Remotes")
	for _, nom in EVENEMENTS do
		Remotes[nom] = dossier:WaitForChild(nom)
	end
end

return Remotes
