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

Règles : l'axe de la piste est X, le dessus des sols est à Y = 0, la planche d'appel du monde 1 reste à X = 120. Une Part interactive porte son tag sur elle-même, pas sur son dossier.

## Modèles (rangés dans Studio, utilisés par le code)

- **Équipement** : un Model nommé par l'identifiant de l'objet, avec une Part `Poignee` qui indique où l'attacher et un attribut `Attache` (PiedGauche, PiedDroit, Dos, Torse).
- **Compagnon** : un Model nommé par l'identifiant de l'espèce, `PrimaryPart` défini, moins de 3 studs de haut, face vers -Z.
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
