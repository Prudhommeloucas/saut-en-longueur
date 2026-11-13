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
