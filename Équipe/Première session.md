# Première session

Procédure que Claude déroule tout seul la première fois qu'une personne ouvre le projet sur une machine. Elle s'adresse à Claude. La version pour les humains est dans `README.md` ; le détail de chaque logiciel est dans [[Installation]].

## Quand la dérouler

- Le fichier `CLAUDE.local.md` n'existe pas à la racine du projet : la machine n'a jamais été configurée.
- Ou l'utilisateur écrit « configure mon poste » (pour refaire les vérifications).

Dans le premier cas, annoncer en une phrase ce qui va se passer, puis commencer sans attendre.

## Règles

- Vérifier d'abord, installer ensuite. Ne rien installer et ne rien modifier hors du dossier du projet sans l'accord de l'utilisateur, demandé une fois avec la liste complète de ce qui manque.
- Adapter les commandes au système de la machine (Windows, macOS).
- Ne modifier aucune note en dehors du fichier de suivi du poste.
- Si une étape échoue, continuer les suivantes et tout rapporter à la fin.

## Étapes

### 1. Dépôt

- `git pull --rebase --autostash`, puis `git status -sb`.
- Régler le dépôt pour que la mise à jour soit toujours sûre (réglages locaux à ce dépôt) :

  ```
  git config pull.rebase true
  git config rebase.autoStash true
  ```

- Vérifier l'identité git (`git config user.name` et `user.email`). Si elle manque, la demander à l'utilisateur et la régler pour ce dépôt.
- Vérifier le droit d'écriture : `git push --dry-run`. En cas de refus, l'utilisateur doit accepter l'invitation GitHub ou se connecter.

### 2. Poste

- Lire [[Équipe]] et l'en-tête des trois fichiers de suivi pour savoir quels postes ont déjà un titulaire.
- Demander à l'utilisateur son prénom et son poste, en ne proposant que ce qui a du sens : Poste 1 (code, terminal), Poste 2 (monde et 3D), Poste 3 (interface, son et image).
- Si le poste choisi a déjà un autre titulaire, le signaler et faire confirmer.

### 3. Logiciels

Vérifier la présence de chaque logiciel utile au poste et noter le résultat.

| Logiciel | Poste 1 | Poste 2 | Poste 3 |
| --- | --- | --- | --- |
| git | oui | oui | oui |
| Obsidian | oui | oui | oui |
| Roblox Studio | oui | oui | oui |
| Blender | pour les tests | oui | oui (rendus d'icônes) |
| Rokit, puis `rokit install` dans le projet | oui | non | non |
| Extension Rojo de Studio | oui | non | non |
| Audacity | non | non | oui |

Pour ce qui manque : donner la liste, proposer la commande d'installation, attendre l'accord.

### 4. Connexions à Studio et à Blender

- Regarder si les outils du MCP Roblox Studio et du MCP Blender sont disponibles dans la session.
- S'ils le sont, les essayer avec une action sans effet : lister les enfants de `Workspace`, décrire la scène Blender. Studio et Blender doivent être ouverts ; dans Blender, le serveur du MCP doit être démarré depuis son panneau.
- S'ils ne le sont pas, expliquer comment les brancher ([[Installation]]) et le noter comme point restant.
- Poste 2 : vérifier que l'unité de Blender donne 1 unité = 1 stud.

### 5. Roblox

- Lire dans [[Poste 1 - Code]] si la tâche T-002 (groupe, Team Create) est cochée.
- Si oui : demander à l'utilisateur s'il a rejoint le groupe et s'il ouvre bien la place partagée.
- Si non : dire que cette partie attend le Poste 1, sans bloquer le reste.

### 6. Fichier du poste

Créer `CLAUDE.local.md` à la racine, sur ce modèle :

```markdown
# Poste de cette machine

Cette machine est le **Poste 2 — Monde et 3D** (Claude Code dans Claude Desktop).

- Titulaire : Prénom
- Fichier de suivi : `Suivi/Poste 2 - Monde et 3D.md`
- Ne crée et ne modifie aucun script.
```

Pour le Poste 1, la dernière ligne devient : « Seul poste autorisé à écrire du code Luau et à modifier `src/`. »

Ce fichier est exclu de git : il ne s'envoie pas.

### 7. Suivi

Dans le fichier de suivi du poste :

- remplacer « Titulaire : à compléter » par le prénom ;
- si toutes les vérifications sont passées, cocher la tâche d'installation (T-003 pour les Postes 2 et 3) avec la date ; sinon ajouter une ligne au journal avec ce qui reste ;
- envoyer : `git add -A`, `git commit -m "[P2] T-003 installation du poste"`, `git pull --rebase --autostash`, `git push`.

### 8. Compte rendu

Terminer par un tableau court : chaque vérification, son résultat, et ce que l'utilisateur doit encore faire lui-même. Puis annoncer la première tâche non cochée du fichier de suivi et les notes à lire pour la faire.

## Sessions suivantes

Dès que `CLAUDE.local.md` existe, cette procédure ne se relance plus : la session suit le début de session décrit dans `CLAUDE.md`.
