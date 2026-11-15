# Saut

Le cœur du jeu : un saut en trois temps. Voir [[Boucles de gameplay]], [[Map]] pour la piste, [[HUD]] pour l'affichage.

## État actuel

Le joueur court, saute, et la distance est mesurée au premier contact avec le sable. Le jetpack donne 1,5 seconde de poussée. Il n'y a encore ni jauge d'appel ni réception. Depuis T-104 (2026-11-15) : sauts rares tirés au passage de la planche (doré 1 sur 100, × 10 ; légendaire 1 sur 1 000, × 100 et annonce au serveur ; chance × (1 + bonus des Porte-bonheur)), annoncés par un message à l'écran ; anneaux tagués `Anneau` (5 pièces, poussée de 30 donnée par le client, +25 pièces pour 3 anneaux dans un même saut). La piste dorée et la musique du saut rare viendront avec les effets (T-110, T-111). Détails dans [[Scripts]].

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
- **Anneaux** : des anneaux flottent au-dessus du bac. En traverser un donne une petite poussée et des pièces. Trois anneaux d'affilée donnent un bonus.
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

- Le serveur calcule la distance, la qualité de l'appel et le tirage du saut rare. Le client n'envoie que des intentions (« j'appuie sur Saut »).
- Le serveur refuse une distance impossible pour les stats et l'équipement du joueur (borne de plausibilité), ce qui couvre la faille actuelle du jetpack piloté par le client.
- L'atterrissage se détecte par la position du personnage, pas par l'événement de contact, qui devient peu fiable à grande vitesse.
- Avec le passe « Saut automatique », le jeu saute à la place du joueur avec un appel Bon ; il ne fait jamais de saut parfait ([[Monétisation]]).
