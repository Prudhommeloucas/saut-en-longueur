# Projet : Saut en longueur

Jeu Roblox où le but est de sauter de plus en plus loin. Nom de travail « Saut en longueur » ; le nom public reste à choisir ([[Décisions]]).

## État

- Première version jouable construite dans Roblox Studio le 2026-11-11 (place « Place1 », pas encore enregistrée ni publiée). Entraînement, saut, pièces, boutique et jetpack fonctionnent. L'existant est décrit dans [[Map]], [[Scripts]] et [[Décor et effets]].
- Le 2026-11-11, la conception a été approfondie et le plan découpé en tâches. Personne n'a de domaine réservé : chacun prend la tâche qu'il veut, code compris, après l'avoir réservée. Rien de cette conception n'est encore codé. Le plan est dans [[Déroulé du développement]], l'avancement dans [[Tableau de bord]].

## Le jeu en trois phrases

1. Le joueur s'entraîne pour faire monter ses stats ([[Entraînement]]).
2. Il prend son élan et saute ; le saut est un petit jeu d'adresse en trois temps : appel, vol, réception ([[Saut]]).
3. La distance rapporte des pièces, qui paient l'équipement, les compagnons et l'accès aux mondes suivants ([[Boucles de gameplay]]).

## Notes de conception (ce qu'on veut faire)

- [[Vision]] : piliers, public, ce qui nous distingue
- [[Boucles de gameplay]] : boucles courte, de session et longue
- [[Saut]] : appel, vol, réception, sauts rares
- [[Entraînement]] : stats, zones, entraînement actif
- [[Équipement]] : chaussures, propulseurs, ailes, niveaux
- [[Compagnons]] : œufs, raretés, fusion, index
- [[Rebirth et talents]] : catégories, médailles, arbre de talents
- [[Mondes]] : six mondes avec chacun sa physique
- [[Quêtes et récompenses]] : quêtes, paliers, connexion, temps de jeu
- [[Social et compétition]] : classements, concours de serveur, amis
- [[Économie]] : monnaies, formules, rythme visé
- [[Monétisation]] : passes, produits, règles Roblox
- [[Premières minutes]] : tutoriel
- [[Référence]] : le jeu qui sert d'inspiration

## Notes de réalisation (comment on le fait)

- [[Map]], [[Décor et effets]], [[Scripts]] : ce qui est déjà construit
- [[Architecture du code]] : organisation cible du code
- [[Contrats]] : noms, tags et attributs qui relient la map, les écrans et le code
- [[HUD]] : tous les écrans
- [[Direction artistique]], [[Modèles 3D]], [[Animations]]
- [[Sons et musique]], [[Images]]
- [[Claude Design]] : plans de mondes, planches de modèles et maquettes avant construction
- [[Lancement]] : publication, mesures, suite après la sortie

## Équipe et suivi

- [[Équipe]] : les trois postes, sans domaine réservé
- [[Liberté de création]] : ce que chacun décide seul, et la boîte à idées (`Idées/`)
- [[Outils]] : logiciels, connecteurs et skills, par type de tâche
- `README.md` : les quatre gestes pour rejoindre le projet
- [[Première session]] : la mise en place que Claude fait seul la première fois
- [[Installation]] : détail de la mise en place d'un poste
- [[Travailler à plusieurs]] : réservation des tâches, git, Rojo, Team Create, demandes
- [[Déroulé du développement]] : toutes les tâches, dans l'ordre
- [[Tâches]] : la liste commune à cocher
- [[Tableau de bord]] : tâches en cours, demandes, idées
- [[Décisions]] : décisions prises et questions à trancher

## Décisions de base (toujours valables)

- Squat = Puissance de saut, mollets = Vitesse d'élan. Les bonus ne s'appliquent que sur la piste.
- 1 mètre = 4 studs au monde 1. La distance est toujours calculée par le serveur.
- On reprend le genre et les mécaniques de la [[Référence]], mais avec notre propre map, notre nom et nos visuels.
