# Économie

Monnaies, formules et rythme de progression visé. Voir [[Boucles de gameplay]]. Toutes les valeurs de cette note sont des points de départ : elles vivent dans les modules de configuration ([[Architecture du code]]) et se règlent par simulation puis par test.

## Trois monnaies

| Monnaie | On la gagne | On la dépense |
| --- | --- | --- |
| Pièces | En sautant | [[Équipement]] et ses niveaux, œufs courants |
| Gemmes | Quêtes, paliers, connexion, concours, index, achat en Robux | Œufs d'or, tours de roue, boosts, remise à zéro des talents, cosmétiques |
| Médailles | En changeant de catégorie | Arbre de talents ([[Rebirth et talents]]) |

Les pièces sont remises à zéro au changement de catégorie ; les gemmes et les médailles jamais.

## Formules

**Gain d'entraînement par battement** ([[Entraînement]])

`palier de zone × matériel × (1 + bonus Coach des compagnons) × (1 + nombre de catégories) × talents × passes × boost × qualité du rythme`

**Capacités physiques**

`vitesse de course = base + k × Vitesse^p` et `puissance de saut = base + k × Puissance^p`, avec `p` entre 0,25 et 0,3 et un plafond par monde. Doubler une stat doit donner au moins 8 % de distance.

En place depuis T-201 (2026-11-22), dans `Config/Stats` : vitesse = 26 + 4,4 × Vitesse^0,25, saut = (62 + 6,6 × Puissance^0,25) × chaussures, plafonds par monde dans `Config/Mondes` (monde 1 : 300 et 600, soit 504 m au plus). Doubler une stat donne +10 à +16 % de distance aux niveaux simulés.

**Bonus de débutant** (T-201, décision de Loucas : les 20 premières minutes doivent avancer vite) : le gain d'entraînement est multiplié par 10 avec un record nul, puis le bonus baisse en ligne droite jusqu'à × 1 à 60 m (`Stats.BONUS_DEBUTANT`, appliqué par le service `Entrainement`). C'est le premier multiplicateur de la formule du gain ; à afficher au joueur (T-209).

**Pièces d'un saut** ([[Saut]])

`distance (m) × multiplicateur du monde × (1 + maîtrise) × tenue × (1 + bonus Trésorier) × traînée × talents × amis × passes × boost × saut rare`

**Prix**

- Équipement : chaque objet coûte environ 15 fois le précédent de sa famille au sein d'un monde.
- Niveaux d'un objet : la moitié du prix d'achat, puis le double à chaque niveau.
- Seuil de catégorie : 10 000 points de stats, puis × 2,5 à chaque rang.

## Rythme visé

| Étape | Temps de jeu cumulé |
| --- | --- |
| Premier achat | 1 min |
| Premier compagnon | 8 min |
| Première catégorie | 35 à 45 min |
| Monde 2 | 1 h 30 |
| Monde 3 | 5 à 6 h |
| Monde 4 | 15 h |
| Monde 5 | 35 h |
| Monde 6 | 70 h |
| Catégorie Légende | 100 h et plus |

Règle de confort : en jeu actif, le joueur ne doit jamais rester plus de 5 minutes sans pouvoir acheter ou débloquer quelque chose pendant la première heure, ni plus de 15 minutes ensuite.

## Méthode d'équilibrage

1. **Tableur** : un classeur `equilibrage.xlsx` dans `assets/` reprend les tables de configuration et calcule, pour un joueur type, le temps entre deux achats. Il se génère à partir des modules de configuration.
2. **Simulation** : un script de test fait jouer un joueur automatique (entraînement, saut, achat du meilleur objet abordable) et trace la courbe record en fonction du temps.

En place depuis T-201 (2026-11-22) :
- `outils/equilibrage/simulation.luau` se lance dans Studio (barre de commande ou MCP, mode Édition) avec les vrais modules de `Config`. Il renvoie un JSON à enregistrer dans `assets/equilibrage/simulation_monde1.json`. `_G.SIMULATION_REGLAGES` permet d'essayer un réglage sans toucher la configuration (stats, zones, matériel, jalons).
- `outils/equilibrage/tableur.py` (Python de Blender, bibliothèque standard seule) en tire `assets/equilibrage/equilibrage.xlsx`, avec les feuilles Jalons, Simulation, Achats, Formules, Mondes et Hypothèses, et la courbe `courbe_record_monde1.svg`.
- Hypothèses du joueur type : appel Bon, réception réussie, rythme actif × 2,5, 75 % du temps à s'entraîner, un saut de 15 s. Ne sont comptés ni les anneaux, ni les sauts rares, ni les compagnons, ni les catégories. Matériel provisoire : 8 paliers, × 2 chacun, 25 pièces puis × 5, à remplacer par le catalogue de T-203.
- Résultat au 2026-11-22 : 25 m en 8 min, 60 m en 22, 80 m en 47, 150 m en 92 (visés : 8, 20, 45 et 90). La plus longue attente entre deux achats pendant la première heure est de 10 min : il faut le catalogue complet de T-203 pour tenir la règle des 5 minutes.
3. **Test réel** : chaque équipier joue une heure avec un compte neuf et note où il s'ennuie ou bloque.
4. **Mesures** : après publication, les entonnoirs et les événements d'économie de Roblox disent où les joueurs partent ([[Lancement]]).

## Sources et dépenses de gemmes

| Source gratuite | Ordre de grandeur par jour |
| --- | --- |
| Quêtes du jour et coffre bonus | 60 |
| Connexion, roue, coffre du groupe | 30 |
| Cadeaux de temps de jeu | 30 |
| Paliers, défis, concours, index | Variable |

Un œuf d'or coûte 150 gemmes : un joueur régulier en ouvre un tous les un à deux jours. Un joueur qui paie en ouvre autant qu'il veut ([[Monétisation]]).

## Grands nombres

- Les stats et les pièces montent vite : affichage abrégé partout (1,2 K, 3,4 M, 5,6 Md, puis notation en lettres), avec un seul module de formatage.
- Les classements ordonnés de Roblox n'acceptent que des entiers : on y stocke les distances en centimètres, et pour les très grandes valeurs un logarithme.

## À surveiller

- L'inflation des multiplicateurs : ils se multiplient entre eux. Chaque nouveau multiplicateur doit être ajouté à la simulation avant d'entrer dans le jeu.
- L'écart entre joueur actif et joueur passif : viser un rapport de 3 environ. Au-delà, le jeu passif ne sert plus à rien ; en deçà, l'adresse ne compte plus.
