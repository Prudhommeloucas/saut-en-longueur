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

## Stade du monde 1 (T-106)

Prompts remplis le 2026-11-22. Ils remplacent les blocs posés par `assets/plans/construction_t106_anneaux.luau` et `construction_t106_stade.luau` ([[Construction du monde 1]], [[Contrats]]). Joindre la planche de l'arche (`stade_arche`) aide à garder le style. Comme pour T-105, aucun texte dessiné : l'écran reste vide, Studio y met le texte.

### Anneau (`stade_anneau`)

Un seul modèle, recoloré dans Studio par série (or, bleu, orange). Il reste décoratif : la `Zone` invisible taguée `Anneau` garde le contact. Le trou doit être grand (diamètre intérieur ≈ 10 studs), le cercle épais et lisible de loin.

```text
Create a prop turnaround sheet of an original floating bonus ring for a Roblox long jump game: "Boost Ring", a big ring floating above the sand pit of world 1 ("Beginner Stadium"). Jumpers fly through its hole to get a boost and coins. Same cartoon style as the attached stadium arch.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no olympic rings, no people, no ground, no shadow, no sparkles, no glow effects.

Design: one thick round ring, standing vertically, about 12 units in outer diameter with a big empty hole about 10 units wide in the middle, and about 1.5 units thick.
Main body: a smooth rounded tube, golden yellow (#FFC83D).
Special feature: four short white arrow-shaped fins (#FFFFFF) on the outer edge, at top, bottom, left and right, all pointing forward in the same direction (the flight direction), like speed fins.
Small details: a thin white stripe running all around the front face of the ring.
Colors: at most two colors: #FFC83D, #FFFFFF.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (ring tube, front stripe, four fins) so it can be rebuilt in 3D with few polygons.
```

### Écran géant (`stade_ecran`)

Posé sur l'arche (X = 0), visible des deux côtés : de la place et de la piste. L'écran lui-même reste une plaque plate et sombre, séparée du cadre, pour y poser les SurfaceGui (`Surface`, tag `EcranGeant`). Taille visée : 28 × 14 studs d'écran, pieds de 3 studs.

```text
Create a prop turnaround sheet of an original giant stadium screen for a Roblox long jump game: "Big Screen", a giant double-sided scoreboard screen standing on top of the stadium entrance arch of world 1 ("Beginner Stadium"). Same cartoon style as the attached stadium arch.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no images on the screen, no people, no ground, no shadow, no lights.

Design: a wide flat screen, about 30 units wide, 16 high and 2 deep, the same on both sides.
Main body: a thick rounded bright blue frame (#1E90FF) all around.
Screen: on both sides, a flat dark navy panel (#16213E) about 28 wide and 14 high, clearly inset in the frame and completely empty.
Special feature: a golden crest on top of the frame (#FFC83D): a simple rounded star in the middle, with two short golden wings.
Small details: a thin golden stripe (#FFC83D) under the frame; two short chunky grey legs (#5B6577) under the frame, with flat round feet, to stand on the arch.
Colors: at most four colors: #1E90FF, #16213E, #FFC83D, #5B6577.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (frame, front screen panel, back screen panel, crest, stripe, legs, feet) so it can be rebuilt in 3D with few polygons.
```

### Projecteur (`stade_projecteur`)

Six exemplaires derrière les tribunes. La tête doit être une pièce séparée du mât (`Tete`, orientée par le code), la face des lampes une troisième pièce (`Lampe`, en Neon dans Studio). Mât d'environ 45 studs, tête de 12 × 7.

```text
Create a prop turnaround sheet of an original stadium floodlight tower for a Roblox long jump game: "Stadium Floodlight", a tall light tower standing behind the grandstands of world 1 ("Beginner Stadium"). Same cartoon style as the attached stadium arch.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no people, no ground, no shadow, no light beams, no glow.

Design: a tall thin tower about 45 units high with a big light head on top.
Mast: a round grey pole (#5B6577), slightly thicker at the bottom, with a wide flat round foot and two blue rings (#1E90FF) along its height.
Head: a wide rounded rectangular box about 12 wide, 7 high and 2.5 deep, dark navy (#16213E), mounted on a short golden hinge (#FFC83D) on top of the pole so it can tilt; the head is clearly a separate piece from the pole.
Lamp face: on the front of the head, a separate flat panel with a grid of 2 rows of 4 big round lamps, pale cream (#FFF8E7), each with a thin golden rim (#FFC83D).
Small details: a small golden cap on top of the head.
Colors: at most five colors: #5B6577, #1E90FF, #16213E, #FFC83D, #FFF8E7.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (foot, pole, blue rings, hinge, head box, lamp panel, lamps, cap) so it can be rebuilt in 3D with few polygons.
```

### Spectateur (`stade_spectateur`)

929 exemplaires assis sur les gradins : il faut un modèle minuscule (viser moins de 60 triangles), recoloré dans Studio (tee-shirt et peau). Un seul morceau, sans bras séparés : la ola soulève le bloc `Public` entier. Hauteur assise ≈ 3,5 studs.

```text
Create a prop turnaround sheet of an original, extremely simple cartoon stadium spectator for a Roblox long jump game: "Crowd Fan", a tiny sitting fan used hundreds of times in the grandstands of world 1 ("Beginner Stadium"). Same cartoon style as the attached stadium arch.

Style: cartoon 3D game asset, very chunky and toy-like, made of very few simple rounded shapes, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Extremely low detail, readable from far away. Joyful. No face details except two dot eyes, no text, no letters, no numbers, no logos, no brand, no clothes details, no seat, no ground, no shadow. Not a real person, not a known character.

Design: a small sitting figure about 3.5 units tall: a rounded box body and a big round head on top, both arms raised up in a happy cheer, all as one simple solid piece with no gaps.
Body: a plain bright blue rounded torso (#1E90FF) (it will be recolored), with short stubby arms of the same color raised above the head.
Head: a big smooth round head, light skin tone (#F2C9A0) (it will be recolored), with two small black dot eyes and no other details.
Colors: at most three colors: #1E90FF, #F2C9A0, black for the eyes.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep the body, arms and head clearly readable so it can be rebuilt in 3D with very few polygons.
```

## Magasin de la place centrale (T-217)

Prompt rempli le 2026-11-23. Le magasin remplace le bouton Boutique du HUD ([[HUD]], [[Décisions]]) : il se pose au nord-ouest de la place, derrière les quatre stands, ouvert vers le centre. Joindre la planche de l'arche (`stade_arche`) aide à garder le style. Aucun texte dessiné : l'enseigne reste vide, Studio y met le nom.

### Magasin (`place_magasin`)

```text
Create a prop turnaround sheet of an original small sports shop building for a Roblox long jump game: "Jumper Shop", the shop on the round spawn plaza of world 1 where players buy jump shoes, jetpacks, training gear and outfits. Players walk up to its open front counter.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no people, no ground, no shadow, no lights.

Design: a compact one-storey shop, about 32 units wide, 22 high and 18 deep. The whole front is open, like a market stall, with a wide counter.
Main body: three walls (back, left, right) in white (#FFFFFF) with a thick bright blue base band (#1E90FF), and a flat roof with a rounded edge.
Awning: above the open front, a big striped awning sloping forward, alternating orange (#FF7A1A) and white (#FFFFFF) stripes, with a scalloped bottom edge.
Sign: on top of the roof, centered, a big blank golden sign board (#FFC83D) with a thick dark blue frame (#16213E), slightly tilted forward, left blank.
Counter: a long low counter across the front, blue (#1E90FF) with a golden top (#FFC83D).
Shelves: on the back wall, four separate display niches side by side, each with one simple oversized item: a pair of chunky sneakers, a small backpack jetpack with two nozzles, a dumbbell, a sports jersey on a hanger. Items are simple shapes in the same palette.
Small details: two short rounded pillars at the front corners holding the awning, golden caps on top; a simple step in front of the counter.
Colors: at most five colors: #FFFFFF, #1E90FF, #FF7A1A, #FFC83D, #16213E.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (walls, base band, roof, awning, sign, counter, four shelf niches and their items, front pillars, step) so it can be rebuilt in 3D with few polygons.
```

## Tableau des quêtes et cadeau de la place centrale (T-218, T-219)

Prompts remplis le 2026-11-23. Ils remplacent le bouton Quêtes et le bouton Cadeau du HUD ([[HUD]], [[Décisions]]). Joindre la planche du magasin (`place_magasin`) aide à garder le style. Aucun texte dessiné : le tableau reste vide, Studio y affiche les quêtes.

### Tableau des quêtes (`place_tableau`)

```text
Create a prop turnaround sheet of an original quest board for a Roblox long jump game: "Challenge Board", a big notice board on the round spawn plaza of world 1 where players read their daily and weekly challenges and claim rewards. The quests are shown later on the empty board surface by the game.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no people, no ground, no shadow, no lights, no paper notes, no pictures on the board.

Design: a large freestanding board, about 22 units wide, 16 high and 3 deep, facing forward.
Main body: two thick square posts in bright blue (#1E90FF) with rounded edges and golden caps (#FFC83D), planted on two small blue feet.
Board: between the posts, a big flat rectangular board, dark blue (#16213E), perfectly flat and empty on the front, about 18 wide and 10 high, framed by a thick white rounded frame (#FFFFFF).
Header: above the board, a wide golden arched plaque (#FFC83D) with a white edge, left blank.
Special feature: on top of the header, centered, a chunky orange star (#FF7A1A) with a white outline.
Small details: a short orange roof edge above the header; two small round golden bolts on each post.
Colors: at most five colors: #1E90FF, #16213E, #FFFFFF, #FFC83D, #FF7A1A.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (posts, feet, post caps, board, board frame, header plaque, star, roof edge, bolts) so it can be rebuilt in 3D with few polygons.
```

### Cadeau (`place_cadeau`)

```text
Create a prop turnaround sheet of an original giant gift box for a Roblox long jump game: "Play Gift", a big present on the round spawn plaza of world 1 that players open every few minutes to get a reward. The lid flies off when it opens, so the lid must be a clearly separate part.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and festive. No text, no letters, no numbers, no logos, no brand, no people, no ground, no shadow, no lights.

Design: a cube-shaped gift about 7 units wide, 7 deep and 6 high, plus a bow on top, sitting on a low round pedestal.
Box: bright purple (#9B5CFF) with rounded edges, crossed by a wide golden ribbon (#FFC83D) on all four sides.
Lid: a separate slightly wider lid in purple (#9B5CFF), with the golden ribbon continuing on it.
Bow: a big chunky golden bow (#FFC83D) on top of the lid, two loops and two short tails.
Pedestal: a low round platform, white (#FFFFFF) with a bright blue edge (#1E90FF), slightly wider than the box.
Small details: a thin white line along the bottom edge of the lid.
Colors: at most four colors: #9B5CFF, #FFC83D, #FFFFFF, #1E90FF.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (box, lid, ribbons, bow loops, bow tails, pedestal, pedestal edge) so it can be rebuilt in 3D with few polygons.
```
