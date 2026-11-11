# Claude Design

Comment l'équipe utilise Claude Design pour dessiner les mondes, les modèles et les écrans avant de les construire. Voir [[Modèles 3D]], [[Map]], [[HUD]] et [[Outils]].

## Ce que c'est, et ce que ce n'est pas

Claude Design est un espace de dessin en deux dimensions : des planches posées sur une grande toile, que l'on fait évoluer en discutant avec Claude. Vérifié le 2026-11-11 : le type « Design » est disponible depuis Claude Code, qui peut créer une planche et la relire ensuite.

**Claude Design ne produit pas de 3D.** Il n'existe pas de bouton qui transforme une planche en map Roblox ou en modèle. « Importer » veut donc dire ici : Claude relit la planche et la reconstruit, dans Studio par le MCP Roblox Studio, ou dans Blender par le MCP Blender. Pour que cette relecture soit fiable, les planches suivent les règles ci-dessous.

Cette chaîne n'a pas encore été essayée de bout en bout : c'est l'objet de la tâche T-015 du [[Déroulé du développement]]. Si l'essai déçoit, on garde Claude Design pour l'intention visuelle et on construit directement dans Studio et Blender.

## Usage 1 : le plan d'un monde

### La planche

- **Vue de dessus, à l'échelle** : 1 pixel = 1 stud. L'axe de la piste (X) va de gauche à droite.
- **Une forme par élément**, de couleur unie, avec son nom écrit dessus : `Piste`, `PlancheAppel`, `Bac`, `ZoneSquat`, `StandChaussures`.
- **Une légende** sous forme de tableau sur la même planche :

| Nom | Tag ([[Contrats]]) | Hauteur (studs) | Matière et couleur | Attributs |
| --- | --- | --- | --- | --- |
| `ZoneSquat` | `ZoneEntrainement` | 1 | Néon rouge | `Stat` = Puissance, `Multiplicateur` = 1 |

- **Une vue de côté** pour ce qui a du relief : falaise, tremplin, gradins.
- **Une planche d'ambiance** à côté : couleurs, heure du jour, deux ou trois images de l'esprit recherché.

### Du plan à Studio

1. L'équipier dessine et ajuste le plan avec Claude Design, puis donne le lien de la planche à Claude Code.
2. Claude relit la planche (positions, tailles, légende) et écrit un relevé dans `assets/plans/monde1.md` : un tableau avec, pour chaque élément, sa position, sa taille, son tag et ses attributs. Ce relevé est la trace durable du plan.
3. Claude construit le monde dans `Workspace.Mondes.MondeN` par le MCP Roblox Studio, en Parts simples d'abord (le « bloc à bloc »), tags et attributs compris.
4. On joue dans le monde en blocs. C'est à ce moment qu'on corrige les distances et les proportions, sur la planche puis dans Studio.
5. Les blocs sont ensuite remplacés par les vrais modèles.

L'intérêt du passage par le plan : tout le monde voit le monde et peut donner son avis avant qu'une seule Part soit posée ([[Liberté de création]]).

## Usage 2 : la planche d'un modèle 3D

### La planche

- Trois vues du même objet : face, profil, trois quarts.
- Dimensions en studs, palette de couleurs (trois ou quatre couleurs au plus).
- Notes : où l'objet s'attache au personnage, ce qui doit bouger, ce qui doit briller.
- Pour une famille (les trois chaussures du monde 1, les cinq compagnons d'un œuf), mettre toute la famille sur une planche, à la même échelle : on voit tout de suite si les objets vont ensemble et si la progression se lit.

### De la planche à Blender

1. L'équipier valide la planche et donne son lien à Claude Code.
2. Claude modélise dans Blender par le MCP Blender en suivant la planche, prend une capture sous les mêmes angles, et compare.
3. Deux ou trois allers-retours, puis la suite de la chaîne habituelle : vérifications, export, import, registre ([[Modèles 3D]]).

Le résultat sera fidèle à la silhouette, aux proportions et aux couleurs de la planche, pas à chaque trait de dessin. Les formes simples et les aplats de couleur du style choisi ([[Direction artistique]]) se prêtent bien à cette méthode.

## Usage 3 : écrans, icônes et vitrine

C'est l'usage le plus direct de l'outil.

- Maquettes des écrans du [[HUD]] sur des planches aux tailles réelles (téléphone, tablette, ordinateur), avant construction dans Studio.
- Icônes d'interface, logo, cadres, bandeaux : dessinés ici, exportés en image, importés dans Roblox ([[Images]]).
- Miniatures et icône de la page du jeu : mise en page, titre et habillage par-dessus une capture du jeu.

## Rangement

- Le lien de chaque planche s'écrit dans la note concernée ([[Map]], [[Modèles 3D]], [[HUD]]) ou dans le registre de la pièce produite.
- Les relevés de plans vont dans `assets/plans/`.
- Une planche jointe à une idée s'indique dans la note d'idée ([[Liberté de création]]).

## Limites à garder en tête

- Pas de volume : une planche ne dit rien de la hauteur sans vue de côté ni légende.
- Un plan trop détaillé se relit mal. Dessiner les grandes masses ; le détail se fait dans Studio.
- Chaque planche et chaque relecture consomment du quota Claude : une planche par monde et une par famille d'objets, pas une par objet.
