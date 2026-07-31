# RÉCUPÉRATION DES OUTILS DE L'ANCIEN AGENT — 2026-07-31

> But : récupérer **tous les outils** de l'ancien agent (branche
> `arena/019fad83`, sandbox `~/audit/scripts/`) et **la méthode de travail**
> (suite de validation pré-commit), les rendre portables et documentés dans
> ce dépôt.

---

## 1. Ce qui existait chez l'ancien agent

L'audit du 2026-07-30 (`docs/audit_2026-07-30.md` §7) listait **24 scripts
d'audit** vivant dans `~/audit/scripts/` de l'ancien sandbox :

> `audit_api.py` · `audit_chgap.py` + `audit_chgap2.py` · `audit_cut2.py` ·
> `audit_tags.py` · `audit_dispatch3.py` · `audit_markers.py` ·
> `audit_zones.py` · `audit_assets2.py` · `audit_resx.py` ·
> `audit_serial.py` · `audit_fade2.py` · `audit_sv.py` + `audit_sv2.py` ·
> `audit_handlers.py` · `audit_emotion.py` · `audit_text.py` ·
> `audit_plot.py` · `audit_require.py` · `audit_ch.py` · `audit_cb2.py`
> + 4 variantes de première passe.

**État de récupération :**

| Groupe | Outils | État |
|---|---|---|
| Déjà commités dans `tools/` (patron du 3e agent) | `audit_bugs.py` (couvre require/handlers/SV/zones/mapstatus/items/comma), `audit_integrite.py` (couvre assets uniques/clés resx/orphelines), `audit_dialogues.py` (textes visibles), `verify_emotions.py` (émotions de portrait), `verify_scene_positions.py` (positions), `verify_ground_registration.py` (grounds/zones), `verify_lua_globals.py`, `count_dialogue.py`, `audit_causalite.py`, `audit_spatial.py`, `audit_fade_leaks.py` | ✅ présents, fonctionnels |
| Commités mais **cassés** (chemin `/home/user/nea` hardcodé) | `audit_text_tags.py` (= audit_tags), `audit_cutscene_exit.py` (= audit_cut2), `audit_chapter_gaps.py` (= audit_chgap2) | ✅ **réparés** (portables, `sys.argv[1]`) |
| Jamais commités (perdus avec le sandbox) | `audit_api`, `audit_markers`, `audit_zones`, `audit_assets2`, `audit_resx`, `audit_serial`, `audit_fade2`, `audit_dispatch3`, `audit_sv2`, `audit_plot` | ✅ **reconstruits** (nouveaux fichiers, voir §2) |
| Fonctions absorbées par les outils existants | `audit_handlers` → audit_bugs E · `audit_emotion` → verify_emotions · `audit_text` → audit_dialogues + audit_text_tags · `audit_require` → audit_bugs J/K · `audit_sv` → audit_bugs C/D + audit_sv2 · `audit_chgap` (v1) → audit_chapter_gaps | ✅ couverts |
| Variantes de première passe | 4 scripts de debug | ⏭️ non reproduits (à dessein) |

---

## 2. Outils reconstruits (tous portables, racine en `sys.argv[1]`)

| Outil | Rôle | Correspondance audit 2026-07-30 |
|---|---|---|
| `tools/audit_api.py` | surface moteur vs référence officielle PMDO (`tools/data/pmdo_script_api.txt`, 255 fonctions) — détecte les inventions d'API | `audit_api.py` |
| `tools/audit_markers.py` | marqueurs d'entrée des `EnterGroundMap` (carte + marker présents dans le `.rsground`) | `audit_markers.py` |
| `tools/audit_zones.py` | grounds orphelins (non déclarés dans une zone), zones jamais citées, zones citées absentes | `audit_zones.py` |
| `tools/audit_assets2.py` | musiques / MapStatus / fonds référencés mais absents du mod (hors assets moteur énumérés) | `audit_assets2.py` |
| `tools/audit_resx.py` | parité EN/FR des clés `.resx` (fichier + clés) | `audit_resx.py` |
| `tools/audit_serial.py` | BOM UTF-8, objets `$values` sans `$type`, JSON illisibles | `audit_serial.py` |
| `tools/audit_fade2.py` | FadeIn atteignable dans Enter/PlotScripting (le moteur ne fondu rien) | `audit_fade2.py` |
| `tools/audit_dispatch3.py` | PNJ instanciés dont le handler `_Action` est référencé mais jamais défini | `audit_dispatch3.py` |
| `tools/audit_sv2.py` | tables SV utilisées sans déclaration ni garde `Ensure()` | `audit_sv2.py` |
| `tools/audit_plot.py` | fichiers `_ch_N` de scène sans branche de dispatch (Chapter==N, appel direct, ChapterDispatch) | `audit_plot.py` |

**Référence API embarquée** : `tools/data/pmdo_script_api.txt` (copie de
`PMDODump/DataAsset/Docs/Script.txt`, 255 fonctions officielles, téléchargée
via l'API GitHub le 2026-07-31).

---

## 3. BUG RÉEL TROUVÉ PAR LES OUTILS RÉCUPÉRÉS — CORRIGÉ

`audit_cutscene_exit.py` (reconstruction d'`audit_cut2`) a détecté un gel de
classe B1 dans le flux de raid nocturne :

**`TownRaid.Victory()`** (Data/Script/halcyon/TownRaid.lua:265) armait
`GAME:CutsceneMode(true)` et ne le désarmait **jamais** — ni dans la fonction,
ni dans son appelant (`metano_town_nuit.Enter` rend la main juste après).
Or `Save.CutsceneMode` est persistant (GroundScene.cs:176) : après une
victoire de raid, le joueur serait **figé sur la place, menu compris**.
La passation (§16) confirmait que les raids n'avaient jamais été testés en jeu.

**Correctif** : patron identique à `TownRaid.Begin` (l.236) et
`RaidScenes.Bedside` — `pcall` du corps, puis désarmement systématique :
`UI:ResetSpeaker()`, `AI:EnableCharacterAI(partner)`, `CutsceneMode(false)`.
Vérifié : 673 Lua compilent, l'outil repasse à **0 fonction à risque**.

---

## 4. LA MÉTHODE DE TRAVAIL — UNE COMMANDE

`tools/run_validations.sh` encapsule la suite pré-commit complète :

```bash
bash tools/run_validations.sh        # suite complète (défaut)
bash tools/run_validations.sh full   # identique + audits exploratoires
```

Sections exécutées (dans l'ordre) :
1. **Compilation Lua** de tous les fichiers (673).
2. **Vérificateurs bloquants** (baselines tenues) : `audit_bugs` (9) ·
   `verify_legend` · `verify_scene_positions` · `verify_bg_format` ·
   `validate_all` (9 salles) · `verify_ground_registration` ·
   `verify_lua_globals` · `verify_spawner_enabled` · `verify_cutscene_guard` ·
   `verify_emotions` · `verify_midpoint_template` · `audit_dialogues` ·
   `audit_integrite` (849) · `count_dialogue`.
3. **Outils récupérés [RÉCUPÉRÉ]** : les 13 outils du §2 + §1 (réparés).
4. **Exploratoires (informatifs, non bloquants)** : `audit_zones` ·
   `audit_spatial` · `audit_causalite` · `audit_boss_cinematics` ·
   `audit_fade_leaks`.

Toute sortie non-zéro d'un outil **bloquant** → le commit est refusé.
Les exploratoires affichent leur signal sans bloquer (dette à trier, comme
les 9 signalements d'`audit_bugs` documentés dans la PASSATION §11).

**Résultat mesuré le 2026-07-31** : ✅ SUITE DE VALIDATION AU VERT.

---

## 5. Méthode de travail (rappel, PASSATION §2 + §9)

1. **Preuve avant hypothèse** : ouvrir le fichier, citer ligne.
2. **Ne jamais inventer une API** : compter les occurrences hors du fichier
   courant — désormais automatisé par `audit_api.py`.
3. **Prouver le format d'un JSON** par round-trip avant de l'écrire.
4. **Toute table `SV` neuve** : déclarer dans `scriptvars.lua` + rattraper
   dans `OnUpgrade` de `debug_tools`.
5. **Toute zone modifiée** → resynchroniser `Data/Zone/index.idx`.
6. **Avant chaque commit** : `bash tools/run_validations.sh` (ou `full`).
7. **Mesure avant/après** : `audit_integrite` (849) et `audit_bugs` (9)
   doivent rester à la baseline ; signaler honnêtement les écarts.
8. **Rien n'est testé en jeu** dans cette sandbox — toujours le rappeler.

---

## 6. Fichier attaché par l'utilisateur

`audit_donjons_rescue_team.md` (annoncé dans `/home/user/uploads/`) :
**non présent sur le disque** au moment de cette session (aucun fichier
`uploads/` trouvé). Dès qu'il sera disponible, le lire et l'intégrer à la
connaissance du projet (audit des donjons type Rescue Team).
