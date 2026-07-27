# Audit ch5 — Chargement des segments & salles de boss/mini-boss (2026-07-27)

Vérification statique complète des 3 donjons du chapitre 5 (Grande Steppe,
Tunnel Incandescent, Mont Venteux) : segments de zone, arènes, grounds,
scripts de flux, dépendances (musiques, tilesets, statuses), post-fix écran noir.

## 1. Segments de zone — ✅ tous chargeables

| Zone | Segment | Type | Étages | Carte/Gén | Musique | Verdict |
|---|---|---|---|---|---|---|
| vast_steppe | 0 | RangeDict | 0-6 (7) | génération grille | Sky Peak Prairie.ogg | ✅ couverture 0..6 complète |
| vast_steppe | 1 | Layered | 1 | `vast_steppe_miniboss.rsmap` | Boss Battle!.ogg | ✅ |
| vast_steppe | 2 | RangeDict | 0-6 (7) | génération grille | Sky Peak Prairie.ogg | ✅ |
| vast_steppe | 3 | Layered | 1 | `vast_steppe_guardian.rsmap` | Boss Battle!.ogg | ✅ |
| searing_tunnel | 0 | RangeDict | 0-9 (2 nœuds 0-4/5-9) | génération | Spring Cave.ogg | ✅ couverture 0..9 sans trou |
| searing_tunnel | 1 | RangeDict | 0-4 (5) | génération | Lower Spring Cave.ogg | ✅ |
| searing_tunnel | 2 | Layered | 1 | `searing_crucible.rsmap` | Boss Battle!.ogg | ✅ |
| mount_windswept | 0 | RangeDict | 0-6 (7) | génération | Mt. Travail.ogg | ✅ |
| mount_windswept | 1 | Layered | 1 | `mount_windswept_miniboss.rsmap` | Boss Battle!.ogg | ✅ |
| mount_windswept | 2 | RangeDict | 0-5 (6) | génération | Mt. Travail.ogg | ✅ |
| mount_windswept | 3 | Layered | 1 | `mount_windswept_guardian.rsmap` | Boss Battle!.ogg | ✅ |

`index.idx` cohérent : vast_steppe 14 étages [7,1,7,1], mount_windswept 13
[7,1,6,1], searing_tunnel 15 [10,5,1].

## 2. Arènes de combat (.rsmap) — ✅ 6/6 valides

| Arène | Dim. | Boss (espèce, niv, pos) | Entrées sur sol | Flood-fill | Statuses |
|---|---|---|---|---|---|
| vast_steppe_miniboss | 15×15 | Mudbray 16 (7,4) + Stantler 16 (5,5) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| vast_steppe_guardian | 17×15 | Stantler 20 (8,4) | 2/2 ✅ | 195/195 ✅ | mysterious_force |
| searing_tunnel_miniboss | 15×15 | Torkoal 17 (6,4) + Magmar 17 (9,4) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| searing_crucible | 21×21 | Magcargo 18 + 8 Slugma 13 (anneau) | 1/1 ✅ | 72/72 ✅ | steam + mysterious_force |
| mount_windswept_miniboss | 15×15 | Gligar 18 (5,4) + Skarmory 18 (9,4) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| mount_windswept_guardian | 17×15 | Aerodactyl 22 (8,4) | 2/2 ✅ | 195/195 ✅ | mysterious_force |

Tous les boss sont sur cases walkables ET atteignables depuis l'entrée.
Statuses `steam`/`mysterious_force` présents dans `Data/MapStatus/`. Niveaux
conformes au palier 2 (équipe 15-25).

## 3. Flux segment→ground→segment — ✅ chaîne complète vérifiée

```
entrance ──EnterDungeon(seg 0)──▶ seg0 ──Cleared──▶ midpoint (relais)
midpoint ──North_Exit──▶ EnterDungeon(seg 2)   [steppe/mont]
   ▲                        │ Cleared
   │                        ▼
   │              zone.ExitSegment ──▶ ground miniboss/guardian (cinématique)
   │                        │ ContinueDungeon(seg 1/3) = combat
   │                        ▼
   └──DefeatedBoss──── ground (retour) ──▶ midpoint / suite
```
- Steppe : seg0→midpoint→seg2→guardian ground→seg3(combat)→guardian ground→
  sortie vers Tunnel (master_zone[47]). Miniboss : entré via ExitSegment(1)
  — win/lose deux chemins écrits (DefeatedBoss→midpoint, DiedToBoss→entrance).
- Tunnel : seg0→miniboss ground (ContinueDungeon 1)→seg1→ExitSegment(1)→
  crucible ground (cinématique Magcargo)→ContinueDungeon(2)=combat→retour.
- Mont : seg0→midpoint→seg2→guardian ground→seg3→victoire = fin d'expédition
  (Chapter=6 posé dans zone init ET mount_windswept_guardian_ch_5 — cohérent).
- Tous les `EndDungeonRun(master_zone, -1, N)` vérifiés : ground[1]=metano_town,
  [6]=guild_dining_room, [22]=guild_second_floor, [46]=vast_steppe_entrance,
  [47]=searing_tunnel_entrance, [48]=searing_tunnel_midpoint,
  [49]=searing_crucible, [50]=mount_windswept_entrance. ✅ aucun index cassé.
- 27 scripts Lua ch5 : syntaxe OK (lupa), strings.resx + strings.fr.resx
  présents partout où MapStrings est utilisé.

## 4. Grounds ch5 — inventaire complet avec provenance

| Ground | Rôle | Dim (cellules 8px) | Provenance | Tilesets |
|---|---|---|---|---|
| vast_steppe_entrance | camp d'entrée Steppe | 64×64 | **création New Era** | Vast_Steppe_* (4 feuilles) |
| vast_steppe_midpoint | relais (Kangourex) | 99×66 | **importé DumpAsset : `cliff_camp`** (relais officiels 1ad6675) | CliffCamp |
| vast_steppe_miniboss | cinématique mini-boss | 46×66 | **création New Era** (crop du biome) | VastSteppeMiniboss_* |
| vast_steppe_guardian | cinématique gardien | 46×66 | **création New Era** | VastSteppeGuardian_* |
| searing_tunnel_entrance | camp d'entrée Tunnel | 73×48 | **création New Era** | Searing_Tunnel_* |
| searing_tunnel_midpoint | relais (patron canonique) | 57×57 | **halcyon d'origine** (autotiles magma_cavern_2) | autotiles jeu de base |
| searing_tunnel_miniboss | cinématique mini-boss | 52×68 | **création New Era** | SearingTunnelMiniboss_* |
| searing_crucible | antre de Magcargo (cinématique majeure) | 63×63 | **importé DumpAsset : tileset `Spring_Cave_Pit`** | Spring_Cave_Pit |
| mount_windswept_entrance | camp d'entrée Mont | 69×63 | **création New Era** | Mount_Windswept_* |
| mount_windswept_midpoint | relais/camp de base | 144×78 | **importé DumpAsset : `canyon_camp`** (relais officiels) | CanyonCamp |
| mount_windswept_miniboss | cinématique mini-boss | 48×66 | **création New Era** | MountWindsweptMiniboss_* |
| mount_windswept_guardian | cinématique gardien (falaise) | 66×78 | **importé DumpAsset : `end_treacherous_mountain`** (tileset MountainPeak) | MountainPeak |

Audit spatial des 12 grounds : `Main_Entrance_Marker` sur cellule walkable
12/12 ; spawners TEAMMATE_1..3 présents 12/12 ; flood-fill : toutes les entités
(markers, spawners, objets interactifs) dans la composante atteignable — les
zones « non atteignables » résiduelles (entrances/miniboss) sont des poches
décoratives hors gameplay, sans entité. `$values` orphelins : 0 (post-fix).

## 5. Anomalies trouvées → corrigées dans ce commit

1. **`mount_windswept_entrance` : Kangaskhan_Rock triggerType=0** (inerte) alors
   que le script `Kangaskhan_Rock_Action` existe et que les 2 autres entrances
   sont à 1 (Action). → passé à 1.
2. **`searing_crucible` : champ Music vide** → `In the Depths of the Pit.ogg`
   (celle que le script ch5 joue) en musique par défaut du ground.
3. **`mount_windswept_entrance` : champ Music vide** → `Canyon Camp.ogg`
   (utile hors ch5 ; en ch5 les PlayBGM scriptés priment).

## 6. Limite

Validation statique (JSON/flux/flood-fill). Le test en jeu (chargement réel
par le moteur) reste à faire — aucun crash connu attendu au vu du format
canonique (identique aux grounds officiels) et du fix écran noir appliqué.
