# Prompts d'origine (arènes et monstres)

Les cinq prompts tels que Loucas les a apportés le 2026-11-13, mot pour mot. Ils viennent d'un autre jeu (un simulateur où l'on combat des monstres dans des arènes) et servent de modèle. Les versions adaptées au saut en longueur sont dans [[Prompts IA]]. Cette note est une archive : on n'y touche pas, on améliore les versions adaptées.

## Prompt 1 d'origine : planche de concept d'un niveau (Gemini)

```text
Create a concept art sheet of LEVEL [NUMBER] "[LEVEL NAME]" of a Roblox monster-catching simulator. It must look like it belongs to the same game as the attached screenshots (previous levels): copy EXACTLY that building style, the same wall made of tall rectangular pillars side by side (no gaps) with flat caps on top and drips hanging from the caps, the same mix of clean blocky walls and simple LOW POLY props. Only the colors and the theme change: [THEME IN ONE SENTENCE, e.g. a frozen glacier cave / a jungle temple / a volcano], where the [MONSTER NAME] lives. It is a big rectangular fighting arena [bigger than the previous levels], with details along the walls and [a few low details towards the middle], but always with clear open space to fight. Show only the environment: no characters, no monsters, no text, no logos, no UI.

Style: the same as the screenshots. Walls built from clean rectangular pillars with flat faces and sharp edges, props in simple low poly (faceted, flat shaded, a few big shapes), bright and readable for a game. No LEGO studs, no realistic details, no textures, no letters.

Colors ([MOOD: e.g. cold and bright / warm and dangerous], but bright and readable):
- Ground: checkerboard of 5x5 stud tiles in two [THEME] colors ([#HEX] and [#HEX]), [optional: a few thin glowing cracks / snow patches / moss lines (#HEX)].
- Wall: [WALL MATERIAL] pillars (main [#HEX], dark sides [#HEX], light top edges [#HEX]) [optional: with a glowing band (#HEX) near the top].
- Caps on top of the pillars: [CAP MATERIAL] [#HEX] flat caps (slightly wider than the pillar, darker edges [#HEX]), with [DRIPS: moss / icicles / lava / molten gold / vines] hanging down the faces ([#HEX] and [#HEX]).
- Props: [MAIN PROP MATERIAL #HEX], [SECOND MATERIAL #HEX], [GLOW / FIRE / WATER #HEX].
- Sky: [SKY: e.g. bright blue with clouds / dark night with aurora / deep space with nebula #HEX to #HEX].

Layout (big rectangular arena, deeper than wide; a player is tiny, about 1/[40] of the width):
- GROUND: FLAT checkerboard, no hills, no holes, no deep water.
- SIDE WALLS (left and right): one continuous solid wall of tall rectangular pillars side by side, touching each other with NO gaps, of different widths and heights (alternating taller and shorter like battlements), about 7-8 times the height of a player, each with its cap and drips, exactly like the previous levels.
- FRONT WALL: the same pillars, with ONE entrance opening in the middle (where players come in from the previous level), framed by a big gate: [GATE DESIGN: two tall pillars with ... on top and a ... beam above the opening].
- BACK WALL: the same pillars, with ONE EXIT opening in the middle (to the next level), framed by the same gate as the entrance. On the [left / right] of the exit, against the back wall, [LANDMARK: the big signature object of the level, e.g. a giant frozen throne / a temple altar / a volcano forge] – the landmark of the level.
- DETAILS ALONG THE WALLS: [4-6 KINDS OF PROPS with numbers, e.g. 4 giant crystal clusters in the corners; 6 braziers along the side walls; 4 obelisks; a few big rocks].
- DETAILS TOWARDS THE CENTER (low or high up, so the fight stays free): [e.g. a big FLAT symbol on the floor in the center; flat glowing lines towards the corners; 4 small waist-high plinths; one big object FLOATING HIGH above the center; small floating rocks high in the air; sparkles in the air].

Keep at least 60% of the ground free for the fight: the center area and wide lanes between the details stay open.

NOT allowed: houses, castles, fences, signs with letters, stairs, swirling portals, LEGO studs, lasers, robots, modern sci-fi machines, any other opening in the walls (only the entrance and the exit).

Sheet layout: 3 images of the SAME level on one sheet: 1) big isometric 3/4 overview from above, seen from the entrance side, 2) top view (plan), 3) ground level view from the entrance looking towards the exit gate and the landmark. Keep every part clearly readable so it can be rebuilt in 3D.
```

## Prompt 2 d'origine : construction d'un niveau en GLB (Claude)

```text
Build LEVEL [NUMBER] "[LEVEL NAME]" of my Roblox monster-catching simulator from the attached concept sheet (isometric view, top view, ground view of the same level), ready to import into Roblox Studio. It comes after my previous levels and must have EXACTLY the same building style and structure: walls of tall rectangular pillars side by side with flat caps and drips, props in clean low poly. Only colors and theme change ([THEME]). Follow the concept closely, with the exact sizes below. Make the props BIG and well readable from far away.

STYLE
Walls and caps: clean boxes with flat faces and sharp edges. Everything else ([LIST OF PROPS]): simple LOW POLY, flat shaded facets, NOT built from cubes or stacked boxes (except [the gate pillars / blocky props], which are clean bevelled blocks). Do NOT model LEGO studs anywhere. No letters or writing anywhere. No black outlines, no textures.

LOW POLY PROPS
- [LANDMARK]: [W] wide, [D] deep, [H] high, [MATERIAL #HEX] with [DETAILS #HEX]; [glowing part] is a separate glow mesh.
- Entrance gate: 2 tall pillars (6 x 6, [44] high) with [CAP / TOP DETAIL], joined by a [BEAM MATERIAL] beam above the opening (bottom face of the beam at Y = 31).
- [PROP 1]: [shape, size in studs, colors].
- [PROP 2]: [shape, size in studs, colors].
- [PROP 3]: [shape, size in studs, colors].
- [CENTER PROPS]: [flat floor symbol, plinths, floating object: shape, size, colors].

COLORS (keep them bright, Roblox lighting darkens them a bit)
- Floor checkerboard in 5x5 stud squares: [#HEX] and [#HEX].
- Wall: main [#HEX] on the faces looking into the arena, dark [#HEX] on the side faces, light [#HEX] on top edges[; glowing band #HEX near the top (part of the Glow mesh)].
- Caps: [#HEX] (darker edges [#HEX]), slightly wider (0.6 studs overhang); drips [#HEX] and [#HEX] [(part of the Glow mesh if they glow)].
- Props: [MATERIAL #HEX, ...].
- Glow colors (separate glow meshes): [#HEX, ...].
Export vertex colors in sRGB so the colors in Roblox match the preview. Do NOT convert to linear.

LAYOUT (1 unit = 1 stud, Y up, origin (0,0,0) = center of the arena at floor level; +Z = back side, -Z = front side where players come in from the previous level, +X = east). A Roblox player is 5 studs tall.
- FLOOR: x -[W/2]..[W/2], z -[D/2]..[D/2], top face exactly at Y = 0, 4 studs thick, checkerboard of 5x5 squares (square corners on multiples of 5). Completely flat.
- WALKABLE ARENA: x -[W/2-5]..[W/2-5], z -[D/2-5]..[D/2-5].
- SIDE WALLS (west and east): inner face exactly on x = ±[W/2-5], outer face on x = ±[W/2+5] (10 thick), from z = -[D/2] to z = [D/2]. A row of tall rectangular pillars of different widths (8-15 studs along the wall) and different heights, alternating tall and short like battlements: heights between [32] and [44] studs (most around [38]), some pillars set back 1-2 studs or sticking out 1 stud, but the inner face never comes inside x = ±[W/2-6]. Every pillar is a SEPARATE closed box (not merged with its neighbours), but the pillars stand SIDE BY SIDE touching each other, with NO gaps: one continuous solid wall. Each pillar has a flat cap 1 stud thick on top that sticks out 0.6 studs on every side, with drips hanging down from the cap (thin vertical strips 0.5-1 wide, 2-8 long), sitting 0.05 studs off the faces.
- FRONT WALL: same pillars, inner face on z = -[D/2-5], outer face on z = -[D/2] (5 thick), from x = -[W/2+5] to [W/2+5], with ONE OPENING exactly x -25..25, Y 0..30 (nothing inside it). Entrance gate pillars at x = ±29 (centers), z = -[D/2-8]; beam from x = -32 to 32, bottom face at Y = 31. Nothing in front of the opening for 20 studs.
- BACK WALL: same pillars, inner face on z = [D/2-5], outer face on z = [D/2] (5 thick), with ONE EXIT OPENING exactly x -25..25, Y 0..30 (nothing inside it). Exit gate identical to the entrance gate at z = [D/2-8]. Nothing in front of the exit for 20 studs.
- Corners: walls meet as closed corners.
- [LANDMARK]: centered at x = [X], back face against the back wall. Never in front of the exit.
- [PROPS ALONG THE WALLS]: [how many, exact positions, distance from the wall].
- [CENTER PROPS]: [exact positions; floating objects at Y = ...].
- FREE AREAS: nothing taller than 0.2 inside the center area (radius [30]) and in the lanes x -15..15 and z -15..15 across the whole arena; nothing tall within 20 studs of the entrance and of the exit.

PARTS (separate named meshes – these names are used by my game code)
- Floor.
- Wall_West, Wall_East, Wall_North (back), Wall_South (front, with the opening), WallCaps_West, WallCaps_East, WallCaps_North, WallCaps_South (caps).
- Gate (entrance gate), ExitGate (exit gate).
- Glow (all glowing parts), [one named mesh per prop type: e.g. Landmark, CrystalClusters, Braziers, Obelisks, Rocks, Plinths, FloatingRocks, Sparkles].
Empty nodes (positions only): LevelCenter (0,0,0), EntranceCenter (0,0,-[D/2-2.5]), ExitCenter (0,0,[D/2-2.5]), [LandmarkCenter].

ROBLOX REQUIREMENTS (very important)
- Exact sizes and positions as in LAYOUT, 1 unit = 1 stud.
- No overlapping or coplanar faces between touching meshes (no flickering): pieces meet edge to edge, decorations sit at least 0.05 studs off the surface they touch.
- Each mesh under 10,000 triangles, total under [80,000].
- Vertex colors only, no textures. No characters, no monsters, no lights, no cameras, no sky in the export.
- Export as GLB.
```

## Prompt 3 d'origine : planche d'un monstre (Gemini)

```text
Create a character turnaround sheet of an original fantasy monster for a Roblox game: "[MONSTER NAME]", the monster of level [NUMBER] ("[LEVEL NAME]").

Style: low poly 3D game asset, chunky stylized proportions, angular faceted shapes with flat planes, flat cartoon colors, thick black outline around every part, soft studio lighting, pure white background. Same style as a stylized low poly mobile game monster. No text, no logos, no ground, no base, no shadow, no aura ring. No round balls or blob shapes.

Design: [WHAT IT IS: animal / creature / living armor / elemental...] inspired by [LEVEL THEME]. [BODY SHAPE: e.g. huge heroic silhouette, wide shoulders, thick legs, long tail...]. It stands [POSE: tall and proud / low and ready to pounce], slightly leaning forward, ready to fight.
Body: [MAIN MATERIAL] ([COLOR #HEX], lighter facets [COLOR #HEX]) with [GLOWING DETAIL: glowing cracks / runes / veins] ([COLOR #HEX]), framed by [TRIM MATERIAL: gold / ice / bone trims] ([COLOR #HEX]).
Head: [HEAD: face, glowing eyes #HEX, horns / crests / helmet], [MOUTH: fangs, tongue...].
Special feature: [THE MOST RECOGNIZABLE ELEMENT: e.g. a burning star core in the chest / ice crystals on the back / a flaming mane].
Arms / legs: [LIMBS: claws, big fists, shoulder armor...].
Weapon or attack part (optional): [WEAPON OR ATTACKING PART: hammer, whip tail, horns...].
Back / tail: [BACK AND TAIL: spikes, cape, crystals, fins...].
Small details: [3-4 SMALL DETAILS: rivets, chains, gems, LEGO studs on the back...].

Sheet layout: 6 views of the SAME model, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Neutral standing pose, limbs slightly away from the body, head straight. Keep every part clearly separated and readable ([PART LIST: body, head, eyes, horns, upper legs, lower legs, paws, tail, back crystals...]) so it can be rebuilt in 3D.
```

## Prompt 4 d'origine : construction et animations d'un monstre (Claude)

```text
Build [MONSTER NAME] from the attached images, ready to import into Roblox Studio, with animations, attack moves and visual effects. It is the monster of level [NUMBER] ("[LEVEL NAME]") of my game: it must look [powerful / scary / cute but dangerous] and very cool.

STYLE
Stylized low-poly cartoon monster, NOT boxy or voxel: sculpted shapes with clear flat facets (sharp angular planes), like a low-poly cartoon game monster.
Colors (bright and readable): [MAIN COLOR #HEX, lighter facets #HEX], [GLOWING DETAIL COLOR #HEX], [TRIM COLOR #HEX], [EYES #HEX], [OTHER PARTS + #HEX].
Export vertex colors in sRGB so the colors in Roblox match the preview. Do NOT convert to linear.

SHAPES
- No spheres, no ball-shaped or blob parts, no perfectly round shapes (round parts become faceted crystals or faceted rocks).
- Build every part from angular, faceted low poly shapes with flat planes and clear edges.
- [BODY TYPE: e.g. a four-legged beast / a living suit of armor / a serpent]: the body flows from part to part, with real joints that bend ([LIST OF JOINTS: knee, elbow, wrist, neck, tail segments...]).
- [SPIKES / CRYSTALS / ARMOR PLATES] must be sharp and readable from far away.

BLACK CARTOON OUTLINE (very important, it must work in Roblox)
- Thick black outline around every part, made as an inverted-hull mesh: a copy of each mesh pushed out about 0.12–0.18 studs along the normals, with flipped faces and solid black vertex color.
- The outline must be geometry inside the GLB (one outline mesh per part, named e.g. Head_Outline, child of its part), not a shader or post-effect.
- Outline meshes must move with their part in every animation. Glow meshes ([GLOW PART NAMES]) have no outline.

ANATOMY
Body: [DESCRIPTION OF THE TORSO + special feature].
Head: [DESCRIPTION: eyes (separate glowing mesh Eyes), horns, mouth, jaw (separate mesh Jaw if it opens)].
[Legs / arms]: [DESCRIPTION: upper part, lower part, paws / fists / claws].
[Tail / back / cape]: [DESCRIPTION, number of segments so it can swing].
[Weapon, optional]: [DESCRIPTION, which hand / part holds it].
Glowing details: [CRACKS / RUNES / CRYSTALS] as separate glowing meshes, slightly in front of the surface, no flicker.

ROBLOX REQUIREMENTS (very important)
Scale: about [HEIGHT] studs tall, about [WIDTH] studs wide and about [LENGTH] studs long (1 unit = 1 stud).
Facing forward along -Z, standing on the ground at Y = 0, centered.
SEPARATE NAMED MESHES, not one merged mesh: [Body (root), Head, Jaw, Eyes, LegFL_Upper, LegFL_Lower, PawFL, ... Tail1, Tail2, ... glowing meshes].
Hierarchy: [which mesh is child of which: e.g. Head, legs and Tail1 children of Body; Jaw and Eyes children of Head; lower leg -> paw; Tail1 -> Tail2 -> Tail3].
Pivot of each mesh at its joint (neck, shoulders, hips, knees, ankles, tail base...).
Each mesh under 10,000 triangles, total under [30,000–45,000] (outlines included).
No overlapping or coplanar faces between touching parts (no flickering / z-fighting).
Vertex colors only, no textures. Mark glowing parts ([GLOW PART NAMES]).
Animate only the named meshes, not an extra root node. Bake all animations at 30 fps, with keyframes on the same times for every joint.
Neutral pose: [NEUTRAL POSE]. Export as GLB. No ground ring or aura under the model.

MOVEMENT ANIMATIONS (animated preview + keyframe table: time in seconds and rotation in degrees for every joint)
IDLE (3 s loop): [breathing, tail sways, glowing parts pulse, small head turn].
WALK (about 1.2 s loop): [how it walks].
RUN (about 0.6 s loop): [how it runs / charges].
```

## Prompt 5 d'origine : attaques et effets d'un monstre (suite du prompt 4)

```text
ATTACK MOVES (it fights the player). For each: animated preview, keyframe table, wind-up / hit / recovery timing, the exact "HIT" frame, range in studs, hit area shape (cone, circle, line) seen from above, cooldown in seconds.
[ATTACK 1 NAME] (close): [what it does] (wind-up [X] s, hit at about [X] s). [Hit area + size]. Cooldown [X] s.
[ATTACK 2 NAME] (close): [what it does] (wind-up [X] s, hit at about [X] s). [Hit area + size]. Cooldown [X] s.
[ATTACK 3 NAME] (medium distance, charge): [what it does]. Line hit area, [X] studs wide. Used at [X–Y] studs. Cooldown [X] s. The forward movement must be on the Body translation so I can keep it in place in Roblox.
[ATTACK 4 NAME] (far or rare): [what it does] (wind-up [X] s, hit at about [X] s). [Hit area + size]. Cooldown [X] s.
HIT REACTION: short stagger backwards (about 0.4 s).
DEFEATED (about 3 s, not looping): [how it falls], glowing parts fade to dull, then it stays still on the ground. Last pose stays on the ground, nothing sinks into the floor.
Which attack it uses by distance (close: [ATTACKS], medium: [ATTACK], far: [ATTACK]).
Every attack has a clear warning before it hits (wind-up pose + glow + ground marker) so the player can dodge.

VISUAL EFFECTS (animated preview + list with colors, size, speed, amount)
Always on: [e.g. small particles rising from the glowing parts, sparkles around the head].
Walk: [dust / snow / embers under each step].
Run: [bigger clouds and a trail behind it].
Attacks: [one effect per attack: shockwave ring, arc trail, charge trail, explosion...].
Glowing parts pulse brighter during attacks.
[Epic / scary] and powerful, but readable and not too busy.
```
