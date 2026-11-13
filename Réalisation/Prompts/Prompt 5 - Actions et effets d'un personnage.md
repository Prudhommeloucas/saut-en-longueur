# Prompt 5 - Actions et effets d'un personnage

- **Sert à** : ajouter au personnage du prompt 4 ses animations d'action (le saut avec le joueur, la fête, l'éclosion) et la liste de ses effets visuels.
- **IA** : la même que le prompt 4, **dans la même conversation**. Ce prompt ne se suffit pas à lui-même : il continue [[Prompt 4 - Construction et animations d'un personnage]].
- **À joindre** : rien de plus.

Voir [[Prompts IA]], [[Animations]], [[Décor et effets]], [[Saut]] et [[Compagnons]].

Le prompt d'origine décrivait les attaques d'un monstre. Ici le compagnon ne combat pas : ses « actions » sont celles du saut.

## À remplir

| Crochet | Où trouver la valeur |
| --- | --- |
| Phases du saut, durées | [[Saut]] |
| Noms des animations | [[Animations]], [[Contrats]] |
| Couleurs et limites des effets | [[Direction artistique]], « Effets visuels » |

## Prompt

```text
ACTION MOVES (the companion jumps with the player; it never fights). For each: animated preview, keyframe table, wind-up / key moment / recovery timing, the exact key frame, and whether it loops.
TAKE-OFF (with the player's take-off): [deep crouch, then a big push with both back legs] (wind-up [0.2] s, leaves the ground at about [0.3] s). Not looping.
FLIGHT (loop of about [1] s, while the player is in the air): [legs tucked, ears and tail pushed back by the wind, arms spread like wings]. The forward movement is NOT in the animation: the game code moves the companion, so keep the Body in place.
LANDING (when the player lands): [legs forward, squash on impact, small bounce, back to idle] (impact at about [0.15] s, total [0.6] s). Not looping.
CELEBRATION (new record or golden jump, about [1.5] s): [two happy jumps on the spot, arms up, a spin]. Not looping.
HATCH (when it comes out of the egg, about [1.2] s): [pops up from small to full size with a bounce, looks left and right, waves]. Not looping.
TRAINING CHEER (loop of about [1] s, while the player trains): [bounces on the spot and pumps its arms like a coach].
SAD (missed take-off, about [1] s): [small disappointed slump, ears down, then shakes it off]. Never dramatic.
Which animation it uses by game state (idle, walking, running down the runway, take-off, flight, landing, record, training, hatching).
Every animation starts and ends in the neutral pose so they can be chained without a jump.

VISUAL EFFECTS (animated preview + list with colors, size, speed, amount)
Always on: [none for common pets / a few small sparkles around the head in the rarity color #HEX for rare and above].
Hop: [small puff of dust under each landing].
Sprint hop: [short speed lines behind it].
Take-off: [small burst of sand or dust and a quick stretch trail].
Flight: [thin trail in the main color of the companion #HEX].
Landing: [small splash of sand #HEX].
Celebration: [confetti burst, golden stars #FFC83D].
Hatch: [egg shell pieces flying out, a ring of light in the rarity color #HEX].
Silver and Gold versions: [a soft metallic shine passing over the body every few seconds].
Each effect lasts less than one second, stays small and never hides the player's character. Joyful and readable, not too busy. Give a reduced version (half the particles) for phones.
```

## Remarques

- Les effets se construisent ensuite dans Studio (particules, traînées) : le prompt ne donne qu'une liste et un aperçu, pas des assets finis ([[Décor et effets]]).
- Jusqu'à 30 compagnons sont visibles à la fois : garder les effets permanents très légers, voire aucun pour les Communs.
- Une animation retenue et publiée s'inscrit dans [[Registre des animations]].
