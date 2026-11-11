# Scripts

Où se trouve le code dans Roblox Studio. Voir [[Projet]].

| Script | Emplacement | Rôle |
| --- | --- | --- |
| `Config` | `ReplicatedStorage` | Toutes les valeurs d'équilibrage et les formules. C'est ici qu'on change un prix ou un gain. |
| `JeuSaut` | `ServerScriptService` | Données des joueurs, entraînement, mesure du saut, boutique, sauvegarde. |
| `ClientSaut` | `StarterPlayer.StarterPlayerScripts` | Affichage à l'écran et pilotage du jetpack. |

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
