# Audit automatique — PMD_RED_RESCUE_TEAM

**Verdict : AUDIT_PASS** — 0 anomalie(s) bloquante(s)

Sévérités : {'LOW': 34}

Couvertures (séparées) : {"grounds_total": 254, "render_pct": 100.0, "frames_full_pct": 100.0, "cinematic_linked_pct": 52.0, "human_identity_pct": 97.2, "note": "pourcentages séparés — ne JAMAIS fusionner en un '100%'"}

| Sévérité | Catégorie | Sujet | Détail |
|---|---|---|---|
| LOW | ASSET | `719 planches` | planches jamais référencées par un ground (ex: A02p01_Base, A02p02_Base, A02p03_Base, A02p04_Base, A04p01_Base, A05p03_Base) — archivage, pa |
| LOW | MAPPING | `d18p11a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `d19p11a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `d20p11a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `d21p21a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `d21p41a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `d22p11a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `t01p00` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | CINEMATIC | `s04.cif.json` | séquence sans dialogue ni audio ({'Camera': 1}) |
| LOW | CINEMATIC | `s05.cif.json` | séquence sans dialogue ni audio ({'Camera': 1}) |
| LOW | DUPLICATE | `a02p03+d08p02` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `a03p02+d10p01` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `a04p01+d07p02` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `a05p03f+a05p03s` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b01p00a+b01p01a+b02p01a+b03p01a` | 5 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b01p02a+b02p02a+b03p02a+b04p02a` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b01p02b+b02p02b+b03p02b+b04p02b` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b01p02c+b02p02c+b03p02c+b04p02c` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b05p01a+b06p01a+b07p01a+b08p01a` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b05p02a+b06p02a+b07p02a+b08p02a` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b05p02b+b06p02b+b07p02b+b08p02b` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b05p02c+b06p02c+b07p02c+b08p02c` | 4 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b09p02a+b10p02a+b11p02a` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b09p02b+b10p02b+b11p02b` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b09p02c+b10p02c+b11p02c` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b10p01a+b11p01a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b12p01a+b13p01a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b12p02a+b13p02a` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b12p02b+b13p02b` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b12p02c+b13p02c` | 2 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b14p01a+b15p01a+b16p01a` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b14p02a+b15p02a+b16p02a` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b14p02b+b15p02b+b16p02b` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
| LOW | DUPLICATE | `b14p02c+b15p02c+b16p02c` | 3 renders bit-identiques (frame_000) — vérifier si les maps source sont réellement identiques |
