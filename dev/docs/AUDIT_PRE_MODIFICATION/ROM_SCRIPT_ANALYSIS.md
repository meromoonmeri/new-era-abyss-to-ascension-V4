# ROM — ANALYSE DES SCRIPTS (SSB/SSA/SSE GBA & NDS)

État consolidé (chaîne déjà en production, preuves antérieures) + points donjons.

## 1. NDS Sky
- SSE/SSA (grounds, acteurs, objets, triggers) : extraits via skytemple/ndspy ; positions 1:1 pixel (x_absolute/y_absolute) ; 118 grounds NDS importés + skyscenes Lua compilés (`Data/Script/halcyon/skyscenes/*` — ex. d22p11a__enter00/m19a0201 : scènes de Dusk Forest ↔ scripts ROM m19a*).
- SSB (dialogues/cutscenes) : convertis en scènes Lua (skyscenes/redscenes), preuve runtime `skyscene:<module>@<ground>` + journeys 14 chapitres.
- PARTIAL documentés : T00P01/enter04 (debug room ROM), s30a0601 (loterie), m00a01a (init titre), unionall NO_DEF0, d105/d106/d171-173 (Dummy ROM) — classés DEV_ONLY/UNUSED côté ROM elle-même.
- Scripts DONJON Sky (boss, cutscenes d'étage) : redirigés vers scènes Lua par zone (`zone/<name>/init.lua` + skyscenes progression) — pattern IR→Lua, pas de hardcode par étage.

## 2. GBA Red
- Cutscenes donjons (dungeon_cutscene_*.c : groudon, kyogre, rayquaza, etc.) : reproduites en scènes Lua (redscenes) validées par RED_GLOBAL_JOURNEY_PASS (boss Skarmory→…→Rayquaza).
- Grounds direct GBA : 27 dossiers `dev/RESERVE/pmdred_direct/scripts/` (animation_metadata + callbacks CANM adaptés).

## 3. Conformité §30/§11 (pas de hardcode inutile)
- Représentation intermédiaire : oui (tables extraites → JSON → Lua généré/écrit).
- Hardcodes arbitraires : non détectés dans la couche donjons (zones = data ; scripts = par-zone init standardisé).
- `ScriptZoneStep` (7 zones) : usages justifiés (événements SV-dépendants), même pattern que DoubleTrio ZONE_GEN_SCRIPT.

## 4. Écarts scripts liés aux donjons à traiter
1. Aucun script hidden-stairs (mécanique absente, cf. R11).
2. Événements « visiteurs » type DoubleTrio SpawnStoryNpc : possibles via ScriptZoneStep si le canon Sky le requiert (missions Spinda café — hors périmètre donjon-gen).
