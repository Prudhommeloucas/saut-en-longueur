# Équipement

Ce que le joueur achète avec ses pièces pour sauter plus loin. Voir [[Projet]], [[Saut]] et [[Économie]].

## État actuel (T-203, 2026-11-22)

- **Catalogue** dans `Config/Equipement.CATALOGUE`. L'identifiant d'un objet est le nom de son modèle dans `Assets.Equipement`. Les neuf objets du monde 1 sont en jeu, avec les valeurs du tableau du catalogue ci-dessous, sauf deux réglages issus de la simulation :
  - Bouteille de soda : 200 pièces et 1,3 s de poussée ;
  - Maillot du club : 400 pièces.
- **Extincteur et réacteur** : poussée 360 et 420, vitesse de montée 50 et 60.
- **Niveaux** de 1 à 5 :
  - chaque niveau ajoute 10 % au bonus de l'objet : l'appel au-dessus de × 1, les pièces au-dessus de × 1, la durée de poussée ;
  - le niveau 2 coûte la moitié du prix d'achat, puis le prix double à chaque niveau (feuille « Catalogue » de `assets/equilibrage/equilibrage.xlsx`).
- **Profil (version 2)** : `equipement.possede` ([identifiant] = niveau) et `equipement.porte` ([famille] = identifiant). La migration a transformé les anciens « Chaussures » et « Jetpack » en `chaussures_ressorts` et `propulseur_soda`, portés.
- **Attributs du joueur** : `Chaussures`, `Propulseur`, `Tenue` (identifiant porté) et `<Famille>Niveau`. Les effets se lisent par `Equipement.appelDe`, `propulseurDe` et `piecesDe`.
- **Effets** :
  - les chaussures multiplient la puissance de saut ;
  - le propulseur donne la durée, la force et la vitesse de montée de la poussée (contrôleur `Saut`, serveur, borne `porteeMax`) ;
  - la tenue multiplie les pièces d'un saut, comme le multiplicateur de pièces du monde.
- **Stands** (provisoire, en attendant `EcranBoutique` de T-209) :
  - invite « Acheter » (E) : l'objet suivant de la famille, le moins cher pas encore possédé dans le monde du joueur. Il est porté s'il est plus cher que l'objet porté ;
  - invite « Améliorer » (R) : l'objet porté de la famille. Elle est créée par le code, comme les invites du stand Tenue.
- **Événements pour l'écran de boutique** : `AcheterObjet`, `AmeliorerObjet`, `PorterObjet`, et `EquipementEtat` (serveur vers joueur).
- **Apparence** :
  - le personnage porte les vrais modèles : propulseur dans le dos (Poignee contre l'arrière du torse), une chaussure à chaque pied (Poignee sous le pied) ;
  - flammes, lueur et son du jetpack sur une `Tuyere` invisible sous le propulseur, traînées sur les chaussures ;
  - les tenues n'ont pas encore de modèle (T-207).
- **Mesuré dans la copie** :
  - puissance de saut 62 → 80,6 (ressorts), 82,5 (ressorts niveau 2), 105,4 (turbo) ;
  - maillot : 11 m donnent 13 pièces ;
  - objets visibles sur le personnage.
- **Simulation** (`outils/equilibrage`) : le joueur type achète le moins cher de ce qui le fait progresser. Résultat :
  - 17 achats pendant la première heure, au plus 6 min d'attente (règle visée : 5) ;
  - jalons tenus : 25 m à 8 min, 80 m à 45, 150 m à 84.

## Cible : cinq familles

| Famille | Effet | Disponible |
| --- | --- | --- |
| Chaussures | Multiplie la puissance de l'appel | Monde 1 |
| Propulseur | Durée et force de la poussée en vol | Monde 1 |
| Matériel d'entraînement | Multiplie le gain des zones ([[Entraînement]]) | Monde 1 |
| Ailes | Multiplie l'efficacité du vol plané | Monde 2 |
| Tenue | Multiplie les pièces gagnées | Monde 1 |

Le joueur porte un objet par famille. Chaque monde ajoute trois objets par famille ; un objet du monde suivant est toujours meilleur que le meilleur du monde précédent.

### Niveaux

Chaque objet possédé s'améliore de 1 à 5. Chaque niveau ajoute 10 % à son effet et coûte le double du précédent (premier niveau : la moitié du prix d'achat). Cela donne un usage aux pièces entre deux achats.

### Catalogue du monde 1 (valeurs de départ, à équilibrer)

| Famille | Objet | Prix | Effet |
| --- | --- | --- | --- |
| Chaussures | Semelles à ressorts | 100 | Appel × 1,3 |
| Chaussures | Baskets turbo | 2 500 | Appel × 1,7 |
| Chaussures | Bottes à réaction | 40 000 | Appel × 2,2 |
| Propulseur | Bouteille de soda | 500 | 1,5 s de poussée |
| Propulseur | Extincteur | 8 000 | 2,5 s, poussée plus forte |
| Propulseur | Réacteur de poche | 120 000 | 4 s, poussée forte |
| Matériel | Haltères, gilet lesté, chevilles lestées… | 50 à 200 000 | Gain × 2 par palier |
| Tenue | Maillot du club | 1 000 | Pièces × 1,25 |
| Tenue | Tenue régionale | 15 000 | Pièces × 1,5 |
| Tenue | Tenue de champion | 250 000 | Pièces × 2 |

Les objets des autres mondes sont listés dans [[Mondes]]. Les descriptions visuelles sont dans [[Modèles 3D]].

## Traînées et auras

Effets cosmétiques portés en permanence : traînée derrière le joueur en course et en vol, aura autour du personnage. On les obtient par les paliers de record, les concours, le pass de saison et la boutique. Chacune donne un petit bonus de pièces (5 à 25 %) pour qu'elles comptent sans être obligatoires.

## Règles

- L'équipement est conservé lors d'un changement de catégorie ([[Rebirth et talents]]).
- La boutique se trouve aux stands du stade et dans un écran accessible partout ([[HUD]]).
- Toutes les valeurs vivent dans un module de configuration, avec un identifiant stable par objet ([[Architecture du code]]).
