# Prompts IA

Les prompts réutilisables du projet, rangés par usage, avec l'IA à laquelle chacun est destiné. On copie le bloc, on remplace les `[CROCHETS]`, on envoie. Voir [[Outils]], [[Claude Design]], [[Modèles 3D]] et [[Direction artistique]].

## Lequel prendre

| # | Prompt | Sert à | IA | À joindre |
| --- | --- | --- | --- | --- |
| 1 | [[Prompt 1 - Planche de concept d'un monde]] | Image de référence d'un monde : vue 3/4, plan, vue au sol | Gemini (image) | Captures des mondes déjà construits |
| 2 | [[Prompt 2 - Construction d'un monde]] | Construire le décor du monde en 3D d'après la planche | Claude + Blender (MCP), ou Claude Design pour le plan | La planche du prompt 1 |
| 3 | [[Prompt 3 - Planche d'un personnage]] | Image de référence d'un compagnon ou d'une mascotte, 6 vues | Gemini (image) | Rien, ou un compagnon déjà fait |
| 4 | [[Prompt 4 - Construction et animations d'un personnage]] | Modèle 3D découpé en parties, animations de déplacement | Claude + Blender (MCP), ou Claude Design pour la planche | La planche du prompt 3 |
| 5 | [[Prompt 5 - Actions et effets d'un personnage]] | Suite du prompt 4 : animations d'action et effets visuels | Même conversation que le prompt 4 | Rien de plus |
| 6 | [[Prompt 6 - Planche d'un objet d'équipement]] | Image de référence d'un objet porté (propulseur, chaussures, ailes), 6 vues. Contient les trois propulseurs du monde 1 déjà remplis | Gemini (image) | Rien, ou un objet de la même famille |

## Les deux chaînes

- **Monde** : prompt 1 (Gemini) → on choisit la planche → prompt 2 (Claude) avec la planche jointe.
- **Personnage** : prompt 3 (Gemini) → on choisit la planche → prompt 4 (Claude) avec la planche jointe → prompt 5 dans la même conversation, une fois le modèle validé.

## Quelle forme de Claude

- **Claude Code avec le MCP Blender** (chaîne du projet, [[Modèles 3D]]) : Claude modélise dans Blender, compare aux captures, exporte en `.fbx`. C'est la voie qui donne un vrai fichier 3D.
- **Claude Design** : ne produit pas de 3D ([[Claude Design]]). Il sert à redessiner la planche à l'échelle, avec les dimensions en studs, avant Blender.
- **Claude (claude.ai)** : peut écrire un aperçu animé et un tableau d'images clés, utile pour régler les animations avant de les refaire dans Studio ([[Animations]]).

## Conseils

- Les prompts sont en anglais : Gemini suit mieux les consignes de style dans cette langue. Les noms de meshes restent ceux de [[Contrats]].
- Toujours remplir les couleurs avec la palette de la [[Direction artistique]] et l'ambiance du monde concerné ([[Mondes]]).
- Ne rien demander de violent ou d'inquiétant : le jeu est joyeux et sportif.
- Une image de Gemini est une intention, pas un plan coté. Les tailles viennent du prompt 2 ou 4, pas de l'image.
- Un prompt amélioré se corrige ici, pour que les trois postes en profitent. Un nouveau prompt s'ajoute dans `Réalisation/Prompts/` et dans le tableau.

## Origine

Ces prompts viennent d'un autre jeu (arènes et monstres à combattre) et ont été adaptés au saut en longueur le 2026-11-13. Les textes de départ, mot pour mot, sont dans [[Prompts d'origine (arènes et monstres)]].

## Stade du monde 1 (T-105)

Prompts remplis le 2026-11-18, d'après la toile « Plan du stade » ([[Construction du monde 1]]). Ils remplacent les blocs posés par `assets/plans/construction_t105.luau`. Joindre la planche du module de tribune (`assets/modeles/planches/`) aide à garder le style. Les chiffres et les inscriptions sont ajoutés dans Studio (texte), jamais dessinés : les plaques restent vides.

### Arche d'entrée (`stade_arche`)

Au début de la piste (X = 0), on passe dessous en courant. Le haut garde un cadre vide pour l'écran géant (T-106).

```text
Create a prop turnaround sheet of an original stadium entrance arch for a Roblox long jump game: "Runway Gate", the big arch players run through at the start of the run-up track of world 1 ("Beginner Stadium"). It is the main landmark seen from the spawn plaza.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no olympic rings, no people, no ground, no shadow, no lights, no flags.

Design: a wide rectangular gate: about 28 units wide, 30 high and 8 deep, with a clear opening 22 wide and 24 high for the track to pass under.
Main body: two thick square pillars with rounded edges, bright blue (#1E90FF), each with a wide white band near the bottom (#FFFFFF) and three short horizontal orange speed stripes near the top (#FF7A1A).
Top beam: one thick golden beam (#FFC83D) across the top, slightly wider than the pillars, with a thick white edge (#FFFFFF).
Screen frame: on top of the beam, centered, an empty dark blue rectangular frame (#16213E) about 16 wide and 8 high, flat and clearly separate, where a giant screen will be added later. Leave the frame empty.
Special feature: a big blank golden plaque in the middle of the beam's front face, slightly raised, left blank.
Small details: a chunky rounded cap on top of each pillar, golden; a thin orange stripe along the bottom of the beam.
Colors: at most five colors: #1E90FF, #FFC83D, #FFFFFF, #FF7A1A, #16213E.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (left pillar, right pillar, white bands, speed stripes, pillar caps, top beam, beam edge, blank plaque, screen frame) so it can be rebuilt in 3D with few polygons.
```

### Panneaux de distance (`stade_panneau_petit`, `stade_panneau_grand`)

Une seule planche pour les deux panneaux, à la même échelle. Le petit est posé tous les 10 m, le grand à 50 m, côté nord du bac ; la face est tournée vers le joueur qui arrive. Le chiffre est ajouté dans Studio.

```text
Create a prop sheet of two original distance signs for a Roblox long jump game, placed along the sand pit of world 1 ("Beginner Stadium"), at the same scale, side by side. Same cartoon style as the attached grandstand module.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no ground, no shadow.

1. "Small Distance Sign": a single round grey pole (#5B6577) about 3 units tall holding a flat rounded rectangular sign about 4 wide and 3 high, golden yellow (#FFC83D) with a thick white rim (#FFFFFF). The sign face is blank. A small rounded cap on top of the pole.
2. "Big Distance Sign": a thicker grey pole (#5B6577) about 4 units tall holding a big flat rounded sign about 5 wide and 8 high, bright orange (#FF7A1A) with a thick white rim (#FFFFFF) and a small golden star (#FFC83D) at the top of the sign. The sign face is blank.
Both signs have a small flat round foot at the bottom of the pole.

Sheet layout: the two signs side by side, each shown three times: front, side and 3/4 view (6 images in total, 2 rows: row 1 = small sign, row 2 = big sign). Keep every part clearly separated and readable (pole, cap, foot, sign board, rim, star) so they can be rebuilt in 3D with few polygons.
```

### Tunnel de sortie à 100 m (`stade_tunnel`)

Il ferme le stade et sert d'arche au premier palier ([[Construction du monde 1]], « Le voyage par paliers »). Le bac passe dessous ; le haut est traversé en vol (sans collision), il doit donc rester une simple masse. Le « 100 m » est ajouté dans Studio sur la plaque vide.

```text
Create a prop turnaround sheet of an original monumental stadium exit for a Roblox long jump game: "Stadium Exit Gate", a huge gate at the far end of the sand pit of world 1 ("Beginner Stadium"), at 100 meters. Jumpers fly through it and leave the stadium toward a park. It must look grand and celebratory, like the end of a stadium.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no olympic rings, no people, no ground, no shadow, no lights, no flags.

Design: a massive rectangular gate: about 120 units wide, 72 high and 40 deep, with a tall opening 44 wide and 60 high in the middle where the sand pit passes through.
Main body: two huge pale stone towers on each side of the opening (#E9E4D8) with rounded corners, each decorated with three tall vertical blue stripes (#1E90FF), joined at the top by a thick stone beam.
Top: along the top of the beam, a wide band of alternating orange and white blocks (#FF7A1A, #FFFFFF), like a stadium crown.
Plaque: a very big blank golden plaque (#FFC83D) in the middle of the beam's front face, above the opening, left blank.
Special feature: inside the opening, the edges are lined with a thick orange frame (#FF7A1A) so the opening reads clearly from far away.
Small details: two round golden medallions, one on each tower, left blank; chunky rounded caps on top of each tower.
Colors: at most four colors: #E9E4D8, #1E90FF, #FF7A1A, #FFC83D.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (left tower, right tower, blue stripes, top beam, crown blocks, plaque, opening frame, medallions, tower caps) so it can be rebuilt in 3D with few polygons.
```
