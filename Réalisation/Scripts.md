# Scripts

Où se trouve le code aujourd'hui, et ce qu'il fait. Voir [[Projet]] et, pour les règles, [[Architecture du code]].

Tout le code vit dans `src/` et Rojo l'envoie dans Studio (`default.project.json`, projet partiel : la map, `Assets` et `Remotes` ne sont jamais touchés). Ne jamais modifier un script dans Studio. Migration dans le dépôt : T-004 ; découpage en modules : T-005 (2026-11-15), sans changement de comportement.

## Organisation

| Dépôt | Dans Studio | Contenu |
| --- | --- | --- |
| `src/shared/Config/` | `ReplicatedStorage.Shared.Config` | Une table par sujet : `Saut` (distances, retour, pièces par mètre), `Stats` (vitesses, entraînement, formules), `Equipement` (objets de la boutique), `Sons`, `Camera`, `Textes` (tous les textes affichés) |
| `src/shared/Remotes.luau` | `ReplicatedStorage.Shared.Remotes` | Liste unique des événements réseau ; le serveur les crée dans `ReplicatedStorage.Remotes`, le client les attend |
| `src/server/init.server.luau` | `ServerScriptService.Server` | Démarre les services dans l'ordre |
| `src/server/Services/` | `Server.Services` | `Donnees` (chargement, leaderstats, attributs, sauvegarde), `Personnage` (réglage à l'apparition, objets portés, flammes, traînées), `Stats` (vitesse et saut sur la piste), `Entrainement` (zones), `Saut` (mesure, effets d'atterrissage, flammes du jetpack), `Boutique` (stands) |
| `src/client/init.client.luau` | `StarterPlayerScripts.Client` | Démarre les contrôleurs |
| `src/client/Controleurs/` | `Client.Controleurs` | `Audio` (son des pièces), `Hud` (écran provisoire créé par le code, à remplacer par T-108/T-109), `Saut` (jetpack, champ de vision, distance en direct) |

Chaque module expose `demarrer()` ; les autres fonctions publiques : `Donnees.estCharge(player)`, `Personnage.equiperVisuels(player)`, `Personnage.activerJetpack(char, actif)`, `Personnage.majTrainees(player, char, surPiste)`, `Hud.majCarburant(fraction)`, `Hud.distanceEnDirect(x)`, `Audio.pieces()`.

Les valeurs de rebirth et de pets (cubes de couleur) de l'ancien `Config` n'étaient branchées nulle part : supprimées à T-005 (historique git). Les vraies viendront avec [[Compagnons]] et [[Rebirth et talents]].

## Événements réseau (`Remotes.luau`)

- `SautResultat`, serveur vers joueur : distance, pièces gagnées, record.
- `Notif`, serveur vers joueur : message de la boutique.
- `JetpackEtat`, joueur vers serveur : vrai quand la poussée démarre, faux quand elle s'arrête. Le serveur allume alors les flammes pour que tout le monde les voie.

Les effets visuels et les sons sont décrits dans [[Décor et effets]].

## Données d'un joueur

- `leaderstats` : `Pièces` et `Record (m)`.
- Attributs sur le Player : `Puissance`, `Vitesse`, `Record`, `Chaussures`, `Jetpack`.

## Points à connaître

- La map est encore lue par ses noms (`Map.Sable`, `Map.Entrainement.ZoneSquat`, `Map.Boutique.Stand<objet>`) : T-008 passera aux tags.
- La distance est calculée par le serveur à partir de la position du personnage au moment où il touche le sable. Le client n'envoie jamais de distance.
- Le jetpack est piloté côté client (il modifie la vitesse verticale du personnage). Un tricheur pourrait en abuser, il n'y a pas de contrôle serveur pour l'instant.
- La sauvegarde utilise le DataStore `SautEnLongueur_v1`. Si le chargement échoue, le joueur n'est pas sauvegardé, pour ne pas écraser ses données.
