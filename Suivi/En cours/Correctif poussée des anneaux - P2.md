---
qui: P2
prenom: Loucas
etat: en cours
debut: 2026-11-22
tache: hors plan
---

# Correctif : poussée vers l'avant des anneaux

## Ce que la tâche touche

- Dépôt : `src/client/Controleurs/Saut.luau`, `src/shared/Config/Saut.luau`, `assets/plans/construction_t106_anneaux.luau`
- Studio : positions des anneaux dans `Workspace.Mondes.Monde1.Anneaux` (si recalage nécessaire)

## Notes

La poussée vers l'avant (+15) est effacée par le Humanoid, qui ramène la vitesse horizontale à WalkSpeed. À corriger pour qu'elle dure jusqu'à l'atterrissage.
