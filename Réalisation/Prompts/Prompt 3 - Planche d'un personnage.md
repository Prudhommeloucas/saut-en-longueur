# Prompt 3 - Planche d'un personnage

- **Sert à** : obtenir l'image de référence d'un compagnon (ou de la mascotte) sous six angles, avant de le modéliser.
- **IA** : Gemini (génération d'image).
- **À joindre** : rien d'obligatoire. La planche d'un compagnon déjà fait aide à garder la même famille.
- **Ensuite** : [[Prompt 4 - Construction et animations d'un personnage]], avec la planche retenue.

Voir [[Prompts IA]], [[Compagnons]], [[Modèles 3D]] et [[Direction artistique]].

## À remplir

| Crochet | Où trouver la valeur |
| --- | --- |
| Espèce, rareté, œuf, monde | [[Compagnons]] |
| Description, couleur dominante | [[Modèles 3D]], « Compagnons et œufs » |
| Couleur de rareté | [[Direction artistique]] |

## Prompt

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "[COMPANION NAME]", a [RARITY] pet from the "[EGG NAME]" of world [NUMBER] ("[WORLD NAME]"). It follows the player by hopping and jumps with them.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a [ANIMAL: frog / rabbit / grasshopper / kangaroo...] inspired by [WORLD THEME] and by athletics. [BODY SHAPE: e.g. round body, very big head, strong back legs made for jumping, small front paws, short tail]. It stands [POSE: upright and proud / crouched and ready to hop], happy and full of energy.
Body: [MAIN COLOR] ([#HEX], lighter belly [#HEX]) with [MARKINGS: spots / stripes / none] ([#HEX]).
Head: [HEAD: big shiny eyes #HEX, ears / antennae / crest, small nose], [MOUTH: big smile, small teeth, tongue...].
Special feature: [THE MOST RECOGNIZABLE ELEMENT: e.g. a sport headband / a race bib / boxing gloves / a tiny cape and hat].
Arms / legs: [LIMBS: big springy back legs, small arms, big feet...].
Back / tail: [BACK AND TAIL: pouch, wings, fluffy tail, fins...].
Small details: [2-3 SMALL DETAILS: wristbands, medal ribbon around the neck, sneakers, stars around it...].

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable ([PART LIST: body, head, eyes, ears, upper legs, lower legs, feet, arms, tail, accessory...]) so it can be rebuilt in 3D with few polygons.
```

## Grenouille (`compagnon_grenouille`, planche de style T-010)

Prompt rempli le 2026-11-14.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Frog", a common pet from the "Stadium Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a frog inspired by a sunny athletics stadium. Round body, very big head wider than the body, strong folded back legs made for jumping, small front paws, no tail. It sits crouched and ready to hop, happy and full of energy.
Body: bright green (#4CC96B, lighter belly #D8F5B0) with no markings; back legs in a darker green (#2E9E4F).
Head: two very big round eyes sitting on top of the head, white with big black pupils and one white highlight, no ears, two tiny nostrils, a very wide simple smile.
Special feature: an orange sport headband (#FF7A1A) around the head just under the eyes, knotted at the back with two short ribbon tails.
Arms / legs: big springy back legs with large flat webbed feet, two small front paws resting on the ground.
Back / tail: smooth round back, no tail.
Small details: nothing else; keep it very simple.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral crouched pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, head, eyes, back legs, back feet, front paws, headband, knot) so it can be rebuilt in 3D with few polygons.
```

## Remarques

- Un compagnon tient en 500 à 1 500 triangles ([[Modèles 3D]]) : demander peu de petits détails, la silhouette doit suffire à le reconnaître.
- Les versions Argent et Or ne demandent pas de planche : même modèle, matière métallique et médaille au cou ([[Compagnons]]).
- Pour la mascotte géante du monde 1, remplacer « companion » par « giant mascot » et décrire la taille (environ 60 studs).
