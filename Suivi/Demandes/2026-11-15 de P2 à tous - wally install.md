---
de: P2
pour: tous
etat: ouverte
date: 2026-11-15
tache: T-006
---

# Lancer `wally install` avant le prochain `rojo serve`

## Demande

La sauvegarde passe maintenant par ProfileStore, installé par Wally (`wally.toml`). Dans le dossier du projet, après `git pull` : `rokit install` puis `wally install`. Le dossier `ServerPackages/` apparaît (hors git). Sans lui, `rojo serve` refuse de démarrer. Voir [[Installation]].

## Pourquoi

T-006 : `default.project.json` envoie `ServerPackages/` dans `ServerStorage.ServerPackages`.

## Réponse

- P2 (Loucas) : fait le 2026-11-15.
