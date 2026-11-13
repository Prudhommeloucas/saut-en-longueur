# Prompt 2 - Construction d'un monde

- **Sert à** : construire en 3D le décor d'un monde d'après la planche de concept, aux bonnes tailles, prêt pour Roblox Studio.
- **IA** : Claude avec Blender (Claude Code + MCP Blender). Avec Claude Design, le même texte sert à obtenir le plan coté vu de dessus, sans 3D ([[Claude Design]]).
- **À joindre** : la planche obtenue avec [[Prompt 1 - Planche de concept d'un monde]].
- **Avant** : réserver la tâche, et vérifier que les noms existent dans [[Contrats]].

Voir [[Prompts IA]], [[Map]], [[Modèles 3D]] et [[Mondes]].

## À remplir

| Crochet | Où trouver la valeur |
| --- | --- |
| Tailles de la piste, du bac, de la place | [[Map]], [[Construction du monde 1]] |
| Studs par mètre | [[Mondes]], « Échelle des distances » (4 pour les mondes 1 et 2) |
| Noms des meshes, tags | [[Contrats]] |
| Budgets de triangles | [[Modèles 3D]] |

## Prompt

```text
Build the scenery of WORLD [NUMBER] "[WORLD NAME]" of my Roblox long jump simulator from the attached concept sheet (isometric view, top view, ground view of the same world), ready to import into Roblox Studio. It comes after my previous worlds and must have EXACTLY the same building style: cartoon, simple shapes, rounded edges, bold flat colors. Only colors and theme change ([THEME]). Follow the concept closely, with the exact sizes below. Make the props BIG and well readable from far away.

STYLE
Cartoon low detail models with rounded (bevelled) edges and chunky exaggerated proportions. Flat colors, no textures, no black outlines. No letters or writing anywhere (texts are added later in Roblox). No LEGO studs. Joyful and sporty, nothing scary.

PROPS
- [LANDMARK]: [W] wide, [D] deep, [H] high, [MATERIAL #HEX] with [DETAILS #HEX]; [glowing part] is a separate glow mesh.
- Shop kiosk: [W x D x H], striped awning [#HEX and #HEX], counter, a big shape of the sold item on the roof.
- Egg incubator: round base [diameter], glass dome, glowing tubes [#HEX].
- Portal: stone arch [W x H], opening [W x H], the glowing surface is a separate mesh.
- [PROP 1]: [shape, size in studs, colors].
- [PROP 2]: [shape, size in studs, colors].
- [PROP 3]: [shape, size in studs, colors].

COLORS (keep them bright, Roblox lighting darkens them a bit)
- Ground: [#HEX]. Runway: [#HEX] with white lines [#FFFFFF]. Landing area: [#HEX], border [#HEX].
- Props: [MATERIAL #HEX, ...]. Game accents: orange #FF7A1A, blue #1E90FF.
- Training pads: red (power), blue (speed), green (glide).
- Glow colors (separate glow meshes): [#HEX, ...].
Use one or two materials per model. If you use vertex colors, export them in sRGB so the colors in Roblox match the preview. Do NOT convert to linear.

LAYOUT (1 unit = 1 stud; [4] studs = 1 meter in this world; in Roblox: Y up, +X = direction of the jump, origin (0,0,0) = middle of the take-off board at ground level. In Blender: Z up, same X). A Roblox player is 5 studs tall.
- GROUND: top face exactly at Y = 0, completely flat around the plaza and the runway.
- SPAWN PLAZA: x -[..]..-[..], z -[..]..[..]. Training pads: [9] flat pads [size], 0.2 high, at [positions], grouped by color, from small to big.
- RUNWAY: from x = -[LENGTH] to x = 0, [WIDTH] wide, centered on z = 0, top face at Y = 0.
- TAKE-OFF BOARD: x -[2]..0, same width as the runway, white, with a thin red strip on the landing side.
- LANDING AREA: from x = 0 to x = [LENGTH IN STUDS], [WIDTH] wide, top face at Y = 0, border [1] high on both sides.
- DISTANCE MARKERS: one small post every [40] studs (10 m) on the z = -[..] side, one big arch every [400] studs (100 m) spanning the landing area, opening at least [30] high.
- ALONG THE SIDES: [what, how many, exact positions, distance from the runway].
- LANDMARK: centered at x = [X], z = [Z]. Never on the runway or the landing area.
- PORTAL: at x = [X], z = [Z], facing the plaza.
- RINGS IN THE AIR: [number] rings, 12 studs in diameter, centered on z = 0, at x = [..], Y = [..].
- FREE AREAS: nothing taller than 0.2 on the runway, the take-off board and the landing area; nothing within [10] studs of their sides; the plaza keeps wide open lanes between the pads and the kiosks.

PARTS (separate named meshes - these names are used by my game code)
- Piste (runway), PlancheAppel (take-off board), Bac (landing area), Sol (ground).
- One named mesh per prop type: Stand, Incubateur, Portail, Pantheon, Podium, Anneau, [Landmark, Tribune, Projecteur, ...].
- Glow (all glowing parts).
Empty nodes (positions only): PointApparition, [PortailCentre, LandmarkCentre].

ROBLOX REQUIREMENTS (very important)
- Exact sizes and positions as in LAYOUT, 1 unit = 1 stud, transforms applied, origin of each prop at its foot.
- No overlapping or coplanar faces between touching meshes (no flickering): pieces meet edge to edge, decorations sit at least 0.05 studs off the surface they touch.
- Each mesh under 10,000 triangles ([200-2,000] for a small prop, 5,000 at most for a big one), total under [80,000].
- No characters, no animals, no lights, no cameras, no sky in the export.
- Take a screenshot from the same three angles as the concept sheet and compare before exporting.
- Export as FBX [or GLB].
```

## Remarques

- Dans ce projet, les éléments simples (sol, piste, bac, zones) se construisent plus vite en Parts dans Studio par le MCP Roblox Studio. Blender sert surtout aux objets du décor ([[Modèles 3D]]).
- Les fichiers vont dans `assets/modeles/source/` (`.blend`) et `assets/modeles/export/` (`.fbx`), puis s'inscrivent dans [[Registre des modèles]].
- Le portail est calme, pas un tourbillon inquiétant : voir la description dans [[Modèles 3D]].
