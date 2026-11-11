# Travailler à plusieurs

Comment trois personnes travaillent en même temps sans se marcher dessus. Voir [[Équipe]] et [[Contrats]].

## Deux espaces partagés

| Espace | Ce qu'il contient | Comment il se partage |
| --- | --- | --- |
| Le dépôt git (ce dossier) | Notes, code, sources des modèles, des sons et des images | GitHub : on récupère au début, on envoie à la fin de chaque tâche |
| La place Roblox | Map, interfaces, sons posés, scripts envoyés par Rojo | Team Create : tout changement est visible par les trois en direct |

La place n'est pas dans git : elle vit chez Roblox, qui garde l'historique de ses versions.

## La règle qui évite presque tous les problèmes

**Chacun ne modifie que ce qui appartient à son poste.**

| | Poste 1 | Poste 2 | Poste 3 |
| --- | --- | --- | --- |
| Dossiers du dépôt | `src/`, configuration, `Conception/`, Contrats, Architecture, Décisions | `assets/modeles/`, `assets/animations/`, `assets/plans/`, registres modèles et animations | `assets/sons/`, `assets/images/`, registres sons, images, produits |
| Ouvert à tous | `Idées/` et `Suivi/Demandes/`, un fichier par idée ou par demande, chacun n'écrit que dans les siens | | |
| Notes de réalisation | Scripts, Architecture du code, Contrats, Lancement | Map, Décor et effets, Modèles 3D, Animations | HUD, Sons et musique, Images, Direction artistique |
| Studio | `ServerScriptService`, `ReplicatedStorage.Shared`, `StarterPlayer` | `Workspace`, `Lighting`, `ReplicatedStorage.Assets`, `ServerStorage.Modeles` | `StarterGui`, `SoundService`, `ReplicatedStorage.Assets.Effets` |
| Suivi | Son fichier de suivi | Son fichier de suivi | Son fichier de suivi |

Une note qui appartient à un autre poste se lit, mais ne se modifie pas : on dépose une demande.

## Git, en pratique

- Une seule branche, `master`. Pas de branches par personne : les zones réservées suffisent, et c'est plus simple pour tout le monde.
- **Début de session** : `git pull --rebase --autostash` (Claude le fait, voir `CLAUDE.md`).
- **Fin de chaque tâche** : valider et envoyer tout de suite. Des envois petits et fréquents rendent les conflits quasi impossibles.
- Message de commit : `[P2] T-105 tribunes modulaires`.
- Si un conflit apparaît malgré tout, Claude l'explique et le règle avec l'équipier concerné ; on ne force jamais un envoi.
- Les fichiers binaires (`.blend`, `.fbx`, images, sons) ne se fusionnent pas : un fichier par modèle, et seul son auteur le modifie. Rester sous 20 Mo par fichier ; au-delà, Google Drive.
- Les réglages personnels d'Obsidian et `CLAUDE.local.md` sont exclus de git.

## Team Create, en pratique

- Les trois ouvrent la même place ; chacun travaille dans sa zone de l'explorateur.
- Les actions de Claude par le MCP sont immédiates et visibles par tous. Avant une action large (déplacer un dossier, renommer en série), prévenir les autres.
- Chacun peut lancer un test de jeu de son côté sans gêner les autres.
- Les scripts n'arrivent dans la place que par Rojo, depuis le Poste 1. Personne ne les modifie dans Studio : la prochaine synchronisation écraserait le changement.
- Avant un changement risqué (réorganisation de la map, gros import), le poste concerné l'essaie d'abord dans la place « Test » ([[Lancement]]).
- En cas d'erreur, l'historique des versions de la place permet de revenir en arrière. Prévenir l'équipe avant de le faire : le retour annule aussi le travail des autres depuis cette version.

## Demandes entre postes

Quand un poste a besoin de quelque chose d'un autre (un nouveau tag, un nom d'élément d'interface, un son manquant, un bug) :

1. Créer une note dans `Suivi/Demandes/`, nommée `AAAA-MM-JJ de P2 à P1 - sujet.md`, sur le [[Modèle de demande]].
2. Envoyer sur GitHub.
3. Le poste destinataire la voit à sa prochaine session (Claude lit les demandes ouvertes qui le concernent), la traite, puis écrit la réponse dans la note et passe son état à `fait`.

Un fichier par demande : deux personnes n'écrivent donc jamais dans le même fichier.

## Avancer sans s'attendre

- Le Poste 1 publie les [[Contrats]] et les listes d'identifiants au début de chaque phase.
- Les Postes 2 et 3 construisent d'après les contrats ; le Poste 1 code avec des objets provisoires de même nom.
- L'ordre des tâches et leurs dépendances sont dans [[Déroulé du développement]]. Une tâche bloquée se signale dans le fichier de suivi (`bloquée par T-…`) et on passe à la suivante.

## Économiser le quota de Claude

- Une session, une tâche. Fermer la session une fois la tâche envoyée.
- Laisser Claude lire [[Projet]], son fichier de suivi et les notes de la tâche, pas tout le coffre.
- Écrire dans les notes ce qui a été appris : la session suivante n'aura pas à le redécouvrir.
