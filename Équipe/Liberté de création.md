# Liberté de création

Chacun a ses idées, et le projet doit en profiter. Cette note dit ce que chacun décide seul, ce qui se propose à l'équipe, et ce qui ne bouge pas. Voir [[Équipe]] et [[Travailler à plusieurs]].

## Le principe

Les notes de conception et de réalisation sont un **cadre de départ**, pas un cahier des charges. Les descriptions de modèles, d'écrans, de sons et de mondes sont des suggestions : celui qui fait la pièce peut faire autrement, et met la note à jour ensuite.

## Trois niveaux

### 1. Libre : je décide, je fais, je mets la note à jour

Tout ce qui se trouve dans la zone de son poste et ne touche pas au travail des autres.

| Poste | Exemples |
| --- | --- |
| Poste 1 | Organisation interne du code, façon de coder un système, outils de test |
| Poste 2 | Forme et plan d'un monde, décor, aspect des modèles et des compagnons, espèces de compagnons, style d'une animation, lumière |
| Poste 3 | Disposition et style d'un écran, choix d'un son ou d'une musique, dessin des icônes, images de la page du jeu |
| Tous | Noms affichés (objets, compagnons, lieux), textes du jeu, petits détails amusants cachés dans la map |

Seules limites : garder les noms techniques, tags et attributs de [[Contrats]], et rester dans les budgets techniques (triangles, tailles d'image, durée des sons).

### 2. À proposer : j'écris l'idée, on décide à trois

Tout ce qui change les règles du jeu ou le travail d'un autre poste.

- Une nouvelle mécanique, une nouvelle monnaie, une nouvelle stat.
- Un changement d'économie : prix, multiplicateurs, conditions d'accès.
- Le thème ou la mécanique d'un monde.
- Un changement des [[Contrats]] ou de la répartition des postes.
- Tout ce qui touche à la [[Monétisation]].

### 3. Fixe : on n'y touche que d'un commun accord

- Le serveur décide de tout ce qui compte (distances, gains, achats).
- Chacun ne modifie que sa zone ; seul le Poste 1 écrit du code.
- Les règles de Roblox ([[Monétisation]], [[Lancement]]).
- Les quatre piliers de la [[Vision]]. Ils peuvent changer, mais seulement si les trois sont d'accord.

## Boîte à idées

Dossier `Idées/`, **un fichier par idée**, ouvert à tous. Chacun n'écrit que dans ses propres fichiers, donc aucun conflit.

1. Copier [[Modèle d'idée]], nommer la note `Prénom - titre court.md`.
2. Décrire l'idée, ce qu'elle apporte au joueur, ce qu'elle demande à chaque poste.
3. Envoyer sur GitHub. L'idée apparaît dans le [[Tableau de bord]].
4. Au point d'équipe suivant, on la passe à `retenue`, `plus tard` ou `écartée`, avec une phrase d'explication.
5. Une idée retenue est intégrée par le Poste 1 dans les notes de conception, [[Décisions]] et le [[Déroulé du développement]].

Une idée peut être un simple paragraphe. On peut y joindre une maquette, un plan ou une planche faite avec [[Claude Design]].

## Ce qui est grand ouvert

- **Les mondes 3 à 6** : les thèmes proposés dans [[Mondes]] sont des pistes. Chacun peut proposer son monde, avec sa propre façon de sauter.
- **Les compagnons et l'équipement** à partir du monde 2 : espèces, objets, noms.
- **Les événements** après la sortie.
- **Le nom du jeu** ([[Décisions]]).

## Comment Claude doit se comporter

- Si l'utilisateur veut faire autrement que ce qui est écrit, et que c'est dans la zone de son poste : le faire, puis mettre la note à jour. Ne pas opposer la note à l'idée.
- Si l'idée relève du niveau 2 : aider à l'écrire dans `Idées/`, et proposer un prototype dans sa zone si c'est possible, sans modifier le travail des autres.
- Si l'idée touche au niveau 3 : expliquer pourquoi c'est fixe et proposer de l'écrire comme idée à discuter.
- Signaler honnêtement un risque (technique, équilibre, règle de Roblox) sans s'en servir pour refuser.
