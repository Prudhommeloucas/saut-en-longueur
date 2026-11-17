# Relevé du plan — monde 1, place centrale

Relevé de la toile Claude Design « Plan de la place centrale » (https://claude.ai/artifact/RJpCk7VXA19GqHzLb2erWh), validée par Loucas le 2026-11-15 (T-114). Voir [[Construction du monde 1]] et [[Contrats]].

Repère : X vers l'est (la piste), Z vers le sud, nord = −Z. Dessus du sol jouable à Y = 0. Tailles en studs : largeur (X) × profondeur (Z) × hauteur (Y). Valeurs de départ, à corriger pendant le test en blocs.

| Élément | Dossier | Tag | Centre (X, Z) | Taille | Attributs |
| --- | --- | --- | --- | --- | --- |
| Sol de la place | `Spawn` | — | (−90, 0) | rond, rayon 85, épaisseur 1 | dalles claires |
| Rosace | `Spawn` | — | (−90, 0) | rond, rayon 18 | couleurs du jeu |
| Points d'apparition × 6 | `Spawn` | `PointApparition` | cercle de rayon 10 autour de (−90, 0) | 6 × 1 × 6 | `Monde` = 1, tournés vers +X |
| Arche | `Piste` | — | (−2, 0) | 8 × 30 × 28 | écran géant au-dessus (T-106) |
| Puissance Débutant | `Entrainement` | `ZoneEntrainement` | (−42, −36) | 24 × 1 × 24 | `Stat` = Puissance, `Multiplicateur` = 1, `RecordRequis` = 0 |
| Puissance Confirmé | `Entrainement` | `ZoneEntrainement` | (−66, −58) | 24 × 1 × 24 | `Stat` = Puissance, `Multiplicateur` = 5, `RecordRequis` = 25 |
| Puissance Élite | `Entrainement` | `ZoneEntrainement` | (−96, −64) | 24 × 1 × 24 | `Stat` = Puissance, `Multiplicateur` = 25, `RecordRequis` = 80 |
| Vitesse Débutant | `Entrainement` | `ZoneEntrainement` | (−42, 36) | 24 × 1 × 24 | `Stat` = Vitesse, `Multiplicateur` = 1, `RecordRequis` = 0 |
| Vitesse Confirmé | `Entrainement` | `ZoneEntrainement` | (−66, 58) | 24 × 1 × 24 | `Stat` = Vitesse, `Multiplicateur` = 5, `RecordRequis` = 25 |
| Vitesse Élite | `Entrainement` | `ZoneEntrainement` | (−96, 64) | 24 × 1 × 24 | `Stat` = Vitesse, `Multiplicateur` = 25, `RecordRequis` = 80 |
| Estrade VIP | `Entrainement` | `ZoneEntrainement` | (−90, −108) | 24 × 2 × 16 | `Stat` = Puissance, `Multiplicateur` = 40, `PasseRequis` = VIP |
| Stand Chaussures | `Boutique` | `Stand` | (−127, −52) | 12 × 8 × 12 | `Famille` = Chaussures |
| Stand Propulseur | `Boutique` | `Stand` | (−140, −40) | 12 × 8 × 12 | `Famille` = Propulseur |
| Stand Matériel | `Boutique` | `Stand` | (−149, −26) | 12 × 8 × 12 | `Famille` = Materiel |
| Stand Tenue | `Boutique` | `Stand` | (−154, −11) | 12 × 8 × 12 | `Famille` = Tenue |
| Incubateur du stade | `Oeufs` | `Incubateur` | (−126, 51) | modèle `Assets.Decor.incubateur` | `Oeuf` = oeuf_stade |
| Incubateur du champion | `Oeufs` | `Incubateur` | (−141, 36) | modèle `Assets.Decor.incubateur` | `Oeuf` = oeuf_champion |
| Coffre du groupe | `Oeufs` | (à créer, T-605) | (−152, 18) | 8 × 4 × 8 | — |
| Roue | `Oeufs` | (à créer, T-605) | (−120, 72) | 10 × 10 × 2 | — |
| Portail monde 2 | `Portails` | `Portail` | (−172, 0) | 16 × 20 × 24, sur 3 marches (Y = 3) | `VersMonde` = 2 |
| Panthéon | `Decor` | `Pantheon` | (−212, 0) | 30 × 24 × 40 | vasque sur le toit |
| Panneaux de classement | `Decor` | `PanneauClassement` | (14, −40) | 16 × 12 × 4 | `Classement` = monde |
| Podium | `Decor` | `Podium` | (14, 40) | 16 × 3 × 10 | Parts `Place1`, `Place2`, `Place3` |
| Marquages au sol | `Spawn` | — | du centre vers chaque activité | 3 de large | orange (piste), rouge (Puissance), bleu (Vitesse), jaune (stands), violet (œufs), turquoise (portail) |
| Collines et arbres | `Decor` | — | anneau de rayon 100 à 140 autour de (−90, 0), sauf vers la piste | hauteur 10 à 40 | cachent les limites |

La piste (X de 0 à 120), la planche (X = 120) et le bac ne changent pas.

## Test en blocs (2026-11-15, place Test)

Construit dans la place `Test` (n° 132609339302090), `Workspace.Mondes.Monde1`, en Parts simples avec tags et attributs : 136 objets. Captures : `monde1_place_blocs_dessus.jpg`, `monde1_place_blocs_spawn.jpg`.

Ce qui reste imparfait :
- Depuis le spawn, on voit l'arche et les zones Débutant ; stands et incubateurs sont dans le dos. **Gardé ainsi** (décision du 2026-11-15) : ne pas surcharger le joueur au spawn.
- Les collines qui recouvraient l'estrade VIP et le panthéon ont été retirées : l'anneau a donc des trous au nord et à l'ouest, où le bord de la map se voit.
- Les incubateurs, le coffre et la roue sont des blocs (pas les vrais modèles), sans prompt testé.

## Construction dans la place partagée (2026-11-17)

Reconstruit depuis ce relevé par `assets/plans/construction_t114.luau` (testé d'abord dans la copie personnelle), et non copié de la place Test. Écarts avec le tableau :
- Podium et panneaux de classement à X = −4 au lieu de 14 : les tribunes occupent X 8 à 112.
- Les trous de l'anneau de collines sont bouchés : collines à r = 150 derrière l'estrade VIP et à r = 168 derrière le panthéon. L'herbe est prolongée (`HerbeOuest`, `HerbeNord`, `HerbeSud`).
- Les incubateurs sont les vrais modèles (`Assets.Decor.incubateur`), avec leur prompt.
- Zones et stands reprennent les panneaux, étincelles et prompts des anciens ; l'arche existante est gardée (T-105).
- Panthéon (T-405 et correctif du 2026-11-17) : vrai modèle à l'échelle 1,3, posé à (−220, 30) au lieu de (−212, 0), pour qu'il ne soit plus caché par le portail depuis le centre de la place.
