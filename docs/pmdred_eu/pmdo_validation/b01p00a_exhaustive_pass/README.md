# b01p00a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p00a` is the canonical EU basic Pikachu rescue-team-base exterior (`MAP_TEAM_BASE_PIKACHU_BASIC`; map ID 9, map-file/place/debug ID 10). The authenticated v2.0.1-eu candidate was loaded by exact PMDO 0.8.12 in an isolated fixture, compared against the independent raw-EU-ROM renderer, read back from the promoted destinations, and indexed again by exact PMDO. The canonical destination and same-ID reserve paths were absent, so no existing asset, script, route, or reserve generation was replaced.

It is classified separately as an ordinary rescue-team-base exterior (`cinematic=false`, `arena=false`, `boss=false`). This Ground-only milestone does not claim dialogue, choreography, music, story routing, or weather behavior beyond the canonical rendered state.

## Exhaustive evidence

| Gate | Result |
|---|---:|
| Exact runtime | PMDO 0.8.12, executable `faf9755c…` |
| Active patched SDL | authenticated reproducible `2cec7b5f…` |
| Native validator events | 97; terminal `end` seen |
| Primary/reload loads | 2/2 `LOAD_PASS`, 2/2 `SAFE` |
| Primary samples | 24 boundary samples, ticks 0–83 |
| Reload samples | tick 0 |
| Full-RGBA comparisons | **25/25 pixel-exact** |
| Fully opaque captures | **25/25** |
| Mismatched pixels / max delta | **0 / 0** |
| Unique primary RGBA frames | 6 |
| BPA animation | one channel, 6 frames × 7 ticks |
| Cycle coverage | two complete 42-tick local cycles |
| Collision | one layer, 3,652 solid cells; movement and blocking pass |
| Lifecycle | entry, exit, same-Ground re-entry, cleanup, unload/reload pass |
| State leakage/stale assets/orphans/locks | none observed |
| Post-promotion indexing | exact-PMDO pass, log `3df47e3b…` |

`report.json` contains metrics for every sample. The bundle tracks representative actual and side-by-side comparative PNGs for primary tick 0, final boundary tick 83, and reload tick 0. All 25 full images—not only those representatives—were compared in RGBA form.

## Promotion and preservation

- `Data/Ground/b01p00a.rsground`: `5b52c0152eac8352bc364e362113d1ff9f73f710d558a64a06ba93d11aa4b449`
- `Content/Tile/b01p00a_Base.tile`: `d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`
- `Data/Zone/master_zone.json`: one insertion after `t01p07`, canonical index 141; BOM preserved; post-edit SHA-256 `b7c0b933…`
- absence/preservation record: `RESERVE/pmdred_pre_promotion/b01p00a/README.md`
- immutable v2.0.0 history and active v2.0.1 candidate reports remain distinct and retained.

## Durable contents

`validation_record.json`, `promotion_record.json`, and `provenance.json` hold the full identity, runtime, visual, animation, collision, lifecycle, classification, destination, and hash record. `report.json`, `events.jsonl`, logs, representative PNGs, and `commands.sh` preserve machine-readable evidence and exact reproduction. `evidence_hashes.sha256` protects the bundle and promoted/dependency inputs.

Resume from `docs/pmdred_eu/pmdo_validation/RESUME.md`; this promotion raises progress to 12/219 and leaves `b01p01a` next.
