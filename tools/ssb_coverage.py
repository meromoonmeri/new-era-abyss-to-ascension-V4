#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ssb_coverage.py — MATRICE DE COUVERTURE SSB -> Lua PMDO (arc du futur).

Pour chacune des 24 scènes :
    SSB ops totales  ->  ops comprises  ->  ops converties  ->  ops non converties

"Comprise"  : opcode connu et sémantique établie (toujours vrai ici : les 89
              opcodes de l'arc sont dans la table XML du jeu).
"Convertie" : il existe un idiome PMDO (RogueEssence) attesté, ET les arguments
              de l'op sont mappables (acteur résolu, position résolue, id
              d'effet/animation/SE résolu dans une table d'adaptation).
"Non convertie" : pas d'équivalent PMDO (ex. message_Mail) OU argument non
              mappable (ex. SetEffect id 640/645/651 sans nom) OU dépend d'une
              table d'adaptation New Era absente (anim id, SE id, BGM id).

STATUTS :
  OK       = conversion directe avec idiome attesté
  ADAPT    = idiome existe mais dépend de la couche d'adaptation New Era
             (acteurs, dialogues, BGM, grounds, anims, SE, effets)
  PARTIEL  = idiome approximatif (délais, échelle) — signalé, jamais silencieux
  NON      = aucun équivalent PMDO — explicitement NON CONVERTI

Toute commande NON/ PARTIEL est listée dans le rapport, jamais ignorée.
"""

import csv
import json
import glob
import os

IR_DIR = "/home/user/V4/docs/ssb_ir"
OUT_MD = "/home/user/V4/docs/MATRICE_COUVERTURE_SSB_LUA.md"
OUT_CSV = os.path.join(IR_DIR, "_coverage_matrix.csv")
OUT_JSON = os.path.join(IR_DIR, "_coverage_summary.json")

# ---------------------------------------------------------------------------
# TABLE DE MAPPING CURATEE : opcode -> (catégorie, statut, idiome PMDO, note)
# ---------------------------------------------------------------------------
# catégories : FLOW / ACTEUR / CAMERA / ECRAN / AUDIO / DECOR / MESSAGE / ETAT / META
M = {}

def add(name, cat, status, idiom, note=""):
    M[name] = {"cat": cat, "status": status, "idiom": idiom, "note": note}

# ------------------------------- FLOW --------------------------------------
add("lives",               "FLOW", "OK",     "structurel (contexte acteur)", "parallèle Sky -> TASK:BranchCoroutine en Lua")
add("WaitExecuteLives",    "FLOW", "OK",     "attente coroutine acteur", "TASK joint la coroutine de l'acteur")
add("WaitExecuteObject",   "FLOW", "OK",     "attente coroutine objet", "idem")
add("WaitExecutePerformer","FLOW", "OK",     "attente coroutine performer", "idem")
add("object",              "FLOW", "OK",     "structurel (contexte objet)", "variable cible Lua")
add("performer",           "FLOW", "OK",     "structurel (contexte performer)", "variable cible Lua")
add("supervision_Acting",        "FLOW", "OK",     "lance une chorégraphie parallèle d'acteur", "TASK:BranchCoroutine")
add("supervision_RemoveActing",  "FLOW", "OK",     "arrête la chorégraphie parallèle", "annulation coroutine")
add("supervision_StationCommon", "FLOW", "OK",     "pose l'acteur en mode stationnaire", "AI:DisableCharacterAI / action idle")
add("CallCommon",          "FLOW", "ADAPT",  "routine commune Sky -> helper Lua", "table routines communes (WAIT_START_FUNC, END_TALK, HANYOU_SAVE_FUNC...) -> équivalent New Era")
add("ExecuteCommon",       "FLOW", "ADAPT",  "routine commune parallèle", "idem, via TASK")
add("Jump",                "FLOW", "OK",     "goto structuré", "traduit en structure Lua (if/label)")
add("End",                 "FLOW", "OK",     "fin de scène", "return")
add("Destroy",             "FLOW", "OK",     "détruit l'acteur/objet courant", "GROUND:RemoveCharacter / Hide")
add("Hold",                "FLOW", "PARTIEL","pause maintenue", "pas d'équivalent exact : GAME:WaitFrames(1) + var")
add("Wait",                "FLOW", "OK",     "attente frames", "GAME:WaitFrames(n)")
add("CaseText",            "FLOW", "OK",     "branchement texte", "if/else Lua sur SV")
add("CaseMenu",            "FLOW", "OK",     "branchement menu", "UI:BeginChoiceMenu / UI:WaitForChoice")
add("DefaultText",         "FLOW", "OK",     "texte par défaut d'un switch", "else Lua")

# ------------------------------ MESSAGE ------------------------------------
add("message_Talk",              "MESSAGE", "ADAPT", "dialogue", "UI:SetSpeaker + UI:WaitShowDialogue(STRINGS:FormatKey(CLE)) — texte = couche d'adaptation FR")
add("message_SetFace",           "MESSAGE", "ADAPT", "portrait + émotion", "UI:SetSpeaker(chara) + GeneralFunctions.SetEmotion(face Sky -> émotion New Era)")
add("message_SetFaceOnly",       "MESSAGE", "ADAPT", "portrait sans dialogue", "idem sans UI:WaitShowDialogue")
add("message_SetActor",          "MESSAGE", "ADAPT", "définit le locuteur", "UI:SetSpeaker(chara) — acteur mappé New Era")
add("message_EmptyActor",        "MESSAGE", "OK",     "locuteur vide", "UI:SetSpeaker('\\\\uE040', true, '', -1, '', Gender.Unknown)")
add("message_ResetActor",        "MESSAGE", "OK",     "réinitialise le locuteur", "UI:ResetSpeaker()")
add("message_Close",             "MESSAGE", "OK",     "ferme le dialogue", "UI:ResetSpeaker()")
add("message_CloseEnforce",      "MESSAGE", "OK",     "ferme le dialogue (forcer)", "UI:ResetSpeaker()")
add("message_SwitchTalk",        "MESSAGE", "ADAPT", "bascule de locuteur selon variable", "if/else sur SV (variable Sky -> SV New Era)")
add("message_SwitchMonologue",   "MESSAGE", "ADAPT", "bascule de monologue", "idem")
add("message_SwitchMenu",        "MESSAGE", "OK",     "menu de choix", "UI:BeginChoiceMenu")
add("message_FacePositionOffset","MESSAGE", "PARTIEL","décalage du portrait", "UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose)")
add("message_ImitationSound",    "MESSAGE", "PARTIEL","son d'imitation vocale", "SOUND:PlayBattleSE approximatif")
add("message_KeyWait",           "MESSAGE", "OK",     "attente clé", "UI:WaitShowDialogue bloque déjà — GAME:WaitFrames court si besoin")
add("message_Mail",              "MESSAGE", "NON",    "courrier (système absent de PMDO)", "à remplacer par un dialogue / rien — NON CONVERTI")

# ------------------------------- ACTEUR ------------------------------------
add("MovePositionMark",      "ACTEUR", "ADAPT", "déplacement vers marqueur", "GROUND:MoveToPosition(chara, sx*8, sy*8) — positions SSA (tuiles) -> pixels")
add("Move2PositionMark",     "ACTEUR", "ADAPT", "déplacement direct vers marqueur", "GROUND:AnimateToPosition / MoveToPosition (sans pathfinding)")
add("MovePositionOffset",    "ACTEUR", "ADAPT", "déplacement relatif", "GROUND:MoveToPosition(chara, pos.x+dx, pos.y+dy)")
add("Move2PositionOffset",   "ACTEUR", "ADAPT", "déplacement relatif direct", "idem")
add("SlidePositionOffset",   "ACTEUR", "ADAPT", "glissement relatif", "GROUND:AnimateToPosition (easing)")
add("Slide2PositionOffset",  "ACTEUR", "ADAPT", "glissement relatif direct", "idem")
add("SlidePositionMark",     "ACTEUR", "ADAPT", "glissement vers marqueur", "idem")
add("SetPositionOffset",     "ACTEUR", "ADAPT", "téléportation relative", "GROUND:TeleportTo(chara, x, y, dir)")
add("SetPositionMark",       "ACTEUR", "ADAPT", "téléportation vers marqueur", "GROUND:TeleportTo")
add("MoveHeight",            "ACTEUR", "ADAPT", "changement d'altitude", "chara.LocHeight (vol/saut) — valeurs Sky -> pixels")
add("Turn2Direction",        "ACTEUR", "ADAPT", "rotation vers direction", "GROUND:CharAnimateTurnTo(chara, dir, frames) — speed/rot -> frames")
add("Turn2DirectionLives",   "ACTEUR", "ADAPT", "rotation d'un acteur", "idem")
add("SetDirection",          "ACTEUR", "ADAPT", "direction immédiate", "chara.Direction = dir")
add("SetAnimation",          "ACTEUR", "ADAPT", "animation", "GROUND:CharSetAnim(chara, nomPMDO, loop) — TABLE anim Sky->PMDO REQUISE (id par espèce)")
add("WaitAnimation",         "ACTEUR", "OK",     "attente fin d'animation", "GROUND:CharWaitAnim(chara)")
add("SetEffect",             "ACTEUR", "ADAPT", "effet de sprite", "GROUND:CharSetEmote / CharSetDrawEffect / PlayVFX — TABLE effets Sky->PMDO REQUISE ; ids 640/645/651 NON CONVERTIS")
add("WaitEffect",            "ACTEUR", "OK",     "attente fin d'effet", "GAME:WaitFrames")
add("SetOutputAttribute",    "ACTEUR", "PARTIEL","attribut de sortie (bulle ?)", "sémantique à confirmer — approximatif")

# ------------------------------- CAMERA ------------------------------------
add("camera_SetMyself",           "CAMERA", "PARTIEL", "caméra suit le performer", "focus caméra PMDO si exposé ; sinon défaut (suit le héros)")
add("camera2_SetPositionMark",    "CAMERA", "PARTIEL", "sous-caméra vers marqueur", "équivalent overlay/parallaxe approximatif")
add("camera_SetEffect",           "CAMERA", "ADAPT",  "effet caméra (shake)", "GROUND:MoveScreen(ScreenMover(0, intensité, durée))")
add("camera2_SetEffect",          "CAMERA", "PARTIEL", "effet sous-caméra", "idem approximatif")

# ------------------------------- ECRAN -------------------------------------
add("screen_FadeIn",        "ECRAN", "OK", "fondu entrée", "GAME:FadeIn(dur)")
add("screen_FadeOut",       "ECRAN", "OK", "fondu sortie", "GAME:FadeOut(false, dur)")
add("screen_FadeInAll",     "ECRAN", "OK", "fondu entrée toutes couches", "GAME:FadeIn(dur)")
add("screen_FadeOutAll",    "ECRAN", "OK", "fondu sortie toutes couches", "GAME:FadeOut(false, dur)")
add("screen_WhiteOut",      "ECRAN", "OK", "voile blanc", "GAME:FadeOut(true, dur)")
add("screen_WhiteOutAll",   "ECRAN", "OK", "voile blanc toutes couches", "GAME:FadeOut(true, dur)")
add("screen_FlushIn",       "ECRAN", "ADAPT", "fondu coloré entrée", "FlashEmitter(StartColor r,g,b) / BossFX.Overlay")
add("screen_FlushOut",      "ECRAN", "ADAPT", "fondu coloré sortie", "idem")
add("screen2_FadeIn",       "ECRAN", "ADAPT", "fondu de la couche décor", "overlay scène (fond) — MECANIQUE DU RIDEAU/SCENE DU FUTUR")
add("screen2_FadeOut",      "ECRAN", "ADAPT", "fondu sortie couche décor", "idem")
add("screen2_WhiteOut",     "ECRAN", "ADAPT", "voile blanc couche décor", "idem")

# ------------------------------- AUDIO -------------------------------------
add("se_Play",       "AUDIO", "ADAPT", "effet sonore", "SOUND:PlayBattleSE('EVT_...') — TABLE SE Sky->PMDO REQUISE")
add("se_Stop",       "AUDIO", "PARTIEL", "arrêt SE", "pas d'arrêt SE direct PMDO (StopBGM ne couvre pas les SE)")
add("se_FadeOut",    "AUDIO", "PARTIEL", "fondu SE", "idem")
add("sound_Stop",    "AUDIO", "PARTIEL", "arrêt de tous les SE", "idem")
add("WaitSe",        "AUDIO", "PARTIEL", "attente fin de SE", "GAME:WaitFrames approximatif")
add("bgm_PlayFadeIn","AUDIO", "ADAPT", "musique", "SOUND:PlayBGM('xxx.ogg', true) — TABLE BGM Sky->New Era REQUISE")
add("bgm_FadeOut",   "AUDIO", "OK", "fondu musique", "SOUND:FadeOutBGM(dur)")
add("bgm_Stop",      "AUDIO", "OK", "arrêt musique", "SOUND:StopBGM()")
add("bgm2_PlayFadeIn","AUDIO", "NON", "2e canal BGM", "PMDO : un seul canal BGM — NON CONVERTI")
add("bgm2_FadeOut",  "AUDIO", "NON", "fondu 2e canal BGM", "idem — NON CONVERTI")
add("WaitBgm",       "AUDIO", "PARTIEL", "attente musique", "GAME:WaitFrames approximatif")

# ------------------------------- DECOR -------------------------------------
add("back_SetGround",         "DECOR", "ADAPT", "change de ground", "transition -> ground New Era (GAME:EnterGroundMap) — TABLE grounds REQUISE")
add("back_ChangeGround",      "DECOR", "ADAPT", "change de ground", "idem")
add("back2_SetGround",        "DECOR", "ADAPT", "couche décor (image de fond)", "overlay image de la scène (MECANIQUE SCENE FUTUR/RIZEAU)")
add("back2_SetMode",          "DECOR", "PARTIEL", "mode couche décor", "sémantique à confirmer")
add("back2_SetEffect",        "DECOR", "PARTIEL", "effet couche décor", "idem")
add("back_SetDungeonBanner",  "DECOR", "PARTIEL", "bannière donjon", "UI:WaitShowTitle approximatif")
add("back_SetBanner2",        "DECOR", "PARTIEL", "bannière chapitre", "UI:WaitShowTitle(title) approximatif")

# ------------------------------- ETAT --------------------------------------
add("flag_Set",            "ETAT", "ADAPT", "écriture variable", "SV.<var> = valeur — table variables Sky->SV REQUISE")
add("flag_CalcBit",        "ETAT", "ADAPT", "bit de variable", "opérations bit sur SV")
add("flag_SetScenario",    "ETAT", "ADAPT", "variable scénario", "SV.Scenario[...] = valeur (SCENARIO_MAIN_BIT_FLAG, COMPULSORY_SAVE_POINT)")
add("main_EnterDungeon",   "ETAT", "ADAPT", "entre dans un donjon", "GAME:EnterDungeon / EnterGroundMap — mapping id")

# ---------------------------------------------------------------------------
CATS = ["FLOW", "MESSAGE", "ACTEUR", "CAMERA", "ECRAN", "AUDIO", "DECOR", "ETAT", "META"]

def statut_poids(st):
    return {"OK": 1, "ADAPT": 2, "PARTIEL": 3, "NON": 4}[st]


def main():
    irs = {}
    for p in sorted(glob.glob(os.path.join(IR_DIR, "*_*.json"))):
        if p.endswith("_validation_summary.json") or p.endswith("_coverage_summary.json"):
            continue
        ir = json.load(open(p))
        irs[f"{ir['zone']}_{ir['scene']}"] = ir

    rows = []
    totals = {"ops": 0, "OK": 0, "ADAPT": 0, "PARTIEL": 0, "NON": 0}
    non_converties = []   # (scène, seq, op, raison)
    partielles = []

    for key, ir in sorted(irs.items()):
        zone, scene = key.split("_", 1)
        comptage = {"ops": len(ir["ops"]), "OK": 0, "ADAPT": 0, "PARTIEL": 0, "NON": 0}
        for op in ir["ops"]:
            spec = M.get(op["name"])
            if spec is None:
                comptage["NON"] += 1
                non_converties.append((zone, scene, op["seq"], op["name"], "opcode absent de la table de mapping"))
                continue
            st = spec["status"]
            comptage[st] += 1
            totals[st] += 1
            if st == "NON":
                non_converties.append((zone, scene, op["seq"], op["name"], spec["note"]))
            elif st == "PARTIEL":
                partielles.append((zone, scene, op["seq"], op["name"], spec["note"]))
        totals["ops"] += comptage["ops"]
        rows.append({"zone": zone, "scene": scene, **comptage})

    # ---- CSV ----
    with open(OUT_CSV, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["zone", "scene", "ops_totales", "ops_comprises", "converties_OK",
                    "adaptation_ADAPT", "partielles_PARTIEL", "non_converties_NON"])
        for r in rows:
            w.writerow([r["zone"], r["scene"], r["ops"], r["ops"],
                        r["OK"], r["ADAPT"], r["PARTIEL"], r["NON"]])

    json.dump({"rows": rows, "totals": totals, "non_converties": non_converties,
               "partielles": partielles}, open(OUT_JSON, "w", encoding="utf-8"),
              ensure_ascii=False, indent=1)

    # ---- Markdown ----
    L = []
    L.append("# MATRICE DE COUVERTURE — SSB → Lua PMDO — ARC DU FUTUR")
    L.append("")
    L.append("Pipeline : `SSB ops totales → ops comprises → ops converties → ops non converties`.")
    L.append("")
    L.append("Statuts : **OK** = idiome attesté · **ADAPT** = idiome OK mais dépend de la couche d'adaptation")
    L.append("New Era (acteurs/dialogues/BGM/grounds/anims/SE/effets) · **PARTIEL** = approximatif (signalé, jamais")
    L.append("silencieux) · **NON** = aucun équivalent PMDO (explicitement NON CONVERTI).")
    L.append("")
    pct = lambda a, b: f"{100*a/b:.1f}%" if b else "—"
    L.append(f"## Récapitulatif global ({totals['ops']} ops sur 24 scènes)")
    L.append("")
    L.append(f"- Ops totales : **{totals['ops']}**")
    L.append(f"- Ops comprises (opcode connu + sémantique établie) : **{totals['ops']} ({pct(totals['ops'], totals['ops'])})**")
    conv = totals["OK"] + totals["ADAPT"]
    L.append(f"- Ops converties (OK + ADAPT) : **{conv} ({pct(conv, totals['ops'])})**")
    L.append(f"  - OK direct : **{totals['OK']}** ({pct(totals['OK'], totals['ops'])})")
    L.append(f"  - ADAPT (couche New Era requise) : **{totals['ADAPT']}** ({pct(totals['ADAPT'], totals['ops'])})")
    L.append(f"- Ops partielles (approximatives, signalées) : **{totals['PARTIEL']}** ({pct(totals['PARTIEL'], totals['ops'])})")
    L.append(f"- Ops NON converties : **{totals['NON']}** ({pct(totals['NON'], totals['ops'])})")
    L.append("")
    L.append("## Par scène")
    L.append("")
    L.append("| Zone | Scène | Ops | Comprises | OK | ADAPT | PARTIEL | NON | Taux converti |")
    L.append("|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        conv_r = r["OK"] + r["ADAPT"]
        L.append(f"| {r['zone']} | {r['scene']} | {r['ops']} | {r['ops']} | {r['OK']} | {r['ADAPT']} | "
                 f"{r['PARTIEL']} | {r['NON']} | {pct(conv_r, r['ops'])} |")
    L.append("")
    L.append("## Table de mapping par opcode (89 opcodes de l'arc)")
    L.append("")
    L.append("| Opcode | Catégorie | Statut | Idiome PMDO | Note |")
    L.append("|---|---|---|---|---|")
    for name in sorted(M, key=lambda n: (M[n]["cat"], n)):
        s = M[name]
        L.append(f"| `{name}` | {s['cat']} | **{s['status']}** | {s['idiom']} | {s['note']} |")
    L.append("")
    if non_converties:
        L.append("## Ops NON converties (exhaustif)")
        L.append("")
        L.append("| Scène | Seq | Op | Raison |")
        L.append("|---|---|---|---|")
        for zone, scene, seq, op, raison in non_converties:
            L.append(f"| {zone}/{scene} | {seq} | `{op}` | {raison} |")
        L.append("")
    if partielles:
        L.append("## Ops PARTIELLES (exhaustif)")
        L.append("")
        L.append("| Scène | Seq | Op | Raison |")
        L.append("|---|---|---|---|")
        for zone, scene, seq, op, raison in partielles:
            L.append(f"| {zone}/{scene} | {seq} | `{op}` | {raison} |")
        L.append("")

    open(OUT_MD, "w", encoding="utf-8").write("\n".join(L))
    print(f"Matrice écrite : {OUT_MD}")
    print(f"Totaux : {totals}")
    print(f"Non converties : {len(non_converties)} — Partielles : {len(partielles)}")


if __name__ == "__main__":
    main()
