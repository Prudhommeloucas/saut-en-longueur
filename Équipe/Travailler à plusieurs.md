# Travailler à plusieurs

Comment trois personnes travaillent en même temps sans se marcher dessus, alors que chacun peut toucher à tout : code, map, écrans, modèles, sons, images. Voir [[Équipe]] et [[Contrats]].

## Deux espaces partagés

| Espace | Ce qu'il contient | Comment il se partage |
| --- | --- | --- |
| Le dépôt git (ce dossier) | Notes, code, sources des modèles, des sons et des images | GitHub : on récupère au début, on envoie à la fin de chaque tâche |
| La place Roblox | Map, interfaces, sons posés, scripts envoyés par Rojo | Team Create : tout changement est visible par les trois en direct |

La place n'est pas dans git : elle vit chez Roblox, qui garde l'historique de ses versions.

## La règle qui évite presque tous les problèmes

**On réserve une tâche avant de la commencer, et on ne touche pas à ce qu'un autre a réservé.**

Il n'y a pas de domaine par personne : la réservation remplace le partage par métier. Elle dit qui fait quoi en ce moment et sur quels fichiers et objets.

### Réserver

1. Choisir une tâche non cochée dans [[Tâches]], dont les dépendances sont faites ([[Déroulé du développement]]) et qui n'a pas de fichier dans `Suivi/En cours/`.
2. Copier [[Modèle de réservation]] dans `Suivi/En cours/T-105.md`. Y écrire ce que la tâche va toucher : dossiers ou fichiers du dépôt (`src/server/Services/Saut.luau`), objets de Studio (`Workspace.Mondes.Monde1.Piste`, `StarterGui.HudSaut`).
3. Envoyer aussitôt : `git commit -m "[P2] T-105 réservée"`, `git pull --rebase --autostash`, `git push`.
4. Si le pull fait apparaître le même fichier, quelqu'un a été plus rapide : retirer sa réservation et en prendre une autre.

Une réservation par personne à la fois, sauf petite tâche liée. Si la liste de ce qu'on touche change en cours de route, mettre le fichier à jour et l'envoyer.

### Pendant la tâche

- Ce qui est listé dans la réservation d'un autre se lit, mais ne se modifie pas. Besoin d'y toucher : s'entendre avec son auteur (demande, message), ou attendre la fin de sa tâche.
- Une réservation sans nouvelle depuis une semaine peut être reprise, après avoir prévenu son auteur.

### Finir

Cocher la tâche dans [[Tâches]], supprimer la réservation, envoyer (voir `CLAUDE.md`).

## Git, en pratique

- Une seule branche, `master`. Les tâches réservées découpent assez le travail, et c'est plus simple pour tout le monde.
- **Début de session** : `git pull --rebase --autostash` (Claude le fait, voir `CLAUDE.md`).
- **Fin de chaque tâche** : valider et envoyer tout de suite. Des envois petits et fréquents rendent les conflits rares.
- Messages de commit : `[P2] T-105 tribunes modulaires`, `[P2] T-105 réservée`.
- Si un conflit apparaît malgré tout, Claude l'explique et le règle, avec l'équipier concerné s'il touche à son travail ; on ne force jamais un envoi.
- Les fichiers binaires (`.blend`, `.fbx`, images, sons) ne se fusionnent pas : un fichier par modèle, et on ne modifie pas celui d'un autre sans le prévenir. Rester sous 20 Mo par fichier ; au-delà, Google Drive.
- Les réglages personnels d'Obsidian, `CLAUDE.local.md` et les copies personnelles de la place sont exclus de git.

## Le code à trois

Tout le monde code. Les règles techniques sont dans [[Architecture du code]] ; voici celles qui évitent les accidents.

### Copie personnelle pour coder et tester

Rojo remplace les scripts de la place par ceux du dossier `src/` de la machine. Si deux personnes branchaient Rojo en même temps sur la place partagée, chacune effacerait le code non envoyé de l'autre. Donc :

1. Dans Studio, ouvrir la place partagée, puis **Fichier > Enregistrer dans un fichier sous** : `copies/ma-copie.rbxl` dans le dossier du projet (exclu de git). Refaire la copie quand la map ou les écrans ont beaucoup changé.
2. Coder dans `src/`, lancer `rojo serve`, connecter Rojo **dans la copie**, tester par le MCP Roblox Studio.
3. Selene et StyLua sans erreur, le jeu se lance sans erreur : envoyer sur GitHub.

### Synchroniser la place partagée

Juste après avoir envoyé du code :

1. `git pull --rebase --autostash`, puis `git status -sb` : aucun changement local, pas de retard sur `origin/master`.
2. `rojo serve`, connecter Rojo dans la place partagée, attendre la fin de la synchronisation, déconnecter aussitôt.

Comme on ne synchronise que depuis la dernière version de GitHub, la place partagée contient toujours exactement le code de `master`. Personne ne modifie un script dans Studio : la synchronisation suivante l'écraserait.

### Fichiers communs à tous les systèmes

`Remotes.luau`, `init.server.luau`, `init.client.luau` et `Config/Textes` sont touchés par presque toutes les tâches de code. Ils ne se réservent pas : on y fait des ajouts courts, sur des lignes à soi, et on les envoie vite. Git fusionne seul des ajouts sur des lignes différentes.

## Team Create, en pratique

- Les trois ouvrent la même place et peuvent toucher à tout l'explorateur, sauf ce qu'une réservation en cours a annoncé.
- Les actions de Claude par le MCP sont immédiates et visibles par tous. Avant une action large (déplacer un dossier, renommer en série, vider un service), prévenir les autres.
- Chacun peut lancer un test de jeu de son côté sans gêner les autres.
- Avant un changement risqué (réorganisation de la map, gros import), l'essayer d'abord dans la place « Test » ([[Lancement]]) ou dans sa copie personnelle.
- En cas d'erreur, l'historique des versions de la place permet de revenir en arrière. Prévenir l'équipe avant de le faire : le retour annule aussi le travail des autres depuis cette version.

## Demandes

Quand on a besoin de quelqu'un (un avis, de l'aide, un objet qu'il a réservé, un bug repéré dans son travail) :

1. Créer une note dans `Suivi/Demandes/`, nommée `AAAA-MM-JJ de P2 à P1 - sujet.md` (ou `à tous`), sur le [[Modèle de demande]].
2. Envoyer sur GitHub.
3. Le destinataire la voit à sa prochaine session (Claude lit les demandes ouvertes qui le concernent), la traite, écrit la réponse dans la note et passe son état à `fait`.

Un fichier par demande : deux personnes n'écrivent donc jamais dans le même fichier. Pour un manque qu'on peut combler soi-même (un tag, un nom d'écran, un son), pas besoin de demande : on le fait, dans sa tâche.

## Avancer sans s'attendre

- Au début de chaque phase, la tâche de contrats (T-100, T-200…) écrit dans [[Contrats]] les noms, tags et identifiants de la phase.
- Les tâches de construction (map, écrans, modèles) suivent ces noms ; les tâches de code utilisent des objets provisoires de même nom, puis une tâche de branchement réunit le tout.
- L'ordre des tâches et leurs dépendances sont dans [[Déroulé du développement]]. Une tâche bloquée se signale dans sa réservation (`bloquée par T-…`) et on passe à une autre.

## Économiser le quota de Claude

- Une session, une tâche. Fermer la session une fois la tâche envoyée.
- Laisser Claude lire [[Projet]], son journal, les réservations et les notes de la tâche, pas tout le coffre.
- Écrire dans les notes ce qui a été appris : la session suivante n'aura pas à le redécouvrir.
