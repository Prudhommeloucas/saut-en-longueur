# Registre des animations

Une animation par ligne, dès qu'elle est publiée sous le groupe. Celui qui publie l'animation l'inscrit. Liste et descriptions dans [[Animations]].

| Identifiant | Asset | Durée | Boucle | Fichier source | État |
| --- | --- | --- | --- | --- | --- |
| `course_elan` | 117642128973469 | 0,97 s | Oui | `ServerStorage.SourcesAnimations.course_elan` (place partagée) | publiée |
| `appel` | 119848317194561 | 0,97 s | Non (publiée en boucle : `Looped = false` au chargement) | `SourcesAnimations.appel` | publiée |
| `vol` | 88329723889520 | 0,97 s | Oui | `SourcesAnimations.vol` | publiée |
| `vol_propulseur` | 85973977561160 | 0,97 s | Oui | `SourcesAnimations.vol_propulseur` | publiée |
| `reception_reussie` | 109700021669266 | 1,97 s | Non (publiée en boucle) | `SourcesAnimations.reception_reussie` | publiée |
| `reception_ratee` | 81028353359857 | 1,97 s | Non (publiée en boucle) | `SourcesAnimations.reception_ratee` | publiée |
| `celebration_record` | 76391129202083 | 1,97 s | Non (publiée en boucle) | `SourcesAnimations.celebration_record` | publiée |
| `mascotte_attente` | 107941930620027 | 4 s | Oui | `SourcesAnimations.mascotte_attente` (place partagée), rig `Assets.Decor.mascotte_bondo` | publiée || `mascotte_applaudit` | 124492385469869 | 2 s | Non | `SourcesAnimations.mascotte_applaudit` | publiée || `mascotte_record` | 84802607737215 | 2 s | Non | `SourcesAnimations.mascotte_record` | publiée || `mascotte_salut` | 130311698699156 | 2 s | Non | `SourcesAnimations.mascotte_salut` | publiée |

États : `en cours`, `publiée`, `validée`.

Rappel : une animation publiée sous un compte personnel ne se joue pas dans le jeu du groupe.

Les sept animations du saut (T-107, 2026-11-24) ont été générées par l'outil d'animation du MCP Roblox Studio (`generate_animation`, à partir d'une description en français), **lancé dans la place partagée** : il publie alors sous le groupe OGC Studio (vérifié). Lancé dans une copie personnelle, il publie sous le compte de l'équipier : c'est arrivé une fois pour un essai de `course_elan` (asset 111030562858478, sous Loucas2103, inutilisé). Les objets `Animation` sont dans `ReplicatedStorage.Assets.Animations`, nommés par l'identifiant.
