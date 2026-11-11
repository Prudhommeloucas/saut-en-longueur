# Sons et musique

Liste des sons à trouver ou créer, et la façon de les choisir. Poste 3. Voir [[Contrats]] et [[Registre des sons]]. Les quatre sons déjà en place sont décrits dans [[Décor et effets]].

Les descriptions sont des suggestions : le Poste 3 choisit librement, tant que chaque identifiant de la liste a un son ([[Liberté de création]]).

## Où trouver les sons

1. **Creator Store de Roblox** (onglet Audio de la boîte à outils de Studio) : gratuit, utilisable tout de suite, et inclut une bibliothèque de musiques sous licence. Premier choix.
2. **Création** quand on ne trouve pas : générateurs d'effets rétro en ligne (famille sfxr) pour les sons d'interface et de pièces, Audacity pour couper, assembler et régler le volume.
3. **Banques libres** (licence CC0) pour les bruits réels : foule, vent, vagues.
4. **Génération par IA** (par exemple ElevenLabs, qui propose un serveur MCP) : utile pour des effets précis, à utiliser si un équipier a un compte.

Tout son importé doit appartenir au groupe du jeu ou lui être autorisé, sinon il reste muet en jeu. Les imports sont limités chaque mois par Roblox : importer seulement ce qui est validé. Noter la source et la licence de chaque son dans le registre.

## Méthode

1. Chercher trois candidats par son, les écouter dans Studio.
2. Tester en jeu, dans la situation réelle, avec la musique.
3. Régler volume et hauteur, inscrire dans le registre.
4. Vérifier après publication : un son du Creator Store peut être retiré.

## Organisation dans Studio

Quatre groupes dans `SoundService` : `Musique`, `Ambiance`, `Effets`, `Interface`. Les réglages du joueur agissent sur les groupes. La musique baisse automatiquement pendant une fanfare ou une annonce.

## Musique

| Identifiant | Usage | Style |
| --- | --- | --- |
| `musique_monde1` | Stade | Entraînante, cuivres et percussions, boucle de 1 à 2 minutes |
| `musique_monde2` à `musique_monde6` | Un thème par monde | Plage : ukulélé ; canyon : guitare western ; pic : cordes légères ; métropole : électro ; lune : nappes planantes |
| `musique_concours` | Pendant un concours | Plus rapide, tension |
| `musique_vent` | Vent favorable | Courte boucle joyeuse |
| `jingle_podium` | Podium | Hymne de 8 secondes |
| `jingle_categorie` | Changement de catégorie | Montée triomphale de 5 secondes |

## Ambiances

| Identifiant | Description |
| --- | --- |
| `ambiance_stade` | Rumeur de foule, quelques sifflets, oiseaux |
| `ambiance_plage` | Vagues, mouettes, vent |
| `ambiance_canyon` | Vent dans la roche, cri d'aigle lointain |
| `ambiance_pic` | Vent froid, neige qui crisse |
| `ambiance_metropole` | Circulation lointaine, bourdonnement de néons |
| `ambiance_lune` | Souffle de respirateur, bips radio |

## Effets du saut

| Identifiant | Description |
| --- | --- |
| `course_pas` | Pas sur piste, de plus en plus rapides |
| `saut_appel` | Impulsion sèche |
| `saut_appel_parfait` | Impulsion et tintement brillant |
| `saut_mordu` | Petit buzzer et « oh » déçu du public |
| `vol_vent` | Vent en boucle, plus aigu et plus fort avec la vitesse |
| `propulseur_soda`, `propulseur_extincteur`, `propulseur_reacteur` | Une boucle par propulseur |
| `anneau` | Note qui monte d'un ton à chaque anneau de suite |
| `reception_sable` | Impact dans le sable (déjà en place) |
| `reception_parfaite` | Impact, roulade, tintement |
| `reception_ratee` | Bruit sourd comique |
| `foule_applaudit`, `foule_ovation` | Selon la qualité du saut |
| `record` | Fanfare courte (déjà en place) |
| `saut_dore`, `saut_legendaire` | Annonce brillante ; grand coup d'orchestre |

## Effets de progression

| Identifiant | Description |
| --- | --- |
| `entrainement_tic` | Son court à chaque gain, hauteur qui monte avec le combo |
| `entrainement_parfait` | Tintement |
| `pieces` | Pièces qui tombent (déjà en place) |
| `achat` | Caisse enregistreuse |
| `amelioration` | Clé à molette et étincelle |
| `oeuf_tremble`, `oeuf_fend` | Coquille |
| `eclosion_commun` à `eclosion_mythique` | Une signature par rareté, de plus en plus spectaculaire |
| `fusion` | Fonte et éclat métallique |
| `palier` | Montée de trois notes |
| `quete_finie`, `cadeau` | Carillon ; papier cadeau |
| `portail` | Aspiration |
| `concours_debut`, `concours_fin` | Corne de brume ; sifflet final |
| `compte_a_rebours` | Bips |
| `vent_favorable` | Rafale et carillons |

## Interface

`ui_clic`, `ui_survol`, `ui_ouvrir`, `ui_fermer`, `ui_erreur`, `ui_notification`. Très courts, discrets, tous de la même famille sonore.

## Règles

- Aucun son répété souvent ne doit dépasser une demi-seconde.
- Les sons des autres joueurs sont plus faibles que les siens et limités en distance.
- Les sons sont préchargés à l'arrivée du joueur.
