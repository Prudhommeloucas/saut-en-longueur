# Tableau de bord

Vue d'ensemble de l'avancement. Cette note ne contient rien à modifier : elle affiche les tâches réservées, la liste des tâches et les demandes ouvertes. Le plan est dans [[Déroulé du développement]].

## Phase en cours

Phase 0 — Fondations (depuis le 2026-11-11). Celui qui coche la revue de fin de phase met cette ligne à jour.

## Tâches en cours (réservées)

```query
path:"Suivi/En cours" "etat: en cours"
```

## Demandes ouvertes

```query
path:"Suivi/Demandes" "etat: ouverte"
```

## Idées à discuter

```query
path:"Idées" "etat: proposee"
```

## Tâches en attente

```query
path:"Suivi/Tâches" task-todo:"T-0"
```

Changer `T-0` en `T-1`, `T-2`, etc. pour voir une autre phase.

## Toutes les tâches

![[Tâches]]

## Journaux

[[Poste 1]] · [[Poste 2]] · [[Poste 3]]
