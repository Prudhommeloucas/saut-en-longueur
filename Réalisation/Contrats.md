# Contrats

Les noms, tags et attributs sur lesquels toute l'équipe s'accorde. C'est ce qui permet de travailler en même temps : l'un construit la map, un autre les écrans, un troisième code, et tout se branche sans retouche. Voir [[Travailler à plusieurs]].

**Tout le monde peut modifier cette note.** Ajouter un tag, un attribut ou un nom d'écran est libre : l'écrire ici pendant la tâche qui en a besoin. Renommer ou supprimer un nom déjà utilisé oblige à mettre à jour, dans la même tâche, le code, les objets de Studio et cette note. Les lignes marquées « prévu » ne sont pas encore lues par le code.

## Organisation de la place

```
Workspace
  Mondes
    Monde1            (un dossier par monde, tout ce qui est visible et solide)
      Spawn, Entrainement, Boutique, Oeufs, Piste, Bac, Decor, Anneaux, Portails
ReplicatedStorage
  Shared              (code, envoyé par Rojo)
  Assets
    Equipement        un Model par objet, nommé par son identifiant
    Compagnons        un Model par espèce
    Decor             modèles de décor prêts à cloner dans un monde (tribune_module)
    Oeufs             un Model par œuf, coquille et décors en `Bas` et `Haut`
    Versions          médailles et recettes des versions Argent et Or des compagnons
    Effets            particules et effets prêts à cloner
    Animations        objets Animation avec leur identifiant
ServerStorage
  Modeles             modèles en cours ou non utilisés (AncienSpawn : l'ancien spawn carré, rangé par T-114)
StarterGui            un ScreenGui par écran
SoundService
  Musique, Ambiance, Effets, Interface   (SoundGroup)
```

La map est rangée dans `Workspace.Mondes.Monde1` depuis T-007 (2026-11-17), voir [[Map]].

## Tags de la map (posés dans Studio, lus par le code)

| Tag | Sur quoi | Attributs | État |
| --- | --- | --- | --- |
| `ZoneEntrainement` | Part au sol | `Stat` (Puissance, Vitesse, Aero), `Multiplicateur` (nombre), `RecordRequis` (m), `PasseRequis` (texte, facultatif) | posé (T-007), lu (T-008) : une Part par zone, la stat doit exister sur le joueur (Aero pas encore). `PasseRequis` = « VIP » : zone fermée sauf si le joueur a l'attribut `PasseVIP` à vrai (T-114 ; à poser par le futur service des passes) |
| `Piste` | Part de la piste d'élan | `Monde` (nombre) | posé (T-007), lu (T-008) : son début (bord -X) déclenche les bonus et fixe le point de retour après un saut |
| `PlancheAppel` | Part de la planche | `Monde` | posé (T-007), lu (T-008) : la distance se mesure depuis son bord +X |
| `Bac` | Parts de la zone d'atterrissage | `Monde` | posé (T-007), lu (T-008) : le premier contact avec une de ces Parts compte comme atterrissage |
| `Anneau` | Part en forme d'anneau, sans collision | `Pieces` (nombre), `Poussee` (nombre) | code prêt (T-104) : pièces une fois par anneau et par saut, en vol seulement ; défauts 5 pièces et poussée 30 (`Config/Saut`) ; aucun anneau posé (T-106) |
| `Stand` | Model d'un stand de boutique | `Famille` (Chaussures, Propulseur, Materiel, Ailes, Tenue), `Objet` (identifiant de `Config/Equipement`, lu par la boutique) ; un `ProximityPrompt` quelque part dans le stand | posé (T-007), lu (T-008), sur les deux stands actuels, qui sont encore des Parts (`Famille` = Chaussures, Propulseur) ; un Model quand les vrais stands seront construits (T-207) |
| `Incubateur` | Model | `Oeuf` (identifiant) | modèle prêt (`Assets.Decor.incubateur`, tag et `Oeuf` = `oeuf_stade` déjà posés ; changer l'attribut pour chaque copie). Attachment `PoseOeuf` dans `Blanc` : là où poser l'œuf |
| `Portail` | Model | `VersMonde` (nombre) | modèle posé (T-405, `Assets.Decor.portail_monde2`) ; pièces `Tourbillon` (PrimaryPart), `Spirale` (DecorAnime, Rotation), `Cadenas` (à retirer quand le monde est ouvert) ; pas encore lu par le code (T-403) |
| `Pantheon` | Model du lieu de changement de catégorie | aucun | modèle posé (T-405, `Assets.Decor.pantheon`), entrée face au centre de la place ; pas encore lu (T-401) |
| `Podium` | Model avec trois Parts `Place1`, `Place2`, `Place3` | aucun | prévu |
| `PanneauClassement` | Part avec une surface d'affichage | `Classement` (identifiant) | prévu |
| `Courant` | Part sans collision (colonne d'air, monde 3) | `Force` | prévu |
| `Rebond` | Part (toit, monde 5) | `Force` | prévu |
| `PointApparition` | Part où réapparaît le joueur | `Monde` | six `SpawnLocation` en cercle sur la place (T-114) ; pas lu par le code tant qu'il n'y a qu'un monde |
| `DecorAnime` | Part ou Model de décor animé par le client | `Type` (Rotation, Flottement, Balancement, Pulsation), `Vitesse` (degrés par seconde pour Rotation), `Amplitude`, `AxeRotation` (Vector3, axe local, pour Rotation) | posé sur la spirale du portail et la vasque (T-405) ; lu par T-117 |
| `CanonConfettis` | Part d'où partent les confettis, le long de la piste | aucun | prévu |
| `LanceurFeuArtifice` | Part d'où part une fusée | `Palier` (0 à 5) | prévu |
| `Projecteur` | Model d'un projecteur de stade orientable | aucun | prévu |
| `EcranGeant` | Part avec une surface d'affichage | aucun | prévu |
| `Mascotte` | Model à squelette de la mascotte géante | aucun | prévu |
| `Vasque` | Model de la vasque, avec une Part `Flamme` | aucun | dans le panthéon (T-405) : Model `Vasque` avec `Flamme` (PrimaryPart) et `FlammeCoeur`, en Neon ; tagué aussi `DecorAnime` (Pulsation) |
| `DrapeauVent` | Model d'un drapeau qui se tend pendant le vent favorable | aucun | prévu |
| `BandePiste` | Parts lumineuses de la piste (saut doré) | aucun | prévu |
| `Public` | Model d'un bloc de spectateurs, pour la ola | `Rang` (ordre dans la vague) | prévu |

Les dix derniers tags viennent de [[Construction du monde 1]] : ce sont les points d'accroche du décor, que le code déclenchera sur les événements du jeu (record, saut parfait, vent favorable, saut doré, concours).

Règles : l'axe de la piste est X, le dessus des sols est à Y = 0, la planche d'appel du monde 1 reste à X = 120. Une Part interactive porte son tag sur elle-même, pas sur son dossier.

## Modèles (rangés dans Studio, utilisés par le code)

- **Équipement** : un Model nommé par l'identifiant de l'objet, avec une Part `Poignee` qui indique où l'attacher et un attribut `Attache` (PiedGauche, PiedDroit, Pieds, Dos, Torse). `Pieds` : le même modèle est cloné sur chaque pied, `Poignee` sous le pied, au centre du dessus de la semelle (`chaussures_ressorts`). `Poignee` est la `PrimaryPart` ; les meshes y sont soudés (`WeldConstraint`), sans collision. Une pièce mobile (`Helice`, `Aiguille`) porte l'attribut `AxeRotation` (Vector3, axe dans le repère du modèle) : le code la fait tourner autour de son pivot pendant la poussée.
- **Compagnon** : un Model nommé par l'identifiant de l'espèce, `PrimaryPart` défini, moins de 3 studs de haut, face vers -Z. Le pivot du modèle est au sol, entre les pattes ; les meshes sont soudés à la `PrimaryPart`, sans collision ni ancrage. Un attachment `Cou` dans la `PrimaryPart`, sur le poitrail, face vers -Z : point d'accroche de la médaille des versions Argent et Or (à poser sur chaque nouveau compagnon). Un nouveau compagnon doit aussi être déclaré dans `Config/Compagnons.ESPECES` (même identifiant), avec sa rareté et son rôle.
- **Décor** (`Assets.Decor`) : un Model nommé par son identifiant, ancré, pivot au sol. Les meshes n'ont pas de collision ; des Parts invisibles nommées `Collision` la portent.
- **Œuf** (`Assets.Oeufs`) : un Model nommé par l'identifiant de l'œuf (`oeuf_stade`, `oeuf_champion`, `oeuf_or`), pivot au sol, 2,5 studs de haut. Coquille en deux MeshParts : `Bas` (`PrimaryPart`) et `Haut`, séparées par une fêlure en zigzag à 1,2 stud : l'éclosion soulève `Haut`. Chaque décor est coupé le long de la fêlure en deux meshes nommés `<Décor>_Bas` et `<Décor>_Haut` (`Orange_Haut`, `Lauriers_Bas`…), soudés chacun à sa moitié de coquille (`WeldConstraint`, `Part0` = `Bas` ou `Haut`). `Haut` est soudé à `Bas` : pour l'éclosion, le code détruit cette soudure puis déplace `Haut`, qui emporte ses décors (et l'`Etoile` de l'œuf du champion). T-304, 2026-11-15.
- **Versions Argent et Or** (`Assets.Versions`) : aucun modèle en plus, le code transforme le compagnon cloné. Deux `Configuration` `Argent` et `Or` portent la recette : `Couleur` (Color3), `Melange` (0,6 : part de la couleur mêlée à celle de chaque mesh), `Matiere` (`Metal`), `Medaille` (nom du modèle de médaille), `Garder` (noms des meshes à laisser tels quels : yeux, pupilles, iris, verres, étoiles, bouche ; les meshes en `Neon` ou `Glass` sont aussi gardés). Médailles `medaille_argent` (ruban bleu) et `medaille_or` (ruban rouge, particules `Eclat`) : `PrimaryPart` = `Ruban`, attachment `Accroche` en haut du ruban, à poser sur l'attachment `Cou` du compagnon puis souder à sa `PrimaryPart`.
- Les identifiants sont ceux des modules de configuration. La tâche de contrats de la phase en publie la liste dans [[Registre des modèles]] avant les tâches de modélisation.

## Interface (construite dans Studio, branchée par le code)

- Un `ScreenGui` par écran, nommé comme dans [[HUD]] (par exemple `HudPrincipal`, `EcranBoutique`).
- Dans chaque écran, les éléments que le code doit lire ou modifier portent un nom fixé par la note [[HUD]] : `TextePieces`, `BoutonFermer`, `ListeObjets`, `ModeleLigne`.
- Les éléments purement décoratifs sont nommés librement.
- Une ligne de liste (un objet de boutique, un compagnon) est construite une fois, nommée `ModeleLigne`, et laissée invisible : le code la clone.
- Aucun `LocalScript` dans `StarterGui`.

## Sons (choisis et publiés, lus par le code)

Chaque son a un identifiant texte (`saut_appel_parfait`) listé dans [[Sons et musique]]. Celui qui publie le son inscrit l'identifiant d'asset dans [[Registre des sons]] et le reporte dans `Config/Sons` (ou laisse le report à la tâche de branchement).

## Comment avancer sans s'attendre

1. Au début de chaque phase, la tâche de contrats (T-100, T-200…) complète cette note et les listes d'identifiants.
2. Les tâches de construction suivent la note. Les tâches de code utilisent des objets provisoires portant les mêmes noms.
3. Quand un élément est livré, il remplace le provisoire sans changement de code.
