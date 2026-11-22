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

## Règle d'équilibrage

Les récompenses gratuites cumulées doivent permettre à un joueur régulier d'ouvrir un œuf d'or tous les deux jours environ. Les sources et les dépenses de gemmes sont suivies dans [[Économie]].
