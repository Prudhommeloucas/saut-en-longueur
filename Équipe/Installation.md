# Installation

Mise en place d'un poste. À faire une fois par personne. Voir [[Outils]] pour le rôle de chaque logiciel et [[Travailler à plusieurs]] pour la suite.

La première fois, Claude fait ces vérifications de lui-même en suivant [[Première session]] ; il suffit d'ouvrir le dossier et d'écrire « configure mon poste » (voir `README.md`). Cette note sert de référence pour le détail.

## Pour tout le monde

1. **Installer** : git, Obsidian, Roblox Studio, Blender, Claude Desktop (ou Claude Code en terminal pour le Poste 1).
2. **Récupérer le dépôt** : demander à Claude « clone le dépôt `Prudhommeloucas/saut-en-longueur` dans mon dossier Documents ». Chaque équipier doit avoir le droit d'écriture sur le dépôt GitHub.
3. **Ouvrir le coffre** : dans Obsidian, « Ouvrir un dossier comme coffre », choisir le dossier cloné.
4. **Ouvrir le dossier dans Claude Code** (onglet Code de Claude Desktop, ou `claude` dans un terminal placé dans le dossier).
5. **Déclarer son poste** : à la première session, Claude demande le poste et crée le fichier `CLAUDE.local.md`. Ce fichier reste sur la machine, il n'est pas partagé. Modèle :

   ```markdown
   # Poste de cette machine

   Cette machine est le **Poste 2 — Monde et 3D** (Claude Code dans Claude Desktop).

   - Fichier de suivi : `Suivi/Poste 2 - Monde et 3D.md`
   - Ne crée et ne modifie aucun script.
   ```

6. **Rejoindre le groupe Roblox** du studio et accepter l'invitation Team Create (après la tâche T-002).
7. **Vérifier les MCP** : demander à Claude « liste les objets de Workspace dans Studio » et « décris la scène Blender ». Les deux doivent répondre.
8. Inscrire son prénom sur la ligne « Titulaire » de son fichier de suivi.

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

## Poste 1 en plus

1. **Outils de code**, depuis le dossier du projet :

   ```
   rokit init
   rokit add rojo-rbx/rojo
   rokit add Kampfkarren/selene
   rokit add JohnnyMorganz/StyLua
   rokit add UpliftGames/wally
   ```

   Cela crée `rokit.toml`, à envoyer sur GitHub.
2. **Extension Rojo dans Studio** : déjà présente sur cette machine. Sinon `rojo plugin install`.
3. **Brancher les MCP sur Claude Code en terminal.** Ils ne sont configurés que pour Claude Desktop. Reprendre la commande de lancement de chaque serveur et l'ajouter avec `claude mcp add`. Forme habituelle, à vérifier dans la documentation de chaque serveur :

   ```
   claude mcp add --transport stdio roblox-studio -- "<chemin>\rbx-studio-mcp.exe" --stdio
   claude mcp add blender -- uvx blender-mcp
   ```

   Puis `claude mcp list` : les deux doivent apparaître comme connectés.

## Poste 2 en plus

- Dans Blender, activer l'extension du MCP Blender et démarrer le serveur depuis son panneau avant chaque séance.
- Régler l'unité de Blender sur « aucune » avec une échelle de 1, pour que 1 unité = 1 stud.
- Vérifier le droit de publier des animations et des modèles au nom du groupe Roblox.

## Poste 3 en plus

- Vérifier le droit de publier des sons et des images au nom du groupe, et de gérer les passes et produits du jeu sur le Creator Hub.
- Installer Audacity.
- Pour piloter le Creator Hub avec Claude : extension Claude pour Chrome, ou le navigateur intégré de Claude Desktop.

## Vérification finale

Demander à Claude : « quelle est ma prochaine tâche ? ». Il doit mettre le dépôt à jour, lire le poste, puis citer la première tâche non cochée du fichier de suivi.
