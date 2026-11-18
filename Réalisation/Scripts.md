# Scripts

Où se trouve le code aujourd'hui, et ce qu'il fait. Voir [[Projet]] et, pour les règles, [[Architecture du code]].

Tout le code vit dans `src/` et Rojo l'envoie dans Studio (`default.project.json`, projet partiel : la map, `Assets` et `Remotes` ne sont jamais touchés). Ne jamais modifier un script dans Studio. Migration dans le dépôt : T-004 ; découpage en modules : T-005 (2026-11-15), sans changement de comportement.

## Organisation

| Dépôt | Dans Studio | Contenu |
| --- | --- | --- |
| `src/shared/Config/` | `ReplicatedStorage.Shared.Config` | Une table par sujet : `Saut` (distances, retour, pièces par mètre), `Stats` (vitesses, entraînement, formules), `Equipement` (objets de la boutique), `Sons`, `Camera`, `Textes` (tous les textes affichés) |
| `src/shared/Remotes.luau` | `ReplicatedStorage.Shared.Remotes` | Liste unique des événements réseau ; le serveur les crée dans `ReplicatedStorage.Remotes`, le client les attend |
| `src/server/init.server.luau` | `ServerScriptService.Server` | Démarre les services dans l'ordre |
| `src/shared/Util/Apparence.luau` | `Shared.Util.Apparence` | `appliquerVersion(modele, version)` : couleurs, matière et médaille des versions Argent et Or |
| `src/server/Services/` | `Server.Services` | `Donnees` (chargement, leaderstats, attributs, sauvegarde), `Personnage` (réglage à l'apparition, objets portés, flammes, traînées), `Index` (album, pages, gemmes et chance), `Compagnons` (inventaire, équipe, bonus, expérience, fusion), `Oeufs` (achat, tirage, éclosion, prompt « Ouvrir » sur chaque `Incubateur` tagué du Workspace, `PolicyService`), `Stats` (vitesse et saut sur la piste), `Entrainement` (zones, × Coachs), `Anneaux` (pièces des anneaux tagués, série), `Saut` (mesure, jugement de l'appel, sauts rares tirés au passage de la planche, × Trésoriers, × saut rare, expérience, effets d'atterrissage, flammes du jetpack ; `Saut.forcerProchain(player, "Dore")` pour les tests), `Boutique` (stands) |
| `src/client/init.client.luau` | `StarterPlayerScripts.Client` | Démarre les contrôleurs |
| `src/client/Controleurs/` | `Client.Controleurs` | `Audio` (son des pièces), `Hud` (écran provisoire créé par le code, à remplacer par T-108/T-109), `Saut` (appel : qualité au décollage, × vitesse verticale ; jetpack, champ de vision, distance en direct), `Compagnons` (affiche les compagnons équipés de chaque joueur, qui suivent en bondissant et sautent avec lui ; dossier local `Workspace.CompagnonsVisibles`) |

Chaque module expose `demarrer()` ; les autres fonctions publiques : `Donnees.estCharge(player)`, `Donnees.donnees(player)` (profil à modifier directement), `Donnees.auChargement(fn)`, `Compagnons.ajouter(player, espece, version?)`, `.retirer`, `.equiper(player, uid, oui)`, `.equiperMeilleurs`, `.multiplicateur(player, role)`, `.gagnerExperience`, `.inventairePlein`, côté joueur `Compagnons.etat()`, `Personnage.equiperVisuels(player)`, `Personnage.activerJetpack(char, actif)`, `Personnage.majTrainees(player, char, surPiste)`, `Hud.majCarburant(fraction)`, `Hud.distanceEnDirect(x)`, `Audio.pieces()`.

Les valeurs de rebirth et de pets (cubes de couleur) de l'ancien `Config` n'étaient branchées nulle part : supprimées à T-005 (historique git). Les vraies viendront avec [[Compagnons]] et [[Rebirth et talents]].

## Événements réseau (`Remotes.luau`)

- `SautResultat`, serveur vers joueur : distance, pièces gagnées, record, saut rare (`Dore`, `Legendaire` ou rien), qualité de l'appel (`Parfait`, `Bon`, `Correct`, `Mordu` ou rien).
- `Appel`, joueur vers serveur : position X au décollage, vérifiée par le serveur (T-101). Réglages dans `Config/Saut` (`APPEL_QUALITES`, `APPEL_MORDU`, `APPEL_MORDU_MAX`, marges, `APPEL_VALIDITE`).
- `AnneauTraverse`, serveur vers joueur : pièces de l'anneau, nombre d'anneaux de la série. La poussée est appliquée par le contrôleur `Saut` du joueur.
- Attribut `SautRare` sur le Player : le saut rare tiré pour le saut en cours (vide sinon).
- Attribut `Appel` sur le Player : qualité de l'appel du saut en cours (vide sinon). Attribut `BonusZoneParfait` (mètres) : élargit la zone Parfait ; à poser par les talents (T-402), lu dès maintenant.
- `Notif`, serveur vers joueur : message de la boutique.
- `JetpackEtat`, joueur vers serveur : vrai quand la poussée démarre, faux quand elle s'arrête. Le serveur allume alors les flammes pour que tout le monde les voie.
- `CompagnonsEtat`, serveur vers joueur : inventaire complet (`liste`, `equipes`, `emplacements`, `inventaireMax`), à chaque changement.
- `EquiperCompagnon` (uid, oui/non) et `EquiperMeilleurs`, joueur vers serveur : vérifiés et limités à une demande toutes les 0,2 s.
- `OuvrirOeuf` (oeufId), joueur vers serveur, une demande toutes les 0,5 s ; `ResultatOeuf` ({oeuf, espece, version, uid, nouveau}), serveur vers joueur, pour l'animation d'éclosion (T-305).
- `Fusionner` (espece, version), joueur vers serveur ; `IndexEtat` ({trouves, pages, chance}), serveur vers joueur.

Attributs du Player ajoutés : `Gemmes` (recopié dans la sauvegarde), `TiragesPayantsInterdits`. Sauvegarde : `gemmes`, `index`, `oeufsOuverts`, `compagnons`.

Attribut `Equipe` sur chaque Player (« espece:version,… ») : les compagnons équipés, lus par tous les clients pour les afficher.

Les effets visuels et les sons sont décrits dans [[Décor et effets]].

## Données d'un joueur

- `leaderstats` : `Pièces` et `Record (m)`.
- Attributs sur le Player : `Puissance`, `Vitesse`, `Record`, `Chaussures`, `Jetpack`.
- **Sauvegarde (T-006)** : bibliothèque **ProfileStore** (Wally, `lm-loleris/profilestore@1.0.3`, dans `ServerStorage.ServerPackages`). Magasin `SautEnLongueur_Profils`, clé `joueur_<UserId>`, verrou de session et sauvegarde automatique. Forme des données et numéro de version dans `Config/Donnees` : `version`, `repriseV1`, `pieces`, `record`, `stats {Puissance, Vitesse}`, `equipement.possede {id = niveau}`. Les autres services ne touchent pas au profil : ils changent les leaderstats et les attributs, et `Donnees` les recopie dans le profil à chaque changement.
- Changer la forme des données : ajouter la clé dans `Config/Donnees.MODELE` (remplie seule chez les anciens joueurs) ; si une donnée change de sens, monter `VERSION` et écrire la migration dans `MIGRATIONS` du service.
- Si le profil ne se charge pas (autre serveur, Roblox injoignable), le joueur est renvoyé avec un message plutôt que de jouer sans sauvegarde.
- Reprise de l'ancien magasin `SautEnLongueur_v1` à la première connexion. Les sauvegardes Roblox sont propres à chaque expérience : l'ancienne place (compte de Loucas2103) avait ses données à part, la reprise ne trouvera donc rien dans l'expérience du groupe ; elle reste sans risque.
- Testé le 2026-11-15 sur la place du groupe (Studio, accès API activé) : pièces, record, Puissance et chaussures retrouvés après avoir quitté puis relancé. Le profil de Loucas2103 garde ces valeurs de test.

## Points à connaître

- La map est encore lue par ses noms (`Map.Sable`, `Map.Entrainement.ZoneSquat`, `Map.Boutique.Stand<objet>`) : T-008 passera aux tags.
- La distance est calculée par le serveur à partir de la position du personnage au moment où il touche le sable. Le client n'envoie jamais de distance.
- Le jetpack est piloté côté client (il modifie la vitesse verticale du personnage). Un tricheur pourrait en abuser, il n'y a pas de contrôle serveur pour l'instant.
- La sauvegarde utilise le DataStore `SautEnLongueur_v1`. Si le chargement échoue, le joueur n'est pas sauvegardé, pour ne pas écraser ses données.
