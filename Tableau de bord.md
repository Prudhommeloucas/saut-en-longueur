# Tableau de bord

Vue d'ensemble de l'avancement. Cette note ne contient rien à modifier : elle affiche les fichiers de suivi des trois postes et les demandes ouvertes. Le plan est dans [[Déroulé du développement]].

## Phase en cours

Phase 0 — Fondations (depuis le 2026-11-11). Le Poste 1 met cette ligne à jour à chaque changement de phase.

## Demandes ouvertes

```query
path:"Suivi/Demandes" "etat: ouverte"
```

## Idées à discuter

```query
path:"Idées" "etat: proposee"
```

## Tâches en attente, tous postes

```query
path:"Suivi/Poste" task-todo:"T-0"
```

Changer `T-0` en `T-1`, `T-2`, etc. pour voir une autre phase.

## Poste 1 — Code

![[Poste 1 - Code]]

## Poste 2 — Monde et 3D

![[Poste 2 - Monde et 3D]]

## Poste 3 — Interface, son et image

![[Poste 3 - Interface, son, image]]
