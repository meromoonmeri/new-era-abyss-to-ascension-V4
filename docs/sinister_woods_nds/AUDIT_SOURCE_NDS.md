# AUDIT DÉFINITIF — Sinister Woods NDS → New Era (phase audit only)

**Date :** 2026-08-10
**ROM SOURCE_NDS :** Blue Rescue Team Europe `APHP` (32 MiB)
**sha256 :** `2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05`
**Règle :** `Data/Zone/gloomy_forest.json` **FROZEN** — non modifié par cet audit.

## Réponse à la question de contrôle

> Est-ce réellement Sinister Woods NDS reconstruit dans New Era ?

**Non. Ce n’est pas un port.** C’est un audit SOURCE_NDS avec extractions prouvées
(floor_id, FloorProperties, spawns monstre, graphismes AT4PX). La conversion PMDO est **bloquée**.
Interdit de dire « Sinister Woods est porté » / « port complet ».

## Chaîne NDS réalisée
```
Blue ROM APHP
 → FNT/FAT (dungeon.sbin, ground.sbin, sound.sbin, …)
 → dungeon.sbin TOC → mapparam + b00..b75 + zmappat + …
 → mapparam SIR0
     dungeon#3 floor_id u16[8]×13 @ 0x160     SOURCE_NDS
     FloorProperties[MainData] 28B @ 0x7380+   SOURCE_NDS
     SpawnPokemonData 8B/entry (Blue)          SOURCE_NDS
 → AT4PX/PX decompress b10* / b41*              SOURCE_NDS_DECODED
 → ground.sbin B10P01* / B10P02*               SOURCE_NDS (scripts UNKNOWN)
```

## Provenance
| Tag | Sens |
|---|---|
| SOURCE_NDS | Octets Blue ROM |
| CROSS_REFERENCE_RED | pret/pmd-red (noms de champs / concordance) |
| DERIVED_MAPPING | tileset id N → blob `b{N:02d}` |
| PMDO_VALUE | New Era actuel |
| UNKNOWN | Non prouvé |

## Floors F1–F13 — FloorProperties (SOURCE_NDS)

| F | MainData | PokéTbl | tileset | music | layout | roomDensity | enemyDensity | MH% | shop% | sticky% | deadEnds | extraHall | buried | vis | ==Red |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 17 | 10 | 41 | 4 | 11 | 7 | 5 | 0 | 0 | 0 | False | 6 | 0 | 0 | True |
| 2 | 18 | 11 | 41 | 4 | 11 | 6 | 5 | 0 | 0 | 0 | False | 8 | 0 | 0 | True |
| 3 | 19 | 12 | 41 | 4 | 11 | 7 | 5 | 0 | 0 | 0 | False | 8 | 0 | 0 | True |
| 4 | 20 | 13 | 41 | 4 | 11 | 7 | 5 | 0 | 0 | 0 | False | 10 | 0 | 0 | True |
| 5 | 21 | 14 | 41 | 4 | 0 | 8 | 6 | 0 | 0 | 0 | True | 10 | 0 | 2 | True |
| 6 | 22 | 15 | 41 | 4 | 0 | 9 | 6 | 0 | 0 | 0 | True | 10 | 0 | 2 | True |
| 7 | 23 | 16 | 41 | 4 | 11 | 10 | 6 | 0 | 0 | 0 | True | 15 | 0 | 2 | True |
| 8 | 24 | 17 | 41 | 4 | 1 | 11 | 6 | 0 | 0 | 0 | True | 15 | 0 | 0 | True |
| 9 | 25 | 17 | 41 | 4 | 11 | 12 | 6 | 0 | 0 | 0 | True | 15 | 0 | 0 | True |
| 10 | 26 | 18 | 41 | 4 | 0 | 12 | 6 | 0 | 0 | 0 | True | 15 | 0 | 0 | True |
| 11 | 27 | 19 | 41 | 4 | 0 | 12 | 6 | 0 | 0 | 0 | True | 15 | 0 | 2 | True |
| 12 | 28 | 20 | 41 | 4 | 0 | 12 | 6 | 0 | 0 | 0 | True | 15 | 0 | 2 | True |
| 13 | 29 | 21 | 65 | 0 | 0 | 10 | 0 | 0 | 0 | 0 | True | 15 | 0 | 0 | True |

Concordance Red (cross-check only) : floor_id **PASS**, FloorProperties bytes **PASS**.

## Pokémon (SOURCE_NDS ids+weights; names CROSS_REFERENCE_RED)

Entry size Blue = **8 bytes** (`u16 bits`, `s16 w0`, `s16 w1`, `u16 pad0`).
species=`bits&0x1FF`, level=`(bits>>9)&0x7F`. Terminator: KECLEON/DECOY zero weights.

### F1
- `ODDISH` id=43 Lv7 cumulative_weights=(1579,1579)
- `SUDOWOODO` id=185 Lv7 cumulative_weights=(5789,5789)
- `SWINUB` id=245 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F2
- `ODDISH` id=43 Lv7 cumulative_weights=(1364,1364)
- `SUDOWOODO` id=185 Lv7 cumulative_weights=(5000,5000)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(6364,6364)
- `SWINUB` id=245 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F3
- `ODDISH` id=43 Lv7 cumulative_weights=(1000,1000)
- `SENTRET` id=161 Lv6 cumulative_weights=(3667,3667)
- `SUDOWOODO` id=185 Lv7 cumulative_weights=(6333,6333)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(7333,7333)
- `SWINUB` id=245 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F4
- `ODDISH` id=43 Lv7 cumulative_weights=(937,937)
- `SENTRET` id=161 Lv6 cumulative_weights=(3437,3437)
- `SUDOWOODO` id=185 Lv7 cumulative_weights=(5937,5937)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(6875,6875)
- `SILCOON` id=291 Lv8 cumulative_weights=(8437,8437)
- `CASCOON` id=293 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F5
- `SENTRET` id=161 Lv6 cumulative_weights=(3810,3810)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(5238,5238)
- `SILCOON` id=291 Lv8 cumulative_weights=(7619,7619)
- `CASCOON` id=293 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F6
- `SENTRET` id=161 Lv6 cumulative_weights=(2759,2759)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(3793,3793)
- `SILCOON` id=291 Lv8 cumulative_weights=(5517,5517)
- `CASCOON` id=293 Lv8 cumulative_weights=(7241,7241)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F7
- `LEDYBA` id=165 Lv7 cumulative_weights=(2400,2400)
- `SUNFLORA` id=192 Lv8 cumulative_weights=(3600,3600)
- `LINOONE` id=289 Lv8 cumulative_weights=(6800,6800)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F8
- `SCYTHER` id=123 Lv10 cumulative_weights=(2286,2286)
- `LEDYBA` id=165 Lv7 cumulative_weights=(4000,4000)
- `WOOPER` id=194 Lv10 cumulative_weights=(5429,5429)
- `LINOONE` id=289 Lv8 cumulative_weights=(7714,7714)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F9
- `SCYTHER` id=123 Lv10 cumulative_weights=(2286,2286)
- `LEDYBA` id=165 Lv7 cumulative_weights=(4000,4000)
- `WOOPER` id=194 Lv10 cumulative_weights=(5429,5429)
- `LINOONE` id=289 Lv8 cumulative_weights=(7714,7714)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F10
- `EXEGGUTOR` id=103 Lv8 cumulative_weights=(1569,1569)
- `SCYTHER` id=123 Lv10 cumulative_weights=(3137,3137)
- `HOOTHOOT` id=163 Lv6 cumulative_weights=(4706,4706)
- `LEDYBA` id=165 Lv7 cumulative_weights=(5882,5882)
- `WOOPER` id=194 Lv10 cumulative_weights=(6863,6863)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(8431,8431)
- `SLAKOTH` id=312 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F11
- `EXEGGUTOR` id=103 Lv8 cumulative_weights=(2000,2000)
- `SCYTHER` id=123 Lv10 cumulative_weights=(4000,4000)
- `HOOTHOOT` id=163 Lv6 cumulative_weights=(6000,6000)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(8000,8000)
- `SLAKOTH` id=312 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F12
- `EXEGGUTOR` id=103 Lv8 cumulative_weights=(2500,2500)
- `HOOTHOOT` id=163 Lv6 cumulative_weights=(5000,5000)
- `SHROOMISH` id=310 Lv9 cumulative_weights=(7500,7500)
- `SLAKOTH` id=312 Lv8 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**
### F13
- `EKANS` id=23 Lv15 cumulative_weights=(3333,3333)
- `GENGAR` id=94 Lv15 cumulative_weights=(6667,6667)
- `MEDICHAM` id=333 Lv12 cumulative_weights=(10000,10000)
- `KECLEON` id=380 Lv90 **terminator/special**

## Graphismes

| Élément | Statut |
|---|---|
| FloorProperties.tileset | **41** SOURCE_NDS |
| Blobs procéduraux | **b41** fon/cel/cex AT4PX décodés (DERIVED_MAPPING id→nom) |
| b10 fon/cel/cex | Décodeés mais **non** sélectionnés par tileset=41 |
| b10/b41 canm | SIR0 sans AT4PX — sémantique UNKNOWN |
| b10/b41 pal | RAW 768 B BGR555 |
| ground B10P01/P02 | Extraits ground.sbin — scripts UNKNOWN |

## Musique
- bgMusic=**4** (SOURCE_NDS F1–F12)
- SEQ SDAT / loop : **UNKNOWN**

## UNKNOWN (bloque la conversion)
1. Payloads tables items (indices 11–12 connus)
2. Payloads traps (index 2)
3. bgMusic 4 → sound.sbin
4. canm animations
5. Scripts ground B10P01/P02 + Team Meanies
6. Formule exacte weight→probabilité (valeurs NDS extraites; mapping % optionnel)

## Outils
| Outil | Exit actuel |
|---|---|
| `tools/audit_blue_sinister.py` | 0 |
| `tools/verify_sinister_fidelity.py` | 2 (A=UNKNOWN) |
| `tools/convert_blue_sinister.py` | 1 BLOCKED |

## Verdict
**SOURCE FIDELITY port = NOT PASS / UNKNOWN.**
**gloomy_forest.json non modifié.**
