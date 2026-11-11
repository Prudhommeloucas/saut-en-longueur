# Équipement

Ce que le joueur achète avec ses pièces pour sauter plus loin. Voir [[Projet]], [[Saut]] et [[Économie]].

## État actuel

| Objet | Prix | Effet |
| --- | --- | --- |
| Chaussures propulsantes | 100 pièces | Puissance de saut × 1,3 sur la piste |
| Jetpack | 500 pièces | 1,5 seconde de poussée par saut, en maintenant la touche Saut en l'air |

- L'achat est définitif et l'objet s'affiche sur le personnage (semelles orange, réservoirs dans le dos).
- Le carburant se recharge dès que le joueur touche le sol. Une jauge l'affiche à l'écran.
- Les valeurs sont dans `ReplicatedStorage.Config`, table `OBJETS` ([[Scripts]]).
- Repère mesuré en test : avec 100 dans chaque stat, les deux objets font passer le saut de 10,6 m à 31,1 m.

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
