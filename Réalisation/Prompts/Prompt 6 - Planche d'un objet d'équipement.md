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

## Remarques

- Budget : 300 à 1 000 triangles par objet porté, sans collision ([[Modèles 3D]]). D'où le peu de détails demandés.
- Les flammes et la fumée ne font pas partie du modèle : ce sont des effets ajoutés par le code ([[Décor et effets]]).
- Les images retenues se rangent dans `assets/modeles/planches/`, nommées par l'identifiant de l'objet.
- Dans Studio, chaque modèle porte une Part `Poignee` et l'attribut `Attache` = `Dos` ([[Contrats]]).
