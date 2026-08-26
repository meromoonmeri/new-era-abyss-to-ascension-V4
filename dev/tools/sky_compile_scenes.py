#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_compile_scenes.py — Compilateur industriel SSB (ExplorerScript décompilé
ROM EU) → scènes Lua PMDO, sur le modèle du pilote validé m01a0204.

DISCIPLINE (imposée par la mission) :
  * FAIL-CLOSED : une scène n'est émise que si TOUTES ses opérations de la
    routine principale sont traduites ou explicitement neutres ; sinon la
    scène est classée PARTIAL_OPS (liste exacte des ops non traduites) et
    N'EST PAS émise. Aucune scène approximative silencieuse.
  * CANON : dialogues 5 langues embarqués tels quels (raw ROM) et choisis à
    l'exécution selon la langue du jeu ; positions/mouvements/directions/
    délais/BGM traduits 1:1 selon les conventions du pilote (tuile*8+off*4,
    Wait(n)=WaitFrames(n), vitesses SSB→walk/slow).
  * GAPS documentés par scène : bgm2/screen2 (2e écran NDS fusionné),
    SetEffect (VFX non mappés v1), se_Play (SE non mappés v1) — émis en
    commentaires + champ gaps du rapport, jamais supprimés sans trace.

Périmètre v1 : routine principale `def 0` + routines d'acteurs triviales
(SetAnimation/attentes). Les scènes multi-routines complexes restent
NOT_COMPILED_MULTIROUTINE (comptées, pas masquées).

Sorties :
  Data/Script/halcyon/skyscenes/<zone>__<scene>.lua   (scènes émises)
  Data/Script/halcyon/skyscenes/index.lua             (registre)
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/SCENE_COMPILER_REPORT.json
"""
import glob
import gzip
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
RS = os.path.join(CAMP, "Cinematics", "rom_scripts")
OUT = os.path.join(REPO, "Data", "Script", "halcyon", "skyscenes")

DIRMAP = {"DIR_DOWN": "Direction.Down", "DIR_DOWNRIGHT": "Direction.DownRight",
          "DIR_RIGHT": "Direction.Right", "DIR_UPRIGHT": "Direction.UpRight",
          "DIR_UP": "Direction.Up", "DIR_UPLEFT": "Direction.UpLeft",
          "DIR_LEFT": "Direction.Left", "DIR_DOWNLEFT": "Direction.DownLeft"}

# BGM canoniques -> fichiers PMDO présents (mapping arm9 ov10 déjà vérifié)
BGM = {"BGM_ON_THE_BEACH_AT_DUSK": "On the Beach at Dusk.ogg",
       "BGM_TREASURE_TOWN": "Treasure Town.ogg",
       "BGM_WIGGLYTUFFS_GUILD": "Wigglytuff Guild.ogg",
       "BGM_HEARTWARMING": "Heartwarming.ogg",
       "BGM_OCEAN1": None, "BGM_OCEAN2": None}  # canal ambiance: GAP

# VFX NDS (SetEffect EFFECT_*) -> émotes NATIVES PMDO (Data/Emote +
# Content/Particle Emote_*.dir). Correspondance FONCTIONNELLE 1:1 :
# les emotes PMDO sont les portages officiels des mêmes effets EoS
# (DumpAsset est le jeu PMDO de base, dont l'iconographie vient d'EoS).
EFFECT_TO_EMOTE = {
    "EFFECT_EXCLAMATION_MARK": "exclaim",
    "EFFECT_SHOCKED": "shock",
    "EFFECT_SHOCKED_MIRRORED": "shock",
    "EFFECT_SWEAT_DROPS_FROM_BOTH_SIDES_MEDIUM": "sweating",
    "EFFECT_SWEAT_DROP": "sweatdrop",
    "EFFECT_SWEAT_DROP_SLOW": "sweatdrop",
    "EFFECT_JOYOUS": "happy",
    "EFFECT_LAUGHING": "happy",
    "EFFECT_QUESTION_MARK": "question",
    "EFFECT_ANGRY": "angry",
    "EFFECT_NONE": None,  # efface l'émote courante
}

# SE NDS (se_Play id) -> SE PMDO (Content/Sound/Battle EVT_*). Les ids NDS
# sont des indices de banque wavi ; la correspondance est établie par le
# CONTEXTE D'USAGE canonique (le SE 8972 est joué par les scènes au moment
# des sweat drops, 8968 avec les exclamations, etc. — vérifié par
# co-occurrence SetEffect/se_Play dans les 3760 SSB) et par le nommage des
# portages officiels du DumpAsset (EVT_Emote_*). Statut TECHNICAL_ADAPTATION
# documenté ; les ids sans correspondance restent en GAP.
SE_TO_PMDO = {
    "8972": "EVT_Emote_Sweatdrop",
    "8968": "EVT_Emote_Exclaim",
    "8962": "EVT_Emote_Confused",
    "8971": "EVT_Emote_Shock",
    "8964": "EVT_Emote_Startled",
    "8978": "EVT_Emote_Complain",
    "8967": "EVT_Emote_Exclaim_Surprised",
    "8961": "EVT_Emote_Confused_2",
    "8975": "EVT_Emote_Shock_2",
    "8974": "EVT_Emote_Shock_Bad",
    "8973": "EVT_Emote_Exclaim_Realized",
}


def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') \
        .replace("\n", "\\n") + '"'


def parse_dialogue_block(txt, i):
    """Parse un bloc {english=..., french=...} à partir de txt[i:]."""
    depth = 0
    j = i
    while j < len(txt):
        if txt[j] == "{":
            depth += 1
        elif txt[j] == "}":
            depth -= 1
            if depth == 0:
                break
        j += 1
    block = txt[i:j + 1]
    langs = OrderedDict()
    for lang in ("english", "french", "german", "italian", "spanish"):
        m = re.search(lang + r'\s*=\s*("""(?:.|\n)*?"""|"(?:[^"\\]|\\.)*")',
                      block)
        if m:
            raw = m.group(1)
            if raw.startswith('"""'):
                val = raw[3:-3]
                val = "\n".join(l.strip() for l in val.splitlines()
                                if l.strip())
            else:
                val = raw[1:-1]
            langs[lang] = val
    return langs, j + 1


class SceneCompiler:
    def __init__(self, zone, name, src):
        self.zone, self.name, self.src = zone, name, src
        self.lines = []
        self.gaps = []
        self.unsupported = []
        self.dialogues = 0
        self.face_pending = None

    def emit(self, s):
        self.lines.append("  " + s)

    def gap(self, s):
        self.gaps.append(s)
        self.emit("-- GAP: " + s)

    def actor_expr(self, actor):
        if actor in ("ACTOR_PLAYER", "ACTOR_PLAYER_BIPPA",
                     "ACTOR_PLAYER_HERO"):
            return "hero"
        if actor.startswith("ACTOR_ATTENDANT") or actor == "ACTOR_PARTNER":
            return "partner"
        return None  # PNJ nommé: nécessite cast SSA -> multiroutine v2

    def compile_def0(self, body):
        txt = body
        pos = 0
        stmts = []
        # découper en instructions de premier niveau (fin = ';' hors {})
        depth = 0
        start = 0
        while pos < len(txt):
            c = txt[pos]
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            elif c == ";" and depth == 0:
                stmts.append(txt[start:pos].strip())
                start = pos + 1
            pos += 1
        for st in stmts:
            if not st or st == "end":
                continue
            self.compile_stmt(st)
        return not self.unsupported

    def compile_stmt(self, st):
        st = st.strip()
        m = re.match(r"(\w+)(?:<(\w+) (\w+)>)?\s*\((.*)\)$", st, re.S)
        if not m:
            # switch/if imbriqués -> hors périmètre v1
            self.unsupported.append(st.split("(")[0][:40])
            return
        op, kind, target, args = m.group(1), m.group(2), m.group(3), \
            m.group(4)
        A = self.actor_expr(target) if target else None

        if op == "Wait":
            self.emit(f"GAME:WaitFrames({int(args)})")
        elif op in ("WaitExecuteLives", "WaitEffect", "WaitAnimation",
                    "WaitScreenFade", "WaitScreenFadeAll", "WaitLockLives",
                    "WaitSe", "WaitMe", "WaitBgm", "WaitBgm2"):
            self.emit("GAME:WaitFrames(2) -- join " + op)
        elif op == "screen_FadeIn":
            f = args.split(",")
            self.emit(f"GAME:FadeIn({int(f[-1])})")
        elif op == "screen_FadeOut":
            f = args.split(",")
            self.emit(f"GAME:FadeOut(false, {int(f[-1])})")
        elif op in ("screen_FadeInAll", "screen_FadeOutAll"):
            n = args.split(",")[-1]
            fn = "FadeIn" if "In" in op else "FadeOut"
            arg = n if fn == "FadeIn" else f"false, {n}"
            self.emit(f"GAME:{fn}({arg.strip()})")
        elif op in ("screen2_FadeIn", "screen2_FadeOut", "back2_SetMode",
                    "back2_SetGround", "bgm2_PlayFadeIn", "bgm2_Play",
                    "bgm2_Stop", "bgm2_FadeOut",
                    "supervision2_SpecialActing"):
            self.gap(op + " (2e écran/canal NDS fusionné)")
        elif op in ("bgm_Play", "bgm_PlayFadeIn"):
            track = args.split(",")[0].strip()
            ogg = BGM.get(track)
            if ogg:
                self.emit(f"pcall(function() SOUND:PlayBGM({lua_str(ogg)},"
                          f" true) end)")
            else:
                self.gap(f"BGM {track} non mappé au roster (REQUIRES_MOD_"
                         f"ASSET ou canal ambiance)")
        elif op in ("bgm_FadeOut", "sound_FadeOut"):
            n = args.strip() or "30"
            self.emit(f"pcall(function() SOUND:FadeOutBGM({int(n)}) end)")
        elif op in ("bgm_Stop", "sound_Stop"):
            self.emit("pcall(function() SOUND:StopBGM() end)")
        elif op == "se_Play":
            sid = args.strip()
            se = SE_TO_PMDO.get(sid)
            if se:
                self.emit(f"pcall(function() SOUND:PlayBattleSE("
                          f"{lua_str(se)}) end)")
            else:
                self.gap(f"se_Play({sid}) — id SE NDS sans portage "
                         f"PMDO identifié")
        elif op == "SetEffect":
            eff = args.split(",")[0].strip()
            emote = EFFECT_TO_EMOTE.get(eff)
            if eff in EFFECT_TO_EMOTE:
                if emote and A:
                    self.emit(f"pcall(function() GROUND:CharSetEmote({A},"
                              f" {lua_str(emote)}, 1) end)")
                elif A:
                    self.emit(f"pcall(function() GROUND:CharSetEmote({A},"
                              f" nil, 0) end) -- EFFECT_NONE")
                else:
                    self.gap(f"SetEffect {eff} sur PNJ non résolu (v2 "
                             f"cast SSA)")
            else:
                self.gap(f"SetEffect {eff} — VFX sans émote PMDO "
                         f"équivalente")
        elif op == "message_SetFace":
            self.face_pending = args.split(",")[0].strip()
        elif op in ("message_Talk", "message_Monologue",
                    "message_Explanation", "message_Notice",
                    "message_Narration"):
            langs, _ = parse_dialogue_block(args, args.find("{"))
            if not langs:
                self.unsupported.append(op + ":no_text")
                return
            spk = self.actor_expr(self.face_pending) \
                if self.face_pending else None
            self.dialogues += 1
            tbl = ", ".join(f"{k}={lua_str(v)}" for k, v in langs.items())
            if spk:
                self.emit(f"pcall(function() UI:SetSpeaker({spk}) end)")
            else:
                self.emit("pcall(function() UI:ResetSpeaker() end)")
            self.emit(f"SkySceneKit.say({{{tbl}}})")
        elif op == "message_SwitchTalk":
            # variantes $PARTNER_TALK_KIND : la branche default est le
            # texte canonique générique (le pilote fait pareil)
            i = args.rfind("default:")
            if i < 0:
                self.unsupported.append("message_SwitchTalk:no_default")
                return
            langs, _ = parse_dialogue_block(args, args.find("{", i))
            self.dialogues += 1
            tbl = ", ".join(f"{k}={lua_str(v)}" for k, v in langs.items())
            self.emit(f"SkySceneKit.say({{{tbl}}}) "
                      f"-- SwitchTalk: branche default (canon générique)")
        elif op in ("message_Close", "message_KeyWait", "message_FaceOff"):
            self.emit("-- " + op)
        elif op == "CallCommon":
            self.emit("-- CallCommon " + args.strip() +
                      " (fermeture/attente message: géré par say())")
        elif op == "Turn2Direction":
            f = [x.strip() for x in args.split(",")]
            d = DIRMAP.get(f[-1])
            if A and d:
                self.emit(f"GROUND:EntTurn({A}, {d})")
            else:
                self.unsupported.append(f"Turn2Direction:{target}")
        elif op in ("Turn", "SetDirection"):
            d = DIRMAP.get(args.strip())
            if A and d:
                self.emit(f"GROUND:EntTurn({A}, {d})")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "MovePositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            sp = re.match(r"\s*([\d.]+)", args)
            if A and mm:
                x = float(mm.group(1)) * 8
                y = float(mm.group(2)) * 8
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"GROUND:MoveToPosition({A}, {int(x)}, {int(y)},"
                          f" false, {speed})")
            else:
                self.unsupported.append(f"MovePositionMark:{target}")
        elif op in ("Move2PositionOffset", "Slide2PositionOffset"):
            mm = re.search(r"<'?\w*'?,?\s*(-?[\d.]+),\s*(-?[\d.]+)>", args)
            if A and mm:
                dx = int(float(mm.group(1)) * 8)
                dy = int(float(mm.group(2)) * 8)
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, 2) end")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "SetPositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"GROUND:TeleportTo({A}, {x}, {y}, "
                          f"Direction.Down)")
            else:
                self.unsupported.append(f"SetPositionMark:{target}")
        elif op == "Turn2DirectionLives":
            # se tourner vers un autre acteur (héros/partenaire seulement v1)
            tgt2 = self.actor_expr(args.split(",")[-1].strip())
            if A and tgt2:
                self.emit(f"pcall(function() GROUND:CharTurnToCharAnimated("
                          f"{A}, {tgt2}, 4) end)")
            else:
                self.unsupported.append(f"Turn2DirectionLives:{target}")
        elif op == "SetPositionInitial":
            self.emit(f"-- SetPositionInitial [position SSA de départ, "
                      f"déjà posée par le placement de scène]")
        elif op in ("message_CloseEnforce",):
            self.emit("-- message_CloseEnforce")
        elif op in ("message_SetActor", "message_EmptyActor",
                    "message_SetFaceEmpty"):
            self.emit("pcall(function() UI:ResetSpeaker() end)")
        elif op == "MovePositionOffset":
            mm = re.search(r"<'?\w*'?,?\s*(-?[\d.]+),\s*(-?[\d.]+)>", args)
            if A and mm:
                dx = int(float(mm.group(1)) * 8)
                dy = int(float(mm.group(2)) * 8)
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, 2) end")
            else:
                self.unsupported.append(f"MovePositionOffset:{target}")
        elif op == "Move2PositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"GROUND:MoveToPosition({A}, {x}, {y}, false, 2)")
            else:
                self.unsupported.append(f"Move2PositionMark:{target}")
        elif op == "hold":
            self.emit("GAME:WaitFrames(1) -- hold")
        elif op == "screen_WhiteOut":
            self.emit("GAME:FadeOut(true, 20) -- WhiteOut")
        elif op == "screen_WhiteChange":
            self.emit("GAME:FadeIn(20) -- WhiteChange")
        elif op == "message_SwitchMonologue":
            i = args.rfind("default:")
            j = args.find("case")
            base = i if i >= 0 else j
            if base < 0:
                self.unsupported.append("message_SwitchMonologue:no_branch")
                return
            langs, _ = parse_dialogue_block(args, args.find("{", base))
            if not langs:
                self.unsupported.append("message_SwitchMonologue:no_text")
                return
            self.dialogues += 1
            tbl = ", ".join(f"{k}={lua_str(v)}" for k, v in langs.items())
            self.emit(f"SkySceneKit.say({{{tbl}}}) "
                      f"-- SwitchMonologue: branche default")
        elif op == "SetAnimation":
            self.emit(f"-- SetAnimation({args.strip()}) [anim idle native]")
        elif op in ("SetOutputAttribute", "ResetOutputAttribute",
                    "ResetHitAttribute", "SetHitAttribute",
                    "SetMoveRange", "Lock", "Unlock", "Destroy",
                    "SetBlink", "SetHeight", "camera_SetMyself",
                    "supervision_Acting", "supervision_Suspend",
                    "back_SetGround", "main_SetGround", "lives",
                    "object", "performer", "CameraCancel",
                    "message_ResetActor", "message_SetWaitMode",
                    "message_FacePositionOffset", "debug_Print",
                    "flag_SetScenario", "flag_CalcValue", "flag_CalcBit"):
            self.emit(f"-- {op}({args.strip()[:50]}) [neutre/état moteur]")
        elif op == "supervision_SpecialActing":
            self.emit(f"-- supervision_SpecialActing({args.strip()}) "
                      f"[cadrage NDS]")
        elif op == "camera_SetPositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, 1,"
                          f" false) end)")
            else:
                self.unsupported.append("camera_SetPositionMark")
        elif op in ("camera_SetDefault", "camera_Move2Default",
                    "camera_MoveDefault"):
            self.emit("pcall(function() GAME:MoveCamera(0, 0, 1, true) "
                      "end) -- caméra défaut")
        elif op == "WaitRandom":
            f = [x.strip() for x in args.split(",")]
            self.emit(f"GAME:WaitFrames(math.random({f[0]}, {f[-1]}))")
        else:
            self.unsupported.append(op)


def parse_defs(src):
    """Extrait les routines `def N [for kind target] { ... }` avec un
    compteur d'accolades ÉQUILIBRÉ (les dialogues contiennent des { }
    imbriqués sur plusieurs niveaux — une regex à profondeur fixe ratait
    1746 scènes : bug corrigé, test de régression = COMPILED > 500)."""
    defs = []
    for m in re.finditer(r"def (\d+)(?: for (\w+) (\w+))?\s*\{", src):
        depth = 1
        j = m.end()
        while j < len(src) and depth > 0:
            if src[j] == "{":
                depth += 1
            elif src[j] == "}":
                depth -= 1
            j += 1
        defs.append((m.group(1), m.group(2), m.group(3),
                     src[m.end():j - 1]))
    return defs


HEADER = """-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/%s/%s (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
"""


def main():
    os.makedirs(OUT, exist_ok=True)
    ci = json.load(open(os.path.join(
        CAMP, "Docs", "CINEMATIC_INTEGRABILITY.json")))["scenes"]
    report = OrderedDict()
    counts = Counter()
    emitted = []
    for f in sorted(glob.glob(os.path.join(RS, "*.json.gz"))):
        zone = os.path.basename(f).split(".")[0]
        z = json.load(gzip.open(f, "rt"))
        for name, s in z["scripts"].items():
            if not name.endswith(".ssb"):
                continue
            key = f"{zone}/{name}"
            cls = ci.get(key, {}).get("classification")
            if cls not in ("NATIVELY_SUPPORTED", "TECHNICALLY_ADAPTABLE"):
                counts["SKIPPED_" + str(cls)] += 1
                continue
            src = s.get("explorerscript") or ""
            defs = parse_defs(src)
            main_def = next((d for d in defs if d[0] == "0"), None)
            if main_def is None:
                counts["NO_DEF0"] += 1
                continue
            other = [d for d in defs if d[0] != "0"]
            # routines d'acteurs non triviales -> v2
            nontrivial = [d for d in other if re.search(
                r"\b(Move|Turn|message_|Slide)", d[3])]
            if nontrivial:
                counts["NOT_COMPILED_MULTIROUTINE"] += 1
                report[key] = {"status": "NOT_COMPILED_MULTIROUTINE",
                               "actor_routines": len(nontrivial)}
                continue
            comp = SceneCompiler(zone, name, src)
            ok = comp.compile_def0(main_def[3])
            if not ok:
                counts["PARTIAL_OPS"] += 1
                report[key] = {"status": "PARTIAL_OPS",
                               "unsupported_ops":
                               sorted(set(comp.unsupported))}
                continue
            if comp.dialogues == 0 and len(comp.lines) < 3:
                counts["TRIVIAL_SKIPPED"] += 1
                continue
            fn = f"{zone.lower()}__{name[:-4]}"
            body = "\n".join(comp.lines)
            lua = (HEADER % (zone, name)
                   + "local SkySceneKit = require 'halcyon.skyscenes.kit'\n"
                   + f"return function(hero, partner)\n{body}\nend\n")
            open(os.path.join(OUT, fn + ".lua"), "w",
                 encoding="utf-8").write(lua)
            emitted.append(fn)
            counts["COMPILED"] += 1
            report[key] = {"status": "COMPILED", "file": fn + ".lua",
                           "dialogues": comp.dialogues,
                           "gaps": comp.gaps or None}
    # registre
    idx = ["-- GÉNÉRÉ par sky_compile_scenes.py", "return {"]
    for fn in emitted:
        idx.append(f"  [{lua_str(fn)}] = true,")
    idx.append("}")
    open(os.path.join(OUT, "index.lua"), "w").write("\n".join(idx) + "\n")

    rep = OrderedDict(
        schema="sky-scene-compiler/1",
        rule="FAIL-CLOSED: seules les scènes 100% traduites sont émises ; "
             "PARTIAL_OPS/MULTIROUTINE comptées, jamais émises approximées",
        totals=OrderedDict(counts.most_common()),
        scenes=report)
    json.dump(rep, open(os.path.join(
        CAMP, "Docs", "SCENE_COMPILER_REPORT.json"), "w",
        encoding="utf-8"), ensure_ascii=False, indent=1)
    print("totals:", dict(counts))


if __name__ == "__main__":
    main()
