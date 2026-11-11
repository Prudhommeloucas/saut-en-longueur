# Lancement

Publication, mesures et vie du jeu après la sortie. Voir [[Déroulé du développement]], phases 7 et 8.

## Mise en place du jeu sur Roblox (une fois, tâche T-002)

1. Créer un **groupe Roblox** pour le studio et y inviter les trois membres.
2. Publier la place sous ce groupe. Tous les assets (animations, sons, images, meshes) seront publiés sous le groupe.
3. Activer **Team Create** et donner le droit d'édition aux trois membres.
4. Dans les réglages du jeu : activer l'accès de Studio aux services d'API (indispensable pour tester la sauvegarde), laisser le jeu en privé.
5. Créer une seconde place « Test » dans la même expérience, pour essayer les changements risqués sans toucher à la place principale.

La place vit dans le nuage de Roblox, qui garde l'historique de ses versions. Elle n'est pas dans le dépôt git ; seuls le code, les sources d'assets et les notes y sont ([[Travailler à plusieurs]]).

## Avant d'ouvrir au public

- [ ] Sauvegarde testée : jouer, quitter, revenir, retrouver ses données. Tester aussi une coupure pendant un achat.
- [ ] Partie complète avec un compte neuf, sur téléphone, du tutoriel au monde 2.
- [ ] Performance : plus de 30 images par seconde sur un téléphone moyen, mémoire stable après 30 minutes.
- [ ] Tous les achats testés en mode test de Roblox.
- [ ] Chances des œufs affichées, restrictions par pays en place ([[Monétisation]]).
- [ ] Questionnaire de maturité rempli, description et genre renseignés.
- [ ] Icône, miniatures, description en français et en anglais ([[Images]]).
- [ ] Traduction : textes extraits, anglais relu à la main, traduction automatique activée pour le reste.
- [ ] Groupe Roblox prêt, code de bienvenue créé.

## Ouverture en deux temps

1. **Bêta fermée** (une à deux semaines) : amis et connaissances, 20 à 50 joueurs. On corrige les blocages et l'équilibrage de la première heure.
2. **Ouverture publique** : un vendredi après-midi, avec une mise à jour déjà prête pour la semaine suivante.

## Mesures à suivre

Le Creator Hub de Roblox fournit les tableaux de bord. Le jeu y envoie ses propres événements (service Mesures, [[Architecture du code]]).

| Mesure | Ce qu'elle dit | Repère à viser |
| --- | --- | --- |
| Rétention à 1 jour | La première session donne-t-elle envie de revenir | 25 % et plus |
| Rétention à 7 jours | La boucle longue tient-elle | 8 % et plus |
| Durée moyenne de session | La boucle de session fonctionne-t-elle | 12 minutes et plus |
| Entonnoir du tutoriel | À quelle étape on perd les joueurs | Moins de 15 % de perte par étape |
| Part de joueurs qui achètent | L'offre est-elle visible et utile | 1 à 3 % |
| Sources et dépenses par monnaie | L'économie est-elle équilibrée | Pas d'accumulation sans usage |

Les repères sont des ordres de grandeur pour ce genre de jeu, à ajuster avec les premières données réelles. Une seule modification à la fois quand on cherche à améliorer une mesure.

## Rythme après la sortie

- **Chaque semaine** : une mise à jour, même petite (un œuf, un code, un événement de week-end), annoncée dans le groupe. Les jeux mis à jour chaque semaine sont mieux mis en avant et gardent leurs joueurs.
- **Toutes les 4 à 6 semaines** : un nouveau monde ou un grand système ([[Mondes]]).
- **Saisons** de 4 à 6 semaines : un pass de 30 niveaux avec une voie gratuite et une voie premium, alimenté par des points gagnés en jouant.
- **Événements du calendrier** : Halloween, hiver, été. Décor du stade, œuf et quêtes de l'événement.

## Faire connaître le jeu

- Le titre, l'icône et la première miniature font l'essentiel : les tester à deux versions.
- Vidéos courtes des sauts les plus spectaculaires (le saut légendaire, la Lune).
- Codes offerts dans la description et dans le groupe.
- Publicité payante sur Roblox seulement une fois la rétention à 1 jour au-dessus du repère : sinon on paie pour des joueurs qui ne restent pas.

## Suite possible

Duels, clubs, échanges de compagnons, mondes 7 et plus, objets d'avatar à vendre. Chaque idée passe d'abord par [[Décisions]].
