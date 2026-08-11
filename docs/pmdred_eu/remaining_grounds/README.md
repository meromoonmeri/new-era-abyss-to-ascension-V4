# PMD Red EU — remaining Ground candidate reconstruction

## Milestone boundary

This directory records the first, deliberately non-destructive milestone for the
**219 canonical archive-backed Grounds**. The 27 conversion-type 10/11 Grounds
are excluded because they have their own exact-PMDO validation bundle.

This milestone proves candidate generation, complete source-local graphical
readback, canonical BMA collision, and full reconciliation with the preserved
legacy reserve. It does **not** yet claim exact-PMDO loading, canonical event
scripts/entities, music, entries/exits, transitions, or completed integration.
Those remain mandatory before any candidate can replace a preserved asset.

No file under `RESERVE/red_grounds/` or `RESERVE/red_tiles/` was modified.
Generated candidates were kept under the ignored
`.runtime-cache/pmdred-eu-remaining-regenerated/` staging root.

## Authority and reproducibility

- ROM SHA-256: `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`
- Normalized resource/dependency authority: `../ground_manifest.json`
- Converter: `tools/convert_red_all.py`, version `2.0.0-eu`
- Authenticated candidate generation: `conversion_report.json`
- Exhaustive candidate/readback reconciliation: `candidate_audit.json`

The converter now refuses `--apply` unless the caller chooses either:

1. a non-destructive `--output-root`, or
2. the explicit destructive escape hatch `--promote-legacy-reserve`.

The canonical subsets are selected from the ROM-derived conversion table with
`--conversion-set remaining|direct|all`; filenames or the legacy inventory do
not define membership.

Reproduction after extracting the authenticated EU archive:

```bash
python tools/convert_red_all.py \
  --source-dir .runtime-cache/pmdred-eu-ground-extraction \
  --manifest docs/pmdred_eu/ground_manifest.json \
  --conversion-set remaining \
  --apply \
  --output-root .runtime-cache/pmdred-eu-remaining-regenerated \
  --report .runtime-cache/pmdred-eu-remaining-regenerated/conversion_report.json

python tools/audit_pmdred_remaining_candidates.py \
  --source-dir .runtime-cache/pmdred-eu-ground-extraction \
  --candidate-root .runtime-cache/pmdred-eu-remaining-regenerated \
  --output .runtime-cache/pmdred-eu-remaining-regenerated/audit.json
```

## Exhaustive result

| Check | Result |
|---|---:|
| Canonical remaining conversions | 219 |
| Successfully regenerated | 219 |
| Candidate failures | 0 |
| Source chunk-cell ticks evaluated | 1,317,611 |
| Candidate tile/tick comparisons | 11,858,469 |
| Exact graphical comparisons | 11,858,469 |
| BMA collision streams | 183 one-layer, 36 no-layer |
| Grounds with animated cells | 125 |
| Grounds retaining separate BMA unknown-data evidence | 15 |

For every Ground, the audit:

1. resolves the exact `map_file_id` from the ROM-derived conversion table;
2. authenticates every normalized BPL/BPC/BMA/BPA dependency by manifest hash;
3. authenticates both generated files against the conversion report;
4. decodes each source graphical cell and compares every 8×8 PMDO tile at
   every source-local animation tick, including palette and BPA timing;
5. verifies camera dimensions, tile schedule references, and sheet coverage;
6. independently decodes BMA auxiliary/collision streams, verifies every PMDO
   obstacle tag and bound, and never reinterprets unknown BMA data as collision;
7. confirms that the graphics-only candidates invent no event entities; and
8. compares every candidate component and tile package with the legacy reserve.

Per-Ground dimensions, resource identities, animation periods, collision
statistics, file hashes, and legacy differences are in `candidate_audit.json`.

## Legacy reserve reconciliation

The preserved reserve is not a canonical conversion inventory:

- 201 of the 219 remaining canonical IDs overlap it;
- 18 canonical IDs are absent;
- 17 reserve IDs are outside the ROM-derived conversion table;
- none of the 201 overlapping Ground pairs is semantically reusable as-is;
- only 189/201 tile packages are byte-identical to current EU regeneration;
- 12/201 tile packages differ;
- 74 Ground layer schedules/geometry payloads differ;
- 20 collision payloads differ;
- all 201 entity payloads differ because the legacy importer inserted
  unauthenticated entry/event markers instead of deriving them from scripts.

The 12 differing tile packages are:

`a05p01`, `b09p02a`, `b10p02a`, `b11p02a`, `d05p01`, `h19p01`, `s02`,
`s05`, `t01p01`, `t01p02a`, `t01p02b`, and `t01p03`.

The 18 canonical IDs absent from the reserve are:

`a05p03f`, `a05p03g`, `a05p03i`, `a05p03s`, `b01p00a`, `s02_fre`,
`s02_ger`, `s02_ita`, `s02_spa`, `s05_fre`, `s05_ger`, `s05_ita`,
`s05_spa`, `s06_fre`, `s06_ger`, `s06_ita`, `s06_spa`, and `t01p00`.

The 17 reserve-only IDs are:

`h01p01w`, `h02p01w`, `h02p02w`, `h02p03w`, `h07p04w`, `h17p01w`,
`h19p01w`, `h29p03w`, `t01p06`, `t01p07w`, `w01`, `w03p01`, `w03p02`,
`w03p03`, `w04`, `w05`, and `w06`.

Reserve-only does not mean “safe to delete”: these files remain untouched until
their world-map/weather or project-specific role is separately identified.
Likewise, existing markers are preserved pending canonical Ground-script
reconstruction; a graphics archive cannot prove event placement.

## Required next validation

Before progressive integration, all 219 staged candidates still require:

1. exact PMDO 0.8.12 load, indexing, lifecycle, and screenshot validation;
2. full-map rendered comparison at authenticated engine animation ticks;
3. collision movement and reachability probes without invented canonical data;
4. reconstruction and audit of canonical lives/effects/events and choreography;
5. canonical music/weather/transition assignment and playback checks; and
6. safe promotion only after each Ground's complete evidence passes.
