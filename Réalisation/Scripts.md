# Scripts

Où se trouve le code aujourd'hui. Voir [[Projet]]. L'organisation visée (services, contrôleurs, `Config/`) est dans [[Architecture du code]] ; le découpage est la tâche T-005.

**Depuis T-004 (2026-11-15), les trois scripts vivent dans le dépôt** et Rojo les envoie dans Studio (`default.project.json`, projet partiel : seuls ces trois scripts sont gérés, la map, `Assets` et `Remotes` ne sont jamais touchés). Ne plus les modifier dans Studio.

| Script | Fichier du dépôt | Emplacement dans Studio | Rôle |
| --- | --- | --- | --- |
| `Config` | `src/shared/Config.luau` | `ReplicatedStorage` | Toutes les valeurs d'équilibrage et les formules. C'est ici qu'on change un prix ou un gain. |
| `JeuSaut` | `src/server/JeuSaut.server.luau` | `ServerScriptService` | Données des joueurs, entraînement, mesure du saut, boutique, sauvegarde. |
| `ClientSaut` | `src/client/ClientSaut.client.luau` | `StarterPlayer.StarterPlayerScripts` | Affichage à l'écran et pilotage du jetpack. |

Migration à l'identique (sources comparées octet par octet), puis mise en forme StyLua. Selene : aucune erreur, cinq avertissements de style (`UDim2.new` simplifiable dans `ClientSaut`), laissés pour T-005. `Config` contient aussi des valeurs de rebirth et de pets (cubes de couleur) d'un ancien prototype, non branchées : T-005 les remplacera.

`ReplicatedStorage.Remotes` contient trois RemoteEvent :

- `SautResultat`, serveur vers joueur : distance, pièces gagnées, record.
- `Notif`, serveur vers joueur : message de la boutique.
- `JetpackEtat`, joueur vers serveur : vrai quand la poussée démarre, faux quand elle s'arrête. Le serveur allume alors les flammes pour que tout le monde les voie.

Les effets visuels et les sons sont décrits dans [[Décor et effets]].

## Données d'un joueur

- `leaderstats` : `Pièces` et `Record (m)`.
- Attributs sur le Player : `Puissance`, `Vitesse`, `Record`, `Chaussures`, `Jetpack`.

## Points à connaître

- La distance est calculée par le serveur à partir de la position du personnage au moment où il touche le sable. Le client n'envoie jamais de distance.
- Le jetpack est piloté côté client (il modifie la vitesse verticale du personnage). Un tricheur pourrait en abuser, il n'y a pas de contrôle serveur pour l'instant.
- La sauvegarde utilise le DataStore `SautEnLongueur_v1`. Si le chargement échoue, le joueur n'est pas sauvegardé, pour ne pas écraser ses données.
