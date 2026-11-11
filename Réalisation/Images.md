# Images

Icônes, textures et images de la page du jeu. Poste 3. Voir [[Direction artistique]], [[HUD]] et [[Registre des images]].

## Comment on les fabrique

Claude ne dessine pas d'image directement. Quatre moyens, par ordre de préférence :

1. **Rendu Blender** par le MCP Blender : pour toutes les icônes d'objets et de compagnons. On réutilise les modèles du Poste 2, avec un éclairage et un angle fixes, fond transparent. Résultat cohérent avec le jeu et sans dessin à la main.
2. **Dessin vectoriel écrit par Claude** (SVG, converti en PNG) : pour les icônes d'interface, les monnaies, les cadres, les boutons, le logo.
3. **Capture mise en scène dans Studio** : pour les miniatures et l'icône du jeu. On pose des personnages, on règle la caméra, on capture, puis on ajoute le titre par-dessus.
4. **Outils de génération** : le générateur de textures de Studio pour les matières ; un générateur d'images externe si un équipier en a un, pour des idées ou des fonds. Toute image importée passe par la modération de Roblox.

Les sources vont dans `assets/images/`, rangées par dossier (`icones`, `interface`, `vitrine`).

## Icônes d'interface

256 × 256, fond transparent, contour épais, même trait pour toutes.

| Groupe | Icônes |
| --- | --- |
| Monnaies | Pièce, gemme, médaille |
| Stats | Puissance (haltère), Vitesse (éclair), Aéro (aile) |
| Menus | Boutique, compagnons, catégorie, quêtes, classements, mondes, Robux, réglages |
| Actions | Fermer, valider, verrou, cadeau, calendrier, roue, inviter, code |
| Boosts | Pièces × 2, entraînement × 2, chance × 2, vent favorable |
| Raretés | Cinq cadres de couleur pour les cases de compagnons |
| Passes | Une icône par passe ([[Monétisation]]), 512 × 512, imposée par Roblox pour la boutique |

## Icônes rendues depuis les modèles

- Un rendu par objet d'[[Équipement]] et par compagnon ([[Compagnons]]), vue de trois quarts.
- Versions Argent et Or des compagnons : même rendu, matière changée.
- Un script Blender unique fait tous les rendus d'un coup, pour pouvoir les refaire quand un modèle change.

## Éléments d'interface

Fond de panneau, bouton (normal, enfoncé, désactivé), barre de progression, pastille de notification, bandeau. Dessinés pour être étirés sans déformation (découpe en neuf zones).

## Textures d'effets

Étoile, étincelle, confetti, anneau de choc, fumée, grain de sable. Petites (128 × 128), blanches sur fond transparent, colorées par le jeu.

## Vitrine du jeu

| Élément | Format | Contenu |
| --- | --- | --- |
| Icône du jeu | Carré, 512 × 512 | Personnage en plein saut, grosses chaussures à ressorts, expression de joie, fond orange. Lisible en très petit |
| Miniatures (3 à 5) | 1920 × 1080 | 1 : le saut au-dessus du stade ; 2 : les compagnons ; 3 : les mondes ; 4 : le podium |
| Bande-annonce | 30 secondes au plus | Entraînement, saut, éclosion, podium, mondes |
| Logo | Vectoriel | Nom du jeu, lettres épaisses orange à contour blanc |

L'icône et la première miniature décident du nombre de joueurs qui cliquent : en préparer deux versions et comparer leurs résultats après le lancement ([[Lancement]]).

## Règles

- Aucune image tirée d'un autre jeu ou d'une marque.
- Texte dans les images réduit au minimum : il ne sera pas traduit.
- Chaque image importée est inscrite dans le registre avec son identifiant et son fichier source.
