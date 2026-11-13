# Prompt 1 - Planche de concept d'un monde

- **Sert à** : obtenir l'image de référence d'un monde avant de le construire (vue 3/4, plan vu de dessus, vue au sol).
- **IA** : Gemini (génération d'image).
- **À joindre** : deux ou trois captures des mondes déjà construits, pour que le style reste le même.
- **Ensuite** : [[Prompt 2 - Construction d'un monde]], avec la planche retenue.

Voir [[Prompts IA]], [[Mondes]] et [[Direction artistique]].

## À remplir

| Crochet | Où trouver la valeur |
| --- | --- |
| Numéro, nom, mécanique du saut | [[Mondes]] |
| Heure, lumière, couleurs dominantes | [[Direction artistique]], « Ambiance par monde » |
| Objets du décor | [[Modèles 3D]], [[Construction du monde 1]] pour le monde 1 |

## Prompt

```text
Create a concept art sheet of WORLD [NUMBER] "[WORLD NAME]" of a Roblox long jump simulator (players train, run down a runway, take off from a board and fly as far as possible over a very long landing area). It must look like it belongs to the same game as the attached screenshots (previous worlds): copy EXACTLY that building style, the same cartoon look with simple shapes, rounded edges and bold flat colors. Only the colors and the theme change: [THEME IN ONE SENTENCE, e.g. a sunny tropical beach / a red rock canyon at sunset / a snowy mountain peak]. Show only the environment: no characters, no animals, no text, no logos, no UI.

Style: the same as the screenshots. Cartoon, low detail, chunky exaggerated proportions, rounded edges, smooth plastic surfaces, flat colors or very simple gradients, a few glowing neon accents. Joyful and sporty, bright and readable for a game, readable on a small phone screen. No realistic details, no realistic textures, no LEGO studs, no letters, nothing scary or violent.

Colors ([MOOD: e.g. warm golden afternoon / bright noon / cold misty morning], bright and readable):
- Ground: [GROUND, e.g. grass #HEX / sand #HEX / snow #HEX], with [optional: painted lines / paths #HEX].
- Runway: [RUNWAY MATERIAL AND COLOR #HEX] with white lane lines.
- Landing area: [SAND / WATER / SNOW / ROOFTOPS #HEX], bordered by [BORDER #HEX].
- Buildings and props: [MAIN COLOR #HEX], [SECOND COLOR #HEX], game accent orange #FF7A1A and blue #1E90FF.
- Training zones: red for power, blue for speed, green for glide (glowing floor pads).
- Sky: [SKY: e.g. golden late afternoon with clouds / bright blue / sunset #HEX to #HEX].

Layout (a long world, much longer than wide; a player is tiny, about 1/[60] of the width of the plaza):
- SPAWN PLAZA (at one end): a flat open plaza with [9] glowing training pads in three colors (3 red, 3 blue, 3 green, from small to big), [3-5] small shop kiosks with striped awnings, one egg incubator (round base with a glass dome), one small temple with columns, a podium with three steps.
- RUNWAY: a straight flat runway starting at the plaza, ending at a white take-off board [or: the edge of a cliff / a ski jump ramp].
- LANDING AREA: starts right after the take-off board and stretches very far in a straight line, with a small distance marker post at regular steps and a big arch at each major step.
- ALONG THE SIDES: [4-6 KINDS OF PROPS with numbers, e.g. 6 grandstand modules; 4 tall floodlight masts; palm trees; rocks; flags; confetti cannons in pairs].
- LANDMARK: [the big signature object of the world, e.g. a giant inflatable entrance arch / a lighthouse / a giant ice statue], near the plaza, visible from everywhere.
- EXIT: one portal to the next world (a stone arch with a calm glowing surface in the colors of the next world), at the edge of the plaza.
- IN THE AIR above the landing area: a few big glowing rings to fly through, [optional: a blimp / balloons / kites].
- FAR BACKGROUND: [what the landing area crosses further away, e.g. a park, a lake, a city, hills].

Keep the runway, the take-off board and the landing area completely free of obstacles, and keep the plaza open and easy to walk through.

NOT allowed: characters, monsters, weapons, signs with letters, numbers, swirling scary portals, LEGO studs, lasers, robots, realistic textures, dark or frightening mood.

Sheet layout: 3 images of the SAME world on one sheet: 1) big isometric 3/4 overview from above, seen from the plaza side, 2) top view (plan) with the runway going from left to right, 3) ground level view from the start of the runway looking towards the take-off board and the landing area. Keep every part clearly readable so it can be rebuilt in 3D.
```

## Remarques

- Le plan vu de dessus met la piste de gauche à droite, comme les planches de [[Claude Design]] (axe X).
- Gemini ajoute volontiers du texte sur les panneaux : le redemander sans lettres si besoin, les textes sont posés ensuite dans Studio.
