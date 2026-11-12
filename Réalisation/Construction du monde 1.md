# Construction du monde 1

La consigne complète pour construire la map du « Stade des Débuts » au niveau d'un simulateur professionnel. Elle se donne telle quelle à Claude au début d'une tâche de map. Voir [[Map]] pour ce qui est déjà construit, [[Mondes]] pour la place du monde 1 dans le jeu.

Choix faits le 2026-11-12 ([[Décisions]]) : place centrale ronde, bac qui traverse cinq décors, style dessin animé soigné, quatre éléments spectaculaires. Comme toute note de réalisation, c'est un cadre de départ ([[Liberté de création]]).

## Mission

Construire la map une étape à la fois, dans l'ordre de la section « Étapes ». À la fin de chaque étape : montrer des captures, lister ce qui reste imparfait, attendre la validation avant de passer à la suivante.

Cette consigne ne couvre pas le gameplay (saut, boutique, concours). Elle livre la map, les modèles, les animations de décor et les points d'accroche que le code utilisera.

## Avant de commencer

- Suivre le début de session et la réservation de `CLAUDE.md`. Chaque étape correspond à une tâche du [[Déroulé du développement]] (tableau en bas de note).
- Lire [[Map]], [[Contrats]], [[Direction artistique]], [[Modèles 3D]], [[Animations]], [[Claude Design]]. Ne pas relire le reste du coffre.
- Vérifier que les MCP Roblox Studio et Blender répondent. Si l'un manque, le dire et s'arrêter.
- La place est partagée en direct : prévenir avant toute commande large (déplacer ou supprimer en masse).

## Ce qui ne change pas

- Tout vit dans `Workspace.Mondes.Monde1`, rangé en `Spawn`, `Entrainement`, `Boutique`, `Piste`, `Bac`, `Decor`, `Anneaux`, `Portails` ([[Contrats]]).
- La piste suit l'axe X. Le dessus des sols jouables est à Y = 0.
- La piste d'élan va de X = 0 à X = 120. La planche d'appel est à X = 120.
- Le bac va de X = 120 à X = 2120 (500 m, 4 studs par mètre), en deux Parts au moins : une Part ne dépasse pas 2048 studs.
- Chaque Part interactive porte son tag et ses attributs sur elle-même.
- Des murs invisibles empêchent d'entrer sur le bac autrement que par la piste.
- Style et palette de [[Direction artistique]]. Puissance en rouge, Vitesse en bleu, partout.
- Public de 8 à 16 ans sur téléphone : rien de violent, tout lisible sur petit écran.
- Tout est original : pas d'anneaux olympiques, pas de marque, pas de mascotte existante.
- Tout code s'écrit dans `src/` et arrive par Rojo, jamais directement dans Studio.

## Les neuf principes d'une map qui marche

1. **Tout se voit en trois secondes.** Depuis le point d'apparition, sans tourner la caméra de plus d'un quart de tour, le joueur voit l'arche de la piste, une zone d'entraînement, un stand et un œuf.
2. **Un repère géant par activité.** Chaque lieu a une silhouette unique visible de toute la place, et une enseigne flottante avec icône et nom.
3. **Le trajet le plus fréquent est le plus court.** L'entraînement débutant et la piste sont à moins de 10 secondes de marche l'un de l'autre.
4. **Ce qui est verrouillé se voit et donne envie.** Zones Confirmé et Élite, portail et paliers lointains sont visibles dès le début, avec un cadenas et la condition affichée.
5. **Rien n'est immobile.** Dans chaque cadrage, au moins trois choses bougent.
6. **Le sol guide.** Des marquages colorés au sol mènent de la place vers chaque activité.
7. **Pas de vide, pas de bord visible.** Collines, arbres et bâtiments lointains cachent les limites de la map. Aucune zone plate et nue de plus de 40 studs.
8. **Objets surdimensionnés.** Machines, enseignes et accessoires à 1,3 fois la taille réaliste. Allées d'au moins 16 studs pour que 20 joueurs se croisent.
9. **La caméra n'est jamais gênée.** Aucun toit bas, aucun objet haut entre le joueur et sa caméra sur la place et la piste.

## Plan de la place centrale

Place ronde, centre vers (-90, 0, 0), rayon d'environ 85 studs. Ce sont des valeurs de départ, à corriger pendant le test en blocs. La piste part vers l'est (+X).

| Secteur | Contenu | Tag |
| --- | --- | --- |
| Centre | Points d'apparition tournés vers l'arche, rosace au sol aux couleurs du jeu | `PointApparition` |
| Est | Grande arche d'entrée, écran géant au-dessus, départ de la piste | `Piste` |
| Nord-est à nord | Trois zones Puissance : Débutant près de l'arche, puis Confirmé, puis Élite | `ZoneEntrainement` |
| Sud-est à sud | Trois zones Vitesse, en miroir | `ZoneEntrainement` |
| Nord-ouest | Quatre stands : Chaussures, Propulseur, Matériel, Tenue | `Stand` |
| Sud-ouest | Deux incubateurs (œuf du stade, œuf du champion), coffre du groupe, roue | `Incubateur` |
| Ouest, surélevé | Portail vers le monde 2, sur des marches, visible de partout | `Portail` |
| À côté du portail | Panthéon, avec la grande vasque et sa flamme sur le toit | `Pantheon` |
| Entre la place et la piste | Podium, panneaux de classement | `Podium`, `PanneauClassement` |
| Estrade dorée | Zone VIP | `ZoneEntrainement` avec `PasseRequis` |

Multiplicateurs et conditions des zones : [[Entraînement]]. Chaque zone fait environ 24 × 24 studs. Le palier se lit à la taille et à la matière de la machine : simple, puis chromée, puis dorée et lumineuse.

## La piste et le bac

- Piste : bande orange brique, couloirs blancs, numéros peints, torches et canons à confettis des deux côtés, tribunes pleines derrière.
- Planche d'appel : blanche, bande rouge au bord, bien contrastée avec la piste.
- Bac : sable légèrement bosselé, bordure blanche arrondie, 40 studs de large.
- Marqueurs : ligne au sol et petit panneau tous les 10 m, grand panneau tous les 50 m.
- Anneaux : première série entre 10 et 100 m, en arcs, à hauteur de vol plausible ([[Saut]]).
- Un emplacement prévu pour le drapeau du record du serveur ([[Social et compétition]]).

## Le voyage par paliers

Le bac sort du stade et traverse cinq décors de 100 m (400 studs) chacun. Une arche marque chaque passage, avec la distance en grand. Chaque record fait découvrir un nouveau paysage.

| Distance | Décor | Ce qui bouge |
| --- | --- | --- |
| 0 à 100 m | Stade : tribunes, projecteurs, canons, sortie par un tunnel monumental | Public, drapeaux, faisceaux |
| 100 à 200 m | Parc : arbres ronds, kiosque, cerfs-volants, montgolfières, panneau du monde 2 à 150 m | Montgolfières, cerfs-volants, oiseaux |
| 200 à 300 m | Lac : le bac devient une jetée de sable au milieu de l'eau | Bateaux, jets d'eau, canards |
| 300 à 400 m | Ville de jour : immeubles colorés, balcons avec public, route sous un pont | Voitures, enseignes, linge |
| 400 à 500 m | Collines des champions : éoliennes, statues dorées, monument final à 500 m | Éoliennes, bannières, lueurs |

Ne reprendre aucun thème des mondes 2 à 6 (plage, canyon, neige, néon, Lune) : voir [[Mondes]].

## Éléments spectaculaires

- **Mascotte géante** : personnage original d'environ 60 studs, à côté de l'arche. Modèle Blender avec squelette. Animations : attente, applaudissement, saut de joie au record, signe de la main à l'arrivée d'un joueur.
- **Dirigeable** : tourne lentement au-dessus du stade, banderole au nom du jeu, hélices qui tournent, légère oscillation.
- **Écran géant** : au-dessus de l'arche, avec une surface d'affichage nommée pour le dernier saut et le record du serveur.
- **Public** : silhouettes par blocs de couleur dans les tribunes, prêtes pour la ola.
- **Feux d'artifice** : lanceurs nommés derrière les tribunes et au bout de chaque palier.
- **Vasque et flamme** : sur le Panthéon, flamme qui grandit lors d'un événement.
- **Canons à confettis** : par paires le long de la piste.

## Modèles Blender

Chaîne et budgets de [[Modèles 3D]] : planche par famille, modélisation, capture, comparaison, vérifications, export, import, registre.

- Bords arrondis, une ou deux matières, dégradés peints.
- Les parties mobiles sont des meshes séparés et nommés, avec leur pivot au bon endroit.
- Familles, dans l'ordre : piste et bac ; machines d'entraînement ; stands ; œufs et incubateurs ; portail, panthéon, podium ; éléments spectaculaires ; décor de chaque palier.
- Murs, sols et gradins simples se construisent en Parts dans Studio.

## Animations de décor

Deux façons, selon l'objet ([[Animations]]) :

- **Mouvement simple et répété** (rotation, flottement, balancement, pulsation) : pas d'animation Blender. L'objet porte le tag `DecorAnime` et ses attributs ([[Contrats]]). Un seul module client, dans `src/`, anime tous les objets tagués proches du joueur.
- **Mouvement organique** (mascotte, personnages du décor) : squelette et animations dans Blender, export, publication sous le groupe, inscription au [[Registre des animations]]. Vérifier la procédure d'import dans la documentation Roblox avant le premier essai.

Chaque mouvement a une accélération et un ralenti, jamais de déplacement linéaire sec. Les objets voisins sont décalés dans le temps pour ne pas bouger à l'unisson.

Liste minimale : machines qui tournent à vide, enseignes qui se balancent, œufs qui tremblent, tourbillon du portail, flamme, drapeaux, hélices, montgolfières, bateaux, voitures, éoliennes, anneaux, public.

## Points d'accroche pour le code

Ces objets sont nommés et tagués pour que le code les déclenche plus tard sans retouche : canons, lanceurs de feux d'artifice, projecteurs, écran géant, mascotte, vasque, drapeaux (vent favorable), bande lumineuse de la piste (saut doré), public (ola). Les tags sont dans [[Contrats]], marqués « prévu ».

## Lumière et ambiance

Fin d'après-midi dorée, ombres douces, brume légère qui donne de la profondeur sur 500 m, ciel dessin animé, léger bloom. Chaque palier a sa teinte dominante. Quelques sources de lumière dynamiques au plus dans un même cadrage.

## Performance

- Chargement progressif activé, décor découpé en modèles par palier.
- Décor ancré, sans collision ni détection quand le joueur ne le touche pas.
- Collisions en boîte sur les meshes. Même mesh réutilisé pour les objets répétés.
- Pas d'ombres portées sur le petit décor lointain.
- Animations de décor côté client seulement, coupées au-delà d'une distance.
- Vérifier les limites et les réglages dans la documentation Roblox, ne pas les supposer.
- Contrôle sur l'émulateur de téléphone de Studio à chaque étape.

## Étapes

| # | Étape | Tâche du déroulé |
| --- | --- | --- |
| 1 | Plan vu de dessus et vue de côté ([[Claude Design]]), relevé dans `assets/plans/monde1.md` | T-015, début de T-105 |
| 2 | Toute la map en blocs, tags et attributs posés. On joue dedans | T-007, T-105 |
| 3 | Sols, piste, planche, bac, marqueurs, arche, tribunes | T-105, T-114 |
| 4 | Place centrale, une famille de modèles à la fois | T-206, T-207, T-303, T-405, T-503 |
| 5 | Voyage par paliers, un palier à la fois | T-215, T-216 |
| 6 | Éléments spectaculaires et anneaux | T-106, T-115, T-116 |
| 7 | Lumière et ambiance | T-703 |
| 8 | Animations de décor | T-117, puis T-118 pour les réactions aux sauts |
| 9 | Optimisation et contrôle sur téléphone | T-703 |
| 10 | Notes : [[Map]], [[Décor et effets]], [[Contrats]], registres | Fin de chaque tâche |

Les réactions du décor au vent favorable et au concours se branchent avec T-502 et T-506. La liste à cocher est dans [[Tâches]].

## Une étape est terminée quand

- Les captures (vue du point d'apparition, vue d'ensemble, vue de piste, vue de vol) respectent les neuf principes.
- Aucune forme provisoire ne reste dans le périmètre de l'étape.
- Le jeu se joue de bout en bout en test, sans erreur dans la sortie.
- Les notes concernées sont à jour.
- Ce qui n'est pas vérifié ou pas fini est dit clairement.
