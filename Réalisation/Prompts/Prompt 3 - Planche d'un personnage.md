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

## Lapin (`compagnon_lapin`, T-303)

Prompt rempli le 2026-11-14. Joindre la planche de la grenouille (`assets/modeles/planches/compagnon_grenouille.webp`) pour garder la même famille.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Rabbit", a common pet from the "Stadium Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them. Same family and same style as the attached frog companion.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a rabbit inspired by a sunny athletics stadium. Round chubby body, very big round head, strong back legs made for jumping, small front paws, short round fluffy tail. It sits upright and proud, happy and full of energy.
Body: soft white (#F4F6FA, lighter belly #FFFFFF) with no markings; inside of the ears and the nose in light pink (#FFB3C1).
Head: two very big round eyes, dark brown (#3A2A22) with one white highlight, two long upright ears slightly rounded at the tip, a tiny pink triangle nose, a small happy smile with two little front teeth.
Special feature: a blue race bib (#1E90FF) worn on the chest like a small square apron tied around the body, with a big white circle in the middle (no number, no text).
Arms / legs: big springy back legs with long flat feet, two small front paws held near the chest.
Back / tail: smooth round back, the bib's two thin blue straps crossing on the back, a white pompom tail.
Small details: nothing else; keep it very simple.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral sitting pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, head, eyes, ears, inner ears, nose, back legs, back feet, front paws, tail, bib, straps) so it can be rebuilt in 3D with few polygons.
```

## Sauterelle (`compagnon_sauterelle`, T-303)

Prompt rempli le 2026-11-14. Joindre les planches de la grenouille et du lapin (`assets/modeles/planches/`).

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Grasshopper", a rare pet from the "Stadium Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them. Same family and same style as the attached frog and rabbit companions.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary, not a realistic insect. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a grasshopper inspired by a sunny athletics stadium. Short round bean-shaped body, very big round head, two huge folded back legs made for jumping (the most recognizable shape), four short stubby front legs, no stinger. It stands crouched and ready to spring, happy and full of energy.
Body: bright lime green (#8BDB2E, lighter belly #E6F7A0) with three soft darker green stripes across the back (#4FA61E).
Head: two very big round eyes, white with big black pupils and one white highlight, a small happy smile, no teeth, no mandibles. Two very long thin antennae curving backward, each ending in a small orange ball (#FF7A1A).
Special feature: the two huge back legs, with a blue sweatband (#1E90FF) around each knee.
Arms / legs: back legs bent in a big Z shape, thick thigh and thin lower leg, small round feet; four short front legs with little round feet.
Back / tail: two small rounded wing covers folded on the back, same green as the stripes, no real wings.
Small details: nothing else; keep it very simple.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral crouched pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, stripes, head, eyes, antennae, antenna balls, back thighs, back lower legs, sweatbands, front legs, feet, wing covers) so it can be rebuilt in 3D with few polygons.
```

## Kangourou (`compagnon_kangourou`, T-303)

Prompt rempli le 2026-11-14. Joindre les planches de la grenouille, du lapin et de la sauterelle.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Kangaroo", an epic pet from the "Stadium Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them. Same family and same style as the attached frog, rabbit and grasshopper companions, but it looks a bit more special because it is epic.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a kangaroo inspired by a sunny athletics stadium. Pear-shaped body, very big round head, huge long back feet made for jumping, short arms, a thick tail that touches the ground and helps it stand. It stands upright and proud on its big feet and tail, happy and full of energy, fists raised like a champion.
Body: warm ginger orange (#D9822B, lighter belly #F6D9A8) with no markings; inside of the ears in the belly color.
Head: two very big round eyes, dark brown with one white highlight, two big rounded upright ears, a small dark brown nose (#4A2A1A), a confident big smile.
Special feature: a pair of big round red boxing gloves (#E8302E) with white cuffs (#FFFFFF).
Arms / legs: short arms ending in the boxing gloves, strong thighs, very long flat back feet.
Back / tail: a thick tapered tail, same orange; a visible pouch on the belly with a slightly darker edge (#C26F20).
Small details: a thin purple ribbon (#8E44EC) tied around the neck with a small knot; nothing else.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, pouch, head, eyes, ears, nose, arms, gloves, cuffs, thighs, feet, tail, ribbon) so it can be rebuilt in 3D with few polygons.
```

## Puce savante (`compagnon_puce`, T-303)

Prompt rempli le 2026-11-14. Joindre les planches de la grenouille, du lapin, de la sauterelle et du kangourou.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Clever Flea", a legendary pet from the "Stadium Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them. Same family and same style as the attached frog, rabbit, grasshopper and kangaroo companions, but it clearly looks legendary and magical.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary, not a realistic insect, no hair, no mandibles. No text, no logos, no ground, no base, no shadow, no aura ring.

Design: a tiny flea acrobat inspired by a circus show and an athletics stadium. Small round egg-shaped body, very big round head, two strong bent back legs made for jumping, four very short thin front legs. It is small (about half the height of the rabbit) but proud, standing upright like a little star performer, one tiny arm raised in a bow.
Body: deep purple-plum (#6B3FA0, lighter belly #C9B3F0) with no markings.
Head: two very big round eyes, white with big black pupils and one white highlight, two short antennae with small round tips, a cheeky smile.
Special feature: a small golden top hat (#FFC531) with a purple band, tilted on the head, and a short flowing red cape (#D7263D) with a golden edge, tied at the neck.
Arms / legs: two strong bent back legs with small round feet, four short thin front legs, one raised.
Back / tail: the cape covers the back down to the middle of the body.
Small details: three small golden five-pointed stars (#FFD447) floating around it at different heights, clearly separated from the body.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, head, eyes, antennae, top hat, hat band, cape, cape edge, back legs, front legs, feet, stars) so it can be rebuilt in 3D with few polygons.
```

## Lièvre (`compagnon_lievre`, T-303)

Prompt rempli le 2026-11-14. Premier compagnon de l'œuf du champion : « même style, plus stylisés » ([[Modèles 3D]]). Joindre les planches du lapin et du kangourou.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Hare", a common pet from the "Champion Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and jumps with them. Same family and same style as the attached rabbit and kangaroo companions, but a little more athletic and stylish, like a young champion.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no numbers, no logos, no ground, no base, no shadow, no aura ring.

Design: a hare inspired by an athletics stadium and a sprint final. Slimmer body than the rabbit, big round head, very long legs and big long feet made for running and jumping, short fluffy tail. It stands upright in a confident sprinter pose, chest out, happy and full of energy.
Body: golden sandy brown (#C8955A, lighter belly and muzzle #F3E2C4) with no markings.
Head: two very big round eyes, amber brown with one white highlight, two very long ears with dark brown tips (#5A3A22), a small pink nose (#E88A9A), a determined happy smile.
Special feature: a white sprinter's tank top (#FFFFFF) with one gold diagonal stripe (#F2B531), and a thin gold laurel wreath (#F2B531) around the base of the ears.
Arms / legs: short arms with small paws, long strong legs, big long feet in light blue running shoes (#5BC0F8) with white soles.
Back / tail: short round white fluffy tail.
Small details: nothing else; keep it very simple.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, head, muzzle, eyes, ears, ear tips, nose, tank top, stripe, laurel wreath, arms, legs, shoes, soles, tail) so it can be rebuilt in 3D with few polygons.
```

## Écureuil volant (`compagnon_ecureuil`, T-303)

Prompt rempli le 2026-11-14. La planche du lièvre est sortie avec des proportions presque humaines : ce prompt impose donc les proportions de la famille (phrase « Proportions »). Joindre les planches du lapin et du kangourou, pas celle du lièvre.

```text
Create a character turnaround sheet of an original cute animal companion for a Roblox long jump game: "Flying Squirrel", a common pet from the "Champion Egg" of world 1 ("Beginner Stadium"). It follows the player by hopping and gliding and jumps with them. Same family and same style as the attached rabbit and kangaroo companions, a little more stylish, like a young champion.

Proportions: chibi pet proportions like the attached companions. The head is as big as the whole body, the body is small and round, the legs are short and stubby. Total height about 1.2 times its width. Not a slim or human-like character.

Style: cartoon 3D game asset, chunky stylized proportions, simple rounded shapes, big head, big eyes, flat cartoon colors, soft studio lighting, pure white background. Same style as a cute stylized mobile game pet. Joyful, sporty and friendly, nothing scary. No text, no numbers, no logos, no ground, no base, no shadow, no aura ring.

Design: a flying squirrel inspired by an athletics stadium and a glider. Round little body, very big round head, short stubby legs, small arms with a stretchy gliding membrane between each arm and leg (like a small cape on each side), a huge fluffy tail curling up behind it. It stands upright with arms slightly open to show the membranes, happy and full of energy.
Body: soft grey-brown (#9A8678, lighter belly and muzzle #F2E6D8), membranes a slightly darker grey-brown (#7C6A5E) with a cream edge.
Head: two very big round eyes, dark brown with one white highlight, two small rounded ears, a small dark nose (#3A2A22), a happy smile with two tiny front teeth.
Special feature: orange aviator goggles (#FF7A1A frame, light blue #8FD3FF lenses) pushed up on the forehead, and a thin gold laurel wreath (#F2B531) behind the goggles like the champion egg.
Arms / legs: small arms and short legs with small round paws.
Back / tail: a very big fluffy tail in the body color, curling up over its back, with a cream tip.
Small details: nothing else; keep it very simple.

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable (body, belly, head, muzzle, eyes, ears, nose, goggles, lenses, laurel wreath, arms, legs, membranes, tail, tail tip) so it can be rebuilt in 3D with few polygons.
```

## Remarques

- Pour garder la famille, préciser les proportions dans chaque prompt (tête aussi grosse que le corps, pattes courtes) : sans cette phrase, Gemini peut sortir un personnage élancé, comme pour le lièvre.

- Un compagnon tient en 500 à 1 500 triangles ([[Modèles 3D]]) : demander peu de petits détails, la silhouette doit suffire à le reconnaître.
- Les versions Argent et Or ne demandent pas de planche : même modèle, matière métallique et médaille au cou ([[Compagnons]]).
- Pour la mascotte géante du monde 1, remplacer « companion » par « giant mascot » et décrire la taille (environ 60 studs).
