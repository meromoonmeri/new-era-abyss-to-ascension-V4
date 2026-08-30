# Guide — pipeline PMU → PNG → New Era

`tools/pmu_maps/` : moteur de rendu fidèle + pipeline complet avec
catalogue, sélection, preview, portes d'approbation, import New Era,
validation disque, provenance chaînée.

```
PMU MapData (.dat clair) ─▶ catalog ─▶ SELECT ─▶ render ─▶ preview ▶ validate
     (141 découverts)                                │
                          rejeter ◀── approve ────────┘
                                            │ approve (sha gelé)
                                            ▼
                              import mode A  ou mode B
                             ┌────────────────────────────────┐
                A : Data/Ground/pmu_<id>.rsground   B : Content/Pictures/
                    + Content/Tile/pmu_<id>_tiles.tile   pmu_<id>_ref.png
                    + Data/Script/.../pmu_<id>/init.lua  (référence artiste,
                    + round-trip DISQUE byte-identical   AUCUNE carte)
                    (via tools/render_ground_png.py — le relecteur officiel)
```

## Commandes (venv : `pip install pillow skytemple-files` suffit côté PMU)

```bash
PY=venv/bin/python
# 1. catalogue complet (id, format, chiffrement, dims, tuiles, statuts, sha)
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A --maps dossier_B catalog
# 2. rendre UNIQUEMENT les maps choisies (jamais le dépôt à l'aveugle)
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A render --select Map-s1000 s1007 map95
# 3. inspecter AVANT d'importer (grille 32 px, overlay collision, couches seules)
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A preview --select s1000
# 4. valider (empreintes, dims, déterminisme) puis approuver GELER le sha
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A validate --select s1000
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A approve --select s1000 --decision approve --by tonnom
# 5. importer — d'abord en sec (aucune écriture sous Data/), puis --write
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A import --select s1000 --mode A
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A import --select s1000 --mode A --write
#    --register en plus pour s'ajouter aux GroundMaps de master_zone.json
#    (additif uniquement ; jamais de réécriture du fichier).
$PY tools/pmu_maps/pmu_pipeline.py --maps dossier_A status --select s1000
# 6. auto-tests complets (fixtures hors données externes + golden map95 si planches)
$PY tools/pmu_maps/pmu_pipeline.py selftest --golden
```

## Garanties (et refus) du mode A
- **Rendu = passe officielle** : `render_pmu_maps.py` reproduit
  `MapRenderer.cs` (Ground → Mask → Mask2 → Fringe → Fringe2, anim = index de
  remplacement, index 0 = rien, hors bornes = tuile 0 — jamais masqué :
  compté et listé dans le manifest).
- **PNG = artefact intermédiaire auditable** : `output/pmu/<id>/render.png` +
  `manifest.json` (dims PMU vs rendues, sha1/sha256 sources + planches,
  couches dessinées, fallbacks, transparence, déterminisme 2 passes).
- **Import = round-trip DISQUE** : le `.rsground`/`.tile` écrits sont relus
  par `tools/render_ground_png.py` (le relecteur du dépôt) et doivent donner
  le render.png OCTET POUR OCTET. Sinon : `REFUSED`, jamais forcé.
  Preuve actuelle : map95 → `BYTE-IDENTICAL`, diff officiel `bbox=None`.
- **Sémantique séparée des pixels** : collision = PMU `TileType`
  (Blocked/SpriteBlock/LevelBlock/HouseOwnerBlock → `Tags:1`), warps/portes/
  signes/etc. = type + `Data1-3` BRUTS dans `semantics.json` + markers posés ;
  ce que le .dat ne contient pas est déclaré irrécupérable, pas deviné.
- **TexSize=4 refusé par conception** : notre propre chaîne de validation
  (le relecteur officiel + les 953 planches du dépôt) ne vit qu'en cellules
  8 px ; émettre un format non re-lisible serait du parallélisme. La tuile
  PMU 32 px devient 4×4 sous-cellules 8 px — pixels exacts, aucune échelle.
- **Mode B** : uniquement le PNG de référence en `Content/Pictures/`, aucun
  fichier de carte. Les deux modes ne se mélangent jamais (manifestes distincts).

## Maps chiffrées (140 caches du client PMU)
Statut dans le catalogue : `encrypted-unrecoverable`, avec intrant manquant
expliqué (un `.dat` en clair `MapData|V4/V9` ou un dump serveur
`map<N>.dat-<hash>`). Elles n'excluent rien du pipeline : dès qu'un fichier
clair arrive dans `--maps`, il est rendable/importable immédiatement, sans
réécriture. Les 4 clés publiées (svKey client/serveur, DEFAULT_KEY réseau +
variante, clé GFX) × CBC/ECB × IV réels/nuls ont été testées sur les 140 :
0 succès (documenté dans `PMU_MAPS_RENDER_2026-08-30.md`). Bypass de
chiffrement : hors de question. Rendus fantaisiste : hors de question.

## Provenance
`output/newera/<id>/manifest.json` enchaîne : sha1/sha256 du `.dat` PMU,
sha256 du `render.png`, empreintes du `.tile`/`.rsground` écrits, résultat du
round-trip, nom de l'approbateur + gel du sha, et (si `--register`) la ligne
ajoutée à `master_zone.json`. Le `.dat` PMU original + le PNG + le manifeste
+ la conversion restent donc chaînables à vie.

## Régression
`tools/pmu_maps/tests_data/` : `map95.dat` (donnée PMU réelle, MIT PMU
Staff), `map95_render_golden.png`, `golden_map95.json` (sha256 du rendu).
`selftest --golden` refuse tout glissement : le rendu doit redevenir bit en
bit la preuve, sinon FAIL. Sans les planches PMU sous la main, le golden
s'affiche SKIP bruyant (et non un faux PASS).
