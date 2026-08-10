# TEMPLATE POINTS MÉDIANS — MODÈLE DE RÉFÉRENCE + REGISTRE (ch.6-32)

**Date** : 2026-08-10
**Branche** : `arena/019fd882-new-era-abyss-to-ascension-v4`
**Décision** : structure fixe partagée / habillage variable par biome (remplace
l'exigence d'unicité totale de structure pour les points médians).

---

## PARTIE A — MODÈLE DE RÉFÉRENCE : POINT MÉDIAN DU TUNNEL ARDENT

### A.1 Structure réelle vérifiée (fichiers, pas analogie)

**Ground** : `Data/Ground/searing_tunnel_midpoint.rsground`
**Script** : `Data/Script/halcyon/ground/searing_tunnel_midpoint/init.lua` +
`searing_tunnel_midpoint_ch_5.lua`

| Élément | Valeur réelle | Rôle |
|---|---|---|
| **Statue Kangourex** | `Kangaskhan_Rock` (GO, trigger:1) à **(216,228)** | Repère central + service (stockage/banque/sauvegarde) |
| **Sortie Sud** | `South_Exit` (192,384, 72×8, trigger:2) | Retour vers la 1re moitié / entrée |
| **Sortie Nord** | `North_Exit` (192,112, 72×8, trigger:2) | Reprise vers la 2e moitié (segment suivant) |
| **Arrivée joueur** | `Main_Entrance_Marker` (220,320, dir 4) | Point d'entrée |
| **Équipe** | Spawners `TEAMMATE_1/2/3` (220,352 / 172,292 / 268,292) | Placement des alliés |
| **Ambiance** | `GROUND:AddMapStatus("steam")` (Init) | Habillage biome (vapeur) |
| **Musique** | `Lower Spring Cave.ogg` | Ambiance |

### A.2 Fonction de la statue (restauration / service)

`Kangaskhan_Rock_Action(obj, activator)` → `GeneralFunctions.Kangashkhan_Rock_Interact`
(GeneralFunctions.lua:2318) : menu « Qu'aimeriez-vous faire ? » → **Stockage,
Retrait, Tout stocker, Banque, Sauvegarder et quitter**.
→ La statue Kangourex est le **service central** du point médian (pas de
restauration automatique de PP/estomac dans le code du modèle : la restauration
se fait via le clear-check des relais — voir A.4 — et le rocher pour le stockage).

### A.3 Mécanisme de respawn (cinématique sobre)

**Variable** : `SV.SearingTunnel.DiedPastCheckpoint` — **déclarée** dans
`scriptvars.lua` (bloc `SV.SearingTunnel`, l.1232-1236).

**Zone** (`zone/searing_tunnel/init.lua`) :
- mort/abandon dans la 2e moitié → `SV.SearingTunnel.DiedPastCheckpoint = true`
  + `EndDungeonRun(result, "master_zone", -1, GROUND_IDX('searing_tunnel_midpoint'), ...)`.

**Ground** (`searing_tunnel_midpoint/init.lua` PlotScripting) :
- `if SV.SearingTunnel.DiedPastCheckpoint then` → `WipedCutscene()`.

**WipedCutscene** (`searing_tunnel_midpoint_ch_5.lua:333`) :
1. `GAME:FadeOut(false, 1)` (noir déjà posé, no-op sinon — corrige l'aperçu de zone).
2. Téléportation de l'équipe autour du rocher (208,176 / 232,176 / 204,208 / 236,208).
3. Animations **EventSleep / Sleep** (cycle décalé 10 frames).
4. Caméra → `MoveCamera(228,200,1,false)`, `FadeIn(40)`, BGM.
5. Attente 110 frames (sommeil).
6. Réveils décalés (`Wake` + `CharAnimateTurnTo`).
7. Dialogue bref (« Urf... Where are we? » — sobre, pas narratif fort).
8. `SV.SearingTunnel.DiedPastCheckpoint = false`, main rendue.

### A.4 Note : les « relais-étages » (.rsmap) restaurent via clear-check

`crystal_sanctuary_relay` / `forgotten_marsh_relay` (.rsmap, floors de donjon) :
`LuaBeginBattleEvent` + 0 MapTeams → le clear-check passe → `FullRestore()` de
l'équipe + `EndSegment(Cleared)`. **C'est un design volontaire** : le relais
restaure l'équipe (zone de repos in-dungeon) puis enchaîne. (B4 de l'audit
précédent = reclassé : pas un bug.)

---

## PARTIE B — REGISTRE DE SUIVI DES POINTS MÉDIANS (ch.6-32)

| Point médian | Donjon / ch. | Statue | Respawn | Variable SV (déclarée ?) | Statut |
|---|---|---|---|---|---|
| searing_tunnel_midpoint | Tunnel Ardent (ch.5, modèle) | ✅ | ✅ WipedCutscene | `SV.SearingTunnel.DiedPastCheckpoint` ✅ | **CONFORME (référence)** |
| vast_steppe_midpoint | Grande Steppe (ch.5) | ✅ | ✅ WipedCutscene | `SV.Chapter5.SteppeMidState` ✅ | CONFORME |
| mount_windswept_midpoint | Mont Venteux (ch.5) | ✅ | ✅ WipedCutscene | `SV.Chapter5.WindsweptMidState` ✅ | CONFORME |
| poisonous_forest_relay | Marais (ch.9) | ✅ | ✅ MidpointTemplate.DeathArrival | `SV.Chapter9.MarshMidState` ✅ | CONFORME |
| cloven_ruins_midpoint | Aegis Cave (ch.5) | ✅ | ✅ MidpointTemplate | `SV.Chapter5.RuinsMidState` + `SV.Ruines.*` ✅ | CONFORME (+ corrections SV.Ruines) |
| gloomy_forest_midpoint | Forêt Sombre (ch.6) | ✅ | ✅ WipedCutscene | `SV.GloomyForest.DiedPastCheckpoint` + `SV.Chapter6.Dazzling*` ✅ | CONFORME (+ corrections Dazzling) |
| crooked_cavern_midpoint | Caverne Tortueuse (ch.3) | ✅ | ✅ WipedCutscene | `SV.CrookedCavern.DiedPastCheckpoint` + `SV.Chapter3.Crooked*` ✅ | CONFORME (+ corrections Crooked) |
| **frosty_forest_midpoint** | Forêt Givrée (canon PMD Red) | ✅ | ✅ **QuickWake (ajouté ce jour)** | `SV.FrostyForest.DiedPastCheckpoint` ✅ (ajouté) | **CORRIGÉ** (respawn manquant → ajouté) |
| **mt_blaze_midpoint** | Mont Cendré (canon PMD Red) | ✅ | ✅ **QuickWake (ajouté ce jour)** | `SV.MtBlaze.DiedPastCheckpoint` ✅ (ajouté) | **CORRIGÉ** (respawn manquant → ajouté) |
| **mt_freeze_midpoint** | Mont Gelé (canon PMD Red) | ✅ | ✅ **QuickWake (ajouté ce jour)** | `SV.MtFreeze.DiedPastCheckpoint` ✅ (ajouté) | **CORRIGÉ** (respawn manquant → ajouté) |
| mt_thunder_midpoint | Col Foudre (job board) | ✅ | — | — | ⚠️ **ORPHELIN** (ground créé, jamais branché — pas de midpoint dans le flux col_foudre) |

### Habillage par biome (structure fixe / habillage variable)

| Point médian | Statut | Musique | Particules/ambiance |
|---|---|---|---|
| searing_tunnel | steam | Lower Spring Cave.ogg | vapeur |
| vast_steppe | — | (biome steppe) | herbes |
| mount_windswept | — | (biome montagne) | vent |
| poisonous_forest_relay | mysterious_distortion | Cave Camp.ogg | brume malsaine |
| cloven_ruins_midpoint | — | In the Depths of the Pit.ogg | ruines |
| gloomy_forest_midpoint | gloom | (biome forêt sombre) | brume |
| crooked_cavern_midpoint | — | (biome caverne) | — |
| frosty_forest_midpoint | winter_snow | Snowbound Path.ogg (réveil) | neige |
| mt_blaze_midpoint | falling_ash | Mt. Horn.ogg (réveil) | cendres |
| mt_freeze_midpoint | winter_snow | Glacial Path.ogg (réveil) | glace |

---

## PARTIE C — CORRECTIONS APPLIQUÉES CE JOUR (commit à venir)

1. **scriptvars.lua** : 14 variables ajoutées/déclarées :
   - `SV.Chapter3.CrookedPlayedMidpointIntro`, `SV.Chapter3.CrookedMidpointState`
   - `SV.Chapter6.DazzlingChapterResolved`, `DazzlingEntranceSeen`,
     `DazzlingPresenceStage`, `DazzlingRelayClueSeen`
   - `SV.Ruines.VaincuRegigigas`, `TourRevelee`, `SceneS04P1901Complete`,
     `SceneS04P1902Pending`, `SceneS04P1902Complete`
   - `SV.FrostyForest.DiedPastCheckpoint`, `SV.MtBlaze.DiedPastCheckpoint`,
     `SV.MtFreeze.DiedPastCheckpoint`
   *(le fameux `SV.Chapter7.RuinsRespawnArena` était déjà déclaré ; la famille
   `SV.Ruines.*` de la révélation finale ne l'était PAS → corrigé.)*
2. **MidpointTemplate.lua** : ajout de `QuickWake(cfg)` — réveil sobre réutilisable
   (noir → équipe au sol → sommeil → fondu → réveil → dialogue bref → main).
3. **Zones** frosty_forest / mt_blaze / mt_freeze : mort/abandon au-delà du
   midpoint (segment ≥ 1) → flag `DiedPastCheckpoint` + retour au midpoint
   (au lieu de la ville). Helper `GROUND_IDX` par nom ajouté à chaque zone.
4. **Midpoints** frosty_forest / mt_blaze / mt_freeze : `Enter` lit le flag →
   `QuickWake` (réveil au pied de la statue), puis consommation du flag.
5. **B4** (audit précédent) : reclassé — les relais-étages restaurent via
   clear-check volontaire, pas un bug.

## PARTIE D — RESTE À FAIRE

- **RUNTIME (REQUIRES_RUNTIME)** : tester en jeu — entrer dans la 2e moitié de
  frosty_forest/mt_blaze/mt_freeze, subir un KO, vérifier le réveil au midpoint
  avec la cinématique QuickWake (fondu, sommeil, dialogue), et la reprise.
- **mt_thunder_midpoint** : décider (brancher sur col_foudre en vrai midpoint,
  ou supprimer/documenter comme non utilisé).
- **Restauration PP/estomac** : le modèle ne restaure pas automatiquement (seule
  la statue = stockage) ; les relais-étages restaurent via clear-check. Si une
  restauration explicite est souhaitée sur les midpoints-grounds, l'ajouter au
  template (documenté, non implémenté pour ne pas dévier du modèle).
