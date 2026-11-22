# HUD

Tous les écrans du jeu. Ils se construisent dans `StarterGui` et le code s'y branche par leurs noms ([[Contrats]]). Le style est décrit dans [[Direction artistique]].

## Règles communes

- Pensé d'abord pour le téléphone en paysage : boutons d'au moins 44 points, rien sous les pouces au centre, rien dans les marges de l'écran (encoche, boutons Roblox en haut à gauche).
- Mise à l'échelle automatique (`UIScale`, tailles relatives), testée avec les tailles d'écran de l'émulateur de Studio : téléphone, tablette, ordinateur, console.
- Un seul écran de menu ouvert à la fois. Chaque écran a un `BoutonFermer`.
- Jouable à la manette : chaque écran définit l'élément sélectionné à l'ouverture.
- Les nombres passent par le format abrégé ([[Économie]]).

## Écrans permanents

### `HudPrincipal`

| Zone | Contenu | Noms |
| --- | --- | --- |
| Haut gauche | Pièces, gemmes, médailles | `TextePieces`, `TexteGemmes`, `TexteMedailles` |
| Sous les monnaies | Stats et leur effet | `TextePuissance`, `TexteVitesse`, `TexteAero` |
| Haut centre | Record du monde en cours, prochain palier et sa barre | `TexteRecord`, `BarrePalier`, `TextePalier` |
| Gauche | Boosts actifs avec leur durée, série de sauts parfaits | `ListeBoosts`, `TexteSerie` |
| Droite | Boutons de menu : Boutique, Compagnons, Catégorie, Quêtes, Classements, Mondes, Robux, Réglages | `BoutonBoutique`, etc. |
| Bas gauche | Cadeau de temps de jeu (compte à rebours), récompense du jour, invitation | `BoutonCadeau`, `BoutonJour`, `BoutonInviter` |
| Haut, sous le record | Bandeau d'annonce (concours, vent favorable, saut légendaire) | `Bandeau` |

Chaque bouton de menu porte une pastille rouge quand quelque chose est à réclamer.

### `HudSaut` (visible sur la piste et en vol)

- `JaugeAppel` : barre qui se remplit pendant la course, avec les zones Bon et Parfait. Version provisoire créée par le code depuis T-101 (`Hud.luau`, dans `HUDSaut`, avec `TexteQualite`) : de 8 m avant le bord à 1 m après, zones `Correct`, `Bon`, `Parfait` (élargie par `BonusZoneParfait`), `Mordu`, et un `Curseur`.
- `TexteQualite` : « Parfait ! », « Bon », « Mordu » au moment de l'appel.
- `TexteDistance` : compteur en direct pendant le vol, en grand.
- `JaugeCarburant`, `BoutonPlaner` (monde 2), `TexteAnneaux`.
- `IndiceReception` : cercle qui se referme avant le contact. Version provisoire créée par le code depuis T-103 (`Hud.luau`) : un anneau se referme pendant les 1,2 dernières secondes de la descente sur une cible `Cible` de 60 px. Il devient vert dans la fenêtre de réception, puis gris une fois l'essai fait. Le texte de série (`TexteSerie`, « Série × 3 ») est aussi provisoire, sous le panneau des stats.

### `HudEntrainement` (visible dans une zone)

- `CibleRythme` : le cercle qui se referme ; `TexteCombo` ; `TexteGain` (gain par seconde).

### `PanneauResultat`

Distance, détail des pièces ligne par ligne, mention « Nouveau record », bouton `BoutonRejouer`. Se ferme seul après 2 secondes.

## Écrans de menu

| Écran | Contenu |
| --- | --- |
| `EcranBoutique` | Onglets par famille, liste des objets, prix, bouton acheter ou améliorer, aperçu 3D |
| `EcranCompagnons` | Inventaire en grille, équipe, « Équiper les meilleurs », fusion, suppression, onglet Index |
| `EcranOeuf` | Contenu de l'œuf et chances, boutons ouvrir × 1, × 3, automatique |
| `EcranEclosion` | Animation plein écran de l'éclosion, rareté obtenue |
| `EcranCategorie` | Catégorie actuelle et suivante, condition, ce qu'on garde et ce qu'on perd, gains, bouton de confirmation |
| `EcranTalents` | Arbre en quatre branches, médailles disponibles, détail d'un talent |
| `EcranQuetes` | Onglets Jour, Semaine, Carrière ; barres de progression ; boutons réclamer |
| `EcranPaliers` | Échelle des paliers de record du monde en cours |
| `EcranClassements` | Onglets par classement, dix premiers, position du joueur |
| `EcranMondes` | Carte des six mondes, conditions d'accès, téléportation |
| `EcranRobux` | Passes, gemmes, boosts, offres ; achat par le système de Roblox |
| `EcranJour` | Calendrier des 7 jours |
| `EcranRoue` | Roue quotidienne |
| `EcranReglages` | Volumes musique et effets, graphismes réduits, cacher les compagnons des autres, saisie d'un code |
| `EcranConcours` | Compte à rebours, classement en direct, résultat |
| `EcranOffre` | Pack de départ et offres ponctuelles |

## Éléments transverses

- `Notifications` : messages courts en bas de l'écran (achat, récompense, erreur).
- `Guide` : flèche et phrase du tutoriel ([[Premières minutes]]).
- Au-dessus de chaque joueur : nom, catégorie, record (interface attachée au personnage).
- Dans le monde : prix et nom au-dessus des stands, condition au-dessus des portails et des zones verrouillées.

## Méthode de travail

1. Maquette de chaque écran avec [[Claude Design]], aux tailles réelles, validée par l'équipe avant construction. La disposition et le style proposés dans cette note sont libres ; seuls les noms des éléments lus par le code sont fixés ([[Liberté de création]]).
2. Construction dans Studio avec les noms de cette note.
3. Capture d'écran sur trois tailles d'écran, jointe à la tâche.
4. Le code branche l'écran, dans la même tâche ou dans la tâche de branchement. Un nom manquant s'ajoute ici et dans [[Contrats]].

## Maquettes faites

- T-305 (2026-11-15) : `EcranCompagnons`, `EcranOeuf`, `EcranEclosion`, téléphone en paysage 844 × 390, sur la toile Claude Design « Écrans compagnons et œufs » : https://claude.ai/artifact/CFbWGuXQHbfNhZMj2WS4JH (privée tant que Loucas ne l'a pas partagée). Noms des éléments lus par le code notés sur la toile. Validées par Loucas le 2026-11-15.

- T-009 (2026-11-22) : `HudPrincipal`, `HudSaut`, `PanneauResultat` et `EcranBoutique`, téléphone en paysage 844 × 390, sur la toile Claude Design « Écrans du saut et de la boutique » : https://claude.ai/artifact/7nUpN2bvo55dk2sCZyGHth (privée tant que Loucas ne l'a pas partagée). Les noms lus par le code sont notés à droite de chaque écran.
  - Ajouts par rapport aux listes de cette note : `ListeDetail` (lignes `TexteNom` et `TexteValeur`) et `TexteTotal` dans `PanneauResultat`. Dans `EcranBoutique` : un onglet par famille (`OngletChaussures`, `OngletPropulseur`, `OngletTenue`, `OngletMateriel`), des lignes `ListeObjets.ModeleLigne` (`Pastille`, `TexteNom`, `TexteEffet`, `Niveau`, `TextePrix`, `BoutonAction`), et `VueObjet`, `TexteDetail`, `BoutonPrincipal`.
  - Le bouton d'une ligne de la boutique prend l'état Acheter, Améliorer, Porter, Porté ou Trop cher (événements `AcheterObjet`, `AmeliorerObjet`, `PorterObjet`, état par `EquipementEtat`).
  - En attente de validation par Loucas, puis par P1 et P3 (condition de fin de T-009).

## Écrans construits

- **T-305 (2026-11-15)** : `EcranCompagnons`, `EcranOeuf`, `EcranEclosion` dans `StarterGui`, construits d'après les maquettes, branchés par `src/client/Controleurs/EcranCompagnons|EcranOeuf|EcranEclosion.luau` et `src/client/Interface.luau`.
  - Chaque menu a une `Fenetre` de 724 × 354 (œuf : 544 × 354) avec un `UIScale` nommé `Echelle`, réglé par le code selon la taille de l'écran (base 844 × 390, de 0,5 à 1,5). Un seul menu ouvert à la fois ; à la manette, le bouton principal est sélectionné à l'ouverture.
  - `EcranCompagnons` : `OngletCompagnons`, `OngletIndex`, `TexteInventaire`, `BoutonFermer`, `PageCompagnons` (`TexteEquipe`, `ListeEquipe.ModeleLigne`, `TexteBonus`, `ListeCompagnons.ModeleLigne` avec `Pastille.Lettre`, `TexteNiveau`, `Badge`, `BoutonFusionner` qui fusionne tous les trios, `BoutonMeilleurs`), `PageIndex` (`TexteIndex`, `ListeIndex.ModeleLigne` avec `PointNormal`, `PointArgent`, `PointOr`). Toucher une carte équipe ou retire.
  - `EcranOeuf` : `VueOeuf` (le modèle de l'œuf), `TexteNomOeuf`, `ListeChances.ModeleLigne` (`Pastille`, `TexteNom`, `TexteRarete`, `Barre.Remplissage`, `TextePourcent`), `TextePrix`, `TexteInterdit`, `BoutonOuvrir1`, `BoutonOuvrir3` et `BoutonAuto` (inactifs : passes à venir). S'ouvre par le prompt « Ouvrir » d'un incubateur : les chances sont toujours vues avant l'achat.
  - `EcranEclosion` : `Fond.Degrade` (lueur de la couleur de la rareté), `Contenu` (`Echelle`, `TexteNouveau`, `Vue`, `TexteEspece`, `TexteRarete`, `BoutonContinuer`). L'œuf tremble, sa moitié `Haut` s'envole avec ses décors, le compagnon apparaît ; Continuer revient à l'œuf.
  - `BoutonsProvisoires.BoutonCompagnons` (bas droite) ouvre l'écran des compagnons, **à retirer quand `HudPrincipal` existera (T-109)**.
  - Pastilles de couleur à la place des icônes, en attendant les rendus de T-306 (`Config/Compagnons.ESPECES[...].couleur`).
  - Testé dans la copie sur un écran d'ordinateur (achat par le prompt et le bouton, éclosion, équipe, bonus, fusion, index) : captures `assets/captures/ecran_oeuf.jpg`, `ecran_eclosion.jpg`, `ecran_compagnons.jpg`, `ecran_index.jpg`. Pas encore vérifié avec l'émulateur téléphone et tablette.
