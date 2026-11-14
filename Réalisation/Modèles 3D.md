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

Œuf du stade : blanc à bandes orange. Œuf du champion : doré avec lauriers. Œuf d'or : translucide, lueur violette.

Versions Argent et Or : même modèle, matière métallique et médaille au cou. Aucun modèle supplémentaire.

## Mondes suivants

Chaque monde demande : son terrain, sa piste et son appel, ses trois paliers de zones, ses stands, son portail, 15 objets d'équipement et 10 compagnons. Les listes détaillées s'écrivent ici au début de la phase du monde ([[Mondes]]).

## Sources toutes faites

Le Creator Store de Roblox et, selon la version du MCP Blender, des bibliothèques de modèles libres peuvent servir pour le décor secondaire (arbres, rochers). Vérifier la licence, retoucher aux couleurs du jeu, et noter la source dans le registre. Les éléments qui font l'identité du jeu (compagnons, équipement, stade) sont faits par nous.
