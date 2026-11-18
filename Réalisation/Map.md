# Map

Voir [[Projet]] pour la vue d'ensemble. Tout est dans `Workspace.Mondes.Monde1` (rangé par T-007 le 2026-11-17, avant dans `Workspace.Map`). La piste suit l'axe X, le dessus des sols est à Y = 0.

## Ce qui est construit

Chemins depuis `Workspace.Mondes.Monde1`. La place centrale ronde (T-114, 2026-11-17) est en blocs : les vrais modèles viendront famille par famille ([[Construction du monde 1]], étape 4). Positions détaillées dans `assets/plans/monde1.md`.

| Élément | Nom dans Studio | Tag (attributs) | Position (X, Z) |
| --- | --- | --- | --- |
| Place ronde | `Spawn.SolPlace`, quatre `Spawn.Rosace` | | centre (-90, 0), rayon 85, dalles ; rosace de rayon 18 |
| Points d'apparition | six `Spawn.PointApparition` (`SpawnLocation`) | `PointApparition` (`Monde` = 1) | cercle de rayon 10 autour du centre, tournés vers la piste |
| Marquages au sol | `Spawn.Marquages` | | du bord de la rosace vers la piste (orange), la Puissance (rouge), la Vitesse (bleu), les stands (jaune), les œufs (violet), le portail (turquoise) |
| Zones de Puissance | `Entrainement.PuissanceDebutant`, `…Confirme`, `…Elite` | `ZoneEntrainement` (`Stat` = Puissance ; ×1, ×5 dès 25 m, ×25 dès 80 m) | (-42, -36), (-66, -58), (-96, -64) |
| Zones de Vitesse | `Entrainement.VitesseDebutant`, `…Confirme`, `…Elite` | `ZoneEntrainement` (`Stat` = Vitesse ; mêmes paliers) | (-42, 36), (-66, 58), (-96, 64) |
| Estrade VIP | `Entrainement.EstradeVIP` | `ZoneEntrainement` (Puissance ×40, `PasseRequis` = VIP : fermée sans passe) | (-90, -108) |
| Stands | `Boutique.StandChaussures`, `StandPropulseur`, `StandMateriel`, `StandTenue` | `Stand` (`Famille` ; `Objet` = Chaussures, Jetpack sur les deux premiers) | (-127, -52), (-140, -40), (-149, -26), (-154, -11) |
| Incubateurs | `Oeufs.Incubateur_stade`, `Oeufs.Incubateur_champion` (vrais modèles) | `Incubateur` (`Oeuf`) | (-126, 51), (-141, 36) |
| Coffre et roue | `Oeufs.Coffre`, `Oeufs.Roue` | à créer (T-605) | (-152, 18), (-120, 72) |
| Portail | `Portails.PortailMonde2` (vrai modèle `portail_monde2`, T-405 : arche, tourbillon, spirale, cadenas) | `Portail` (`VersMonde` = 2), pas encore lu | (-172, 0) |
| Panthéon | `Decor.Pantheon` (vrai modèle `pantheon` à l'échelle 1,3, T-405 : statue dorée, vasque et flamme) | `Pantheon` ; `Vasque` sur sa flamme | (-220, 30) : décalé du portail pour ne pas être caché (2026-11-17) |
| Classement et podium | `Decor.PanneauClassement`, `Decor.Podium` (`Place1` à `Place3`) | `PanneauClassement` (`Classement` = monde), `Podium` | (-4, -40), (-4, 40) : décalés du relevé, les tribunes occupant X 8 à 112 |
| Limites cachées | `Decor.Collines` (21), `Decor.ArbresPlace` (17 arbres) | | anneau de rayon 118 à 128, plus loin derrière l'estrade VIP (150) et le panthéon (168), ouvert vers la piste |
| Arche d'entrée | `Piste.Arche.Arche` (vrai modèle `stade_arche`, T-105) | | X = 0, 33,6 de large, 35 de haut avec l'écran |
| Piste d'élan | `Piste.Piste` (brique), deux `Piste.LignePiste` | `Piste` (`Monde` = 1) | X de 0 à 120, 16 de large |
| Planche d'appel | `Piste.PlancheAppel` (blanche) et `Piste.BandePlanche` (rouge, décor sans collision) | `PlancheAppel` (`Monde` = 1) sur la planche seulement | X = 120, la distance se mesure à partir d'ici |
| Sable | `Bac.Sable`, `Bac.Bordure` (blanche, de 0 à 100 m) | `Bac` (`Monde` = 1) sur le sable | X de 120 à 2120 (500 m), 40 de large |
| Marqueurs | `Bac.Marqueurs` ; `Bac.Panneaux` de 10 à 90 m (vrais modèles `stade_panneau_petit` et `_grand` à 50 m, côté nord) | | une ligne tous les 10 m jusqu'à 500 m ; poteaux au-delà de 100 m |
| Tunnel 100 m | `Bac.Tunnel.Tunnel` (vrai modèle `stade_tunnel`, collisions sur les tours seulement) | | X de 500 à 540, sortie du stade et arche du premier palier |
| Tribunes | `Decor.Tribunes` : 48 `tribune_module` (T-105) | | X de 10 à 490, des deux côtés, l'avant à Z ±27 |
| Murs invisibles | `Bac.Murs` | | autour du sable |
| Décor | `Decor` (`Sol` : `Herbe`, `HerbeOuest`, `HerbeNord`, `HerbeSud` ; `Tribunes`, `Drapeaux`, `Arbres`, `ArbresPiste`) | | voir [[Décor et effets]] |
| Anneaux | `Anneaux` | | dossier vide (T-106) |

L'ancien spawn carré (sol, zones squat et mollets, racks, stands, gym, lampadaires, 9 arbres) est rangé dans `ServerStorage.Modeles.AncienSpawn`, pas supprimé.

Le code lit la map par les tags (T-008, module `Shared/Util/Map`) : noms et dossiers sont libres. On peut déplacer ou ajouter une zone, une planche, un bac ou un stand sans toucher au code, tant que le tag et les attributs sont posés. Scripts relançables : `assets/plans/rangement_t007.luau` (rangement), `assets/plans/construction_t114.luau` (place centrale), `assets/plans/construction_t105.luau` (stade en blocs, 2026-11-18 ; ce qu'il remplace est rangé dans `ServerStorage.Modeles.BlocsT105`). Captures : `assets/captures/monde1_place_spawn.jpg`, `monde1_place_dessus.jpg`.

## Règles

- Les murs invisibles obligent à entrer sur le sable par la piste. Sans eux, on pourrait marcher sur le sable par le côté et gagner des pièces sans sauter.
- L'atterrissage est détecté par la position (T-102) : le serveur regarde sous les pieds du joueur s'il y a une Part taguée `Bac`. Le premier mètre de sable ne compte pas (zone où l'on peut mordre).
- Rien ne doit gêner le vol au-dessus du bac : le linteau du tunnel est sans collision, les panneaux et les tribunes restent hors des murs invisibles (Z ±21).
- Après l'atterrissage, le joueur est renvoyé au bout de 2 secondes sur la place, juste à côté de la bande orange `VersPiste` : 18 studs avant le début de la piste et 5 studs à droite de son axe (côté +Z), tourné vers le bac. Il choisit d'y retourner ou d'aller ailleurs (choisi par Loucas le 2026-11-18, réglages `RETOUR_*` dans `Config/Saut`). Ce point doit rester dégagé quand on pose le décor autour de la piste.
- Depuis le point d'apparition, on voit l'arche, la piste et les zones Débutant ; stands et œufs sont dans le dos (décision du 2026-11-15 : ne pas surcharger le joueur au spawn).

## À faire

- Remplacer les blocs par les vrais modèles, une famille à la fois (T-206, T-207, T-503, T-605) ; panthéon et portail faits (T-405).
- Brancher le portail (monde 2), le panthéon, le podium et le classement quand leur code existera.
- Les mondes suivants sont décrits dans [[Mondes]], les modèles à produire dans [[Modèles 3D]].
- Si les sauts dépassent 500 m, allonger le sable (une Part est limitée à 2048 studs, il faudra en ajouter une deuxième).
