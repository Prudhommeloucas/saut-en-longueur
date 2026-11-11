# Entraînement

Zones situées au spawn ([[Map]]) où le joueur améliore son personnage. Voir [[Projet]].

## Fonctionnement

- Rester debout dans une zone suffit : +1 toutes les 0,5 seconde.
- Zone squat (rouge) : augmente la stat **Puissance**, qui fait sauter plus haut.
- Zone mollets (bleue) : augmente la stat **Vitesse**, qui fait courir plus vite sur la piste.
- Les stats n'agissent que sur la piste (X > 0). Au spawn, le personnage garde la vitesse et le saut normaux.

## Formules

Elles sont dans `ReplicatedStorage.Config` ([[Scripts]]).

- Vitesse de course = 16 + 4 × √Vitesse, maximum 300.
- Puissance de saut = 50 + 5 × √Puissance, maximum 600.

Repère mesuré en test : avec 100 dans chaque stat, sans objet, le saut fait 10,6 m.

## À faire

- Animations de squat et de mollets.
- Multiplicateurs d'entraînement (zones plus fortes, rebirth).
