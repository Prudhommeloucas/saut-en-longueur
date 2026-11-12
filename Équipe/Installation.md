# Installation

Mise en place d'un poste. À faire une fois par personne. Voir [[Outils]] pour le rôle de chaque logiciel et [[Travailler à plusieurs]] pour la suite.

La première fois, Claude fait ces vérifications de lui-même en suivant [[Première session]] ; il suffit d'ouvrir le dossier et d'écrire « configure mon poste » (voir `README.md`). Cette note sert de référence pour le détail.

## Pour tout le monde

1. **Installer** : git, Obsidian, Roblox Studio, Blender, Claude Desktop (ou Claude Code en terminal).
2. **Récupérer le dépôt** : demander à Claude « clone le dépôt `Prudhommeloucas/saut-en-longueur` dans mon dossier Documents ». Chaque équipier doit avoir le droit d'écriture sur le dépôt GitHub.
3. **Ouvrir le coffre** : dans Obsidian, « Ouvrir un dossier comme coffre », choisir le dossier cloné.
4. **Ouvrir le dossier dans Claude Code** (onglet Code de Claude Desktop, ou `claude` dans un terminal placé dans le dossier).
5. **Déclarer son poste** : à la première session, Claude demande le prénom, attribue un numéro de poste libre et crée le fichier `CLAUDE.local.md`. Ce fichier reste sur la machine, il n'est pas partagé. Le numéro ne donne aucun domaine : tout le monde peut coder et construire. Modèle :

   ```markdown
   # Poste de cette machine

   Cette machine est le **Poste 2** (Claude Code dans Claude Desktop).

   - Titulaire : Prénom
   - Journal : `Suivi/Poste 2.md`
   - Pas de domaine réservé : ce poste prend n'importe quelle tâche de [[Tâches]], après l'avoir réservée.
   ```

6. **Rejoindre le groupe Roblox** du studio et accepter l'invitation Team Create (après la tâche T-002).
7. **Vérifier les MCP** : demander à Claude « liste les objets de Workspace dans Studio » et « décris la scène Blender ». Les deux doivent répondre.
8. Inscrire son prénom sur la ligne « Titulaire » de son journal, et ses envies sur la ligne « Envies ».
9. **Outils de code** (tout le monde code) : voir la partie suivante.

## Mise à jour automatique au début de session

`CLAUDE.md` demande à Claude de lancer `git pull --rebase --autostash` avant toute chose. Pour que ce soit fait même si Claude l'oublie, chaque poste peut ajouter un déclencheur dans le fichier `.claude/settings.json` du projet :

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "git",
            "args": ["pull", "--rebase", "--autostash"],
            "timeout": 60,
            "statusMessage": "Synchronisation avec GitHub..."
          }
        ]
      }
    ]
  }
}
```

Une fois ce fichier créé et envoyé sur GitHub par le Poste 1, il s'applique aux trois postes (Claude Code demande une confirmation à la première ouverture).

## Outils de code, pour tout le monde

1. **Fixer les outils dans le projet** (une seule fois, tâche T-001), depuis le dossier du projet :

   ```
   rokit init
   rokit add rojo-rbx/rojo
   rokit add Kampfkarren/selene
   rokit add JohnnyMorganz/StyLua
   rokit add UpliftGames/wally
   ```

   Cela crée `rokit.toml`, à envoyer sur GitHub.
2. **Sur chaque machine** : installer Rokit, puis `rokit install` dans le dossier du projet. `rojo --version` doit répondre.
3. **Extension Rojo dans Studio** : `rojo plugin install`.
4. **Copie personnelle de la place** : dans Studio, ouvrir la place partagée puis Fichier > Enregistrer dans un fichier sous, dans `copies/` à la racine du projet (exclu de git). C'est là qu'on branche Rojo pour coder et tester ([[Travailler à plusieurs]]).

## Claude Code en terminal en plus

**Brancher les MCP sur Claude Code en terminal.** Ils ne sont configurés que pour Claude Desktop. Reprendre la commande de lancement de chaque serveur et l'ajouter avec `claude mcp add`. Forme habituelle, à vérifier dans la documentation de chaque serveur :

   ```
   claude mcp add --transport stdio roblox-studio -- "<chemin>\rbx-studio-mcp.exe" --stdio
   claude mcp add blender -- uvx blender-mcp
   ```

   Puis `claude mcp list` : les deux doivent apparaître comme connectés.

## Monde, 3D, son et image, pour tout le monde

- Dans Blender, activer l'extension du MCP Blender et démarrer le serveur depuis son panneau avant chaque séance.
  - L'extension s'appelle « MCP » (Blender Lab). Elle ne vient pas du dépôt d'extensions par défaut : dans Préférences > Get Extensions > Repositories, ajouter le dépôt distant `https://lab.blender.org/`, puis chercher « MCP » et l'installer.
  - Elle est à réinstaller après chaque changement de version de Blender (5.2 vers 5.3 par exemple) : le nouveau profil repart sans extension. Le connecteur attend Blender sur `localhost:9876`.
- Régler l'unité de Blender sur « aucune » avec une échelle de 1, pour que 1 unité = 1 stud.
- Vérifier le droit de publier des animations, des modèles, des sons et des images au nom du groupe Roblox.
- Pour les passes et produits : droit de les gérer sur le Creator Hub ; pour piloter le Creator Hub avec Claude, extension Claude pour Chrome ou navigateur intégré de Claude Desktop.
- Facultatif : Audacity, pour retoucher des sons.

## Vérification finale

Demander à Claude : « quelle est ma prochaine tâche ? ». Il doit mettre le dépôt à jour, lire le poste et les réservations en cours, puis proposer des tâches libres de [[Tâches]].
