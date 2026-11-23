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
| `ZoneEntrainement` | Part au sol | `Stat` (Puissance, Vitesse, Aero), `Palier` (1, 2, 3, 4 : rang dans `Config/Mondes.zones` du monde) ; en secours, sans `Palier` : `Multiplicateur` (nombre), `RecordRequis` (m), `PasseRequis` (texte, facultatif) | posé (T-007), lu (T-008) : une Part par zone, la stat doit exister sur le joueur (Aero pas encore). Depuis T-202 (2026-11-22), le `Palier` donne multiplicateur, record requis et passe depuis la configuration (monde 1 : 1 Débutant × 1, 2 Confirmé × 2 dès 25 m, 3 Élite × 12 dès 80 m, 4 VIP × 20 avec l'attribut `PasseVIP`) ; les sept zones de la place l'ont. Les anciens attributs restent posés mais ne servent plus |
| `Piste` | Part de la piste d'élan | `Monde` (nombre) | posé (T-007), lu (T-008) : son début (bord -X) déclenche les bonus et fixe le point de retour après un saut (sur la place, 18 studs avant son début, 5 studs côté +Z) |
| `PlancheAppel` | Part de la planche | `Monde` | posé (T-007), lu (T-008) : la distance se mesure depuis son bord +X |
| `Bac` | Parts de la zone d'atterrissage | `Monde` | posé (T-007), lu (T-008) : le premier contact avec une de ces Parts compte comme atterrissage |
| `Anneau` | Part de contact sans collision. Monde 1 : disque invisible `Zone` (cylindre, axe X, PrimaryPart) d'un Model `AnneauN` ; le modèle `stade_anneau` autour (`Or` à la couleur de la série, `Blanc`) est décoratif, sans contact | `Pieces` (nombre), `Poussee` (nombre) | posé (T-106, 2026-11-22) : 9 anneaux en blocs dans `Monde1.Anneaux.Serie1` à `Serie3` ; pièces une fois par anneau et par saut, en vol seulement ; défauts 5 pièces et poussée 20 (`Config/Saut`, 30 jusqu'au 2026-11-22) |
| `Stand` | Model d'un stand de boutique | `Famille` (Chaussures, Propulseur, Materiel, Ailes, Tenue) ; `Objet` = « Materiel » pour le stand de matériel (sinon ignoré depuis T-203) ; une invite `Prompt` (Acheter, E) et, créée par le code si absente, `PromptAmeliorer` (Améliorer, R) | posé (T-007), lu (T-008) ; depuis T-203 (2026-11-22), un stand de famille vend l'objet suivant de sa famille et améliore l'objet porté ; les stands Chaussures, Propulseur, Tenue et Materiel sont des Parts, un Model quand les vrais stands seront construits (T-207) |
| `Magasin` | Model du magasin de la place centrale (T-217) | une Part invisible `Comptoir` qui porte l'invite `PromptBoutique` (Ouvrir, E), créée par le code ; elle ouvre la boutique du joueur (événement `OuvrirBoutique`), fermée avant le premier saut comme les stands | posé et lu le 2026-11-23 (`Workspace.Mondes.Monde1.Boutique.Magasin`, modèle `Assets.Decor.place_magasin`) |
| `TableauQuetes` | Model du tableau des quêtes de la place centrale (T-218) | une Part invisible `Ecran` (face avant -Z) : le contrôleur `TableauQuetes` y pose une SurfaceGui du joueur (quêtes du jour et coffre, semaine, défis ; boutons → `ActionRecompense`) et une pastille rouge `PastilleQuetes` au-dessus | posé et lu le 2026-11-23 (`Workspace.Mondes.Monde1.Decor.TableauQuetes`, modèle `Assets.Decor.place_tableau`) |
| `Cadeau` | Model du cadeau de temps de jeu de la place centrale (T-219) | une Part `Socle` (cylindre, collision) qui porte l'invite `PromptCadeau` (Ouvrir, E), créée par le serveur : elle ouvre le premier cadeau de la session prêt et pas encore pris (événement `CadeauOuvert`) ; les meshes `Couvercle_*` sautent à l'ouverture ; compte à rebours `CompteCadeau` au-dessus | posé et lu le 2026-11-23 (`Workspace.Mondes.Monde1.Decor.Cadeau`, modèle `Assets.Decor.place_cadeau`) |
| `Incubateur` | Model | `Oeuf` (identifiant) | modèle prêt (`Assets.Decor.incubateur`, tag et `Oeuf` = `oeuf_stade` déjà posés ; changer l'attribut pour chaque copie). Attachment `PoseOeuf` dans `Blanc` : là où poser l'œuf |
| `Portail` | Model | `VersMonde` (nombre) | modèle posé (T-405, `Assets.Decor.portail_monde2`) ; pièces `Tourbillon` (PrimaryPart), `Spirale` (DecorAnime, Rotation), `Cadenas` (à retirer quand le monde est ouvert) ; pas encore lu par le code (T-403) |
| `Pantheon` | Model du lieu de changement de catégorie | aucun | modèle posé (T-405, `Assets.Decor.pantheon`), entrée face au centre de la place ; pas encore lu (T-401) |
| `Podium` | Model avec trois Parts `Place1`, `Place2`, `Place3` | aucun | prévu |
| `PanneauClassement` | Part avec une surface d'affichage | `Classement` (identifiant) | prévu |
| `Courant` | Part sans collision (colonne d'air, monde 3) | `Force` | prévu |
| `Rebond` | Part (toit, monde 5) | `Force` | prévu |
| `PointApparition` | Part où réapparaît le joueur | `Monde` | six `SpawnLocation` en cercle sur la place (T-114) ; pas lu par le code tant qu'il n'y a qu'un monde |
| `DecorAnime` | Part ou Model de décor animé par le client | `Type` (Rotation, Flottement, Balancement, Pulsation), `Vitesse` (degrés par seconde pour Rotation), `Amplitude`, `AxeRotation` (Vector3, axe local, pour Rotation) | lu par le contrôleur client `DecorAnime` (T-117) : l'objet bouge autour de son pivot, côté joueur seulement, à moins de 300 studs de la caméra (`Config/Decor`) ; Vitesse = allers-retours par seconde hors Rotation ; Amplitude en studs (Flottement), degrés (Balancement) ou part de la taille (Pulsation). Posé sur la spirale du portail et la vasque |
| `CanonConfettis` | Part d'où partent les confettis, le long de la piste | aucun | prévu |
| `LanceurFeuArtifice` | Part d'où part une fusée | `Palier` (0 à 5) | prévu |
| `Projecteur` | Model d'un projecteur de stade orientable (modèle `stade_projecteur`) : fixes `Mat` (seule pièce avec collision), `Bagues`, `Charniere` ; tête `Tete` (PrimaryPart), `Lampe` (Neon + SpotLight), `Cerclages`, `Chapeau`, à tourner ensemble autour de l'axe de la charnière, 48 studs au-dessus du pied | aucun | posé (T-106, 2026-11-22) : 6 dans `Monde1.Decor.Projecteurs`, X 10 / 250 / 490, Z ±50, têtes inclinées vers l'axe du bac |
| `EcranGeant` | Part avec une surface d'affichage : `Surface` du Model `Piste.EcranGeant`, SurfaceGui `AffichageLeft` (vers la place) et `AffichageRight` (vers la piste), chacun avec `Fond.Titre` et `Fond.Info` | aucun | posé (T-106, 2026-11-22) au-dessus de l'arche, dans le modèle `stade_ecran` (`Bleu`, `Nuit`, `Or`, `Gris`) ; contenu provisoire |
| `Mascotte` | Model à squelette de la mascotte géante | aucun | prévu |
| `Vasque` | Model de la vasque, avec une Part `Flamme` | aucun | dans le panthéon (T-405) : Model `Vasque` avec `Flamme` (PrimaryPart) et `FlammeCoeur`, en Neon ; tagué aussi `DecorAnime` (Pulsation) |
| `DrapeauVent` | Model d'un drapeau qui se tend pendant le vent favorable | aucun | prévu |
| `BandePiste` | Parts lumineuses de la piste (saut doré) | aucun | prévu |
| `Public` | Model d'un bloc de spectateurs, pour la ola | `Rang` (ordre dans la vague) | posé (T-106, 2026-11-22) : un Model `Public` dans chacun des 48 modules de `Decor.Tribunes`, `Rang` 1 à 24 d'ouest en est (même rang des deux côtés), 929 spectateurs `stade_spectateur` (MeshParts `Corps` et `Tete`, couleurs variées) sans collision |

Les dix derniers tags viennent de [[Construction du monde 1]] : ce sont les points d'accroche du décor, que le code déclenchera sur les événements du jeu (record, saut parfait, vent favorable, saut doré, concours).

Règles : l'axe de la piste est X, le dessus des sols est à Y = 0, la planche d'appel du monde 1 reste à X = 120. Une Part interactive porte son tag sur elle-même, pas sur son dossier.

## Modèles (rangés dans Studio, utilisés par le code)

- **Équipement** : un Model nommé par l'identifiant de l'objet, avec une Part `Poignee` qui indique où l'attacher et un attribut `Attache` (PiedGauche, PiedDroit, Pieds, Dos, Torse). `Pieds` : le même modèle est cloné sur chaque pied, `Poignee` sous le pied, au centre du dessus de la semelle (`chaussures_ressorts`). `Poignee` est la `PrimaryPart` ; les meshes y sont soudés (`WeldConstraint`), sans collision. Une pièce mobile (`Helice`, `Aiguille`) porte l'attribut `AxeRotation` (Vector3, axe dans le repère du modèle) : le code la fait tourner autour de son pivot pendant la poussée.
- **Compagnon** : un Model nommé par l'identifiant de l'espèce, `PrimaryPart` défini, moins de 3 studs de haut, face vers -Z. Le pivot du modèle est au sol, entre les pattes ; les meshes sont soudés à la `PrimaryPart`, sans collision ni ancrage. Un attachment `Cou` dans la `PrimaryPart`, sur le poitrail, face vers -Z : point d'accroche de la médaille des versions Argent et Or (à poser sur chaque nouveau compagnon). Un nouveau compagnon doit aussi être déclaré dans `Config/Compagnons.ESPECES` (même identifiant), avec sa rareté et son rôle.
- **Décor** (`Assets.Decor`) : un Model nommé par son identifiant, ancré, pivot au sol. Les meshes n'ont pas de collision ; des Parts invisibles nommées `Collision` la portent.
- **Œuf** (`Assets.Oeufs`) : un Model nommé par l'identifiant de l'œuf (`oeuf_stade`, `oeuf_champion`, `oeuf_or`), pivot au sol, 2,5 studs de haut. Coquille en deux MeshParts : `Bas` (`PrimaryPart`) et `Haut`, séparées par une fêlure en zigzag à 1,2 stud : l'éclosion soulève `Haut`. Chaque décor est coupé le long de la fêlure en deux meshes nommés `<Décor>_Bas` et `<Décor>_Haut` (`Orange_Haut`, `Lauriers_Bas`…), soudés chacun à sa moitié de coquille (`WeldConstraint`, `Part0` = `Bas` ou `Haut`). `Haut` est soudé à `Bas` : pour l'éclosion, le code détruit cette soudure puis déplace `Haut`, qui emporte ses décors (et l'`Etoile` de l'œuf du champion). T-304, 2026-11-15.
- **Versions Argent et Or** (`Assets.Versions`) : aucun modèle en plus, le code transforme le compagnon cloné. Deux `Configuration` `Argent` et `Or` portent la recette : `Couleur` (Color3), `Melange` (0,6 : part de la couleur mêlée à celle de chaque mesh), `Matiere` (`Metal`), `Medaille` (nom du modèle de médaille), `Garder` (noms des meshes à laisser tels quels : yeux, pupilles, iris, verres, étoiles, bouche ; les meshes en `Neon` ou `Glass` sont aussi gardés). Médailles `medaille_argent` (ruban bleu) et `medaille_or` (ruban rouge, particules `Eclat`) : `PrimaryPart` = `Ruban`, attachment `Accroche` en haut du ruban, à poser sur l'attachment `Cou` du compagnon puis souder à sa `PrimaryPart`.
- Les identifiants sont ceux des modules de configuration. La tâche de contrats de la phase en publie la liste dans [[Registre des modèles]] avant les tâches de modélisation.

## Attributs du joueur liés à l'entraînement et à l'équipement (posés par le code, T-202, T-203)

| Attribut | Type | Posé par | Sens |
| --- | --- | --- | --- |
| `Entraine` | texte ou rien | service `Entrainement` | stat que le joueur entraîne en ce moment (absent hors zone) ; le contrôleur `Rythme` affiche le cercle quand il est posé |
| `Materiel` | nombre | profil (`equipement.materiel`), boutique | palier de matériel d'entraînement atteint (0 à 8, `Config/Equipement.MATERIEL`) |
| `PasseEntrainementAuto` | booléen | futur service des passes (T-602) | joue le rythme à la qualité Bon à la place du joueur |
| `Chaussures`, `Propulseur`, `Tenue` | texte ou rien | boutique, d'après le profil (T-203) | identifiant de l'objet porté dans la famille (`Config/Equipement.CATALOGUE`) |
| `ChaussuresNiveau`, `PropulseurNiveau`, `TenueNiveau` | nombre | boutique (T-203) | niveau de l'objet porté, de 1 à 5 |

Un stand `Stand` avec `Objet` = « Materiel » vend le palier de matériel suivant (`StandMateriel`, invite ajoutée le 2026-11-22).

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
