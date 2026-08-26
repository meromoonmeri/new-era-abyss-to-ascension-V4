# Audit automatique — PMD_SKY_EXPLORERS

**Verdict : AUDIT_PASS** — 0 anomalie(s) bloquante(s)

Sévérités : {'ACCEPTED': 2, 'LOW': 26}

Couvertures (séparées) : {"grounds_total": 460, "render_pct": 99.8, "frames_full_pct": 99.8, "cinematic_linked_pct": 73.0, "human_identity_pct": 100.0, "note": "pourcentages séparés — ne JAMAIS fusionner en un '100%'"}

| Sévérité | Catégorie | Sujet | Détail |
|---|---|---|---|
| LOW | ASSET | `110 planches` | planches jamais référencées par un ground (ex: AegisCaveBoss_Base, AegisCaveIce_Base, AegisCaveRock_Base, WaterfallCaveBoss_Base, WaterfallC |
| LOW | DUPLICATE | `aegis_cave_entrance+aegis_cave_floor_01+aegis_cave_floor_02` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `aegis_cave_floor_07+aegis_cave_floor_08+aegis_cave_floor_09+d33p41a` | 14 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d00p02+d10p21a+d12p21a+d15p21a` | 20 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d06p11a+waterfall_cave_1` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d46p31a+d46p41a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d53p41a+d53p41b` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d58p41a+d59p41a+d60p41a+d61p41a` | 7 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d73p21a+d73p22a+d73p23a+d73p24a` | 5 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `d91p41a+d92p41a+d93p41a+d94p41a` | 5 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `p03p01a+p03p02a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `p28p01a+v03p07a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `s00p01a+s04p01a+s06p01a+s07p01a` | 5 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `s01p01b+s15p05b` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `s05p02c3+s05p02c4` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `s13p01a3+s13p01a4` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `s15p02a+s15p03a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `t00p02+t01p01a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `t00p03+t01p02a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `v00p01+v01p07b` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `v00p03+v05p03a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `v15p02a+v15p03a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `v26p11a2+v26p11a5` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `w00+w01a+w01b` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `w02a+w02b` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `w03a+w03b+w04a+w04b` | 6 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| ACCEPTED | PLACEHOLDER | `b01p01_beach` | map sans layer/tuiles (contenu vide) |
| ACCEPTED | PLACEHOLDER | `Renders/s05p04a/frame_000.png` | render suspect (298 octets) |
