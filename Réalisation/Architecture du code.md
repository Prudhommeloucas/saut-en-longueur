# Architecture du code

Organisation cible du code. Seul le Poste 1 écrit du code ([[Équipe]]). L'existant, trois scripts dans Studio, est décrit dans [[Scripts]] ; il sera migré vers cette organisation ([[Déroulé du développement]], tâches T-004 et T-005).

## Principe : le code vit dans le dépôt

- Les scripts sont des fichiers `.luau` dans `src/`, versionnés par git.
- **Rojo** les envoie dans Studio. Seul le Poste 1 lance Rojo ; les deux autres postes reçoivent les scripts par Team Create, comme n'importe quel objet de la place.
- Rojo ne gère que les dossiers de code. La map, les interfaces et les sons restent construits dans Studio et ne sont jamais écrasés (projet Rojo partiel).
- Outils de qualité : **Selene** (détection d'erreurs), **StyLua** (mise en forme), **Wally** (bibliothèques). Versions fixées par **Rokit** dans `rokit.toml` ([[Outils]]).

## Arborescence

```
src/
  shared/            -> ReplicatedStorage.Shared
    Config/          une table par sujet : Stats, Mondes, Equipement, Compagnons,
                     Oeufs, Talents, Quetes, Paliers, Boutique, Sons, Textes
    Util/            Format (grands nombres), Signal, Table, Tags
    Remotes.luau     liste unique de tous les événements réseau
  server/            -> ServerScriptService.Server
    Services/        un module par système
    init.server.luau démarre les services dans l'ordre
  client/            -> StarterPlayer.StarterPlayerScripts.Client
    Controleurs/     un module par système côté joueur
    init.client.luau
```

## Services (serveur)

| Service | Rôle |
| --- | --- |
| Donnees | Chargement, sauvegarde, verrou de session, migrations de schéma |
| Stats | Calcul des capacités à partir des stats, de l'équipement et des bonus |
| Entrainement | Zones, rythme, matériel, gains hors ligne |
| Saut | Appel, vol, réception, distance, sauts rares, borne de plausibilité |
| Boutique | Achat et niveaux de l'équipement |
| Compagnons | Inventaire, équipement, éclosion, fusion, expérience, index |
| Categorie | Rebirth, médailles, talents |
| Mondes | Portails, téléportation, physique propre à chaque monde |
| Quetes | Quêtes, défis, paliers, connexion, cadeaux, roue, codes |
| Classements | Classements mondiaux et de serveur |
| Evenements | Concours, vent favorable, annonces |
| Monetisation | Passes, produits, reçus, boosts, règles par pays |
| Mesures | Entonnoirs et événements d'économie |

Côté client, les contrôleurs correspondants : Hud, Saut, Entrainement, Boutique, Compagnons, Categorie, Mondes, Quetes, Classements, Evenements, Audio, Effets, Tutoriel, Reglages.

## Règles

1. **Le serveur décide.** Distances, gains, achats, tirages : tout est calculé côté serveur. Le client envoie des intentions et affiche des résultats.
2. **Tout nombre d'équilibrage est dans `Config/`.** Un système ne contient aucune valeur en dur.
3. **La map se décrit par des tags et des attributs** ([[Contrats]]). Le code ne connaît pas le nom ni la position des zones : il lit les objets marqués. Le Poste 2 peut donc ajouter une zone, un anneau ou un portail sans code.
4. **L'interface est construite dans Studio** par le Poste 3 et le code s'y branche par les noms fixés dans [[Contrats]]. Le code ne crée pas d'écran.
5. **Un seul point d'entrée réseau** : `Remotes.luau`. Chaque événement venant du client est vérifié (types, bornes) et limité en fréquence.
6. **Identifiants stables.** Objets, compagnons, talents et quêtes ont un identifiant texte qui ne change jamais, même si le nom affiché change. Les sauvegardes ne stockent que ces identifiants.
7. **Textes centralisés** dans `Config/Textes`, en français, pour permettre la traduction ([[Lancement]]).

## Données d'un joueur

Sauvegarde par la bibliothèque **ProfileStore** (verrou de session, sauvegarde automatique, reprise après erreur), dans un magasin versionné.

```
version, stats {Puissance, Vitesse, Aero}, pieces, gemmes, medailles,
categorie, talents {id = niveau}, equipement {possede = {id = niveau}, porte = {famille = id}},
compagnons {liste, equipes}, index, mondes {ouverts, records}, quetes, paliers,
connexion {serie, dernierJour}, cadeaux, boosts, passes, recusTraites,
reglages, tutoriel, statistiques (totaux pour les défis), derniereConnexion
```

- Chaque changement de forme ajoute une migration numérotée. Les données de la version actuelle (`SautEnLongueur_v1`) seront migrées, pas perdues.
- Les achats en Robux ne sont confirmés qu'après une sauvegarde réussie ([[Monétisation]]).

## Tests

- Vérification statique à chaque tâche : Selene et StyLua.
- Test en jeu par le MCP Roblox Studio : lancer une partie, lire la sortie, vérifier la liste de contrôle de la tâche.
- Simulation d'équilibrage ([[Économie]]).
- Avant chaque publication : une partie complète avec un compte neuf, sur téléphone ([[Lancement]]).

## Sécurité

- Borne de plausibilité sur chaque saut ([[Saut]]).
- Aucune confiance dans les valeurs envoyées par le client.
- Limite de fréquence par joueur sur tous les événements.
- Journal des anomalies envoyé aux mesures, sans exclusion automatique au début.
