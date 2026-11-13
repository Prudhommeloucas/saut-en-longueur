---
qui: P2
prenom: Loucas
etat: en cours
debut: 2026-11-14
tache: T-207 (partie propulseurs)
---

# Propulseurs du monde 1 - P2

## Tâche

Partie « propulseurs » de T-207 (Équipement du monde 1) : bouteille de soda, extincteur, réacteur de poche. Prise avant T-010 par choix de Loucas ; le reste de T-207 (chaussures, matériel, tenues, stands) reste libre.

## Ce que la tâche touche

- Dépôt : `assets/modeles/source/propulseur_*.blend`, `assets/modeles/export/propulseur_*.fbx`, `assets/modeles/planches/`, `Réalisation/Prompts/Prompt 6 - Planche d'un objet d'équipement.md`, lignes des propulseurs dans [[Modèles 3D]] et [[Registre des modèles]]
- Studio : `ReplicatedStorage.Assets.Equipement.propulseur_soda`, `propulseur_extincteur`, `propulseur_reacteur` (à l'import)

## Notes

Étapes : une planche Gemini par propulseur (prompts dans [[Prompt 6 - Planche d'un objet d'équipement]]), puis modélisation dans Blender par le MCP, export `.fbx`, import dans Studio, registre.

Identifiants provisoires, repris de ceux des sons ([[Sons et musique]]) : `propulseur_soda`, `propulseur_extincteur`, `propulseur_reacteur`. À confirmer par la tâche de contrats de la phase 2.

Où on en est (2026-11-14) : planches Gemini rangées dans `assets/modeles/planches/`, trois modèles construits par script dans `assets/modeles/source/propulseurs_monde1.blend` et exportés en `.fbx` (904, 862 et 760 triangles). Bouteille de soda refaite en opaque à la demande de Loucas. Reste : import dans Studio à la main (vérifier l'échelle 1 unité = 1 stud et l'orientation), Part `Poignee` et attribut `Attache` = `Dos`, `Neon` sur la lueur, puis état `importé` au registre.
