# Déroulé du développement

Le plan du projet, tâche par tâche, pour les trois postes. Voir [[Équipe]] pour les rôles, [[Travailler à plusieurs]] pour les règles, [[Tableau de bord]] pour l'avancement.

## Comment lire ce document

- Chaque tâche a un numéro (`T-105`), un poste, une taille et une condition de fin.
- **Taille** : P = une session, M = deux ou trois sessions, G = davantage (à découper en cours de route).
- **Dépend de** : la tâche ne peut pas commencer avant. Tout le reste peut se faire en parallèle.
- **Humain** : un geste que Claude ne peut pas faire seul (compte Roblox, validation, import).
- L'avancement se coche dans le fichier de suivi de chaque poste, pas ici. Seul le Poste 1 modifie ce document.
- Une tâche dit **quoi livrer**, pas comment. La forme, le style et les détails appartiennent à celui qui la fait ([[Liberté de création]]). Une idée qui change le plan se dépose dans `Idées/` et peut ajouter, retirer ou déplacer des tâches.
- Dans une phase, les trois postes avancent en même temps : les Postes 2 et 3 construisent d'après les [[Contrats]], le Poste 1 code avec des objets provisoires, puis une tâche de branchement réunit le tout.

## Vue d'ensemble

| Phase | But | Fin de phase quand |
| --- | --- | --- |
| 0. Fondations | Tout le monde peut travailler ; le jeu existant tourne sur les nouvelles bases | Les trois postes ont livré une première pièce par la chaîne complète |
| 1. Le saut | Le saut en trois temps est amusant à lui seul | On a envie de refaire un saut sans aucune récompense |
| 2. Progression | Entraînement, équipement, quêtes : une première heure complète | Un compte neuf joue une heure sans s'ennuyer ni bloquer |
| 3. Compagnons | Œufs, fusion, index | On a envie d'ouvrir « encore un œuf » |
| 4. Long terme | Catégories, talents, monde 2 | Le jeu tient 10 heures |
| 5. Social | Classements, concours, podium | Un serveur à plusieurs est plus amusant que seul |
| 6. Monétisation | Passes, produits, offres | Tous les achats fonctionnent en mode test |
| 7. Lancement | Tutoriel, finition, bêta, ouverture | Le jeu est public |
| 8. Après la sortie | Mises à jour régulières | Sans fin |

## Phase 0 — Fondations

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-001 | P1 | Installer Rojo, Selene, StyLua, Wally par Rokit ; brancher les MCP Roblox Studio et Blender sur le terminal ([[Installation]]) | P | — | `rojo --version` répond ; `claude mcp list` montre les deux MCP connectés |
| T-002 | P1, humain | Créer le groupe Roblox, publier la place sous le groupe, activer Team Create et l'accès aux services d'API, créer la place Test ([[Lancement]]) | P | — | Les trois membres ouvrent la place en même temps |
| T-003 | P2, P3 | Installer son poste ([[Installation]]) | P | T-002 | « Quelle est ma prochaine tâche ? » donne la bonne réponse |
| T-004 | P1 | Migrer les trois scripts existants vers `src/` avec Rojo, sans changer le comportement ([[Architecture du code]]) | M | T-001, T-002 | Le jeu se joue comme avant ; les scripts viennent du dépôt |
| T-005 | P1 | Découper en `Config/`, services et contrôleurs ; liste unique des événements réseau | M | T-004 | Selene sans erreur ; le jeu se joue comme avant |
| T-006 | P1 | Sauvegarde avec ProfileStore, données versionnées, reprise des données `v1` | M | T-005 | Quitter puis revenir sur la place publiée conserve tout |
| T-007 | P2 | Ranger la map dans `Workspace.Mondes.Monde1` et poser les tags et attributs de [[Contrats]] sur l'existant | P | T-003 | Chaque zone, piste, planche et bac porte son tag ; [[Map]] à jour |
| T-008 | P1 | Lire la map par les tags au lieu des noms et positions en dur | P | T-005, T-007 | Déplacer une zone dans Studio ne casse rien |
| T-009 | P3 | Maquettes de `HudPrincipal`, `HudSaut`, `PanneauResultat` et `EcranBoutique` avec [[Claude Design]] ([[HUD]]) | M | T-003 | Maquettes validées par les trois |
| T-010 | P2 | Planche de style : une paire de chaussures, un compagnon, un module de tribune, par la chaîne complète planche Claude Design → Blender → Studio ([[Modèles 3D]]) | M | T-003 | Les trois modèles sont dans la place, inscrits au registre, style validé |
| T-015 | P2 | Essai de la chaîne plan → Studio : plan du stade actuel avec [[Claude Design]], relevé dans `assets/plans/`, reconstruction en blocs dans la place Test | M | T-003 | Le stade en blocs correspond au plan ; l'équipe décide de garder ou d'ajuster la méthode ([[Décisions]]) |
| T-011 | P3 | Thème d'interface dans Studio : panneau, bouton, barre, ligne de liste, polices, couleurs ([[Direction artistique]]) | M | T-009 | Un écran d'exemple construit avec ces pièces, correct sur trois tailles d'écran |
| T-012 | P1 | Créer les skills du projet ([[Outils]]) | M | T-001 | `/fin-tache` et `/demande` fonctionnent sur les trois postes |
| T-013 | P3 | Groupes de sons dans `SoundService`, six sons d'interface, registre initial avec les quatre sons existants ([[Sons et musique]]) | P | T-003 | Les sons se jouent en test ; registre rempli |
| T-014 | Tous | Revue de fin de phase : valider le style, trancher les questions ouvertes de [[Décisions]] | P | Tout ce qui précède | Décisions écrites |

## Phase 1 — Le saut

Référence : [[Saut]]. Le Poste 1 commence par compléter [[Contrats]] et les listes d'identifiants de la phase.

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-101 | P1 | Appel : jauge, quatre qualités, effet sur la puissance | M | T-008 | Les quatre qualités sortent en test et changent la distance |
| T-102 | P1 | Vol : propulseur validé par le serveur, compteur en direct, caméra, atterrissage détecté par la position, borne de plausibilité | M | T-101 | Un saut truqué côté client est refusé |
| T-103 | P1 | Réception, saut parfait, série, résultat détaillé | M | T-102 | Le détail des pièces correspond à la formule |
| T-104 | P1 | Anneaux et sauts rares | P | T-103 | Un anneau donne poussée et pièces ; un saut doré forcé en test multiplie par 10 |
| T-105 | P2 | Stade : plan définitif, puis piste, planche, bac, panneaux de distance, arche, tribunes | G | T-010, T-015 | Plus aucune forme provisoire sur le trajet du saut |
| T-106 | P2 | Anneaux le long du bac, tableau d'affichage, projecteurs, public | M | T-105 | Anneaux tagués ; public prêt à être animé |
| T-107 | P2 | Animations du saut : course, appel, vol, propulseur, deux réceptions, célébration ([[Animations]]) | G | T-003 | Sept animations publiées sous le groupe et inscrites au registre |
| T-108 | P3 | Construire `HudSaut` et `PanneauResultat` | M | T-011 | Noms conformes à [[HUD]] ; captures sur trois tailles |
| T-109 | P3 | Construire `HudPrincipal` | M | T-011 | Idem |
| T-110 | P3 | Sons du saut, ambiance et musique du stade | M | T-013 | Tous les identifiants « Effets du saut » ont un son au registre |
| T-111 | P3 | Effets visuels du saut : traînée, appel parfait, sable, confettis | M | T-003 | Effets rangés dans `Assets.Effets`, visibles en test |
| T-112 | P1 | Brancher écrans, sons, animations et effets sur le saut | M | T-103, T-107 à T-111 | Un saut complet se voit et s'entend |
| T-113 | Tous | Séance de jeu : le saut est-il amusant sans rien d'autre ? | P | T-112 | Liste de réglages écrite et traitée |

## Phase 2 — Progression

Références : [[Entraînement]], [[Équipement]], [[Quêtes et récompenses]], [[Économie]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-201 | P1 | Nouvelles formules de stats, configuration des mondes, format des grands nombres, tableur et simulation d'équilibrage | M | T-103 | La simulation trace la courbe record / temps du monde 1 |
| T-202 | P1 | Entraînement : zones par paliers, rythme actif, matériel | M | T-201 | Le rythme parfait rapporte trois fois le passif |
| T-203 | P1 | Équipement : cinq familles, niveaux, boutique, objet porté sur le personnage | G | T-201 | Acheter, améliorer et porter chaque objet du monde 1 |
| T-204 | P1 | Paliers de record et ouverture progressive des fonctions | P | T-203 | Chaque fonction s'ouvre à son palier ([[Boucles de gameplay]]) |
| T-205 | P1 | Quêtes du jour et de la semaine, défis, connexion, cadeaux de temps de jeu, roue, boosts, codes | G | T-204 | Chaque récompense se gagne et se réclame une seule fois |
| T-206 | P2 | Salle d'entraînement : machines des trois paliers, zone VIP | G | T-105 | Zones taguées avec leurs attributs |
| T-207 | P2 | Équipement du monde 1 : chaussures, propulseurs, matériel, tenues ; stands | G | T-010 | Un modèle par identifiant dans `Assets.Equipement` |
| T-208 | P2 | Animations d'entraînement : squat, mollets, tapis | M | T-107 | Une répétition par seconde, publiées et inscrites |
| T-209 | P3 | `HudEntrainement`, `EcranBoutique`, `EcranPaliers` | M | T-109 | Noms conformes ; captures |
| T-210 | P3 | `EcranQuetes`, `EcranJour`, `EcranRoue`, `Notifications`, `EcranReglages` | G | T-109 | Idem |
| T-211 | P3 | Icônes : monnaies, stats, menus, boosts ; rendus des objets ([[Images]]) | M | T-207 pour les rendus | Icônes importées et inscrites |
| T-212 | P3 | Sons de progression | M | T-110 | Identifiants « Effets de progression » au registre (hors œufs) |
| T-213 | P1 | Brancher le tout ; équilibrer la première heure | M | T-202 à T-212 | La simulation et un test réel tiennent le rythme visé |
| T-214 | Tous | Séance : une heure chacun avec un compte neuf | P | T-213 | Blocages et moments d'ennui listés et traités |

## Phase 3 — Compagnons

Référence : [[Compagnons]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-301 | P1 | Inventaire, équipe, compagnons qui suivent et sautent, bonus, niveaux | G | T-213 | Trois compagnons équipés changent les gains |
| T-302 | P1 | Œufs, éclosion, chances affichées, fusion Argent et Or, index, restrictions par pays | G | T-301 | Mille éclosions simulées respectent les chances |
| T-303 | P2 | Dix compagnons, trois œufs, incubateur | G | T-010 | Modèles conformes aux [[Contrats]], inscrits |
| T-304 | P2 | Œufs en parties séparées pour l'éclosion ; matières Argent et Or | P | T-303 | L'œuf peut se fendre ; les versions se distinguent de loin |
| T-305 | P3 | `EcranCompagnons`, `EcranOeuf`, `EcranEclosion` | G | T-109 | Noms conformes ; captures |
| T-306 | P3 | Rendus des compagnons, cadres de rareté, sons d'éclosion et de fusion | M | T-303 | Une icône par espèce et par version |
| T-307 | P1 | Brancher ; premier œuf offert à 15 m | M | T-302 à T-306 | Le parcours complet d'un œuf fonctionne |

## Phase 4 — Long terme

Références : [[Rebirth et talents]], [[Mondes]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-401 | P1 | Catégories et médailles | M | T-213 | Monter de catégorie remet à zéro et conserve ce qui est prévu |
| T-402 | P1 | Arbre de talents, gains hors ligne | G | T-401 | Chaque talent a un effet mesurable |
| T-403 | P1 | Système de mondes : portails, téléportation, physique et échelle par monde, chargement à la demande | G | T-401 | Aller au monde 2 et en revenir sans rechargement visible |
| T-404 | P1 | Monde 2 : rafales, stat Aéro, vol plané, ailes | G | T-403 | Sauter pendant une rafale et planer allongent le saut |
| T-405 | P2 | Panthéon et portail au monde 1 | M | T-105 | Modèles tagués |
| T-406 | P2 | Plage des Alizés : plan avec [[Claude Design]] validé à trois, version en blocs jouable, puis terrain, piste, bac, zones, soufflerie, stands, manche à air | G | T-405 | Monde 2 complet dans `Mondes.Monde2` |
| T-407 | P2 | Équipement et compagnons du monde 2 ; animations de vol plané et de soufflerie | G | T-406 | Modèles et animations inscrits |
| T-408 | P3 | `EcranCategorie`, `EcranTalents`, `EcranMondes` | G | T-109 | Noms conformes ; captures |
| T-409 | P3 | Musique et ambiance du monde 2, jingle de catégorie, icônes du monde 2 | M | T-407 | Inscrits aux registres |
| T-410 | P1 | Brancher ; équilibrer jusqu'à l'entrée du monde 3 | M | T-402 à T-409 | La simulation tient le rythme visé sur 6 heures |

## Phase 5 — Social et compétition

Référence : [[Social et compétition]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-501 | P1 | Classements mondiaux, de la semaine et du serveur ; panneaux | M | T-213 | Les panneaux affichent les dix premiers |
| T-502 | P1 | Concours et podium, vent favorable, bonus d'amis, annonces | G | T-501 | Un concours complet à trois joueurs |
| T-503 | P2 | Podium, panneaux de classement, drapeau du record du serveur | M | T-105 | Modèles tagués |
| T-504 | P3 | `EcranClassements`, `EcranConcours`, bandeau, affichage au-dessus des joueurs | M | T-109 | Noms conformes ; captures |
| T-505 | P3 | Musiques et sons de concours, hymne du podium | P | T-110 | Inscrits au registre |
| T-506 | P1 | Brancher | P | T-502 à T-505 | Séance à trois : concours, podium, vent favorable |

## Phase 6 — Monétisation

Référence : [[Monétisation]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-601 | P3, humain | Créer passes et produits sur le Creator Hub, avec leurs icônes | M | T-002, T-211 | Tous les identifiants dans [[Registre des produits]] |
| T-602 | P1 | Passes, produits, reçus, boosts achetés, cadeaux, règles par pays | G | T-601, T-205 | Chaque achat en mode test est livré une seule fois, même après une coupure |
| T-603 | P1 | Pack de départ, offres, bonus Premium, saut et entraînement automatiques | M | T-602 | L'offre apparaît au bon moment, une fois par session au plus |
| T-604 | P3 | `EcranRobux`, `EcranOffre` | M | T-109 | Noms conformes ; captures |
| T-605 | P2 | Zone VIP décorée, coffre du groupe, roue | M | T-206 | Modèles tagués |
| T-606 | Tous | Tester tous les achats | P | T-603 à T-605 | Tableau de tests rempli |

## Phase 7 — Finition et lancement

Références : [[Premières minutes]], [[Lancement]].

| N° | Poste | Tâche | Taille | Dépend de | Terminé quand |
| --- | --- | --- | --- | --- | --- |
| T-701 | P1 | Tutoriel et mesures (entonnoir, économie) | G | T-307 | Un compte neuf suit le tutoriel sans aide ; les événements arrivent sur le Creator Hub |
| T-702 | P1 | Sécurité des événements réseau, performance, réglages, extraction des textes pour la traduction | G | T-602 | Relecture de sécurité faite ; 30 images par seconde sur téléphone |
| T-703 | P2 | Optimiser la map : chargement, collisions, triangles ; lumière finale | M | T-406 | Mémoire stable après 30 minutes |
| T-704 | P3 | Icône du jeu, miniatures, logo, description en français et en anglais, bande-annonce | G | T-406 | Page du jeu complète, en privé |
| T-705 | P3 | Mixage audio final ; vérification de tous les écrans sur téléphone et à la manette | M | T-604 | Aucun écran coupé, aucun son trop fort |
| T-706 | Tous | Dérouler la liste « Avant d'ouvrir au public » | M | T-701 à T-705 | Toutes les cases cochées |
| T-707 | Tous | Bêta fermée et corrections | G | T-706 | Rétention et tutoriel au niveau des repères, ou causes comprises |
| T-708 | Tous, humain | Ouverture publique | P | T-707 | Le jeu est public ; première mise à jour prête |

## Phase 8 — Après la sortie

Chaque ligne est un petit projet qui reprend le schéma d'une phase : contrats, construction en parallèle, branchement, séance de jeu.

| N° | Postes | Projet |
| --- | --- | --- |
| T-801 | Tous | Monde 3, Canyon du Vertige, en commençant par le prototype d'échelle ([[Mondes]]) |
| T-802 | Tous | Pass de saison |
| T-803 | Tous | Premier événement du calendrier |
| T-804 | Tous | Mondes 4, 5 et 6, un toutes les 4 à 6 semaines |
| T-805 | P1 | Duels, clubs, échanges, selon [[Décisions]] |

## Ce que seuls les humains peuvent faire

- Créer le groupe Roblox, inviter les membres, régler les droits et la répartition des revenus.
- Importer un modèle 3D, publier une animation, un son ou une image, créer un passe ou un produit : Claude prépare et guide, l'équipier valide.
- Jouer et dire si c'est amusant.
- Trancher les questions de [[Décisions]].
- Rendre le jeu public.
