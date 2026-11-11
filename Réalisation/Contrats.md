# Contrats

Les noms, tags et attributs sur lesquels les trois postes s'accordent. C'est ce qui permet de travailler en même temps : le Poste 2 construit la map, le Poste 3 construit les écrans, le Poste 1 code, et tout se branche sans retouche. Voir [[Travailler à plusieurs]].

**Seul le Poste 1 modifie cette note.** Pour ajouter un tag, un attribut ou un nom d'écran, déposer une demande. Les lignes marquées « prévu » ne sont pas encore lues par le code.

## Organisation de la place

```
Workspace
  Mondes
    Monde1            (un dossier par monde, tout ce qui est visible et solide)
      Spawn, Entrainement, Boutique, Piste, Bac, Decor, Anneaux, Portails
ReplicatedStorage
  Shared              (code, Poste 1)
  Assets              (Poste 2)
    Equipement        un Model par objet, nommé par son identifiant
    Compagnons        un Model par espèce
    Oeufs
    Effets            particules et effets prêts à cloner (Poste 3)
    Animations        objets Animation avec leur identifiant
ServerStorage
  Modeles             modèles en cours ou non utilisés (Poste 2)
StarterGui            un ScreenGui par écran (Poste 3)
SoundService
  Musique, Ambiance, Effets, Interface   (SoundGroup, Poste 3)
```

La map actuelle (`Workspace.Map`, voir [[Map]]) sera déplacée dans `Workspace.Mondes.Monde1` par le Poste 2 (tâche T-007).

## Tags de la map (Poste 2 pose, Poste 1 lit)

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

## Modèles (Poste 2 livre, Poste 1 utilise)

- **Équipement** : un Model nommé par l'identifiant de l'objet, avec une Part `Poignee` qui indique où l'attacher et un attribut `Attache` (PiedGauche, PiedDroit, Dos, Torse).
- **Compagnon** : un Model nommé par l'identifiant de l'espèce, `PrimaryPart` défini, moins de 3 studs de haut, face vers -Z.
- **Œuf** : un Model nommé par l'identifiant de l'œuf.
- Les identifiants sont ceux des modules de configuration. Le Poste 1 en publie la liste dans [[Registre des modèles]] avant que le Poste 2 commence.

## Interface (Poste 3 construit, Poste 1 branche)

- Un `ScreenGui` par écran, nommé comme dans [[HUD]] (par exemple `HudPrincipal`, `EcranBoutique`).
- Dans chaque écran, les éléments que le code doit lire ou modifier portent un nom fixé par la note [[HUD]] : `TextePieces`, `BoutonFermer`, `ListeObjets`, `ModeleLigne`.
- Les éléments purement décoratifs sont nommés librement.
- Une ligne de liste (un objet de boutique, un compagnon) est construite une fois, nommée `ModeleLigne`, et laissée invisible : le code la clone.
- Aucun `LocalScript` dans `StarterGui`.

## Sons (Poste 3 livre, Poste 1 utilise)

Chaque son a un identifiant texte (`saut_appel_parfait`) listé dans [[Sons et musique]]. Le Poste 3 inscrit l'identifiant d'asset correspondant dans [[Registre des sons]] ; le Poste 1 le reporte dans `Config/Sons`.

## Comment avancer sans s'attendre

1. Au début de chaque phase, le Poste 1 complète cette note et les listes d'identifiants.
2. Les Postes 2 et 3 construisent à partir de la note. Le Poste 1 code avec des objets provisoires portant les mêmes noms.
3. Quand un élément est livré, il remplace le provisoire sans changement de code.
