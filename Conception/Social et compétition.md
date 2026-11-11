# Social et compétition

Ce qui rend le stade vivant et donne envie de jouer avec les autres. Voir [[Vision]] et [[Boucles de gameplay]].

## Concours de serveur

- Toutes les 10 minutes, une annonce lance un concours de 90 secondes. Ouvert aux joueurs qui ont un record de 30 m.
- Chaque joueur fait autant de sauts qu'il veut ; son meilleur saut compte.
- Pour que les débutants aient leur chance, le classement se fait sur le **pourcentage du record personnel** dans le monde en cours, pas sur la distance brute.
- À la fin, les trois premiers sont téléportés sur le podium : hymne, confettis, médailles.
- Récompenses : gemmes pour le podium, pièces pour tous les participants, un point de concours pour le classement de la semaine.

## Vent favorable

Événement aléatoire, environ toutes les 15 minutes : pendant 60 secondes, les pièces sont doublées pour tout le serveur. Les drapeaux du stade se tendent et une musique démarre. Un joueur peut aussi l'offrir au serveur ([[Monétisation]]) ; son nom est alors annoncé.

## Classements

| Classement | Portée | Remise à zéro |
| --- | --- | --- |
| Record par monde | Mondial | Jamais |
| Catégorie la plus haute | Mondial | Jamais |
| Distance totale de la semaine | Mondial | Chaque lundi |
| Concours gagnés dans la semaine | Mondial | Chaque lundi |
| Meilleur saut du serveur | Serveur | À la fermeture du serveur |

- Des panneaux en jeu affichent les dix premiers, dans le stade de chaque monde.
- Les trois premiers d'un classement de la semaine reçoivent des gemmes et un titre temporaire.
- Le record du serveur est matérialisé par un drapeau planté dans le bac, avec le nom du joueur.

## Jouer avec ses amis

- +10 % de pièces par ami présent dans le serveur, jusqu'à +50 %.
- Bouton d'invitation dans le HUD.
- Les serveurs privés sont gratuits.

## Voir les autres

- Le titre de catégorie et le record sont affichés au-dessus de chaque joueur.
- Un saut légendaire ou un nouveau record du serveur est annoncé à tous.
- Les compagnons et les traînées des autres sont visibles (avec une option pour les cacher).

## Plus tard

- **Duels** : défier un joueur sur un saut, avec une mise en pièces.
- **Clubs** : groupes de joueurs avec un objectif de distance commun chaque semaine.
- **Échanges** de compagnons ([[Compagnons]]).

## Règles techniques

- Les classements mondiaux utilisent des magasins de données ordonnés, mis à jour au plus une fois par minute et par joueur.
- Toute valeur classée est calculée par le serveur ([[Architecture du code]]).
- Les messages annoncés à tous n'affichent que des noms d'utilisateur et des nombres, jamais de texte libre saisi par un joueur.
