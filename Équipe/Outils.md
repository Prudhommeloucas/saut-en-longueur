# Outils

Logiciels, connecteurs et skills utiles au projet, classés par type de tâche. Tout le monde peut faire tous les types de tâches, donc tout le monde peut avoir besoin de tous ces outils. Voir [[Installation]] pour la mise en place.

## État du Poste 1 (vérifié le 2026-11-11)

| Outil | État |
| --- | --- |
| git, GitHub CLI (connecté), Node, Python | Installés |
| Rokit 1.2.0 | Installé |
| Rojo, Selene, StyLua, Wally | **À installer** dans le projet (tâche T-001) |
| Roblox Studio, extension Rojo de Studio | Installés |
| Blender 5.2 | Installé |
| Obsidian | Installé, coffre ouvert |
| MCP Roblox Studio et MCP Blender | **Non branchés sur Claude Code en terminal** (tâche T-001). Ils ne sont configurés que côté Claude Desktop |

Les Postes 2 et 3 installent Rokit et l'extension Rojo à la tâche T-003, puisque tout le monde code.

## Communs aux trois postes

| Outil | Rôle |
| --- | --- |
| Obsidian | Lecture et suivi du projet. Aucune extension obligatoire : le suivi repose sur des cases à cocher et des notes incluses. Extensions facultatives : Tasks, Dataview |
| git et GitHub | Partage du dépôt. Claude fait les commandes ; personne n'a besoin de les connaître |
| Team Create (Roblox) | Édition de la même place à trois, en direct |
| MCP Roblox Studio | Permet à Claude d'agir dans Studio : créer des objets, lancer du code, lancer un test, lire la sortie |
| MCP Blender | Permet à Claude d'agir dans Blender : créer et modifier des modèles par script, capturer la vue |
| Recherche web | Documentation de Roblox (`create.roblox.com/docs`). À consulter dès qu'une règle ou une limite de la plateforme est en jeu : elles changent souvent |

## Par type de tâche

### Code

| Outil | Rôle |
| --- | --- |
| Rojo | Envoie les fichiers de `src/` dans Studio |
| Rokit | Installe et fixe la version de Rojo, Selene, StyLua, Wally |
| Selene, StyLua | Détection d'erreurs et mise en forme du Luau |
| Wally | Bibliothèques (ProfileStore pour la sauvegarde) |
| MCP Roblox Studio | Lancer le jeu, lire les erreurs, vérifier un comportement |
| Skills `code-review`, `simplify`, `security-review` | Relecture du code avant chaque fin de phase |
| Skill `xlsx` | Tableur d'équilibrage ([[Économie]]) |
| Skill `dataviz` | Courbes de progression issues de la simulation |
| Agents `Explore` et `Plan` | Recherche dans le code et préparation d'un système complexe |

### Modélisation et animation

| Outil | Rôle |
| --- | --- |
| Claude Design | Plan de chaque monde vu de dessus et planches de modèles (face, profil, trois quarts) avant construction. Ne produit pas de 3D : Claude relit la planche et la reconstruit dans Studio ou Blender ([[Claude Design]]) |
| Blender et MCP Blender | Modélisation par script, vérification du nombre de triangles, export |
| Import 3D de Studio | Import des `.fbx` (geste manuel) |
| MCP Roblox Studio | Construction du décor en Parts, rangement, tags et attributs, lumière |
| Éditeur d'animation de Studio | Animations des personnages ([[Animations]]) |
| Bibliothèques de modèles accessibles depuis le MCP Blender | Décor secondaire, selon la version installée et la licence |
| Skill `computer-use` (Claude Desktop) | Gestes manuels dans Studio ou Blender quand aucun MCP ne les couvre |

### Interface

| Outil | Rôle |
| --- | --- |
| Claude Design | Maquettes des écrans aux tailles réelles, icônes d'interface, logo, habillage des miniatures ([[Claude Design]]) |
| Skill `artifact-design` et outil Artifact | Autre façon de maquetter un écran, en page HTML partageable par lien |
| MCP Roblox Studio | Construction des écrans dans `StarterGui`, captures |
| Émulateur d'appareils de Studio | Vérification sur téléphone, tablette, ordinateur |

### Sons

| Outil | Rôle |
| --- | --- |
| Boîte à outils de Studio, onglet Audio | Recherche et écoute des sons et musiques du Creator Store |
| Générateur d'effets en ligne (famille sfxr) | Création de sons d'interface et de pièces |
| Audacity | Découpe, mélange, volume |
| ElevenLabs (facultatif, compte requis, serveur MCP disponible) | Effets générés sur description |

### Images

| Outil | Rôle |
| --- | --- |
| MCP Blender | Rendu des icônes d'objets et de compagnons à partir des modèles |
| Dessin SVG écrit par Claude, converti en PNG | Icônes d'interface, logo, cadres |
| Captures de Studio | Miniatures et icône du jeu |
| Générateurs de textures et de matières de Studio | Matières du décor |

### Page du jeu, passes et produits

| Outil | Rôle |
| --- | --- |
| Skill `claude-in-chrome` ou navigateur intégré | Création des passes et produits sur le Creator Hub, réglages du jeu, lecture des statistiques. Les achats et les publications restent validés par l'équipier |

### Pilotage

| Outil | Rôle |
| --- | --- |
| Skill `deep-research` | Étude des jeux du même genre avant une décision de conception |
| Skill `schedule` | Rappel hebdomadaire : relire les mesures, préparer la mise à jour |
| Skill `skill-creator` | Création des skills du projet (voir plus bas) |
| Connecteur Google Drive | Stockage des fichiers trop lourds pour git (vidéos, sources audio longues) |
| Connecteur Todoist ou Google Agenda (facultatif) | Rappels personnels ; le suivi officiel reste dans Obsidian |

## Skills du projet à créer (tâche T-012)

Rangés dans `.claude/skills/` et partagés par git, ils donnent les mêmes gestes aux trois postes, quel que soit le genre de la tâche.

| Skill | Ce qu'il fait |
| --- | --- |
| `debut-session` | Met le dépôt à jour, lit le poste, les réservations en cours et les demandes, propose des tâches libres |
| `prendre-tache` | Vérifie qu'une tâche est libre et ses dépendances faites, crée la réservation et l'envoie aussitôt |
| `fin-tache` | Coche [[Tâches]], met à jour journal, notes et registres, supprime la réservation, envoie sur GitHub, synchronise la place si du code a changé |
| `sync-place` | Vérifie que le dépôt est à jour et propre, puis guide la synchronisation Rojo de la place partagée |
| `demande` | Crée une demande à un autre poste ou à tous, au bon format |
| `modele-3d` | Déroule la chaîne Blender → export → import → registre, avec ses vérifications |
| `ecran-hud` | Construit un écran selon [[HUD]] et [[Contrats]], avec captures sur trois tailles |
| `son` | Cherche trois candidats, teste, inscrit le son retenu |
| `test-jeu` | Lance une partie par le MCP, lit la sortie, déroule la liste de contrôle de la tâche |

## Limites à connaître

- Les trois membres ont un abonnement Claude Pro : les longues séances de modélisation ou de code consomment vite le quota. Préférer des tâches courtes et bien délimitées, et éviter de faire relire tout le coffre à Claude ([[Travailler à plusieurs]]).
- Claude ne génère pas d'images ni de sons lui-même : il pilote des outils qui le font.
- L'import 3D, la publication d'une animation et la création d'un produit demandent une validation humaine.
