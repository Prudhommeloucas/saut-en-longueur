# Entraînement

Zones où le joueur fait monter ses stats. Voir [[Projet]], [[Map]] et [[Économie]].

## État actuel

- Rester debout dans une zone suffit : +1 toutes les 0,5 seconde.
- Zone squat (rouge) : stat **Puissance**, qui fait sauter plus haut.
- Zone mollets (bleue) : stat **Vitesse**, qui fait courir plus vite sur la piste.
- Les stats n'agissent que sur la piste (X > 0). Au spawn, le personnage garde la vitesse et le saut normaux.
- Formules en place, dans `ReplicatedStorage.Config` ([[Scripts]]) : vitesse de course = 16 + 4 × √Vitesse (maximum 300) ; puissance de saut = 50 + 5 × √Puissance (maximum 600).
- Repère mesuré en test : avec 100 dans chaque stat, sans objet, le saut fait 10,6 m.

## Cible

### Trois stats

| Stat | Exercice | Effet | Disponible |
| --- | --- | --- | --- |
| Puissance | Squat | Hauteur du saut | Monde 1 |
| Vitesse | Mollets, puis tapis de course | Vitesse d'élan | Monde 1 |
| Aéro | Soufflerie | Efficacité du vol plané | Monde 2 |

Comme chaque stat a un rendement décroissant, le meilleur choix est de les monter ensemble. C'est voulu : le joueur passe d'une zone à l'autre.

### Zones par paliers

Chaque monde propose trois paliers de zones pour chaque stat. Une zone est une simple Part marquée par un tag et des attributs ([[Contrats]]), donc le Poste 2 peut en ajouter sans toucher au code.

| Palier (monde 1) | Multiplicateur | Condition |
| --- | --- | --- |
| Débutant | × 1 | Aucune |
| Confirmé | × 5 | Record de 25 m |
| Élite | × 25 | Record de 80 m |
| Zone VIP | × 40 | Passe VIP ([[Monétisation]]) |

Les zones des mondes suivants reprennent le même schéma avec des multiplicateurs plus élevés ([[Mondes]]).

### Entraînement actif

- Passif (comme aujourd'hui) : un gain toutes les 0,5 seconde.
- Actif : un cercle se referme sur une cible une fois par seconde. Appuyer au bon moment donne × 3 (parfait) ou × 2 (bon). Ne rien faire laisse le gain passif.
- Le joueur présent gagne donc trois fois plus que le joueur absent, sans que l'absence soit punie.
- Le passe « Entraînement automatique » joue le rythme à la place du joueur avec la qualité Bon.

### Matériel d'entraînement

Acheté en pièces, il multiplie le gain de toutes les zones : haltères, gilet lesté, chevilles lestées, etc. Huit paliers par monde, chacun doublant le précédent ([[Équipement]]).

### Formule du gain

`gain par battement = palier de zone × matériel × (1 + bonus des compagnons) × (1 + catégories) × talents × passes × qualité du rythme`

### Gains hors ligne

Un talent donne, au retour, une part de l'entraînement passif accumulé pendant l'absence (plafond de 2 heures, extensible). Voir [[Rebirth et talents]].

## Nouvelles formules de stats

Les formules actuelles atteignent leur plafond vers 5 000 points de stat, beaucoup trop tôt pour un jeu long. La cible est une courbe sans plafond dur, de la forme `base + k × stat^p` avec `p` entre 0,25 et 0,3, bornée par un plafond propre à chaque monde. Règle à tenir : doubler une stat doit toujours donner au moins 8 % de distance en plus. Les valeurs se règlent dans la tâche d'équilibrage ([[Économie]]).

## À faire

- Animations de squat et de mollets ([[Animations]]).
- Machines de sport à la place des zones plates ([[Modèles 3D]]).
