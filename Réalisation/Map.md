# Map

Voir [[Projet]] pour la vue d'ensemble. Tout est dans `Workspace.Mondes.Monde1` (rangé par T-007 le 2026-11-17, avant dans `Workspace.Map`). La piste suit l'axe X, le dessus des sols est à Y = 0.

## Ce qui est construit

Chemins depuis `Workspace.Mondes.Monde1`.

| Élément | Nom dans Studio | Tag (attributs) | Position |
| --- | --- | --- | --- |
| Sol du spawn | `Spawn.SolSpawn` | | X de -120 à 0, 120 de large |
| Point d'apparition | `Spawn.Spawn` | `PointApparition` (`Monde` = 1) | X = -100, face à la piste |
| Zone squat | `Entrainement.ZoneSquat` | `ZoneEntrainement` (`Stat` = Puissance, `Multiplicateur` = 1, `RecordRequis` = 0) | (-60, -38) |
| Zone mollets | `Entrainement.ZoneMollets` | `ZoneEntrainement` (`Stat` = Vitesse, `Multiplicateur` = 1, `RecordRequis` = 0) | (-60, 38) |
| Stands de boutique | `Boutique.StandChaussures`, `Boutique.StandJetpack` | `Stand` (`Famille` = Chaussures, Propulseur), posé sur des Parts pour l'instant | (-18, ±30) |
| Arche d'entrée | `Piste.Arche` | | X = 0 |
| Piste d'élan | `Piste.Piste`, deux `Piste.LignePiste` | `Piste` (`Monde` = 1) | X de 0 à 120, 16 de large |
| Planche d'appel | `Piste.PlancheAppel` | `PlancheAppel` (`Monde` = 1) | X = 120, la distance se mesure à partir d'ici |
| Sable | `Bac.Sable` | `Bac` (`Monde` = 1) | X de 120 à 2120 (500 m), 40 de large |
| Marqueurs | `Bac.Marqueurs` | | une ligne et un panneau tous les 10 m, jusqu'à 500 m |
| Murs invisibles | `Bac.Murs` | | autour du sable |
| Décor | `Decor` (`Sol` avec la grande `Herbe`, `Tribunes`, `Drapeaux`, `Lampadaires`, `Gym`, `Arbres`, `ArbresPiste`) | | voir [[Décor et effets]] |
| Anneaux, portails | `Anneaux`, `Portails` | | dossiers vides (T-106, monde 2) |

Le code lit la map par les tags (T-008, module `Shared/Util/Map`) : noms et dossiers sont libres. On peut déplacer ou ajouter une zone, une planche, un bac ou un stand sans toucher au code, tant que le tag et les attributs sont posés. Script du rangement, relançable : `assets/plans/rangement_t007.luau`.

## Règles

- Les murs invisibles obligent à entrer sur le sable par la piste. Sans eux, on pourrait marcher sur le sable par le côté et gagner des pièces sans sauter.
- Le premier contact avec `Sable` compte comme l'atterrissage. Marcher sur le sable sans sauter donne environ 0 m.
- Après l'atterrissage, le joueur est renvoyé au début de la piste au bout de 2 secondes.

## Plan cible

Décidé le 2026-11-12, pas encore construit : le spawn carré devient une place ronde (centre vers X = -90, rayon d'environ 85 studs) avec entraînement, stands, œufs, panthéon et portail en cercle, et le bac traverse cinq décors de 100 m. La piste, la planche (X = 120) et le bac ne bougent pas. Le plan complet et les étapes sont dans [[Construction du monde 1]]. Le tableau ci-dessus décrit l'existant ; il sera refait quand la place ronde sera construite.

## À faire

- Construire la place centrale (T-114).
- Les mondes suivants sont décrits dans [[Mondes]], les modèles à produire dans [[Modèles 3D]].
- Le décor est en place, voir [[Décor et effets]]. Il reste à remplacer les formes simples par de vrais modèles.
- Si les sauts dépassent 500 m, allonger le sable (une Part est limitée à 2048 studs, il faudra en ajouter une deuxième).
