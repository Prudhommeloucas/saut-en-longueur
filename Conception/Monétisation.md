# Monétisation

Comment le jeu gagne des Robux, et les règles à respecter. Voir [[Économie]] et [[Vision]]. Les identifiants des passes et produits sont dans [[Registre des produits]].

## Principes

- Tout le contenu de jeu est accessible sans payer. Payer fait gagner du temps, du confort ou du style.
- Les achats répétables (produits) rapportent plus que les achats uniques (passes) sur la durée : c'est là qu'il faut soigner l'offre.
- Le public est jeune : pas de faux compte à rebours, pas de fenêtre d'offre à répétition (une proposition par session au plus), prix toujours affiché avant l'achat.

## Passes (achat unique)

| Passe | Effet | Prix de départ (Robux) |
| --- | --- | --- |
| VIP | Zone d'entraînement VIP, pièces × 1,2, titre dans le chat, un tour de roue en plus par jour | 399 |
| Pièces × 2 | Double les pièces des sauts | 299 |
| Entraînement × 2 | Double le gain des zones | 299 |
| Entraînement automatique | Joue le rythme à la place du joueur (qualité Bon) | 149 |
| Saut automatique | Enchaîne les sauts sans intervention (appel Bon) | 199 |
| Deux emplacements de compagnons | Deux compagnons équipés en plus | 399 |
| Éclosion triple | Ouvre trois œufs à la fois | 249 |
| Éclosion automatique | Ouvre des œufs en continu | 149 |
| Chance aux œufs × 2 | Double les chances des raretés hautes | 499 |
| Grand inventaire | 100 places de compagnons en plus | 99 |
| Repos prolongé | Gains hors ligne jusqu'à 12 heures | 199 |

## Produits (achat répétable)

| Produit | Contenu | Prix de départ (Robux) |
| --- | --- | --- |
| Gemmes | 100, 550, 1 500, 5 000, 15 000 | 49, 199, 499, 1 499, 3 999 |
| Boost de 15 min | Pièces × 2, entraînement × 2 ou chance × 2 | 29 |
| Boost d'une heure | Idem | 79 |
| Vent favorable | 5 minutes de pièces doublées pour tout le serveur, nom annoncé | 99 |
| Tours de roue | 3 tours | 49 |
| Catégorie immédiate | Monte d'une catégorie sans la condition de stats | 149 |
| Œuf exclusif | Œuf d'événement, à l'unité ou par trois | 149, 399 |
| Pass de saison | Voie de récompenses premium de la saison ([[Lancement]]) | 399 |
| Cadeau | Offrir un passe à un autre joueur du serveur | Prix du passe |

## Offres

- **Pack de départ** (une seule fois, 99 Robux) : un compagnon épique exclusif, 500 gemmes, un boost d'une heure. Proposé entre la 10e minute et le 3e jour de jeu.
- **Offre de catégorie** : à la première montée de catégorie, un lot passes × 2 à prix réduit.
- **Offres d'événement** : œuf et cosmétiques de la période.

## Autres revenus

- **Programme de récompenses des créateurs de Roblox** : Roblox rémunère l'engagement et les dépenses des joueurs. Un jeu où l'on reste longtemps et où l'on revient chaque jour est mieux rémunéré, d'où l'importance des cadeaux de temps de jeu et de la connexion quotidienne. Les règles exactes changent : les relire sur le Creator Hub avant le lancement.
- **Abonnement** « Club des champions » (mensuel) : gemmes chaque jour, pièces × 1,5, aura exclusive. Soumis à des conditions d'accès côté Roblox, à vérifier.
- **Publicités récompensées** (regarder une vidéo contre un boost de 5 minutes) : possible seulement si le jeu remplit les conditions de Roblox, à vérifier après le lancement.
- **Bonus Premium** : +10 % de pièces pour les abonnés Roblox Premium, ce qui les incite à rester.

## Règles Roblox à respecter

- **Tirages payants** : les chances de chaque œuf sont affichées avant l'achat. Dans les pays où les tirages payants sont interdits, `PolicyService` l'indique : le jeu y masque les œufs en gemmes et en Robux.
- **Livraison des achats** : uniquement par le serveur, dans le traitement officiel des reçus. Chaque reçu traité est enregistré pour ne jamais livrer deux fois, et n'est confirmé qu'une fois la sauvegarde réussie.
- **Abonnements et publicités** : affichés seulement si `PolicyService` les autorise pour ce joueur.
- **Aucun paiement hors de Roblox**, aucun lien vers un site de vente.
- Le questionnaire de maturité de l'expérience doit être rempli avant publication ([[Lancement]]).

## Répartition dans l'équipe

Le jeu est publié sous un groupe Roblox. Les Robux arrivent sur le groupe et sont répartis par les versements du groupe. La clé de répartition est à décider ([[Décisions]]). Roblox reverse environ 70 % du prix de chaque vente en jeu ; la conversion en argent réel passe par le programme DevEx, dont le seuil et le taux sont à relire sur le site de Roblox.

## Suivi

Dès la publication, suivre par semaine : part de joueurs qui achètent, revenu moyen par joueur actif, produits les plus vendus. Changer un seul prix à la fois, pendant une semaine, pour pouvoir comparer.
