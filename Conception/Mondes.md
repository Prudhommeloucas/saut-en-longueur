# Mondes

Six mondes, chacun avec une physique de saut différente. Voir [[Vision]], [[Map]] pour ce qui est construit et [[Direction artistique]] pour l'ambiance.

Le monde 1 existe et le monde 2 est le prochain. **Les thèmes des mondes 3 à 6 sont des pistes** : chaque équipier peut proposer son propre monde dans `Idées/`, à condition qu'il apporte une nouvelle façon de sauter ([[Liberté de création]]). Le plan de chaque monde se dessine d'abord avec [[Claude Design]].

## Vue d'ensemble

| # | Monde | Ce qui change dans le saut | Accès | Longueur du bac | Pièces |
| --- | --- | --- | --- | --- | --- |
| 1 | Stade des Débuts | Règles de base, anneaux | Départ | 500 m | × 1 |
| 2 | Plage des Alizés | Rafales de vent arrière, vol plané (stat Aéro) | Record de 150 m au monde 1 | 1 500 m | × 5 |
| 3 | Canyon du Vertige | Appel au bord d'une falaise, courants ascendants à enchaîner | Record de 600 m au monde 2, catégorie Amateur | 4 km | × 25 |
| 4 | Pic Givré | Tremplin de saut à ski, piste d'élan glacée en descente | Record de 2 km au monde 3 | 8 km | × 150 |
| 5 | Métropole Néon | Rebonds sur les toits (un geste par rebond), anneaux mobiles | Record de 5 km au monde 4, catégorie National | 15 km | × 1 000 |
| 6 | Base Lunaire | Faible gravité, propulseur beaucoup plus efficace | Record de 10 km au monde 5 | 40 km | × 8 000 |

Les seuils et multiplicateurs sont des valeurs de départ ([[Économie]]).

## Ce que contient chaque monde

- Un spawn avec trois paliers de zones d'[[Entraînement]] par stat.
- Une piste, une planche d'appel (ou son équivalent) et une zone d'atterrissage.
- Trois objets par famille d'[[Équipement]] et deux œufs de [[Compagnons]].
- Un record et un classement propres ([[Social et compétition]]).
- Un portail vers le monde suivant, qui affiche la condition d'accès.
- Une ambiance sonore et une musique ([[Sons et musique]]).

Une fois ouvert, un monde est accessible à tout moment par l'écran de téléportation.

## Détail des mécaniques

- **Stade des Débuts** : le bac sort du stade et traverse cinq décors de 100 m (stade, parc, lac, ville, collines). Aucune physique nouvelle, seulement le plaisir de découvrir plus loin. Plan dans [[Construction du monde 1]].
- **Plage des Alizés** : une manche à air montre la force du vent. Sauter pendant une rafale ajoute de la vitesse. Le joueur apprend à attendre le bon moment. La soufflerie d'entraînement Aéro et les premières ailes (cerf-volant) s'achètent ici.
- **Canyon du Vertige** : la planche est au bord du vide, le vol dure plus longtemps. Des colonnes d'air chaud, visibles par leurs particules, redonnent de la hauteur à qui les traverse en planant.
- **Pic Givré** : la piste d'élan descend sur de la glace et se termine par un tremplin relevé. L'appel se fait en bout de tremplin. Des bourrasques de neige réduisent parfois la visibilité.
- **Métropole Néon** : des auvents et des trampolines sur les toits permettent de rebondir. Chaque rebond demande un appui au bon moment, comme une réception. Le saut devient une suite de rebonds.
- **Base Lunaire** : la gravité est divisée par six. Les vols sont lents et très longs, le carburant devient la ressource principale.

## Échelle des distances

Un saut de 40 km ne tient pas dans une map Roblox à 4 studs par mètre : au-delà d'environ 50 000 studs de l'origine, l'affichage se dégrade. Chaque monde a donc sa propre échelle, stockée dans sa configuration :

| Monde | Studs par mètre |
| --- | --- |
| 1 et 2 | 4 |
| 3 et 4 | 2 |
| 5 | 1 |
| 6 | 0,5 |

Le décor lointain de ces mondes est construit en conséquence. Ce principe est à valider par un prototype au moment du monde 3, avant de construire les suivants.

## Ordre de livraison

1. Monde 1 complet et soigné : c'est le jeu de lancement, avec le monde 2.
2. Monde 3 comme première grande mise à jour, puis un monde toutes les quatre à six semaines ([[Lancement]]).

Chaque monde vit dans son propre dossier de `Workspace` et se charge à la demande, pour que les téléphones tiennent ([[Contrats]]).
