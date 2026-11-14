# Saut en longueur (jeu Roblox)

Ce dossier est à la fois le dépôt git partagé par l'équipe et un coffre Obsidian. Les notes `.md` sont la mémoire du projet et le point central du suivi. Trois personnes y travaillent en même temps, chacune avec Claude.

**Personne n'a de domaine réservé.** Tout le monde peut écrire du code, construire la map, les écrans, les modèles, les sons et les images. Ce qui évite les conflits, ce n'est pas un partage par métier mais la **réservation des tâches** ([[Travailler à plusieurs]]).

## Début de session (obligatoire, dans cet ordre)

1. **Mettre le dépôt à jour.** Lancer `git pull --rebase --autostash`, puis `git status -sb` pour vérifier que `master` n'est pas en retard sur `origin/master`. Si la commande échoue (conflit, rebase en cours), régler le problème ou le signaler à l'utilisateur avant toute autre action. Ne jamais travailler sur une version en retard.
2. **Identifier le poste.** Lire `CLAUDE.local.md` (fichier non partagé) : il donne le numéro du poste (P1, P2 ou P3) et le prénom. **S'il n'existe pas, c'est la première session sur cette machine : dérouler tout de suite la procédure de `Équipe/Première session.md`**, sans attendre que l'utilisateur la demande, puis reprendre ici. La phrase « configure mon poste » relance cette procédure.
3. **Voir ce qui est en cours.** Lister `Suivi/En cours/` : chaque fichier est une tâche réservée, avec ce qu'elle touche. Ne pas modifier ces fichiers ni ces objets de Studio.
4. **Trouver la tâche.** Lire [[Projet]], puis le journal du poste (`Suivi/Poste N.md`). Si ce poste a une réservation en cours, la reprendre. Sinon, proposer dans [[Tâches]] quelques tâches non cochées, non réservées et dont les dépendances sont faites ([[Déroulé du développement]]), en tenant compte des envies notées dans le journal ; l'utilisateur choisit librement, y compris une tâche hors de ses habitudes. Lire ensuite seulement les notes liées à la tâche, pas tout le coffre.
5. **Regarder les demandes.** Chercher dans `Suivi/Demandes/` les notes qui contiennent `pour: P<numéro du poste>` ou `pour: tous` et `etat: ouverte`, et les signaler à l'utilisateur avant de commencer.

## Réserver avant de commencer

Avant la première modification d'une tâche :

1. Copier [[Modèle de réservation]] dans `Suivi/En cours/`, nommé par la tâche (`T-105.md`) : qui, depuis quand, et ce que la tâche va toucher (fichiers du dépôt, objets de Studio).
2. L'envoyer tout de suite : `git add`, `git commit -m "[P2] T-105 réservée"`, `git pull --rebase --autostash`, `git push`.
3. Si le pull révèle que le fichier existe déjà, la tâche vient d'être prise : annuler sa propre réservation et en choisir une autre.

Un travail hors plan (correctif, prototype d'une idée) se réserve de la même façon, avec un nom court : `Suivi/En cours/Correctif caméra - P2.md`.

## Règles communes

- **Tout le monde peut écrire du code Luau**, toujours dans `src/` : aucun script créé ou modifié directement dans Studio, car Rojo l'écraserait ([[Architecture du code]]).
- On ne modifie pas ce qu'une autre réservation a annoncé. Si c'est nécessaire, s'entendre d'abord avec son auteur (demande ou message).
- **Rojo** : on code et on teste dans sa **copie personnelle** de la place. On ne synchronise la place partagée que depuis un dépôt à jour et propre (`git status` sans changement local ni retard), juste après avoir envoyé son code ([[Travailler à plusieurs]]).
- Avant d'envoyer du code : Selene et StyLua sans erreur, et le jeu se lance sans erreur dans la sortie.
- La place Roblox est partagée en direct (Team Create) : une commande envoyée par le MCP Roblox Studio est visible tout de suite par toute l'équipe. Ne jamais lancer de commande large (vider un service, renommer ou déplacer en masse) sans prévenir les autres.
- Les noms d'objets, les tags et les attributs suivent [[Contrats]]. En ajouter est libre, à condition de les écrire dans la note pendant la même tâche. Renommer ou supprimer un nom déjà utilisé oblige à mettre à jour, dans la même tâche, le code, les objets de Studio et la note.

## Liberté de création

Les notes sont un cadre de départ, pas un cahier des charges. Chaque équipier a ses idées et doit pouvoir les réaliser, quel que soit le sujet ([[Liberté de création]]).

- L'utilisateur veut faire autrement que ce qui est écrit : le faire, puis mettre la note à jour. Ne pas opposer la note à son idée.
- L'idée change les règles du jeu, l'économie ou la monétisation : l'aider à l'écrire dans `Idées/` (un fichier par idée, ouvert à tous) et, si possible, la prototyper.
- Restent fixes : la réservation des tâches, le code dans `src/` envoyé par Rojo, les [[Contrats]] tenus à jour, les règles de Roblox.
- Les plans de mondes et les maquettes d'écrans se dessinent avec Claude Design avant construction ([[Claude Design]]).
- Pour la planche d'un modèle 3D (objet, compagnon, décor), Claude ne dessine pas : il donne le prompt à copier dans Gemini, puis attend l'image de l'équipier avant de modéliser ([[Modèles 3D]], [[Prompts IA]]).

## Règles des notes

- Répondre en français.
- Ne pas explorer Roblox Studio pour retrouver une information déjà écrite dans une note.
- Après un changement dans le jeu (nouveau système, nouvelle valeur d'équilibrage, décision de design), mettre à jour la note concernée, en quelques lignes. Toutes les notes sont modifiables par tous.
- Une note par sujet, courte, avec des liens `[[...]]` vers les notes voisines.
- Un identifiant d'asset (son, image, mesh, animation, produit) s'écrit dans le registre correspondant de `Suivi/Registre/` dès qu'il existe, par celui qui l'a publié.
- Besoin de quelqu'un (avis, aide, objet réservé par un autre) : créer une note dans `Suivi/Demandes/` (un fichier par demande, voir [[Travailler à plusieurs]]).
- Une décision prise par l'équipe s'écrit dans [[Décisions]], par n'importe lequel des trois.

## Fin de tâche

1. Cocher la tâche dans [[Tâches]] avec la date et le poste, et ajouter une ligne au journal du poste.
2. Mettre à jour les notes et les registres concernés.
3. Supprimer sa réservation dans `Suivi/En cours/`.
4. Partager : `git add -A`, `git commit -m "[P2] T-105 tribunes modulaires"` (poste, numéro de tâche, résumé), `git pull --rebase --autostash`, `git push`. Ces commits et ces envois de fin de tâche sont autorisés d'avance par l'équipe.
5. Si du code a changé : synchroniser la place partagée par Rojo, depuis le dépôt à jour ([[Travailler à plusieurs]]).

Le plan complet, tâche par tâche, est dans [[Déroulé du développement]].
