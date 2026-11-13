# Prompt 4 - Construction et animations d'un personnage

- **Sert à** : construire le modèle 3D d'un compagnon (ou de la mascotte) d'après sa planche, découpé en parties nommées, avec ses animations de déplacement.
- **IA** : Claude avec Blender (Claude Code + MCP Blender). Avec Claude Design, le même texte sert à redessiner la planche à l'échelle, sans 3D ([[Claude Design]]).
- **À joindre** : la planche obtenue avec [[Prompt 3 - Planche d'un personnage]].
- **Ensuite** : [[Prompt 5 - Actions et effets d'un personnage]], dans la même conversation, une fois le modèle validé.

Voir [[Prompts IA]], [[Modèles 3D]], [[Animations]] et [[Compagnons]].

## À remplir

| Crochet | Où trouver la valeur |
| --- | --- |
| Taille, budget de triangles | [[Modèles 3D]], « Budgets » |
| Couleurs | La planche, corrigées avec la [[Direction artistique]] |
| Noms des parties et des animations | [[Contrats]], [[Animations]] |

## Prompt

```text
Build [COMPANION NAME] from the attached images, ready to import into Roblox Studio, with animations. It is a [RARITY] pet companion of world [NUMBER] ("[WORLD NAME]") of my long jump game: it follows the player by hopping and jumps with them. It must look [cute / funny / proud] and very appealing.

STYLE
Stylized cartoon character with simple rounded shapes, big head, big eyes, chunky proportions. Low detail, clean silhouette readable from far away and on a phone.
Colors (bright and readable): [MAIN COLOR #HEX, lighter belly #HEX], [MARKINGS #HEX], [ACCESSORY #HEX], [EYES #HEX], [OTHER PARTS + #HEX].
Flat colors, one or two materials at most, no textures. If you use vertex colors, export them in sRGB so the colors in Roblox match the preview. Do NOT convert to linear.

SHAPES
- Rounded but with few polygons: no high resolution spheres, no tiny details that disappear at a distance.
- [BODY TYPE: e.g. a two-legged hopper / a four-legged runner / a small flying glider]: the body flows from part to part, with real joints that bend ([LIST OF JOINTS: hip, knee, ankle, shoulder, neck, tail base...]).
- The back legs are big and clearly made for jumping.
- [ACCESSORY: headband / bib / gloves / cape] must be readable from far away.

OUTLINE (optional, only if the whole game uses it)
[No outline. / Thick dark outline around every part, made as an inverted-hull mesh: a copy of each mesh pushed out about 0.05-0.08 studs along the normals, with flipped faces and a solid dark color, as geometry inside the file (one outline mesh per part, child of its part).]

ANATOMY
Body: [DESCRIPTION OF THE TORSO + special feature].
Head: [DESCRIPTION: eyes (separate mesh Eyes), ears / antennae, mouth].
Legs / arms: [DESCRIPTION: upper part, lower part, feet / paws].
Tail / back: [DESCRIPTION, number of segments so it can swing].
Accessory: [DESCRIPTION, which part carries it]. The medal ribbon around the neck is a separate mesh (Medal), hidden by default.

ROBLOX REQUIREMENTS (very important)
Scale: about [3] studs tall, about [2.5] studs wide and about [3] studs long (1 unit = 1 stud; a Roblox player is 5 studs tall).
Facing forward along -Z in Roblox (-Y in Blender), standing on the ground at height 0, centered, origin at its feet, transforms applied.
SEPARATE NAMED MESHES, not one merged mesh: [Body (root), Head, Eyes, EarL, EarR, LegL_Upper, LegL_Lower, FootL, LegR_Upper, LegR_Lower, FootR, ArmL, ArmR, Tail1, Tail2, Accessory, Medal].
Hierarchy: [which mesh is child of which: e.g. Head, legs, arms and Tail1 children of Body; Eyes and ears children of Head; upper leg -> lower leg -> foot; Tail1 -> Tail2].
Pivot of each mesh at its joint (neck, shoulders, hips, knees, ankles, tail base...).
Triangles: [500-1,500] for the whole companion (up to 30 are visible at once), never more than 10,000 per mesh.
No overlapping or coplanar faces between touching parts (no flickering / z-fighting).
Animate only the named meshes, not an extra root node. Bake all animations at 30 fps, with keyframes on the same times for every joint.
Neutral pose: [NEUTRAL POSE]. Export as FBX [or GLB]. No ground ring or aura under the model.

MOVEMENT ANIMATIONS (animated preview + keyframe table: time in seconds and rotation in degrees for every joint)
IDLE (3 s loop): [breathing, ears or tail sway, small head turn, a little bounce].
HOP (about 0.6 s loop, follows the player walking): [crouch, push with the back legs, short flight, soft landing with squash and stretch].
SPRINT HOP (about 0.4 s loop, follows the player running down the runway): [longer and flatter hops, ears pushed back by the wind].
```

## Remarques

- Compter les triangles et comparer une capture sous les six angles de la planche avant d'exporter ([[Modèles 3D]]).
- Les animations finales se publient depuis Studio et s'inscrivent dans [[Registre des animations]] ; le tableau d'images clés sert de référence pour les refaire dans l'éditeur d'animation.
- Pour la mascotte géante : environ 60 studs, plusieurs meshes de moins de 10 000 triangles, squelette ([[Animations]]).
