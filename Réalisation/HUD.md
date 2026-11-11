# HUD

Tous les écrans du jeu. Le Poste 3 les construit dans `StarterGui`, le Poste 1 les branche ([[Contrats]]). Le style est décrit dans [[Direction artistique]].

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

- `JaugeAppel` : barre qui se remplit pendant la course, avec les zones Bon et Parfait.
- `TexteQualite` : « Parfait ! », « Bon », « Mordu » au moment de l'appel.
- `TexteDistance` : compteur en direct pendant le vol, en grand.
- `JaugeCarburant`, `BoutonPlaner` (monde 2), `TexteAnneaux`.
- `IndiceReception` : cercle qui se referme avant le contact.

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
4. Le Poste 1 branche l'écran. Tout nom manquant passe par une demande.
