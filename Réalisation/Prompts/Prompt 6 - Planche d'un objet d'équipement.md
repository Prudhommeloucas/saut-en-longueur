# Prompt 6 - Planche d'un objet d'équipement

- **Sert à** : obtenir l'image de référence d'un objet porté par le joueur (propulseur, chaussures, ailes, matériel) sous six angles, avant de le modéliser.
- **IA** : Gemini (génération d'image).
- **À joindre** : rien d'obligatoire. La planche d'un objet de la même famille aide à garder l'échelle et le style.
- **Ensuite** : donner l'image à Claude Code, qui modélise dans Blender par le MCP ([[Modèles 3D]]).

Voir [[Prompts IA]], [[Équipement]] et [[Direction artistique]]. Ce prompt est dérivé du [[Prompt 3 - Planche d'un personnage]].

## Modèle à trous

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "[OBJECT NAME]", a [FAMILY: back-mounted thruster / pair of shoes / pair of wings] worn by the player. It is the [cheap starter / mid-range / best] item of world [NUMBER] ("[WORLD NAME]").

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no ground, no base, no shadow, no flames, no smoke.

Design: [WHAT IT IS, IN ONE SENTENCE].
Main body: [SHAPE AND COLORS #HEX].
Thrust part: [NOZZLES / WHERE THE JET COMES OUT, pointing down, COLORS #HEX].
How it is worn: [HARNESS: two shoulder straps and a flat back plate #HEX], sized for a blocky character about twice as tall as the object.
Special feature: [THE MOST RECOGNIZABLE ELEMENT].
Small details: [2-3 SMALL DETAILS].
Colors: at most four colors: [#HEX, #HEX, #HEX, #HEX].

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Object upright, exactly as worn on the back. Keep every part clearly separated and readable ([PART LIST]) so it can be rebuilt in 3D with few polygons.
```

## Les trois propulseurs du monde 1

Prompts remplis le 2026-11-14 ([[Équipement]], catalogue du monde 1). Une planche par objet. La progression doit se lire : bricolé, puis sérieux, puis haut de gamme.

### Bouteille de soda (`propulseur_soda`, 500 pièces)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Soda Bottle Booster", a back-mounted thruster worn by the player. It is the cheap starter item of world 1 ("Beginner Stadium"), clearly homemade.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no ground, no base, no shadow, no flames, no smoke, no liquid spraying.

Design: two big soda bottles strapped side by side upside down, used as a homemade jetpack.
Main body: two fat rounded plastic bottles, translucent blue (#1E90FF) with orange fizzy soda inside (#FF7A1A), each with a plain white label band with nothing written on it (#FFFFFF).
Thrust part: the two bottle necks point straight down, each closed by a big chunky orange cap (#FF7A1A) that works as the nozzle.
How it is worn: two wide grey fabric shoulder straps and a flat grey back plate (#5A6270), sized for a blocky character about twice as tall as the object. The bottles are held together by two thick bands of grey duct tape.
Special feature: a few big round bubbles visible inside the bottles.
Small details: a bent metal wire handle on top, one cork-shaped safety pin on a short string.
Colors: at most four colors: #1E90FF, #FF7A1A, #FFFFFF, #5A6270.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Object upright, exactly as worn on the back. Keep every part clearly separated and readable (left bottle, right bottle, caps, labels, tape bands, back plate, shoulder straps, handle) so it can be rebuilt in 3D with few polygons.
```

### Extincteur (`propulseur_extincteur`, 8 000 pièces)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Fire Extinguisher Booster", a back-mounted thruster worn by the player. It is the mid-range item of world 1 ("Beginner Stadium"), sturdier and more serious than a homemade one.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no ground, no base, no shadow, no flames, no smoke, no foam spraying.

Design: one big fat fire extinguisher worn upside down as a backpack jetpack.
Main body: one large rounded red cylinder (#E5484D) with a domed end, a plain white band around the middle with nothing written on it (#FFFFFF).
Thrust part: the valve head is at the bottom; a short thick black hose (#2B2F38) curves down from it and ends in a wide cone nozzle pointing straight down.
How it is worn: two wide black shoulder straps and a flat black back plate (#2B2F38), sized for a blocky character about twice as tall as the object. Two chunky yellow metal clamps (#FFC83D) hold the cylinder on the plate.
Special feature: a big round pressure gauge on the side with a simple needle and a green and red dial, no numbers.
Small details: a yellow squeeze handle with a ring pin (#FFC83D), a small dent in the red body.
Colors: at most four colors: #E5484D, #2B2F38, #FFC83D, #FFFFFF.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Object upright, exactly as worn on the back. Keep every part clearly separated and readable (cylinder, white band, valve head, handle, hose, cone nozzle, gauge, clamps, back plate, shoulder straps) so it can be rebuilt in 3D with few polygons.
```

### Réacteur de poche (`propulseur_reacteur`, 120 000 pièces)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Pocket Jet Engine", a back-mounted thruster worn by the player. It is the best and most expensive item of world 1 ("Beginner Stadium"): clean, shiny and high-tech, but still cute and toy-like.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no ground, no base, no shadow, no flames, no smoke, no weapons.

Design: a small fat airplane jet engine with little wings, worn vertically on the back.
Main body: one short fat turbine barrel, white (#FFFFFF) with a wide orange stripe (#FF7A1A), air intake on top with a big simple fan of six thick blades and a round blue nose cone (#1E90FF).
Thrust part: a wide dark grey exhaust cone at the bottom (#3A404D), pointing straight down, with a glowing orange ring just inside the rim (#FF7A1A).
How it is worn: two wide dark grey shoulder straps and a flat dark grey back plate (#3A404D), sized for a blocky character about twice as tall as the object.
Special feature: two short rounded stabilizer fins on the sides, like tiny airplane wings, orange with a blue tip, and one small tail fin on the back.
Small details: three big round rivets on the barrel, a small round blue glowing light on each fin tip.
Colors: at most four colors: #FFFFFF, #FF7A1A, #1E90FF, #3A404D.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Object upright, exactly as worn on the back. Keep every part clearly separated and readable (turbine barrel, intake fan, nose cone, exhaust cone, glow ring, left fin, right fin, tail fin, back plate, shoulder straps) so it can be rebuilt in 3D with few polygons.
```

## Planche de style (T-010)

Prompts remplis le 2026-11-14. La grenouille est dans [[Prompt 3 - Planche d'un personnage]]. Dimensions et palette : [[Modèles 3D]], « Planche de style ».

### Semelles à ressorts (`chaussures_ressorts`)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Spring Soles", a pair of shoes worn by the player. It is the cheap starter item of world 1 ("Beginner Stadium").

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no legs, no ground, no base, no shadow.

Design: one big chunky sneaker standing on two fat metal springs, like a toy jumping shoe. Show ONE single shoe (the left one); the right one is a mirror copy.
Main body: a fat rounded sneaker with a big bulbous toe, bright orange (#FF7A1A), with one wide blue diagonal stripe on each side (#1E90FF) and a thick white padded collar around the ankle opening (#FFFFFF).
Sole and springs: a thick rounded white sole (#FFFFFF); under it two big chunky chrome coil springs (#AEB8C6), one under the toe and one under the heel, each with only three thick coils and a small flat dark grey foot pad underneath (#5A6270).
How it is worn: on the foot of a blocky character; the shoe is about as wide as the foot and twice as long, the springs lift the character off the ground.
Special feature: the two oversized springs, as tall as the sole is thick times two.
Small details: three thick white laces across the top, a small white pull tab at the heel.
Colors: at most four colors: #FF7A1A, #FFFFFF, #1E90FF, #AEB8C6.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Shoe upright, standing on its springs. Keep every part clearly separated and readable (shoe upper, toe, collar, stripe, laces, sole, front spring, back spring, foot pads) so it can be rebuilt in 3D with few polygons.
```

## Les deux autres chaussures du monde 1 (T-207)

Prompts remplis le 2026-11-14. Même famille que les semelles à ressorts : joindre `assets/modeles/planches/chaussures_ressorts.webp` à Gemini aide à garder l'échelle et le style. La progression doit se lire : jouet, puis sport, puis haute technologie.

### Baskets turbo (`chaussures_turbo`, 2 500 pièces)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Turbo Sneakers", a pair of shoes worn by the player. It is the mid-range item of world 1 ("Beginner Stadium"): sporty, fast and more serious than toy spring shoes.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no legs, no ground, no base, no shadow, no flames, no smoke.

Design: one big chunky running sneaker with small wings and a little jet nozzle at the heel. Show ONE single shoe (the left one); the right one is a mirror copy.
Main body: a fat rounded running sneaker, bright blue (#1E90FF), with a thick white padded collar (#FFFFFF) and a big rounded toe cap in white.
Sole: a thick chunky white sole (#FFFFFF) with a bright yellow stripe running all along its side (#FFC83D), slightly raised at the toe like a racing shoe.
Thrust part: one short round nozzle at the back of the heel, dark grey (#3A404D), pointing backwards and slightly down, with a yellow ring around its opening (#FFC83D).
How it is worn: on the foot of a blocky character; the shoe is about as wide as the foot and twice as long.
Special feature: two small rounded yellow fins (#FFC83D), one on each side of the ankle, swept backwards like little wings.
Small details: three thick white laces across the top, two yellow speed stripes on each side of the shoe.
Colors: at most four colors: #1E90FF, #FFFFFF, #FFC83D, #3A404D.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Shoe upright, standing flat. Keep every part clearly separated and readable (shoe upper, toe cap, collar, laces, sole, sole stripe, side fins, heel nozzle, nozzle ring) so it can be rebuilt in 3D with few polygons.
```

### Bottes à réaction (`chaussures_reaction`, 40 000 pièces)

```text
Create a prop turnaround sheet of an original piece of equipment for a Roblox long jump game: "Rocket Boots", a pair of boots worn by the player. It is the best and most expensive item of world 1 ("Beginner Stadium"): high-tech and shiny like a cartoon astronaut boot, but still cute and toy-like.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple rounded shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty, a bit silly. No text, no letters, no numbers, no logos, no brand, no character, no legs, no ground, no base, no shadow, no flames, no smoke, no weapons.

Design: one big chunky space boot that rises above the ankle, with two small round jet engines under the sole. Show ONE single boot (the left one); the right one is a mirror copy.
Main body: a fat rounded boot, white (#FFFFFF), with a thick orange cuff at the top (#FF7A1A) and a wide orange band around the ankle.
Sole: a thick dark grey sole (#3A404D), flat underneath.
Thrust part: two short fat round jet nozzles under the sole, one under the toe and one under the heel, dark grey (#3A404D), pointing straight down, each with a glowing blue ring just inside the rim (#1E90FF).
How it is worn: on the foot and lower leg of a blocky character; the boot is about as wide as the foot, twice as long, and as tall as it is long.
Special feature: a small round glowing blue light on each side of the ankle (#1E90FF), like a power indicator.
Small details: two big round buckles on the front, orange; one thin blue stripe along the side of the sole.
Colors: at most four colors: #FFFFFF, #FF7A1A, #3A404D, #1E90FF.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Boot upright, standing on its nozzles. Keep every part clearly separated and readable (boot body, cuff, ankle band, buckles, sole, front nozzle, back nozzle, glow rings, side lights) so it can be rebuilt in 3D with few polygons.
```

### Module de tribune (`tribune_module`)

Le modèle à trous sert aussi pour un élément de décor : on remplace la famille par « stadium prop » et on retire la partie portée.

```text
Create a prop turnaround sheet of an original stadium building block for a Roblox long jump game: "Grandstand Module", one modular section of bleachers placed along the running track of world 1 ("Beginner Stadium"). Identical modules are placed end to end to make a long grandstand.

Style: cartoon 3D game asset, chunky exaggerated proportions, simple shapes with bevelled edges, flat cartoon colors, smooth plastic look, soft studio lighting, pure white background. Low detail, readable from far away and on a phone. Joyful and sporty. No text, no letters, no numbers, no logos, no brand, no people, no crowd, no ground, no shadow, no flags, no lights.

Design: a small stepped grandstand, wider than deep: about 20 units long, 14 deep and 16 high.
Main body: six big concrete steps rising toward the back, light grey (#E8ECF1), with a plain low wall at the back.
Seats: one row of ten chunky rounded plastic seats on each step, alternating orange (#FF7A1A) and blue (#1E90FF) in a checkerboard pattern from row to row.
Roof: one flat sloped orange roof (#FF7A1A) with a thick white front edge, higher at the front than at the back, covering all the rows. It is held only from the back by three thick dark grey posts (#5A6270) with diagonal braces, so nothing stands in front of the seats.
Special feature: the orange and blue checkerboard of seats.
Small details: both ends of the module are flat and open so that two modules join without a gap; no stairs, no railings.
Colors: at most four colors: #E8ECF1, #FF7A1A, #1E90FF, #5A6270.

Sheet layout: 6 views of the SAME object, same size, evenly spaced on one image in 2 rows: front, back, left side, right side, 3/4 front, top. Keep every part clearly separated and readable (steps, back wall, seats, posts, braces, roof, roof edge) so it can be rebuilt in 3D with few polygons.
```

## Remarques

- Budget : 300 à 1 000 triangles par objet porté, sans collision ([[Modèles 3D]]). D'où le peu de détails demandés.
- Les flammes et la fumée ne font pas partie du modèle : ce sont des effets ajoutés par le code ([[Décor et effets]]).
- Les images retenues se rangent dans `assets/modeles/planches/`, nommées par l'identifiant de l'objet.
- Dans Studio, chaque modèle porte une Part `Poignee` et l'attribut `Attache` = `Dos` ([[Contrats]]).
