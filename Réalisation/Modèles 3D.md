# Modèles 3D

Liste et description des modèles à produire, et la façon de les produire. Voir [[Direction artistique]], [[Contrats]] et [[Registre des modèles]].

Les descriptions de cette note sont des suggestions de départ : celui qui fait le modèle est libre de faire autrement et met la note à jour ([[Liberté de création]]).

## Chaîne de production

0. **Planche du modèle par Gemini** : c'est l'image de référence. Claude ne dessine pas la planche lui-même : il **donne le prompt à copier dans Gemini** (modèles à trous dans [[Prompts IA]], prompt 3 pour un personnage, prompt 6 pour un objet ou un décor), l'équipier génère l'image, choisit la meilleure et la range dans `assets/modeles/planches/`. Le prompt rempli se garde dans la note du prompt.
   En complément, et seulement si l'équipier le demande : une planche [[Claude Design]] qui redessine l'objet à l'échelle, avec les dimensions en studs et la palette, de préférence une par famille d'objets.
1. **Blender**, piloté par le MCP Blender : Claude construit le modèle par script en suivant la planche, prend une capture sous les mêmes angles, corrige.
2. Vérifications : nombre de triangles, échelle (1 unité Blender = 1 stud), origine au pied du modèle, face vers -Y dans Blender, transformations appliquées, une ou deux matières au plus.
3. Enregistrement du fichier source dans `assets/modeles/source/` (un `.blend` par modèle) et export `.fbx` dans `assets/modeles/export/`.
4. Import dans Studio par l'outil d'import 3D (geste fait à la main par l'équipier, Claude le guide).
5. Rangement dans la place selon [[Contrats]], pose des tags et des attributs, collisions simplifiées.
6. Inscription dans [[Registre des modèles]].

Pour les éléments simples de décor (murs, sols, gradins), construire directement en Parts dans Studio par le MCP Roblox Studio est plus rapide que de passer par Blender.

## Planche de style (T-010)

Planche Claude Design du 2026-11-14 (P2), privée tant qu'elle n'est pas partagée depuis son menu Partager : https://claude.ai/artifact/9ukTh4nfmykJBq9LZP4sfG. Trois objets, chacun en face, profil et trois quarts, avec dimensions et palette :

| Identifiant | Dimensions (studs) | Couleurs |
| --- | --- | --- |
| `chaussures_ressorts` | Une chaussure : 1,3 de large, 2,4 de long, 2,2 de haut | Orange `#FF7A1A`, blanc, bleu `#1E90FF`, chrome `#AEB8C6` |
| `compagnon_grenouille` | 2,8 de large, 2,6 de long, 2,6 de haut | Vert `#4CC96B`, vert foncé `#2E9E4F`, ventre `#D8F5B0`, bandeau orange |
| `tribune_module` | 20 de long, 14 de profond, 16 de haut ; six rangs de 2 de profond et 1,4 de haut | Béton `#E8ECF1`, sièges orange et bleus en damier, toit orange, poteaux `#5A6270` |

Cette planche donne l'échelle et les couleurs. La référence visuelle vient des planches Gemini, dont les prompts remplis sont dans [[Prompt 6 - Planche d'un objet d'équipement]] (chaussures, tribune) et [[Prompt 3 - Planche d'un personnage]] (grenouille). Planches Gemini reçues et rangées dans `assets/modeles/planches/` (`.webp`).

Modélisés le 2026-11-14 dans `assets/modeles/source/planche_style_t010.blend`, exportés en `.fbx` (mêmes réglages que les propulseurs : échelle « FBX Units Scale »). Aperçu : `assets/modeles/planches/planche_style_apercu.png`. Un mesh par couleur, nommé `identifiant_Couleur`.

- `chaussures_ressorts` (872 triangles) : une seule chaussure, symétrique, qui sert aux deux pieds. Origine sous le pied, au centre du dessus de la semelle ; pointe vers -Y. Le mesh `_Ressorts` est séparé pour pouvoir l'écraser à l'appel.
- `compagnon_grenouille` (1 494 triangles) : origine au sol, face vers -Y. Pattes du même vert que le corps, comme sur la planche Gemini. Bandeau en ruban plaqué sur la tête, nœud et deux pans derrière ; bouche en grand sourire, coins relevés (vert foncé `#14602B`).
- `tribune_module` (1 120 triangles) : 20 de long, 15,7 de profond avec le débord du toit, 16 de haut. Six rangs de huit sièges. Origine au sol, au milieu du bord avant ; les gradins montent vers +Y. Deux poteaux à 5 studs du centre, pour un poteau tous les 10 studs quand les modules se suivent.

Importés dans la place le 2026-11-14 (échelle 1 unité = 1 stud vérifiée : la tribune mesure 20 × 16 × 15,7). Capture dans Studio : `assets/modeles/planches/planche_style_studio.jpg`. Dans la file d'import, le bouton « Importer » traite les trois lignes d'un coup. Studio pose chaque modèle dans le `Workspace`, sous la forme d'un Model qui en contient un second ; un script aplatit, renomme les meshes (`Orange`, `Blanc`…), remet les couleurs et range.

- Chaussure : `Poignee` et `Attache` = `Pieds` ([[Contrats]]), ressorts avec un peu de reflet.
- Grenouille : `PrimaryPart` = `Vert`, pivot au sol.
- Tribune : dans `Assets.Decor`, ancrée, six Parts invisibles `Collision` (une par rang).

Reste : le style est validé par P2 seulement ; l'avis des deux autres est demandé dans `Suivi/Demandes/`.

## Budgets

| Type | Triangles | Remarque |
| --- | --- | --- |
| Compagnon | 500 à 1 500 | Jusqu'à 30 visibles à la fois |
| Équipement porté | 300 à 1 000 | Sans collision |
| Accessoire de décor | 200 à 2 000 | |
| Machine, stand | 1 500 à 4 000 | Collision en boîte |
| Grand élément (arche, tremplin) | 5 000 au plus | Découper en plusieurs meshes au-delà |

Rester sous 10 000 triangles par mesh. La limite d'import de Roblox est à vérifier dans sa documentation avant le premier gros modèle.

## Monde 1 : stade

| Modèle | Description |
| --- | --- |
| Arche d'entrée | Grande arche gonflable orange et blanche, bandeau au nom du jeu, deux mâts à drapeaux |
| Tribune modulaire | Module de 20 studs : gradins sur 6 rangs, sièges alternés orange et bleu, toit incliné sur poteaux. Se répète le long de la piste |
| Piste d'élan | Bande orange brique, lignes blanches, numéros de couloir peints |
| Planche d'appel | Planche blanche bordée d'une bande de plasticine rouge |
| Bac à sable | Bordure blanche arrondie, sable légèrement bosselé, râteau posé au bord |
| Panneau de distance | Petit panneau sur pied tous les 10 m, grand panneau tous les 100 m |
| Tableau d'affichage | Écran géant sur pylônes, affiche le dernier saut et le record du serveur |
| Podium | Trois marches numérotées, tapis, fond d'arche à médailles |
| Projecteur de stade | Mât haut à quatre spots |
| Public | Silhouettes simples par blocs de couleur, animées en vague par le code |

## Monde 1 : entraînement et services

| Modèle | Description |
| --- | --- |
| Cage à squat | Cadre rouge, barre chargée de gros disques, tapis au sol |
| Presse à mollets | Machine bleue à plateau incliné |
| Tapis de course | Tapis large, console lumineuse (palier Confirmé) |
| Zones Élite | Versions dorées et plus grosses des machines |
| Stands de boutique | Kiosque à auvent rayé, un par famille, enseigne en forme de l'objet vendu |
| Incubateur | Socle rond, cloche de verre, tuyaux lumineux |
| Panthéon | Petit temple à colonnes, statue d'athlète, flamme |
| Portail | Arche de pierre avec un tourbillon aux couleurs du monde suivant |
| Coffre du groupe, roue | Coffre doré sur estrade ; grande roue verticale à cases colorées |
| Anneau de vol | Anneau lumineux de 12 studs de diamètre, flèches qui tournent |

## Monde 1 : éléments spectaculaires et paliers

Ajoutés le 2026-11-12, voir [[Construction du monde 1]].

| Modèle | Description |
| --- | --- |
| Mascotte géante | Personnage original d'environ 60 studs, à côté de l'arche. Seul modèle de décor à squelette ([[Animations]]). À découper en plusieurs meshes pour tenir le budget |
| Dirigeable | Ballon aux couleurs du jeu, nacelle, hélices séparées, banderole |
| Écran géant | Remplace le tableau d'affichage : au-dessus de l'arche, cadre épais, surface d'affichage |
| Vasque | Grande coupe sur le toit du Panthéon, flamme en partie séparée |
| Canon à confettis | Petit canon coloré, par paires le long de la piste |
| Lanceur de feux d'artifice | Tube sur socle, discret |
| Arche de palier | Une par 100 m, distance en grand, couleur du décor traversé |
| Décor du parc | Arbres ronds, kiosque, montgolfière, cerf-volant |
| Décor du lac | Jetée, bateau, canard, jet d'eau |
| Décor de la ville | Immeubles colorés modulaires, voiture, pont, enseigne |
| Décor des collines | Éolienne, statue dorée, monument final des 500 m |

## Équipement porté (monde 1)

| Objet | Description |
| --- | --- |
| Semelles à ressorts | Gros ressorts chromés sous des baskets orange |
| Baskets turbo | Baskets à ailettes, petite tuyère au talon |
| Bottes à réaction | Bottes blanches de cosmonaute, deux réacteurs |
| Bouteille de soda | Deux bouteilles sanglées dans le dos, bouchon vers le bas |
| Extincteur | Extincteur rouge en sac à dos, tuyau |
| Réacteur de poche | Petit réacteur d'avion avec ailerons |
| Propulseurs modélisés (2026-11-14) | Les trois propulseurs sont importés dans `ReplicatedStorage.Assets.Equipement` (échelle 1 unité = 1 stud vérifiée, face de Blender -Y = -Z dans Roblox ; l'import ne garde ni les couleurs ni l'origine des pièces, elles sont remises par script ; passer par Fichier → Importer, puis double-clic sur chaque ligne de la file). Chacun : une plaque dorsale et deux sangles (mesh `Sangles`, à supprimer si elles traversent le personnage), puis un mesh par couleur. Origine au centre de la face de la plaque qui touche le dos ; l'objet dépasse vers +Y dans Blender. Soda : bouteilles opaques, dôme et goulot bleus (mesh `Bouteilles`), corps orange (mesh `Soda`). Réacteur : mesh `Lueur` à passer en `Neon`. Pièces mobiles séparées, à animer par le code pendant la poussée (aucune animation n'est faite dans Blender) : `propulseur_reacteur_Helice` (tourne autour de son axe Z local, pivot au centre du moyeu) et `propulseur_extincteur_Aiguille` (tourne autour de son axe Z local, pivot au centre du cadran, à régler par `PivotOffset` si l'import ne garde pas l'origine). Flammes, mousse et jet de soda : particules à ajouter dans Studio ([[Décor et effets]]). Aperçu : `assets/modeles/planches/propulseurs_apercu.png` |
| Baskets turbo et bottes à réaction (2026-11-15) | Modélisées dans `assets/modeles/source/chaussures_monde1.blend` d’après les planches Gemini `chaussures_turbo.webp` et `chaussures_reaction.webp`, rangées dans `ReplicatedStorage.Assets.Equipement`. Même méthode que `chaussures_ressorts` : une seule chaussure pour les deux pieds, origine au centre du dessus de la semelle, pointe vers -Y dans Blender (-Z dans Roblox), `Poignee` invisible en `PrimaryPart`, `Attache` = `Pieds`, meshes soudés, sans masse ni collision. `chaussures_turbo` (916 triangles, 1,43 × 1,60 × 2,69 studs) : tige bleue `#1E90FF`, bout, semelle, lacets et bourrelet du col blancs, bandes, liseré, ailes en éventail et anneau de la tuyère jaunes `#FFC83D`, tuyère au talon `#3A404D` (flamme à ajouter en particules). `chaussures_reaction` (992 triangles, 1,40 × 2,99 × 2,50 studs, réacteurs compris) : botte blanche, revers tricoté, bande de cheville, sangle à boucles et boucle de tirage orange `#FF7A1A`, semelle épaisse et deux réacteurs sous la semelle `#3A404D`, mesh `Bleu` `#1E90FF` en `Neon` (filet de semelle, quatre voyants, anneaux des réacteurs). Les réacteurs dépassent de 0,69 stud sous la semelle : le code devra relever le personnage d’autant ou les laisser traverser le sol. Aperçus `chaussures_monde1_apercu.png` et `chaussures_monde1_studio.jpg` (les trois paires) |
| Matériel | Haltères, gilet lesté, chevilles lestées : visibles pendant l'entraînement |
| Tenues | Maillot et short aux couleurs du club, puis régionale, puis dorée |

## Compagnons et œufs (monde 1)

Grosse tête, grands yeux, corps rond, pattes arrière marquées. Chaque espèce a une couleur dominante.

| Espèce | Rareté | Description |
| --- | --- | --- |
| Grenouille | Commun | Verte, bandeau de sport |
| Lapin | Commun | Blanc, dossard |
| Sauterelle | Rare | Vert vif, longues antennes |
| Kangourou | Épique | Roux, gants de boxe, poche |
| Puce savante | Légendaire | Minuscule, cape et chapeau, entourée d'étoiles |
| Lièvre, écureuil volant, gazelle, dauphin, puma | Œuf du champion | Même style, plus stylisés |

### Compagnons modélisés (T-303)

Même chaîne que la grenouille : un `.blend` par compagnon dans `assets/modeles/source/`, un mesh par couleur nommé `identifiant_Couleur`, origine au sol entre les pattes, face vers -Y dans Blender (-Z dans Roblox). Dans la place : meshes renommés par leur couleur, soudés à la `PrimaryPart`, `CanCollide` et `CanTouch` coupés, pivot au sol. Import possible par Claude en pilotant Studio à l'écran (Fichier → Importer, chemin du `.fbx`, bouton Importer).

- `compagnon_lapin` (2026-11-14, 1 494 triangles, 1,66 × 2,85 × 1,49 studs) : blanc rosé `#ECE4E6`, ventre, dents, queue et rond du dossard `#FAFAF8`, intérieur des oreilles et nez `#F4A6B6`, yeux et sourire `#3A2218`, dossard et sangles croisées dans le dos `#3D8BE0`. `PrimaryPart` = `Blanc`. Planche `compagnon_lapin.png`, aperçus `compagnon_lapin_apercu.png` (Blender) et `compagnon_lapin_studio.jpg` (à côté de la grenouille).
- `compagnon_sauterelle` (2026-11-14, 1 498 triangles, 2,27 × 2,49 × 3,17 studs, plus longue que haute) : vert citron `#8BDB2E` (tête, corps, pattes, antennes ; `PrimaryPart`), ventre `#E6F7A0`, élytres `#74C928` et trois rayures `#4FA61E`, yeux blancs, pupilles et sourire `#111418`, bandeaux bleus `#1E90FF` aux grandes cuisses, boules orange `#FF7A1A` au bout des antennes. Les grandes pattes arrière sont dans le mesh `Vert` : à séparer si on veut les animer un jour. Planche `compagnon_sauterelle.webp`, aperçus `_apercu.png` et `_studio.jpg`.
- `compagnon_kangourou` (2026-11-14, 1 482 triangles, 1,75 × 2,58 × 1,73 studs) : roux `#D9822B` (`PrimaryPart` = `Orange`), ventre, museau et intérieur des oreilles `#F6D9A8`, bord de la poche `#C26F20`, yeux, nez et sourire `#4A2A1A`, reflets et manchettes blancs, gants de boxe `#E8302E`, ruban violet au cou `#8E44EC` (couleur de la rareté Épique). Planche `compagnon_kangourou.webp`, aperçus `_apercu.png` et `_studio.jpg` (les quatre compagnons de l'œuf du stade côte à côte).

- `compagnon_puce` (2026-11-14, 1 538 triangles dont 120 pour les étoiles, 1,47 × 2,09 × 1,00 studs, plus petite que les autres) : prune `#6E3A70` (`PrimaryPart` = `Violet`), ventre lavande `#A88BDB`, yeux blancs, pupilles et sourire `#111418`, haut-de-forme violet foncé `#4E2466` incliné, cape rouge `#C8262E` à double face avec col et nœud, mesh `Or` `#F2B531` en `Metal` (bande du chapeau, liseré de la cape, broche), mesh `Etoiles` `#FFD447` en `Neon` (trois étoiles flottantes). Les étoiles sont soudées comme le reste : pour les faire tourner, le code remplace leur soudure par un `Motor6D`. Le chapeau de la planche Gemini est violet à bande dorée (le prompt demandait un chapeau doré) : on a suivi la planche. Planche `compagnon_puce.webp`, aperçus `_apercu.png` et `_studio.jpg` ; les cinq compagnons de l'œuf du stade côte à côte : `compagnons_oeuf_stade_studio.jpg`.

- `compagnon_lievre` (2026-11-14, 1 468 triangles, 1,07 × 2,85 × 0,69 studs) : sable `#C8955A` (`PrimaryPart` = `Sable`), ventre, museau et intérieur des oreilles `#F3E2C4`, bout des oreilles `#5A3A22`, nez `#E88A9A`, yeux blancs à iris ambre `#B8742A`, débardeur à bretelles, queue et semelles `#FAFAFA`, bande du débardeur et couronne de lauriers `#F2B531` en `Metal`, chaussures `#5BC0F8`. La planche Gemini a donné des proportions presque humaines (petite tête, longues jambes) : le modèle les suit, il tranche donc avec la famille « grosse tête ». Gardé ainsi par choix de P2 le 2026-11-14 (silhouette de sprinteur pour l’œuf du champion). Les prompts suivants imposent les proportions (voir [[Prompt 3 - Planche d'un personnage]]).
- `compagnon_ecureuil` (2026-11-14, 1 476 triangles, 1,43 × 1,90 × 1,77 studs, queue comprise) : gris-brun `#9A8678` (`PrimaryPart` = `Gris`), ventre, joues, intérieur des oreilles et bout de la queue `#F2E6D8`, membranes de vol plané `#7C6A5E` (nappes à double face entre bras et hanches), yeux, nez et sourire `#3A2A22`, reflets et dents blancs, lunettes d'aviateur `#E8892A` relevées sur le front avec verres `#8FD3FF` en `Glass`, lauriers `#F2B531` en `Metal` le long de la sangle. Grande queue en panache qui monte derrière lui. Planche `compagnon_ecureuil.webp`, aperçus `_apercu.png` et `_studio.jpg`.
- `compagnon_gazelle` (2026-11-14, 1 456 triangles, 1,28 × 2,24 × 1,74 studs) : quadrupède, tête en avant sur un cou court. Fauve `#D9A15B` (`PrimaryPart` = `Fauve`), ventre, poitrail, museau, tour des yeux et intérieur des oreilles blancs, bande brune sur chaque flanc, sabots et touffe de la queue `#5E3C25`, yeux, nez et sourire `#3A2A22`, cornes `#8A6A4A` recourbées vers l'arrière avec deux anneaux bruns, lauriers `#F2B531` en `Metal` à la base des cornes, bandeaux bleus `#1E90FF` aux pattes avant (couleur de la rareté Rare). Planche `compagnon_gazelle.png`, aperçus `_apercu.png` et `_studio.jpg`.
- `compagnon_dauphin` (2026-11-14, 1 392 triangles, 1,59 × 1,93 × 1,51 studs) : corps en œuf debout sur sa nageoire caudale. Bleu ciel `#4FA8E8` (`PrimaryPart` = `Bleu` : corps, bec, nageoires, aileron, queue), ventre et dessous du bec `#CDEBFF`, yeux blancs à iris `#14213D` (aussi l'évent et le sourire), ruban violet `#8E44EC` en V (couleur de la rareté Épique), médaille et lauriers `#F2B531` en `Metal`. Planche `compagnon_dauphin.webp`, aperçus `_apercu.png` et `_studio.jpg`.
- `compagnon_puma` (2026-11-14, 1 536 triangles dont 40 pour l'étoile, 0,87 × 1,70 × 1,90 studs) : bébé puma à quatre pattes, queue relevée derrière lui. Fauve `#D69A4A` (`PrimaryPart` = `Fauve`), ventre, poitrail, museau et coussinets `#F7E6C8`, oreilles et bout de la queue `#5A3A22`, nez et intérieur des oreilles `#E88A9A`, yeux blancs à iris vert `#3FB55E`, pupilles et sourire `#111418`, petite cape dorée `#F2B531` (mesh `Cape`, double face) à bord blanc, couronne de lauriers `#F2B531` en `Metal` (mesh `Or`), étoile `#FFD447` en `Neon` sur le nœud de la cape (or = rareté Légendaire). Planche `compagnon_puma.webp`, aperçus `_apercu.png` et `_studio.jpg`.

Les dix compagnons du monde 1 côte à côte dans Studio : `assets/modeles/planches/compagnons_monde1_studio.jpg`.

### Œufs modélisés (T-303)

Les trois dans `assets/modeles/source/oeufs_monde1.blend`, d'après une planche Gemini commune (`oeufs_monde1.webp`, prompt dans [[Prompt 6 - Planche d'un objet d'équipement]]). Même forme pour les trois : 2,5 studs de haut, 1,85 de large, plus large en bas, coquille déjà coupée en `Bas` et `Haut` le long d'une fêlure en zigzag (dix dents, à 1,2 stud), voir [[Contrats]]. Rangés dans `ReplicatedStorage.Assets.Oeufs` (dossier créé le 2026-11-14). Aperçus `oeufs_monde1_apercu.png` (Blender) et `oeufs_monde1_studio.jpg`.

- `oeuf_stade` (1 120 triangles) : coquille blanche, deux larges bandes orange `#FF7A1A` bordées d'un filet bleu `#1E90FF`, fêlure grise `#C9CED6`.
- `oeuf_champion` (1 496 triangles) : coquille dorée `#F2B531` en `Metal`, deux branches de lauriers `#E0A21F` qui montent sur l'avant des flancs, étoile blanche sur le devant, fêlure `#B8861A`.
- `oeuf_or` (900 triangles) : coquille violette `#C9A2FF` en `Glass` à 35 % de transparence, bande dorée en zigzag `#FFD447` en relief sur la fêlure, neuf étincelles en `Neon` à l'intérieur, `PointLight` violet dans `Bas`.

Décors coupés pour l'éclosion (T-304, 2026-11-15) : dans le `.blend`, chaque décor est coupé le long du zigzag (vingt plans, un par segment de la fêlure) en `<identifiant>_<Décor>_Bas` et `_Haut` ; les pièces détachées (bandes, filets, feuilles, étincelles) sont rangées entières du côté de leur centre. Triangles : `oeuf_stade` 1 240, `oeuf_champion` 1 698, `oeuf_or` 940. Les coquilles n'ont pas changé : seuls les décors ont été importés (`oeufs_decors_t304.fbx`), placés et soudés par script. Aperçus `oeufs_ouverts_apercu.png` (Blender) et `oeufs_ouverts_studio.jpg`.

### Incubateur (T-303)

`incubateur` (2026-11-15, 2 024 triangles, 6,8 × 5,75 × 8,0 studs avec les marches) dans `ReplicatedStorage.Assets.Decor`, source `assets/modeles/source/incubateur.blend`, planche `incubateur.webp` (prompt dans [[Prompt 6 - Planche d'un objet d'équipement]]). Socle évasé blanc (`Blanc`, `PrimaryPart`) à deux bandes orange, collier, couvercle, boîtier et marches gris `#C9CED6`, cloche `Verre` `#CFEFFF` en `Glass` (transparence 0,6), quatre tubes `#5BC0F8` en `Neon` avec un `PointLight`, coussin rouge `#E8302E`, bouton vert `#4CC96B` en `Neon` sur le boîtier, côté -Z (face avant). Ancré ; meshes sans collision, trois Parts invisibles `Collision` (socle, cloche, marches). Attachment `PoseOeuf` dans `Blanc`, sur le coussin : un œuf de 2,5 studs posé là tient sous la cloche. Tag `Incubateur` et attribut `Oeuf` posés ([[Contrats]]). Capture avec l'œuf du stade et le lapin : `incubateur_studio.jpg`.

Le premier import dans Studio a échoué sans message (« Échec de l'importation ») ; le second, avec le même modèle nettoyé (sommets doubles, faces dégénérées, triangulé), a réussi. En cas d'échec, refaire l'export après ce nettoyage.

Pour un compagnon Légendaire ou Épique, un détail à la couleur de la rareté ([[Direction artistique]]) le fait reconnaître de loin : ruban violet du kangourou, or pour la puce savante.

Œuf du stade : blanc à bandes orange. Œuf du champion : doré avec lauriers. Œuf d'or : translucide, lueur violette.

Versions Argent et Or : même modèle, matière métallique et médaille au cou. Aucun modèle supplémentaire. Fait le 2026-11-15 (T-304) : recettes et médailles dans `ReplicatedStorage.Assets.Versions` ([[Contrats]]), couleurs mêlées à 60 % à l'argent `#D5DCE4` ou à l'or `#FFC83D`, matière `Metal` ; attachment `Cou` posé sur les dix compagnons (placé par lancer de rayons sur le poitrail). Aperçu des trois rangées (normale, Argent, Or) : `versions_argent_or_studio.jpg`.

## Mondes suivants

Chaque monde demande : son terrain, sa piste et son appel, ses trois paliers de zones, ses stands, son portail, 15 objets d'équipement et 10 compagnons. Les listes détaillées s'écrivent ici au début de la phase du monde ([[Mondes]]).

## Sources toutes faites

Le Creator Store de Roblox et, selon la version du MCP Blender, des bibliothèques de modèles libres peuvent servir pour le décor secondaire (arbres, rochers). Vérifier la licence, retoucher aux couleurs du jeu, et noter la source dans le registre. Les éléments qui font l'identité du jeu (compagnons, équipement, stade) sont faits par nous.

## Panthéon et portail du monde 1 (T-405, 2026-11-17)

Planches Gemini `pantheon.webp` et `portail_monde2.webp` (prompts dans [[Prompt 6 - Planche d'un objet d'équipement]]), modélisés par script dans Blender (`assets/modeles/source/pantheon.blend`, `portail_monde2.blend`), un mesh par couleur. Aperçus `pantheon_apercu*.png`, `portail_monde2_apercu*.png`, capture `assets/captures/monde1_pantheon_portail.jpg`.

- `pantheon` (4 876 triangles, 32 × 35,6 × 44 studs avec la vasque) : temple ouvert en façade, 14 colonnes, fronton aux rampants dorés, carreaux bleus, deux bannières orange à laurier bleu, statue dorée d'un sauteur en vol sur piédestal avec anneau `Lueur` (Neon). Model `Vasque` (tag `Vasque`) avec `Flamme` et `FlammeCoeur` (Neon), séparés pour être animés. 22 Parts `Collision` (socle, marches, colonnes, toit, piédestal, statue).
- `portail_monde2` (4 292 triangles, 26 × 24,2 × 16 studs) : arche en blocs de pierre sable, clé de voûte turquoise et plaque vierge, coquillages corail, palmes, trois marches blanches à liseré turquoise, deux lanternes (Neon). Pièces séparées : `Tourbillon` (PrimaryPart), `Spirale` (tag `DecorAnime`, Rotation autour de son Z local), `Cadenas`. 8 Parts `Collision` ; le tourbillon se traverse.

Piège de l'import FBX : chaque MeshPart importé garde un quart de tour dans son `PivotOffset`. Définir la `PrimaryPart` d'un modèle importé fait basculer son pivot ; il faut ensuite remettre `PrimaryPart.PivotOffset = PrimaryPart.CFrame:ToObjectSpace(CFrame.new(pivot voulu))`.

Correctif du 2026-11-17 : derrière le portail et dans son axe, le panthéon était caché depuis la place. Le modèle `Assets.Decor.pantheon` est passé à l'échelle 1,3 (`Model:ScaleTo`, 41 × 46 × 57 studs, flamme à 46 studs) et posé à (-220, 30), à gauche du portail vu de la place ; trois collines et un arbre ont été repoussés vers l'extérieur.

## Stade du monde 1 (T-105, 2026-11-18)

Planches Gemini `stade_arche.png`, `stade_panneaux.png`, `stade_tunnel.webp` (prompts dans [[Prompts IA]], section « Stade du monde 1 »), modélisées par script dans Blender, un mesh par couleur, avant vers -Y. Aperçus `*_apercu.png` dans `assets/modeles/planches/`, captures `assets/captures/monde1_stade_arche.jpg` et `monde1_stade_bac.jpg`.

- `stade_arche` (1 820 triangles, 33,6 × 35 × 6,2) : piliers bleus à bande blanche et trois rayures orange, poutre dorée bordée de blanc, `Plaque` (texte « SAUT ! » sur une Part invisible `TextePlaque`), `Ecran` bleu nuit dans un cadre bleu, prêt pour l'écran géant (T-106). 3 Parts `Collision` (piliers, poutre).
- `stade_panneau_petit` (860) et `stade_panneau_grand` (832, étoile dorée) : pied gris, cadre blanc, `Face` jaune ou orange. Le chiffre est écrit dans `TexteAvant` et `TexteArriere` ; le script de pose le remplace par la distance.
- `stade_tunnel` (2 760, 123 × 75 × 43) : tours en pierre `#D9D2C3` à rayures bleues, médaillons et chapeaux dorés, couronne orange et blanche, ouverture de 44 × 60 bordée d'orange, `Plaque` « 100 m ». Collisions sur les deux tours seulement : le haut se traverse en vol.

## Stade du monde 1, suite (T-106, 2026-11-22)

Planches Gemini `stade_anneau.png`, `stade_ecran.png`, `stade_projecteur.png`, `stade_spectateur.png` (prompts dans [[Prompts IA]], section « Stade du monde 1 (T-106) »). Le MCP Blender n'était pas branché : modèles construits par `assets/modeles/source/t106_modeles.py`, lancé sans fenêtre (`blender-launcher.exe -b --factory-startup --python lanceur_blender.py -- <journal> t106_modeles.py`). Le script nettoie, triangule, exporte les `.fbx` et rend les aperçus `*_apercu.png`. Import par Fichier → Importer (les quatre d'un coup), puis préparation et pose par `assets/plans/modeles_t106.luau`. L'envoi par Open Cloud a été refusé : le dossier `assets/modeles/export` n'est pas autorisé dans les permissions MCP de Studio. Captures : `assets/captures/monde1_stade_anneaux.jpg`, `monde1_stade_ecran.jpg`, `monde1_stade_public.jpg`.

- `stade_anneau` (1 096 triangles, 16,3 × 16,3 × 1,7 avec les flèches) : anneau `Or` lissé (rayons 4,8 à 6,7), liseré et quatre flèches `Blanc`. Mis à l'échelle du rayon de la `Zone` (× 7/6 pour la série 3) et recoloré par série.
- `stade_ecran` (996, 30 × 22,9 × 2,6) : cadre `Bleu`, écran `Nuit` sur les deux faces, étoile ailée et liseré `Or`, deux pieds `Gris`. La Part `Surface` (SurfaceGui) est recalée sur l'écran : centre à Y 45,9, 27,8 × 13,8.
- `stade_projecteur` (1 940, mât de 45 et tête de 12 × 7) : tête orientable autour de la charnière (Y 48), lampes en Neon.
- `stade_spectateur` (100 triangles, 3 × 3,4 × 1,5) : corps et bras levés `Corps`, tête `Tete` lisse. Ni yeux ni pieds, par économie (929 copies, environ 93 000 triangles).

Préparation dans Studio : structure aplatie, meshes renommés par couleur, `SmoothPlastic`, sans collision ni requête, `WorldPivot` au sol avec l'avant vers -Z local (sans `PrimaryPart`, pour éviter le piège du pivot). Pose par `assets/plans/modeles_t105.luau`, avant tourné vers -X.

## Propulseurs remontés (T-203, 2026-11-22)

Dans `Assets.Equipement`, les trois propulseurs étaient démontés : sangles à leur place, mais bouteilles, cuves et réacteurs à environ 122 studs de la `Poignee`. Ils ont été remis en place d'après `propulseurs_monde1.blend` (Blender x, y, z → Roblox x, z, y depuis la plaque contre le dos), dans la place partagée et dans la copie. Tailles : soda 2,8 × 2,9 × 2,5 ; extincteur 2,0 × 2,9 × 2,6 ; réacteur 3,8 × 2,8 × 3,0. Le personnage les porte depuis T-203 ([[Équipement]]).

## Magasin de la place centrale (T-217, 2026-11-23)

Planche Gemini `place_magasin.webp` (prompt dans [[Prompts IA]]). Modèle construit par `assets/modeles/source/t217_magasin.py` (même chaîne que T-106, lancé sans fenêtre), 2 172 triangles, 35 × 25 × 22, six meshes par couleur. Aperçus `place_magasin_apercu.png` et `_face.png`. Importé par Fichier → Importer dans la copie ; le Model publié sur le compte de Loucas (73209698561012) ne se charge pas dans la place du groupe (« not authorized ») : il faut réimporter le FBX dans la place partagée, sous OGC Studio (Model 77419986787196). Préparation et pose par `assets/plans/construction_t217.luau` : collisions portées par des Parts invisibles `Collision` (socle, murs, toit) et `Comptoir`.

## Tableau des quêtes et cadeau (T-218, T-219, 2026-11-23)

Planches Gemini `place_tableau.png` et `place_cadeau.webp` (prompts dans [[Prompts IA]]). Modèles construits par `assets/modeles/source/t218_t219_modeles.py` : tableau 1 078 triangles (26,6 × 3,4 × 21,3), cadeau 1 268 triangles (11 × 11 × 10,2). Le couvercle du cadeau est fait de meshes séparés `Couvercle_Violet`, `Couvercle_Or`, `Couvercle_Blanc` (le code les fait sauter). Importés dans la copie puis dans la place partagée sous OGC Studio (les deux d'un coup : dans la boîte de dialogue, ouvrir le dossier `export` puis taper `"place_tableau.fbx" "place_cadeau.fbx"`). Préparation et pose par `assets/plans/construction_t218_t219.luau` ; les deux modèles et le magasin sont en `ModelStreamingMode` `Atomic`, sinon le code du joueur peut les recevoir sans leur `Ecran` ou leur `Socle`.

## Machines d'entraînement (T-206, 2026-11-24)

Planches Gemini `salle_cage.webp`, `salle_presse.webp`, `salle_tapis.webp` (prompts dans [[Prompts IA]], section « Machines d'entraînement (T-206) »). Modèles construits par `assets/modeles/source/t206_machines.py` (même chaîne que T-106, lancé sans fenêtre) : cage 1 748 triangles (9,7 × 6,6 × 9), presse 1 264 (5,8 × 6,4 × 6,5), tapis 1 236 (5,2 × 10,3 × 6,4). Aperçus `salle_*_apercu.png`, `_face.png`, `_dos.png`. Le cadre est un mesh `Cadre` d'une seule couleur, recoloré dans Studio selon le palier (peint, chromé en `Metal`, doré) ; les meshes `Barre_*`, `Plateau_*` et `Bande_*` sont regroupés en Models `Barre`, `Plateau`, `Bande`. Importés dans la place partagée sous OGC Studio (les trois d'un coup), préparés et posés par `assets/plans/construction_t206.luau` : 18 machines dans `Entrainement.Machines`, échelle 0,8 (Débutant et Confirmé), 1,15 à 1,25 (Élite), 1,2 à 1,4 (VIP). La bande du tapis ne défile pas (DecorAnime n'a pas de défilement) ; la copie personnelle n'a ni la place centrale ni les machines.
