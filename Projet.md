# Projet : Saut en longueur

Map Roblox où le but est de sauter de plus en plus loin.

## État

Première version jouable construite dans Roblox Studio le 2026-11-11 (place « Place1 », pas encore enregistrée ni publiée). Testée en mode jeu : entraînement, saut, pièces, boutique et jetpack fonctionnent.

## Boucle de jeu

1. Au spawn, le joueur s'entraîne pour améliorer son personnage ([[Entraînement]]).
2. Il va sur la piste, prend son élan et saute. La distance donne des pièces ([[Map]]).
3. Avec les pièces, il achète des objets pour aller encore plus loin ([[Objets]]).

## Notes du projet

- [[Map]] : le spawn et la piste de saut, avec les coordonnées
- [[Entraînement]] : squat, mollets, formules des stats
- [[Objets]] : jetpack, chaussures propulsantes, prix
- [[Scripts]] : où est le code dans Studio et comment il fonctionne
- [[Décor et effets]] : tribunes, arbres, lumière, particules, sons
- [[Référence]] : le jeu qui sert d'inspiration

## Décisions prises

- Map tout en longueur : une piste de saut, avec un spawn au départ.
- Squat = puissance de saut, mollets = vitesse d'élan.
- Les bonus de vitesse et de saut ne s'appliquent que sur la piste, pas au spawn.
- 1 mètre sauté = 1 pièce. 1 mètre = 4 studs.
- Les objets s'achètent avec des pièces.
- On reprend le genre et les mécaniques de la [[Référence]], mais avec notre propre map, notre nom et nos visuels.

## Pas encore fait

- Rebirth, pets, plusieurs mondes (prévu après la base).
- Animations d'entraînement, musique, vrais modèles 3D (voir [[Décor et effets]]).
- Plusieurs niveaux par objet.
- La sauvegarde est codée mais jamais testée : elle demande une place publiée avec l'accès API activé.
