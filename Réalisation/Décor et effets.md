# Décor et effets

Ajoutés le 2026-11-11. Voir [[Projet]], [[Map]] et [[Scripts]].

## Décor

Tout est dans `Workspace.Map.Decor`, purement visuel (aucun script n'en dépend).

| Dossier | Contenu |
| --- | --- |
| `Sol` | Herbe sous toute la longueur du sable, bordures blanches du bac à sable |
| `Tribunes` | Gradins avec sièges colorés et toit, des deux côtés de la piste d'élan |
| `Drapeaux` | Un mât tous les 20 m le long du sable, côté opposé aux panneaux de distance |
| `Lampadaires` | Quatre lampadaires aux coins du spawn |
| `Gym` | Haltères, banc et plots dans les zones d'entraînement |
| `Arbres`, `ArbresPiste` | 26 arbres autour du spawn, 70 le long du sable |

Ambiance (service `Lighting`) : fin d'après-midi (16 h 12), brume légère, bloom, couleurs un peu plus saturées, rayons de soleil.

## Effets

| Effet | Déclencheur | Où c'est codé |
| --- | --- | --- |
| Étincelles sur les zones | Permanent | ParticleEmitter `Etincelles` dans chaque zone |
| « +1 » au-dessus de la tête | Gain de Puissance ou de Vitesse | `ClientSaut`, fonction `popup` |
| Traînée orange aux pieds | Chaussures possédées, joueur sur la piste | `JeuSaut`, `ajouterTrainee` et `activerTrainees` |
| Flammes, lueur et son du jetpack | Pendant la poussée | `JeuSaut`, `ajouterFlamme` et `activerJetpack` |
| Gerbe de sable et bruit d'impact | Atterrissage | `JeuSaut`, `effetAtterrissage` |
| Confettis et fanfare | Nouveau record | `JeuSaut`, `effetAtterrissage` |
| Son de pièces | Saut qui rapporte des pièces | `ClientSaut` |
| Champ de vision élargi | Vitesse élevée (de 70 à 100 maximum) | `ClientSaut`, valeurs `FOV_BASE` et `FOV_MAX` dans `Config` |

## Sons

Les identifiants sont dans `Config.SONS`. Trois viennent du Creator Store (gratuits), le quatrième est un son intégré à Roblox.

- Atterrissage : `9118767941` (Sand Impacts 3, ProSoundEffects)
- Pièces : `135483737426662` (Coin Collect)
- Record : `9067124098` (victory fanfare sfx+)
- Jetpack : `rbxasset://sounds/action_falling.ogg`, joué en boucle et accéléré. C'est un bruit de vent faute d'avoir trouvé un bon son de réacteur gratuit.

Les quatre se chargent bien en test dans Studio. À revérifier une fois le jeu publié : un son du Creator Store peut être retiré ou restreint.

## À faire

Le décor ci-dessus est provisoire : il sera remplacé par la place ronde et le voyage par paliers de [[Construction du monde 1]] (décidé le 2026-11-12).

Les listes complètes sont maintenant dans [[Modèles 3D]], [[Animations]] et [[Sons et musique]] ; les quatre sons ci-dessus sont repris dans [[Registre des sons]]. Rappel de ce qui manquait à l'origine :

- Animations de squat et de mollets (il faut créer ou trouver des animations).
- Un vrai son de réacteur pour le jetpack.
- Musique d'ambiance.
- Vrais modèles 3D à la place des formes simples (stands, machines de sport).
