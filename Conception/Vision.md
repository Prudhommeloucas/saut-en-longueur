# Vision

Ce que le jeu doit être, et les règles qui tranchent quand on hésite. Voir [[Projet]].

## En une phrase

Un simulateur d'athlète où chaque saut est un petit moment d'adresse, et où l'on passe d'un bac à sable de quartier à un saut de plusieurs kilomètres sur la Lune.

## Public

- Joueurs Roblox de 8 à 16 ans, en majorité sur téléphone. Tout doit se jouer avec un pouce.
- Sessions courtes (10 à 20 minutes) répétées chaque jour.
- Jeu en français et en anglais dès la sortie (traduction automatique de Roblox pour le reste).

## Les quatre piliers

1. **Le saut est un jeu, pas une attente.** Appel, vol et réception demandent chacun un geste. Un bon joueur gagne plus qu'un joueur passif à stats égales ([[Saut]]).
2. **Toujours un objectif à portée.** À tout moment le joueur voit un but à moins de 5 minutes, un autre à moins d'une heure, un autre pour la semaine ([[Boucles de gameplay]]).
3. **Chaque monde change les règles.** Vent, falaise, tremplin, rebonds, faible gravité : un nouveau monde apporte une nouvelle façon de sauter et pas seulement des nombres plus gros ([[Mondes]]).
4. **On joue ensemble.** Concours de serveur, podium, vent favorable pour tous, classements : le stade est un lieu vivant ([[Social et compétition]]).

## Ce qui nous distingue de la référence

La [[Référence]] repose sur l'entraînement automatique et un lancer sans intervention. Nous gardons sa structure de progression (entraînement, monnaie, équipement, compagnons, rebirth, mondes), et nous ajoutons :

- un saut en trois temps qui récompense l'adresse ;
- des mondes à physique différente ;
- des concours en direct avec podium ;
- un thème d'athlétisme cohérent partout : catégories au lieu de « rebirth », médailles, stade, public.

## Règles de conception

- Un nouveau système doit nourrir la boucle principale (sauter plus loin) ou donner une raison de revenir. Sinon on ne le fait pas.
- Un joueur qui ne paie pas peut tout débloquer. Payer fait gagner du temps ou du style ([[Monétisation]]).
- Tout nombre d'équilibrage vit dans un module de configuration, jamais dans le code d'un système ([[Architecture du code]]).
- On livre d'abord un monde 1 complet et soigné, puis on élargit.
