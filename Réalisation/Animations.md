# Animations

Liste des animations et façon de les produire. Voir [[Modèles 3D]], [[Saut]] et [[Registre des animations]].

## Point important

Une animation ne se joue dans un jeu que si elle appartient au propriétaire du jeu. Le jeu étant publié sous un groupe Roblox, **toutes les animations doivent être publiées sous ce groupe**, pas sous un compte personnel ([[Installation]]).

## Chaîne de production

1. Les personnages sont des avatars R15 standard.
2. Création, au choix :
   - **Éditeur d'animation de Studio** : le plus direct pour des animations courtes. Le MCP Roblox Studio peut poser les clés par script, l'équipier ajuste à la main.
   - **Blender** avec un squelette R15 et l'extension d'export d'animation vers Roblox : mieux pour les mouvements complexes.
   - **Capture d'animation de Studio** (à partir d'une vidéo) pour une base à retoucher, si l'outil est disponible sur le compte.
3. Publication sous le groupe, identifiant inscrit dans [[Registre des animations]].
4. Un objet `Animation` portant l'identifiant est déposé dans `ReplicatedStorage.Assets.Animations`, nommé par son identifiant texte.

Les fichiers source vont dans `assets/animations/`.

## Liste

| Identifiant | Description | Durée | Boucle | Priorité |
| --- | --- | --- | --- | --- |
| `course_elan` | Course penchée en avant, grands mouvements de bras | 0,6 s | Oui | Mouvement |
| `appel` | Dernière foulée, genou levé, bras lancés vers le haut | 0,3 s | Non | Action |
| `vol` | Jambes qui pédalent, bras en balancier | 1 s | Oui | Action |
| `vol_propulseur` | Corps droit, bras le long du corps, tremblement | 0,5 s | Oui | Action |
| `vol_plane` | Bras et jambes écartés (monde 2) | 1 s | Oui | Action |
| `reception_reussie` | Jambes en avant, glissade, roulade, relevé bras levés | 1,2 s | Non | Action |
| `reception_ratee` | Chute à plat ventre, tête dans le sable | 1,5 s | Non | Action |
| `celebration_record` | Saut de joie, poing levé | 1,5 s | Non | Action |
| `squat` | Flexion complète avec barre sur les épaules | 1 s | Oui | Action |
| `mollets` | Montées sur la pointe des pieds | 0,5 s | Oui | Action |
| `tapis` | Course sur place | 0,5 s | Oui | Action |
| `soufflerie` | Corps à l'horizontale, flottant (monde 2) | 2 s | Oui | Action |
| `podium_1`, `podium_2`, `podium_3` | Bras levés ; applaudissement ; salut | 3 s | Oui | Action |
| `eclosion_attente` | Mains jointes, impatience | 1 s | Oui | Action |

Le rythme de `squat` et de `mollets` doit suivre le battement de l'entraînement actif : une répétition par seconde ([[Entraînement]]).

## Compagnons

Les compagnons n'ont pas de squelette. Leur mouvement (bonds derrière le joueur, saut en même temps que lui, tremblement de joie) est fait par le code, à partir du modèle ([[Architecture du code]]).

## Objets animés par le code

Œuf qui tremble puis se fend, anneaux qui tournent, drapeaux, roue, public en vague, portail. Les modèles sont livrés avec des parties séparées et nommées ; le code les anime.

Les mouvements simples et répétés du décor (rotation, flottement, balancement, pulsation) passent par le tag `DecorAnime` de [[Contrats]] : un seul module client anime tous les objets tagués proches du joueur ([[Construction du monde 1]]).

## Décor à squelette

Exception décidée le 2026-11-12 : la **mascotte géante** du stade, et tout personnage de décor au mouvement organique, a un squelette et des animations faites dans Blender. Elles suivent la même règle de publication sous le groupe et s'inscrivent au [[Registre des animations]]. La procédure d'import d'un modèle à squelette et de ses animations est à vérifier dans la documentation Roblox au premier essai.

| Identifiant | Description | Boucle |
| --- | --- | --- |
| `mascotte_attente` | Respiration, regard qui balaie le stade | Oui |
| `mascotte_applaudit` | Applaudissement après un saut parfait | Non |
| `mascotte_record` | Saut de joie, bras levés | Non |
| `mascotte_salut` | Signe de la main à l'arrivée d'un joueur | Non |
