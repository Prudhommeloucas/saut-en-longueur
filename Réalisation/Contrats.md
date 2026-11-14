# Contrats

Les noms, tags et attributs sur lesquels toute l'équipe s'accorde. C'est ce qui permet de travailler en même temps : l'un construit la map, un autre les écrans, un troisième code, et tout se branche sans retouche. Voir [[Travailler à plusieurs]].

**Tout le monde peut modifier cette note.** Ajouter un tag, un attribut ou un nom d'écran est libre : l'écrire ici pendant la tâche qui en a besoin. Renommer ou supprimer un nom déjà utilisé oblige à mettre à jour, dans la même tâche, le code, les objets de Studio et cette note. Les lignes marquées « prévu » ne sont pas encore lues par le code.

## Organisation de la place

```
Workspace
  Mondes
    Monde1            (un dossier par monde, tout ce qui est visible et solide)
      Spawn, Entrainement, Boutique, Piste, Bac, Decor, Anneaux, Portails
ReplicatedStorage
  Shared              (code, envoyé par Rojo)
  Assets
    Equipement        un Model par objet, nommé par son identifiant
    Compagnons        un Model par espèce
    Decor             modèles de décor prêts à cloner dans un monde (tribune_module)
    Oeufs
    Effets            particules et effets prêts à cloner
    Animations        objets Animation avec leur identifiant
ServerStorage
  Modeles             modèles en cours ou non utilisés
StarterGui            un ScreenGui par écran
SoundService
  Musique, Ambiance, Effets, Interface   (SoundGroup)
```

La map actuelle (`Workspace.Map`, voir [[Map]]) sera déplacée dans `Workspace.Mondes.Monde1` (tâche T-007).

## Tags de la map (posés dans Studio, lus par le code)

| Tag | Sur quoi | Attributs | État |
| --- | --- | --- | --- |
| `ZoneEntrainement` | Part au sol | `Stat` (Puissance, Vitesse, Aero), `Multiplicateur` (nombre), `RecordRequis` (m), `PasseRequis` (texte, facultatif) | prévu |
| `Piste` | Part de la piste d'élan | `Monde` (nombre) | prévu |
| `PlancheAppel` | Part de la planche | `Monde` | prévu |
| `Bac` | Parts de la zone d'atterrissage | `Monde` | prévu |
| `Anneau` | Part en forme d'anneau, sans collision | `Pieces` (nombre), `Poussee` (nombre) | prévu |
| `Stand` | Model d'un stand de boutique | `Famille` (Chaussures, Propulseur, Materiel, Ailes, Tenue) | prévu |
| `Incubateur` | Model | `Oeuf` (identifiant) | prévu |
| `Portail` | Model | `VersMonde` (nombre) | prévu |
| `Pantheon` | Model du lieu de changement de catégorie | aucun | prévu |
| `Podium` | Model avec trois Parts `Place1`, `Place2`, `Place3` | aucun | prévu |
| `PanneauClassement` | Part avec une surface d'affichage | `Classement` (identifiant) | prévu |
| `Courant` | Part sans collision (colonne d'air, monde 3) | `Force` | prévu |
| `Rebond` | Part (toit, monde 5) | `Force` | prévu |
| `PointApparition` | Part où réapparaît le joueur | `Monde` | prévu |
| `DecorAnime` | Part ou Model de décor animé par le client | `Type` (Rotation, Flottement, Balancement, Pulsation), `Vitesse`, `Amplitude` | prévu |
| `CanonConfettis` | Part d'où partent les confettis, le long de la piste | aucun | prévu |
| `LanceurFeuArtifice` | Part d'où part une fusée | `Palier` (0 à 5) | prévu |
| `Projecteur` | Model d'un projecteur de stade orientable | aucun | prévu |
| `EcranGeant` | Part avec une surface d'affichage | aucun | prévu |
| `Mascotte` | Model à squelette de la mascotte géante | aucun | prévu |
| `Vasque` | Model de la vasque, avec une Part `Flamme` | aucun | prévu |
| `DrapeauVent` | Model d'un drapeau qui se tend pendant le vent favorable | aucun | prévu |
| `BandePiste` | Parts lumineuses de la piste (saut doré) | aucun | prévu |
| `Public` | Model d'un bloc de spectateurs, pour la ola | `Rang` (ordre dans la vague) | prévu |

Les dix derniers tags viennent de [[Construction du monde 1]] : ce sont les points d'accroche du décor, que le code déclenchera sur les événements du jeu (record, saut parfait, vent favorable, saut doré, concours).

Règles : l'axe de la piste est X, le dessus des sols est à Y = 0, la planche d'appel du monde 1 reste à X = 120. Une Part interactive porte son tag sur elle-même, pas sur son dossier.

## Modèles (rangés dans Studio, utilisés par le code)

- **Équipement** : un Model nommé par l'identifiant de l'objet, avec une Part `Poignee` qui indique où l'attacher et un attribut `Attache` (PiedGauche, PiedDroit, Pieds, Dos, Torse). `Pieds` : le même modèle est cloné sur chaque pied, `Poignee` sous le pied, au centre du dessus de la semelle (`chaussures_ressorts`). `Poignee` est la `PrimaryPart` ; les meshes y sont soudés (`WeldConstraint`), sans collision. Une pièce mobile (`Helice`, `Aiguille`) porte l'attribut `AxeRotation` (Vector3, axe dans le repère du modèle) : le code la fait tourner autour de son pivot pendant la poussée.
- **Compagnon** : un Model nommé par l'identifiant de l'espèce, `PrimaryPart` défini, moins de 3 studs de haut, face vers -Z. Le pivot du modèle est au sol, entre les pattes ; les meshes sont soudés à la `PrimaryPart`, sans collision ni ancrage.
- **Décor** (`Assets.Decor`) : un Model nommé par son identifiant, ancré, pivot au sol. Les meshes n'ont pas de collision ; des Parts invisibles nommées `Collision` la portent.
- **Œuf** : un Model nommé par l'identifiant de l'œuf.
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
