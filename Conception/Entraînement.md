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

Chaque monde propose trois paliers de zones pour chaque stat. Une zone est une simple Part marquée par un tag et des attributs ([[Contrats]]), donc on peut en ajouter sans toucher au code.

| Palier (monde 1) | Multiplicateur | Condition |
| --- | --- | --- |
| Débutant | × 1 | Aucune |
| Confirmé | × 2 | Record de 25 m |
| Élite | × 12 | Record de 80 m |
| Zone VIP | × 20 | Passe VIP ([[Monétisation]]) |

Valeurs réglées par la simulation de T-201 (2026-11-22, `Config/Mondes`). Elles étaient de × 5, × 25 et × 40 ; avec le bonus de débutant (× 10 au départ, éteint à 60 m), ces paliers rendaient la suite trop rapide. Les attributs `Multiplicateur` des zones de la place ont été mis aux nouvelles valeurs.

Les zones des mondes suivants reprennent le même schéma avec des multiplicateurs plus élevés ([[Mondes]]).

### Entraînement actif

- Passif (comme aujourd'hui) : un gain toutes les 0,5 seconde.
- Actif : un cercle se referme sur une cible une fois par seconde. Appuyer au bon moment donne × 3 (parfait) ou × 2 (bon). Ne rien faire laisse le gain passif.
- Le joueur présent gagne donc trois fois plus que le joueur absent, sans que l'absence soit punie.
- Le passe « Entraînement automatique » joue le rythme à la place du joueur avec la qualité Bon.

En place depuis T-202 (2026-11-22) :
- Le battement tombe à chaque seconde entière de l'heure du serveur, et le cercle du joueur est calé dessus.
- On appuie avec le bouton « Pousser ! » au centre du cercle, la touche E ou le bouton X de la manette.
- Le joueur envoie l'heure de son appui, le serveur la vérifie (ni dans le futur, ni plus vieille d'une seconde) et la juge :
  - Parfait à 0,08 s près, × 3 ;
  - Bon à 0,2 s près, × 2 ;
  - au-delà, l'appui est raté.
- Un seul appui compte par battement. Il ajoute le gain passif de la seconde × (multiplicateur − 1) : la seconde Parfaite vaut donc exactement trois fois le passif.
- Le rythme s'ouvre au record de 5 m.
- Réglages dans `Config/Stats.RYTHME`.
- L'écran est provisoire, construit par le contrôleur `Rythme` (`RythmeProvisoire`). Il montre aussi le bonus de débutant ; le vrai `HudEntrainement` viendra avec T-209.
- Mesuré dans la copie : passif 2/s, Parfait +4 par seconde jouée (× 3), Bon +2 (× 2), passe automatique × 2,1.
- Limite connue : c'est le joueur qui annonce l'heure de son appui. Un tricheur pourrait jouer Parfait à chaque battement, mais jamais plus de × 3.

### Matériel d'entraînement

Acheté en pièces, il multiplie le gain de toutes les zones : haltères, gilet lesté, chevilles lestées, etc. Huit paliers par monde, chacun doublant le précédent ([[Équipement]]).

En place depuis T-202 (2026-11-22), dans `Config/Equipement.MATERIEL`, pour le monde 1 :

| Palier | Objet | Multiplicateur | Prix (pièces) |
| --- | --- | --- | --- |
| 1 | Haltères | × 2 | 25 |
| 2 | Élastiques | × 4 | 125 |
| 3 | Kettlebell | × 8 | 625 |
| 4 | Gilet lesté | × 16 | 3 125 |
| 5 | Chevilles lestées | × 32 | 15 625 |
| 6 | Medecine-ball | × 64 | 78 125 |
| 7 | Traîneau de poussée | × 128 | 390 625 |
| 8 | Barre en or | × 256 | 1 953 125 |

Les prix sont ceux de la simulation T-201. Les paliers s'achètent dans l'ordre au stand `StandMateriel` (attribut `Objet` = « Materiel »). Le palier atteint est sauvegardé (`equipement.materiel`, attribut `Materiel`). L'achat n'a pas pu être essayé en test automatique (les invites ne s'affichent pas quand Studio n'a pas la main) : à vérifier à la main.

**Gain par battement en place** : `ENTRAINEMENT_GAIN × palier de zone × matériel × Coachs × bonus de débutant`, puis × qualité du rythme pour la seconde jouée.

### Formule du gain

`gain par battement = palier de zone × matériel × (1 + bonus des compagnons) × (1 + catégories) × talents × passes × qualité du rythme`

### Gains hors ligne

Un talent donne, au retour, une part de l'entraînement passif accumulé pendant l'absence (plafond de 2 heures, extensible). Voir [[Rebirth et talents]].

## Nouvelles formules de stats

Fait à T-201 (2026-11-22) : voir [[Économie]] pour les valeurs en place et la simulation. Les anciennes formules atteignaient leur plafond vers 5 000 points de stat, beaucoup trop tôt pour un jeu long. La cible est une courbe sans plafond dur, de la forme `base + k × stat^p` avec `p` entre 0,25 et 0,3, bornée par un plafond propre à chaque monde. Règle à tenir : doubler une stat doit toujours donner au moins 8 % de distance en plus. Les valeurs se règlent dans la tâche d'équilibrage ([[Économie]]).

## À faire

- Animations de squat et de mollets ([[Animations]]).
- Machines de sport à la place des zones plates ([[Modèles 3D]]).
