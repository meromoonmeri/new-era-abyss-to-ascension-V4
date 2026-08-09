#!/usr/bin/env python3
# fix_runtime_types.py
# Corrige les bugs de données réels découverts par le harness de validation
# runtime (AUDIT_RUNTIME_LINUX_2026-08-09) : types $type absents du moteur
# RogueEssence/PMDC 0.8.12, remplacés par les types natifs équivalents.
#
# Modifications CHIRURGICALES : remplacement de blocs exacts uniquement, tout
# le reste des fichiers (formatage, ordre, autres champs) est conservé à
# l'identique. Aucune resérialisation.
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]  # repo root
Z = ROOT / "Data" / "Zone"
G = ROOT / "Data" / "Ground"
M = ROOT / "Data" / "Map"

def load(p):
    return p.read_text(encoding="utf-8-sig")  # gère BOM s'il existe

def save(p, s):
    bom = p.read_bytes().startswith(b"\xef\xbb\xbf")
    data = s.encode("utf-8")
    if bom:
        data = b"\xef\xbb\xbf" + data
    p.write_bytes(data)

# ---- Fix A : MultiSpawner (cassé) -> TeamContextSpawner (natif), passage_temps
def fix_multispawner(s):
    pat = re.compile(
        r'(?P<ind>[ \t]*)"\$type": "RogueEssence\.LevelGen\.MultiSpawner`1'
        r'\[\[RogueEssence\.LevelGen\.MapGenContext, RogueEssence\], RogueEssence\]",\n'
        r'[ \t]*"Spawns": \[\]'
    )
    repl = ('\\g<ind>"$type": "RogueEssence.LevelGen.TeamContextSpawner`1'
            '[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",\n'
            '\\g<ind>"Amount": {"Min": 2, "Max": 4}')
    return pat.sub(repl, s)

# ---- Fix B : WaterTerrainStencil (absent) -> MapTerrainStencil natif (all-match = ocean)
# MapTerrainStencil est le stencil natif dominant (246 usages, chargé par le
# moteur réel ET par le harness). Room/Wall/Blocked=true => toutes tuiles
# éligibles => l'eau couvre tout l'étage (intention "ocean").
def fix_waterstencil(s):
    # 1) le type absent WaterTerrainStencil {Stencil:"ocean"}
    pat = re.compile(
        r'(?P<ind>[ \t]*)"\$type": "RogueElements\.WaterTerrainStencil, RogueElements",\n'
        r'[ \t]*"Stencil": "ocean"'
    )
    repl = ('\\g<ind>"$type": "RogueElements.MapTerrainStencil`1'
            '[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",\n'
            '\\g<ind>"Room": true, "Wall": true, "Blocked": true, "Not": false')
    s = pat.sub(repl, s)
    # 2) rattrapage : si une exécution précédente avait posé DefaultTerrainStencil
    pat2 = re.compile(
        r'(?P<ind>[ \t]*)"\$type": "RogueElements\.DefaultTerrainStencil`1'
        r'\[\[RogueEssence\.LevelGen\.MapGenContext, RogueEssence\]\], RogueEssence"'
    )
    repl2 = ('\\g<ind>"$type": "RogueElements.MapTerrainStencil`1'
             '[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements",\n'
             '\\g<ind>"Room": true, "Wall": true, "Blocked": true, "Not": false')
    return pat2.sub(repl2, s)

# ---- Fix C : arg générique DetectIsolatedStairsStep StairsTile -> MapGenExit
def fix_stairstile(s):
    return s.replace("RogueEssence.Dungeon.StairsTile, RogueEssence",
                     "RogueEssence.LevelGen.MapGenExit, RogueEssence")

# ---- Fix D : namespace LayeredBG Ground -> Dungeon
def fix_layeredbg(s):
    return s.replace("RogueEssence.Ground.LayeredBG, RogueEssence",
                     "RogueEssence.Dungeon.LayeredBG, RogueEssence")

# ---- Fix E : StatusEffects serialisé en tableau [] au lieu d'objet {} (bug de format)
# L'engine attend un objet StatusState ; toutes les maps qui chargent utilisent {}.
def fix_statuseffects(s):
    return s.replace('"StatusEffects": []', '"StatusEffects": {}')

# ---- Fix F : Tactic serialisé en string au lieu d'objet TacticData (bug de format)
# L'engine attend un objet TacticData complet. On injecte la tactique objet
# prouvée (celle des arènes de boss qui chargent : "wander_dumb").
WANDER_DUMB = ('{"Name": {"DefaultText": "Dumb Wander", "LocalTexts": {}}, '
               '"Released": false, "Comment": "", "ID": "wander_dumb", '
               '"Assignable": false, "Plans": ['
               '{"$type": "PMDC.Dungeon.AttackFoesPlan, PMDC", "AttackPattern": 1, '
               '"PositionPattern": 0, "IQ": 36, "RestrictedMobilityTypes": 0, '
               '"RestrictMobilityPassable": false, "AttackRange": 4, "StatusRange": 4, '
               '"SelfStatusRange": 3, "AbandonRangeOnHit": true}, '
               '{"$type": "PMDC.Dungeon.FollowLeaderPlan, PMDC", "IQ": 164, '
               '"RestrictedMobilityTypes": 0, "RestrictMobilityPassable": false, '
               '"AttackRange": 0, "StatusRange": 0, "SelfStatusRange": 0, '
               '"AbandonRangeOnHit": true}, '
               '{"$type": "PMDC.Dungeon.ExplorePlan, PMDC", "IQ": 164, '
               '"RestrictedMobilityTypes": 0, "RestrictMobilityPassable": false, '
               '"AttackRange": 0, "StatusRange": 0, "SelfStatusRange": 0, '
               '"AbandonRangeOnHit": true}, '
               '{"$type": "PMDC.Dungeon.WaitPlan, PMDC", "IQ": 164, '
               '"RestrictedMobilityTypes": 0, "RestrictMobilityPassable": false, '
               '"AttackRange": 0, "StatusRange": 0, "SelfStatusRange": 0, '
               '"AbandonRangeOnHit": true}]}')
def fix_tactic(s):
    return s.replace('"Tactic": "boss_wait_then_attack"', '"Tactic": ' + WANDER_DUMB)

# ---- Fix G : CharData.BackRef en entier 0 au lieu d'objet TempCharBackRef (bug de format)
# Seul le BackRef du CharData (celui qui suit "CharStates") est concerné ; les
# BackRef des Skills/Intrinsics sont de légitimes entiers et ne doivent PAS bouger.
def fix_backref(s):
    pat = re.compile(r'("CharStates":\s*\[\],\n\s*)"BackRef": 0')
    return pat.sub(lambda m: m.group(1) + '"BackRef": {"Assembly": false, "Index": -1}', s)

# ---- Fix H : BaseSkills en liste de strings au lieu d'objets SlotSkill (bug de format)
# L'engine attend [{"SkillNum": "...", "Charges": n}, ...]. BaseIntrinsics reste
# une liste de strings (format natif correct) — on ne touche pas à ça.
# ---- Fix I : autres champs CharData de spiritomb_arena au format erroné (0/null/[] au lieu des objets natifs)
def fix_chardata(s):
    reps = [
        ('"EquippedItem": null',
         '"EquippedItem": {"ID": "", "Cursed": false, "HiddenValue": "", "Amount": 0, "Price": 0}'),
        ('"OriginalTeam": 0', '"OriginalTeam": ""'),
        ('"MetAt": 0', '"MetAt": ""'),
        ('"MetLoc": 0', '"MetLoc": {"ID": "", "StructID": {"Segment": -1, "ID": -1}, "EntryPoint": -1}'),
        ('"DefeatAt": 0', '"DefeatAt": ""'),
        ('"DefeatLoc": 0', '"DefeatLoc": {"ID": "", "StructID": {"Segment": -1, "ID": -1}, "EntryPoint": -1}'),
        ('"Relearnables": []', '"Relearnables": {}'),
        ('"ScriptVars": []', '"ScriptVars": null'),
    ]
    for old, new in reps:
        if old in s:
            s = s.replace(old, new)
    return s

def fix_baseskills(s):
    pat = re.compile(r'("BaseSkills": \[\n)((?:\s*"[^"]+",?\n)+?)(\s*\])')
    def repl(m):
        head, body, close = m.group(1), m.group(2), m.group(3)
        items = re.findall(r'"([^"]+)"', body)
        objs = [('{"SkillNum": "%s", "Charges": 10}' % sk) for sk in items]
        indent = re.match(r'\s*', body).group(0)
        close_indent = re.match(r'\s*', close).group(0)
        inner = (",\n" + indent).join(objs)
        return head + indent + inner + "\n" + close_indent + "]"
    return pat.sub(repl, s)

changes = 0
def apply(fname, fn, count_label):
    global changes
    p = Z / fname if pdir == "Z" else (G / fname if pdir == "G" else M / fname)
    s = load(p)
    before = s
    s2 = fn(s)
    if s2 != before:
        save(p, s2)
        changes += 1
        print(f"  FIX {p.relative_to(ROOT)} : {count_label}")
    else:
        print(f"  --  {p.relative_to(ROOT)} : aucun changement ({count_label})")

print("=== Corrections des bugs runtime (types absents du moteur) ===")
pdir="Z"
apply("passage_temps.json", fix_multispawner, "MultiSpawner x3 -> TeamContextSpawner")
for f in ["dark_hill.json","dusk_forest.json","sealed_ruin.json","sealed_ruin_pit.json"]:
    apply(f, fix_waterstencil, "WaterTerrainStencil -> DefaultTerrainStencil")
for f in ["chasm_cave.json","spiritomb_room.json","dark_hill.json","dusk_forest.json","sealed_ruin.json","sealed_ruin_pit.json"]:
    apply(f, fix_stairstile, "DetectIsolatedStairsStep arg StairsTile -> MapGenExit")
pdir="G"
apply("genesis_vision.rsground", fix_layeredbg, "Ground.LayeredBG -> Dungeon.LayeredBG")
pdir="M"
apply("spiritomb_arena.rsmap", fix_statuseffects, "StatusEffects [] -> {} (format bug)")
apply("spiritomb_arena.rsmap", fix_tactic, "Tactic string -> TacticData object")
apply("spiritomb_arena.rsmap", fix_backref, "CharData BackRef 0 -> TempCharBackRef object")
apply("spiritomb_arena.rsmap", fix_baseskills, "BaseSkills strings -> SlotSkill objects")
apply("spiritomb_arena.rsmap", fix_chardata, "CharData format bugs (EquippedItem/OriginalTeam/Met/Defeat/Relearnables/ScriptVars)")

print(f"\n{changes} fichiers corrigés.")
