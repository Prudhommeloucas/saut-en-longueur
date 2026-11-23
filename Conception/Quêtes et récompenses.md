# Quêtes et récompenses

Tout ce qui donne un objectif précis et une raison de revenir. Voir [[Boucles de gameplay]] et [[Économie]].

## Quêtes du jour

- Trois quêtes tirées au sort chaque jour, remises à zéro à minuit (heure UTC). Disponibles à partir d'un record de 10 m.
- Exemples : « Fais 20 sauts », « Réussis 5 appels parfaits », « Gagne 5 000 points de Puissance », « Traverse 30 anneaux », « Fais éclore 3 œufs », « Bats ton record ».
- Les objectifs s'adaptent au niveau du joueur (un pourcentage de ses stats ou de son record).
- Récompenses : gemmes et pièces. Les trois quêtes finies donnent un coffre bonus.
- Une quête peut être remplacée une fois par jour gratuitement.

## Quêtes de la semaine

Cinq quêtes plus longues, remises à zéro le lundi. Récompenses plus fortes : gemmes, œuf, boost.

## Défis de carrière

Succès à paliers, sans limite de temps : distance totale sautée, nombre de sauts parfaits, plus longue série, œufs ouverts, catégories franchies, concours gagnés. Chaque palier donne des gemmes ; certains donnent un titre ou une traînée.

## Paliers de record

Une échelle par monde : 10 m, 25 m, 50 m, 100 m, 150 m, etc. Chaque palier franchi donne une récompense à réclamer et, pour certains, ouvre une fonction ([[Boucles de gameplay]]). L'échelle est affichée en permanence avec le prochain palier et sa récompense : c'est l'objectif à court terme le plus visible du jeu.

En place depuis T-204 (2026-11-22), dans `Config/Paliers.ECHELLE`, pour le monde 1 :

| Palier | Gemmes | Pièces |
| --- | --- | --- |
| 10 m | 5 | 20 |
| 25 m | 10 | 50 |
| 50 m | 15 | 150 |
| 75 m | 20 | 300 |
| 100 m | 30 | 600 |
| 150 m | 50 | 1 500 |
| 200 m | 60 | 3 000 |
| 300 m | 80 | 8 000 |
| 400 m | 100 | 20 000 |
| 500 m | 150 | 50 000 |

- **Récompense** : elle se prend une seule fois (profil : `paliers.reclames`, clé « monde:record »).
- **Réclamation** : tant que `Paliers.RECLAMATION_AUTO` est vrai, la récompense est donnée tout de suite, avec une bannière. Quand `EcranPaliers` existera (T-209), on passera ce réglage à faux et le joueur réclamera par l'événement `ReclamerPalier`.
- **Rattrapage** : les paliers déjà dépassés sont donnés au chargement.
- **Affichage provisoire** (`PaliersProvisoire`) : « Prochain palier : 25 m (+10 gemmes) » en haut de l'écran, avec une barre de progression. `TextePalier` et `BarrePalier` iront dans `HudPrincipal` (T-109).

## Récompense de connexion

Calendrier de 7 jours qui se répète. La récompense grandit chaque jour ; le jour 7 donne un œuf d'or. Une série interrompue reprend au jour 1.

## Cadeaux de temps de jeu

Huit cadeaux par session, à 5, 10, 20, 30, 45, 60, 90 et 120 minutes de présence. Le compteur est visible dans le HUD.

## Roue quotidienne

Un tour gratuit par jour : pièces, gemmes, boost, et une petite chance de compagnon rare. Des tours supplémentaires s'achètent ([[Monétisation]]).

## Coffre du groupe

Les membres du groupe Roblox du jeu ouvrent un coffre gratuit toutes les 24 heures. Cela fait grandir le groupe, qui sert à annoncer les mises à jour.

## Codes

Des codes publiés avec chaque mise à jour donnent pièces, gemmes ou boosts. Ils se saisissent dans les réglages.

## Boosts

Récompense courante de tous ces systèmes. Un boost dure 15 minutes de jeu et double l'un de ces gains : pièces, entraînement ou chance aux œufs. Les boosts s'empilent en durée, pas en puissance.

## En place (T-205, 2026-11-22)

- **Configuration** dans `Config/Recompenses`.
- **Service `Recompenses`** :
  - il compte la progression : sauts, appels parfaits, anneaux, points de stats, œufs, records battus, distance totale, plus longue série ;
  - les services `Saut`, `Anneaux`, `Entrainement` et `Oeufs` appellent `Recompenses.compter` ;
  - tout est gardé dans le profil (`recompenses`), sauf les cadeaux de temps de jeu, qui valent pour la session.
- **Quêtes du jour** : 3 tirées parmi 6 modèles (sauts, appels parfaits, anneaux, stats, œufs, record).
  - L'objectif de stats vaut un cinquième des stats du joueur, au moins 500.
  - Récompense : 10 gemmes et des pièces égales à 10 × le record.
  - Coffre bonus : 20 gemmes, 20 × le record en pièces, et un boost pièces.
  - Elles s'ouvrent à 10 m. On peut changer une quête par jour.
- **Quêtes de la semaine** : 5 fixes (300 sauts, 60 parfaits, 200 anneaux, 20 œufs, 10 records), avec des gemmes et des boosts.
- **Défis de carrière** :
  - distance totale : 100 m à 1 000 km ;
  - appels parfaits : 10 à 5 000 ;
  - série : 3 à 10 ;
  - œufs : 5 à 500.

  Les paliers donnent 10, 20, 40, 80, puis 150 gemmes.
- **Connexion** : 100 pièces, 10 gemmes, 500 pièces, boost pièces, 25 gemmes, 2 000 pièces avec un boost entraînement, puis 150 gemmes au jour 7. Simplification : 150 gemmes plutôt qu'un œuf d'or, c'est le prix d'un œuf d'or.
- **Cadeaux de temps de jeu** : aux 8 moments de la note, de 50 pièces à 14 gemmes avec un boost chance.
- **Roue** : 8 cases pondérées, de 200 pièces au gros lot de 150 gemmes (1 chance sur 100).
- **Coffre du groupe** : 15 gemmes et 500 pièces toutes les 24 h, pour les membres d'OGC Studio (`IsInGroup`).
- **Codes** : écrits dans le service, côté serveur seulement, pour qu'un tricheur ne puisse pas les lire. Pour l'instant `LANCEMENT` (50 gemmes) et `SAUTDORE` (1 000 pièces et un boost pièces), à changer à chaque annonce. Majuscules et espaces ignorés, un seul usage par joueur.
- **Boosts** : attributs `BoostPieces`, `BoostEntrainement`, `BoostChance` (secondes de jeu restantes). Ils doublent les pièces d'un saut, le gain d'entraînement ou la chance aux œufs.
- **Écran provisoire** : bouton « Récompenses » et panneau `RecompensesProvisoire`. Les vrais écrans viendront avec T-210.
- **Événements** : `ActionRecompense` (joueur → serveur), `RecompensesEtat` et `ResultatRoue` (serveur → joueur).
- **Testé dans la copie** : chaque récompense ne se prend qu'une fois. Code inconnu ou déjà utilisé, roue déjà tournée, quête pas finie, cadeau pas encore atteint, quêtes fermées sous 10 m : tous refusés avec un message. Le boost pièces double bien les pièces (14 → 28).

- **Sur la place centrale (T-218, T-219, 2026-11-23)** : les quêtes du jour et le coffre du jour, les quêtes de la semaine et les défis s'affichent et se réclament sur le **tableau des quêtes** (contrôleur `TableauQuetes`, une SurfaceGui par joueur sur l'écran du tableau, pastille rouge au-dessus quand quelque chose est à réclamer). Le coffre du jour n'est ouvrable qu'une fois les quêtes du jour prises. Les cadeaux de temps de jeu se prennent au **cadeau** de la place : compte à rebours au-dessus, invite Ouvrir (E) qui donne le premier cadeau prêt de la session, couvercle qui saute (événement `CadeauOuvert`). Le panneau provisoire « Récompenses » ne garde que les boosts, la connexion, la roue, le coffre du groupe et les codes (T-210).

## Règle d'équilibrage

Les récompenses gratuites cumulées doivent permettre à un joueur régulier d'ouvrir un œuf d'or tous les deux jours environ. Les sources et les dépenses de gemmes sont suivies dans [[Économie]].
