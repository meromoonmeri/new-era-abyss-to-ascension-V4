# PMD Red European Ground authority

This directory is the reproducible, byte-level starting point for reconstructing
Pokémon Mystery Dungeon: Red Rescue Team Grounds in New Era. It supersedes
older conversion reports as evidence; those reports remain inventories only.

## Content authority

Only this ROM is accepted:

| Property | Required value |
|---|---|
| Edition | Europe `(En,Fr,De,Es,It)` |
| Size | `33,554,432` bytes |
| SHA-256 | `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd` |
| MD5 (identity only) | `9837da1fdfe900c52f2109d9718d4e85` |

The ROM itself and extracted copyrighted payloads are deliberately not stored
in this repository.

`ground_manifest.json` is generated from the ROM by
`tools/audit_pmdred_eu_rom.py`. It records every source pointer/range, parsed
header, compressed-stream boundary, semantic and physical hash, normalized
hash, map dependency, all 246 Ground conversions, all 27 direct
Ground-to-dungeon mappings, all 64 direct floor counts, decoded BMA
map/collision/data-layer hashes and counts, BPA slot check, regional comparison,
and validation result.

## Reproduce the manifest and extraction

```bash
python tools/audit_pmdred_eu_rom.py \
  "/path/to/Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It).gba" \
  --report /tmp/pmdred-eu-ground-manifest.json \
  --extract-dir /tmp/pmdred-eu-ground \
  --pret-map-bg /path/to/pmd-red/data/map_bg
```

The extraction has 724 files. BPL, BMA, and BPA files end at their decoded
semantic extent. European BPC is compressed in the ROM; extracted BPC is a
deterministic raw normalization consisting of its 16-byte header, logical tile
payload, and interleaved high/low chunk-mapping planes. It is suitable for the
existing raw BPC reader without substituting US bytes.

The committed manifest was generated without `--extract-dir`, so it does not
claim that generated binary assets are tracked. Its SHA-256 is
`02a5d8699ceef50c8195fccedcd455694121983f23869070e5b42b6dfb4e9730`.

Run the dependency-free unit suite with:

```bash
python tools/test_pmdred_eu_audit.py -v
```

Set `PMDRED_EU_ROM` to the authoritative ROM path to enable the additional
full-ROM deterministic-report reproduction test.

## Validate the PMDO graphical conversion

Install the converter's pinned image dependency, then validate all 262 EU
map-file dependency rows without writing game assets:

```bash
python -m pip install -r tools/requirements-pmdred.txt
python tools/convert_red_all.py \
  --source-dir /tmp/pmdred-eu-ground \
  --report /tmp/pmdred-eu-conversion-validation.json
```

The converter verifies every input file against the manifest before use. It
consumes only the normalized EU extraction, reproduces all visual BMA layers,
BPC flips/palettes, BPL palette cycles, BPA tile cycles (including the GBA BPA
post-decrement timer), and BMA collision, and never silently substitutes a US
resource or invented border. All four BPA dependency slots (including gaps) are
retained in rendering and provenance. The graphical converter deliberately
creates no entrance marker: entrances belong to event/script reconstruction,
so a guessed walkable center would be fabricated evidence. `--apply` is
required to change reserve assets; the default is a no-write exhaustive
validation.

The committed `conversion_validation.json` is the no-write result for all 262
rows: zero failures. Its SHA-256 is
`3a638e0da12909d6abe96f45a44841f537f1ac5a0beaa05f7f6b710aa3ce0d94`.
This establishes deterministic conversion coverage, not visual approval or
scene/event completeness.

## Proven Ground archive results

- Ground archive: ROM offset `0x01A20000`, address `0x09A20000`, magic
  `pksdir0`.
- 724 unique, lexicographically sorted records: 262 BPL, 194 BPC, 201 BMA,
  and 67 BPA.
- EU map dependency table: ROM offset `0x00275CDC`, 262 records, seven pointers
  per record (BPL, BPC, BMA, BPA slots 0–3).
- EU Ground conversion table: ROM offset `0x002792B4`, 246 records. Its next
  bytes begin the adjacent `__ground_amd` string pool; it references 246 unique
  map-file IDs through 254. It must not be used as the dependency-table bound.
- Direct map-to-dungeon table: ROM offset `0x00274A04`, 27 records followed by
  its `-1` sentinel. These records exactly cover conversion types 10 and 11.
- Direct dungeon floor-count table: ROM offset `0x002194B4`, 64 bytes.
- All 724 resources parse and all 262 dependency records validate.
- All 213 decoded visual map layers, 26 interaction/data layers, and 152
  collision layers have deterministic decoded hashes; collision metadata also
  records exact solid/walkable cell counts.
- All 724 archive resources are named by the complete regional dependency
  table. The former 245-row truncation falsely classified 55 as unreferenced.
- No decoder reads beyond the next archive pointer.
- Nine records have eight bytes beyond ordinary four-byte alignment before the
  next pointer. These bytes are preserved as physical-range provenance but are
  not part of the decoded semantic payload.
- Wish Cave `D23P01c` ends at relative byte 3,639 and has one archive-alignment
  byte before `D23P01m`. Its normalized payload is identical to pret's raw US
  payload after ignoring pret's two trailing zero-padding bytes.

## Important BPC decoder correction

An earlier temporary audit incorrectly used `(command & 0x3F) + 1` for every
BPC chunk-plane command. The EU routine at `0x080A9BFC` instead gives the zero
class (`0x00..0x7F`) a seven-bit run length of `command + 1`; only repeat and
literal classes (`0x80..0xFF`) use six-bit lengths. The bad mask split canonical
zero runs, consumed later bytes as commands, and falsely reported 25 pointer
overreads (including a false one-byte overlap for `A01P01c`).

The repository decoder follows the instruction flow directly and has a focused
regression test for command `0x7F`. With the corrected semantics:

- every BPC plane reaches its declared target without output overshoot;
- all 194 BPC streams end at or before the following archive pointer;
- `A01P01c` has semantic extent 13,997 bytes within a 14,000-byte pointer span;
- `D23P01c` retains the independently established 3,639-byte semantic extent.

This correction is why executable semantics and exhaustive normalized
comparison are both required; a parser merely reaching the end is not proof.

## EU versus pret US payloads

The optional comparison uses the normalized EU semantic payload and does not
count trailing US zero padding as a content difference:

| Outcome | Count |
|---|---:|
| Exact semantic payload | 452 |
| Same payload, pret has trailing zero padding only | 215 |
| Genuine content difference | 7 |
| EU-only resource | 50 |

The seven shared-name differences are `S02`, `S02c`, `S02m`, `S05`, `S05c`,
`S05m`, and `T01P01c`. The S-series differences are regional content. The EU
`T01P01c` differs in only three chunk entries and must not be overwritten by
its US counterpart.

The 50 EU-only resources include localized `S02`, `S05`, and `S06` triplets,
regional `A05P03` variants, `B01P00A`, and `T01P00`. The US reference has only
`T01P06`, `T01P06c`, and `T01P06m` absent from Europe. Exact lists and per-file
hashes are in the manifest.

## Direct dungeon-backed Ground reconstruction

The separate runtime path used for dungeon summits, midpoints, relays, and
fixed boss/story maps is reconstructed by:

- `tools/pmdred_dungeon_ground.py` — bounds-checked `pksdir0`, SIRO, strict
  pret-equivalent AT4PX, `mapparam`, CANM, BMA terrain, 64-column CEX/EMAP
  composition, GBA palette quantization, and deterministic rendering;
- `tools/reconstruct_pmdred_dungeon_grounds.py` — all-27 orchestration and
  evidence/report generation;
- `tools/validate_pmdred_dungeon_ground_bundle.py` — independently reloads the
  supplied ROM and freshly rederives Ground mappings, names, floor counts, BMA
  data, selectors/properties, all compressed resources, chunk composition,
  tick-zero pixels, animation metadata, PNGs, and decoded APNG frames before
  comparing every artifact and file hash;
- `tools/test_pmdred_dungeon_ground.py` — synthetic format/timing regressions
  plus ROM-gated all-stream and all-mapping assertions.

Install the pinned dependencies and reproduce the committed bundle:

```bash
python -m pip install -r tools/requirements-pmdred.txt
python tools/reconstruct_pmdred_dungeon_grounds.py \
  "/path/to/Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It).gba" \
  /tmp/pmdred-dungeon-grounds \
  --max-animation-frames 8
python tools/validate_pmdred_dungeon_ground_bundle.py \
  "/path/to/Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It).gba" \
  /tmp/pmdred-dungeon-grounds
```

The default reconstruction performs a differential comparison of every AT4PX
stream in the EU dungeon archive: 136 direct and 68 SIRO-rooted streams, all
204 byte-identical to `skytemple-files` after decompression. The direct Ground
PAL loader publishes its 192 source colors first (forcing each palette's color
0 black), then initializes CANM timers without publishing their first colors.
`sub_80A3BB0(groundBg, 0)` only initializes map-render contexts. Therefore the
committed tick-0 PNGs use the raw PAL; CANM color 0 first becomes visible at its
record's initial timer expiry.

The illustrated all-27 relationship index and per-Ground evidence are in
[`dungeon_grounds/report.md`](dungeon_grounds/report.md). The bundle records all
independent palette cycles and their exact steady periods; APNGs are bounded,
exact startup-prefix previews rather than an impractical expansion of the
cycles' global least common multiples. The separate
[`direct_ground_visual_review.md`](direct_ground_visual_review.md) records the
human inspection of all 27 tick-zero renders and all 131 stored preview states.

## Scope boundary

This manifest proves Ground graphical archive and dependency-table extraction.
It does **not** by itself prove a PMDO Ground, event, transition, collision
interaction, cutscene, dungeon, or music assignment. Those require subsequent
EU-backed conversion and visual/spatial/functional/musical validation. A
successful load is not accepted as completion.
