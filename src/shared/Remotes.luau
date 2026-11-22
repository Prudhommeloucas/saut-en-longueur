-- Liste unique des événements réseau. Le serveur les crée dans ReplicatedStorage.Remotes,
-- le client les attend. Tout nouvel événement s'ajoute ici, avec son sens et ses arguments.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local EVENEMENTS = {
	-- serveur → joueur : (metres: number, gain: number, estRecord: boolean, rare: string?, appel: string?)
	-- rare = "Dore", "Legendaire" ou nil ; appel = "Parfait", "Bon", "Correct", "Mordu" ou nil (pas d'appel)
	-- 6e argument (T-103) : maitrise = { reception: boolean, parfait: boolean, serie: number, bonus: number }
	"SautResultat",
	-- joueur → serveur : () nouvel appui sur Saut pendant la descente, l'essai de réception
	"Reception",
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
	-- joueur → serveur : (tempsServeur: number) appui du rythme d'entraînement, à cette heure du serveur (T-202)
	"Rythme",
	-- serveur → joueur : (qualite: string?, gain: number) résultat de l'appui (nil : raté)
	"RythmeResultat",
	-- joueur → serveur : (id: string) acheter un objet du catalogue d'équipement (T-203)
	"AcheterObjet",
	-- joueur → serveur : (id: string) monter d'un niveau un objet possédé
	"AmeliorerObjet",
	-- joueur → serveur : (id: string) porter un objet possédé
	"PorterObjet",
	-- serveur → joueur : (etat: { possede = { [id] = niveau }, porte = { [famille] = id } })
	"EquipementEtat",
	-- serveur → joueur : (id: string, nom: string) une fonction du jeu vient de s'ouvrir (T-204)
	"Deblocage",
	-- serveur → joueur : (monde: number, record: number, gemmes: number, pieces: number, recu: boolean) palier franchi
	"PalierFranchi",
	-- joueur → serveur : (monde: number, record: number) réclamer la récompense d'un palier franchi
	"ReclamerPalier",
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
