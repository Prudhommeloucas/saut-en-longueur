# Saut en longueur (jeu Roblox)

Ce dossier est à la fois le dépôt git partagé par l'équipe et un coffre Obsidian. Les notes `.md` sont la mémoire du projet et le point central du suivi. Trois personnes y travaillent en même temps, chacune avec Claude.

## Début de session (obligatoire, dans cet ordre)

1. **Mettre le dépôt à jour.** Lancer `git pull --rebase --autostash`, puis `git status -sb` pour vérifier que `master` n'est pas en retard sur `origin/master`. Si la commande échoue (conflit, rebase en cours), régler le problème ou le signaler à l'utilisateur avant toute autre action. Ne jamais travailler sur une version en retard.
2. **Identifier le poste.** Lire `CLAUDE.local.md` (fichier non partagé). **S'il n'existe pas, c'est la première session sur cette machine : dérouler tout de suite la procédure de `Équipe/Première session.md`**, sans attendre que l'utilisateur la demande, puis reprendre ici. La phrase « configure mon poste » relance cette procédure.
3. **Trouver la tâche.** Lire [[Projet]], puis le fichier de suivi du poste dans `Suivi/`, puis seulement les notes liées à la tâche. Ne pas relire tout le coffre.
4. **Regarder les demandes.** Chercher dans `Suivi/Demandes/` les notes qui contiennent `pour: P<numéro du poste>` et `etat: ouverte`, et les signaler à l'utilisateur avant de commencer.

## Qui touche à quoi

| Poste | Rôle | Zone réservée dans le dépôt | Zone réservée dans Studio |
| --- | --- | --- | --- |
| Poste 1 | Code et systèmes | `src/`, fichiers de configuration, `Réalisation/Architecture du code.md`, `Réalisation/Contrats.md`, `Conception/` | `ServerScriptService`, `ReplicatedStorage` (sauf `Assets`), `StarterPlayer` |
| Poste 2 | Monde et 3D | `assets/modeles/`, `assets/animations/`, `assets/plans/`, registres des modèles et des animations | `Workspace`, `Lighting`, `ReplicatedStorage.Assets`, `ServerStorage.Modeles` |
| Poste 3 | Interface, son et image | `assets/sons/`, `assets/images/`, registres des sons, des images et des produits | `StarterGui`, `SoundService` |

- **Seul le Poste 1 écrit du code Luau.** Les Postes 2 et 3 ne créent et ne modifient aucun script, ni dans Studio ni dans `src/`. S'il leur faut un comportement, ils déposent une demande (voir plus bas).
- Chaque poste ne modifie que sa zone et son propre fichier de suivi. C'est ce qui évite les conflits git et les écrasements dans Studio.
- La place Roblox est partagée en direct (Team Create) : une commande envoyée par le MCP Roblox Studio est visible tout de suite par toute l'équipe. Ne jamais supprimer ni déplacer un objet hors de sa zone, ni lancer de commande large (vider un service, renommer en masse).
- Les noms d'objets, les tags et les attributs suivent [[Contrats]]. Ne pas en inventer : demander au Poste 1 d'ajouter ce qui manque.

## Liberté de création

Les notes sont un cadre de départ, pas un cahier des charges. Chaque équipier a ses idées et doit pouvoir les réaliser ([[Liberté de création]]).

- L'utilisateur veut faire autrement que ce qui est écrit, dans la zone de son poste : le faire, puis mettre la note à jour. Ne pas opposer la note à son idée.
- L'idée change les règles du jeu, l'économie ou le travail d'un autre poste : l'aider à l'écrire dans `Idées/` (un fichier par idée, ouvert à tous) et, si possible, la prototyper dans sa zone.
- Restent fixes : les zones réservées, le code au seul Poste 1, les noms techniques de [[Contrats]], les règles de Roblox.
- Les plans de mondes, planches de modèles et maquettes d'écrans se dessinent avec Claude Design avant construction ([[Claude Design]]).

## Règles des notes

- Répondre en français.
- Ne pas explorer Roblox Studio pour retrouver une information déjà écrite dans une note.
- Après un changement dans le jeu (nouveau système, nouvelle valeur d'équilibrage, décision de design), mettre à jour la note concernée, en quelques lignes.
- Une note par sujet, courte, avec des liens `[[...]]` vers les notes voisines.
- Un identifiant d'asset (son, image, mesh, animation, produit) s'écrit dans le registre correspondant de `Suivi/Registre/` dès qu'il existe.
- Besoin de quelque chose d'un autre poste : créer une note dans `Suivi/Demandes/` (un fichier par demande, voir [[Travailler à plusieurs]]).
- Une décision qui change la conception s'ajoute dans [[Décisions]] ; seul le Poste 1 modifie ce fichier.

## Fin de tâche

1. Cocher la tâche dans son fichier de suivi et ajouter la date.
2. Mettre à jour les notes et les registres concernés.
3. Partager : `git add -A`, `git commit -m "[P2] T-105 tribunes modulaires"` (poste, numéro de tâche, résumé), `git pull --rebase --autostash`, `git push`. Ces commits et ces envois de fin de tâche sont autorisés d'avance par l'équipe.

Le plan complet, tâche par tâche, est dans [[Déroulé du développement]].
