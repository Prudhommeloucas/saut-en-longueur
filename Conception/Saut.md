# Saut

Le cœur du jeu : un saut en trois temps. Voir [[Boucles de gameplay]], [[Map]] pour la piste, [[HUD]] pour l'affichage.

## État actuel

Le joueur court et saute. Depuis T-102 (2026-11-18), le serveur détecte l'atterrissage par la position : à chaque image, il regarde sous les pieds du joueur et l'atterrissage compte quand le sable est à moins de 1 stud et que le joueur ne monte plus. C'est plus juste que l'ancien contact, qui se déclenchait environ 1 m trop tôt. Un saut plus long que la portée maximale calculée pour les stats et l'équipement du joueur est refusé : pas de pièces ni de record, un message, et un avertissement dans la sortie. Le jetpack donne 1,5 seconde de poussée ; le serveur compte le temps annoncé et éteint les flammes au-delà. La caméra recule pendant le vol (`Config/Camera`). Depuis T-101 (2026-11-18), l'appel est jugé : au décollage, la qualité (Parfait, Bon, Correct, Mordu ; plus de 6 m avant le bord, ce n'est pas un appel) multiplie la vitesse verticale du saut. Une jauge provisoire montre les zones, la qualité s'affiche au décollage puis dans le résultat. La planche du monde 1 fait 0,5 m, donc la zone Parfait est la planche entière ; le premier mètre de sable est la zone où l'on peut mordre, les pas qui y tombent ne comptent pas comme atterrissage. Depuis T-103 (2026-11-18), la réception, le saut parfait et la série sont en place, comme décrit plus bas. Un indice provisoire (un anneau qui se referme et devient vert dans les 0,3 dernières secondes) aide à viser. Un seul essai par saut : le premier nouvel appui pendant la descente. Garder Saut enfoncé pour le jetpack ne compte pas, il faut relâcher puis réappuyer. Avec un appel Bon ou Correct, une réception réussie donne +10 % sans toucher à la série ; la série augmente seulement avec un saut parfait, et repart à zéro sur un appel mordu ou une réception ratée. La série n'est pas sauvegardée entre deux parties. La roulade, la chute comique et l'ovation viendront avec les animations et le décor (T-107, T-118). Depuis T-104 (2026-11-15) : sauts rares tirés au passage de la planche (doré 1 sur 100, × 10 ; légendaire 1 sur 1 000, × 100 et annonce au serveur ; chance × (1 + bonus des Porte-bonheur)), annoncés par un message à l'écran ; anneaux tagués `Anneau` (5 pièces, poussée de 20 donnée par le client, 30 à l'origine, +25 pièces pour 3 anneaux dans un même saut). La piste dorée et la musique du saut rare viendront avec les effets (T-110, T-111). Détails dans [[Scripts]].

## Cible : les trois temps

### 1. L'appel

- Le joueur court sur la piste d'élan (30 m) et appuie sur Saut près de la planche d'appel.
- La qualité dépend de la position des pieds par rapport au bord de la planche au moment de l'appui :

| Qualité | Position | Effet sur la puissance de saut |
| --- | --- | --- |
| Parfait | Dans les 0,5 derniers mètres de la planche | × 1,25 |
| Bon | Entre 0,5 et 1,5 m avant le bord | × 1,10 |
| Correct | Plus tôt | × 1,00 |
| Mordu | Après le bord | × 0,80, et la série de sauts parfaits s'arrête |

- Une jauge se remplit pendant la course et montre la zone parfaite ([[HUD]]). La zone parfaite s'élargit avec les talents ([[Rebirth et talents]]).
- Plus la vitesse est grande, plus la fenêtre est courte en temps : la difficulté monte naturellement avec la progression.

### 2. Le vol

- **Propulseur** : maintenir Saut en l'air brûle le carburant et pousse vers le haut et l'avant. Le meilleur moment est le sommet de la trajectoire. Carburant et force dépendent du propulseur ([[Équipement]]).
- **Anneaux** : des anneaux flottent au-dessus du bac. En traverser un donne une petite poussée et des pièces. Trois anneaux d'affilée donnent un bonus. Un anneau pris en descente relance le joueur comme un rebond (vitesse vers le haut d'au moins 20). La poussée vers l'avant était effacée par le Humanoid ; depuis le correctif du 2026-11-22, l'élan de chaque anneau (la moitié de la poussée, +10 studs/s) tient jusqu'au sol, comme le prévoyait déjà la borne `porteeMax`. Poussée `ANNEAU_POUSSEE` passée de 30 à 20 le même jour : avec 30, un joueur entraîné passait de 36 à 108 m. Effet mesuré avec 20 : débutant 5 → 14 m, joueur entraîné 38 → 66 m. Placement des trois séries dans [[Construction du monde 1]].
- **Vol plané** (à partir du monde 2) : avec des ailes, maintenir le bouton Planer réduit la chute. La stat Aéro règle l'efficacité ([[Entraînement]]).
- **Effets du monde** : rafales, courants ascendants, rebonds, faible gravité ([[Mondes]]).
- Un compteur de distance défile en direct, la caméra recule et le champ de vision s'élargit avec la vitesse.

### 3. La réception

- Appuyer sur Saut dans les 0,3 seconde avant le contact avec le sol.
- Réussie : roulade, +10 % de pièces. Ratée : chute comique, aucun malus.

## Bonus de maîtrise

- **Saut parfait** : appel parfait et réception réussie. Pièces × 1,5 et ovation du public.
- **Série** : chaque saut parfait consécutif ajoute +10 % de pièces, jusqu'à +100 %. Un appel mordu ou une réception ratée remet la série à zéro.

## Sauts rares

Tirés au sort par le serveur à chaque saut. Le joueur est prévenu au moment de l'appel (piste dorée, musique).

| Saut | Chance de base | Effet |
| --- | --- | --- |
| Doré | 1 sur 100 | Pièces × 10 |
| Légendaire | 1 sur 1 000 | Pièces × 100, annonce à tout le serveur |

La chance augmente avec les talents et les compagnons porte-bonheur.

## Calcul des pièces d'un saut

`pièces = distance (m) × multiplicateur du monde × (1 + bonus de maîtrise) × multiplicateurs permanents × saut rare`

Le détail est affiché ligne par ligne sur l'écran de résultat. Les multiplicateurs sont listés dans [[Économie]].

## Règles techniques à respecter

- Le serveur calcule la distance, la qualité de l'appel et le tirage du saut rare. Le client n'envoie que des intentions (« j'appuie sur Saut »). Exception pour l'appel (T-101) : le client envoie sa position au décollage, et le serveur, qui voit le joueur avec un peu de retard, la retient si elle est à moins de vitesse × (2 × ping + 0,15 s) + 2 studs de la sienne ; sinon il garde la sienne. En test, sans cette marge, un appel Bon était jugé Correct.
- Le serveur refuse une distance impossible pour les stats et l'équipement du joueur (borne de plausibilité), ce qui couvre la faille du jetpack piloté par le client. Fait à T-102 : `Config/Saut.porteeMax` simule le meilleur cas (appel Parfait, toute la poussée des anneaux traversés, jetpack poussé jusqu'au bout), puis multiplie par 1,2 et ajoute 3 m. Exemples : sans entraînement, 9,1 m au plus pour 5,2 m réels ; avec le jetpack, 22,6 m au plus pour 17,9 m réels. Toute nouvelle façon d'aller plus loin (ailes, rafales, talents) doit être ajoutée à ce calcul, sinon les bons sauts seront refusés.
- L'atterrissage se détecte par la position du personnage, pas par l'événement de contact, qui devient peu fiable à grande vitesse.
- Avec le passe « Saut automatique », le jeu saute à la place du joueur avec un appel Bon ; il ne fait jamais de saut parfait ([[Monétisation]]).
