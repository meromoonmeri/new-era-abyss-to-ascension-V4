# Reprise des donjons (takeover) — remplacement des anciennes implémentations

Dès qu'un donjon entre dans le périmètre de ce Builder, l'implémentation
précédente cesse d'être la référence. Ce document décrit la procédure appliquée,
outillée par `tools/dungeon_builder/takeover.py`
(`python3 tools/dungeon_builder.py takeover [<donjon>] --report --verbose`).

## 1. Classement des artefacts

| Action | Signification | Peut être supprimé ? |
|---|---|---|
| `HARVEST` | donnée canonique réutilisée telle quelle (Ground de scène, `.rsmap`, géométrie, collisions, marqueurs) | jamais |
| `TRANSFER` | contenu narratif ou scène archivée qui **suit** le donjon : cutscenes de Ground, script de zone, cinématiques PMD Red (`.cif.json`) | jamais |
| `REPLACE` | ancienne zone concurrente du donjon, produite par un agent précédent | oui, après reconstruction |
| `REVIEW` | ancien générateur/patcher qui écrivait cette zone | jamais automatiquement — décision humaine |
| `CURRENT` | zone déjà produite par ce Builder | rien à faire |
| `PROTECT` | donjon hors périmètre | intouchable |

## 2. Garde-fous avant suppression

`--apply` refuse de supprimer tant que **les trois** conditions ne sont pas
réunies (`takeover.can_apply`) :

1. le donjon est dans le périmètre du Builder ;
2. son statut de readiness est `READY_FOR_GENERATION` ;
3. la nouvelle zone existe **et** `narrative.transferred` est vrai dans la
   définition (le contenu narratif a été raccordé).

Les outils (`REVIEW`) ne sont jamais supprimés automatiquement : beaucoup
portent aussi de la logique narrative ou d'audit à conserver.

## 3. Contenu narratif : rien ne se perd

Chaque définition embarque désormais un bloc `narrative` :

```json
"narrative": {
  "transferred": false,
  "cutscenes": [{"scene": "d09p03", "state": "active",
                 "path": "Data/Script/halcyon/ground/d09p03"}],
  "zone_script": "Data/Script/halcyon/zone/mt_blaze",
  "red_cinematics": ["RESERVE/red_cinematics/d09p03.cif.json"],
  "rule": "…rejouées sur le Ground canonique (cinématique = combat = fin)."
}
```

Total inventorié sur les 51 donjons : **65 dossiers de cutscene** et
**60 cinématiques PMD Red** (`.cif.json` : audio, caméra, dialogues, déclencheur
de combat). Un test vérifie que chaque chemin référencé existe réellement, et
l'audit signale tout donjon dont le narratif n'est pas encore marqué transféré.

## 4. Chaîne complète auditée par donjon

`entrée → progression → scène narrative → boss/fin → cinématique → combat → sortie`

* **entrée** : Ground d'entrée canonique (`fixed_grounds.entrance`) quand il existe ;
* **progression** : étages procéduraux RogueElements générés par le Builder ;
* **scène / boss / cinématique / combat** : un **seul** espace —
  `scenes.cinematic_ground == scenes.battle_ground == scenes.canonical_end_ground` ;
* **sortie** : gérée par le script de zone transféré.

## 5. Statut de reprise dans l'audit

`ALREADY_IMPLEMENTED` a été **supprimé** du vocabulaire : une ancienne
implémentation dans le périmètre devient `TAKEOVER_PENDING` (à reconstruire puis
à supprimer), et non une excuse pour conserver l'existant. Seuls les donjons
hors périmètre restent `OWNED_BY_OTHER_AGENT`.

État courant : **7 donjons `TAKEOVER_PENDING`** — `mt_blaze`, `mt_freeze`,
`frosty_forest`, `lapis_cave`, `wish_cave` (zones héritées présentes) et
`sky_tower`, `sky_tower_summit` (arc ch.10 importé par un agent précédent).

## 6. Exemple vérifié — `mt_blaze`

```
REPLACE   Data/Zone/mt_blaze.json
HARVEST   Data/Ground/mont_cendre_pied.rsground      (entrée canonique)
HARVEST   Data/Ground/d09p02.rsground                (relais canonique)
HARVEST   Data/Ground/d09p03.rsground                (scène Sulfura : cinématique = combat)
TRANSFER  Data/Script/halcyon/ground/{mont_cendre_pied,d09p02,d09p03}
TRANSFER  Data/Script/halcyon/zone/mt_blaze + RESERVE/scripts_zone/mt_blaze
TRANSFER  RESERVE/red_cinematics/{d09p01,d09p02,d09p03}.cif.json
REVIEW    tools/…                                    (anciens générateurs)
```

Nouvelle source de vérité après reprise : `DungeonDefs/canonical/mt_blaze.json`
(définition) + `Data/Zone/mt_blaze.json` régénéré par le Builder + les Grounds
canoniques conservés + les scripts transférés. Aucun doublon fonctionnel.
