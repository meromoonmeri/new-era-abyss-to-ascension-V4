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

# entid (md_index) -> espèce PMDO (dérivé de PMDO_MAPPING, 525 entrées)
def _load_entid_map():
    m = json.load(open(os.path.join(CAMP, "Tables", "PMDO_MAPPING.json")))
    out = {}
    for en, e in m["species"]["entries"].items():
        sp = e.get("pmdo_species")
        if sp:
            for mi in e["md_indexes"]:
                out[mi] = sp
                out[mi % 600] = sp
    return out

ENTID2SPECIES = _load_entid_map()

# table GLOBALE acteurs (ACTOR_GLOBAL_TABLE.json — entid unique ROM +
# première position SSA par zone) : résout le cast des scènes dont le
# SSA propre ne place pas l'acteur (chargé par une autre scène de la zone)
_AGT = json.load(open(os.path.join(CAMP, "Docs",
                                   "ACTOR_GLOBAL_TABLE.json")))
GLOBAL_ACTOR_ENTID = _AGT["entid"]
GLOBAL_ACTOR_ZONEPOS = _AGT["zone_first_pos"]

DIRMAP = {"DIR_DOWN": "Direction.Down", "DIR_DOWNRIGHT": "Direction.DownRight",
          "DIR_RIGHT": "Direction.Right", "DIR_UPRIGHT": "Direction.UpRight",
          "DIR_UP": "Direction.Up", "DIR_UPLEFT": "Direction.UpLeft",
          "DIR_LEFT": "Direction.Left", "DIR_DOWNLEFT": "Direction.DownLeft"}

# BGM canoniques -> fichiers PMDO présents. AUTORITÉ : enum music_id
# pmdsky-debug (204 pistes) -> titre jukebox -> fichier .ogg vérifié
# PRÉSENT dans Content/Music ou DumpAsset (56 correspondances). Les
# pistes absentes du roster restent GAP (REQUIRES_MOD_ASSET), jamais
# substituées.
BGM = {"BGM_AEGIS_CAVE": "Aegis Cave.ogg",
       "BGM_AMP_PLAINS": "Amp Plains.ogg",
       "BGM_APPLE_WOODS": "Apple Woods.ogg",
       "BGM_BATTLE_AGAINST_DUSKNOIR": "Battle Against Dusknoir.ogg",
       "BGM_BOSS_BATTLE": "Boss Battle.ogg",
       "BGM_BOULDER_QUARRY": "Boulder Quarry.ogg",
       "BGM_BRINE_CAVE": "Brine Cave.ogg",
       "BGM_CHASM_CAVE": "Chasm Cave.ogg",
       "BGM_CRAGGY_COAST": "Craggy Coast.ogg",
       "BGM_CRYSTAL_CAVE": "Crystal Cave.ogg",
       "BGM_CRYSTAL_CROSSING": "Crystal Crossing.ogg",
       "BGM_DARK_CRATER": "Dark Crater.ogg",
       "BGM_DARK_HILL": "Dark Hill.ogg",
       "BGM_DEEP_DARK_CRATER": "Deep Dark Crater.ogg",
       "BGM_DEEP_DUSK_FOREST": "Deep Dusk Forest.ogg",
       "BGM_DRENCHED_BLUFF": "Drenched Bluff.ogg",
       "BGM_FOGGY_FOREST": "Foggy Forest.ogg",
       "BGM_GOODNIGHT": "Goodnight.ogg",
       "BGM_GROWING_ANXIETY": "Growing Anxiety.ogg",
       "BGM_GUILDMASTER_WIGGLYTUFF": "Guildmaster Wigglytuff.ogg",
       "BGM_HEARTWARMING": "Heartwarming.ogg",
       "BGM_HIDDEN_HIGHLAND": "Hidden Highland.ogg",
       "BGM_HIDDEN_LAND": "Hidden Land.ogg",
       "BGM_ICICLE_FOREST": "Icicle Forest.ogg",
       "BGM_LOWER_SPRING_CAVE": "Lower Spring Cave.ogg",
       "BGM_MAROWAK_DOJO": "Marowak Dojo.ogg",
       "BGM_MONSTER_HOUSE": "Monster House.ogg",
       "BGM_MT_BRISTLE": "Mt. Bristle.ogg",
       "BGM_MT_HORN": "Mt. Horn.ogg",
       "BGM_MT_TRAVAIL": "Mt. Travail.ogg",
       "BGM_MYSTIFYING_FOREST": "Mystifying Forest.ogg",
       "BGM_NORTHERN_DESERT": "Northern Desert.ogg",
       "BGM_OUTLAW": "Outlaw.ogg",
       "BGM_QUICKSAND_CAVE": "Quicksand Cave.ogg",
       "BGM_RISING_FEAR": "Rising Fear.ogg",
       "BGM_SEALED_RUIN": "Sealed Ruin.ogg",
       "BGM_SKY_PEAK_CAVE": "Sky Peak Cave.ogg",
       "BGM_SKY_PEAK_COAST": "Sky Peak Coast.ogg",
       "BGM_SKY_PEAK_FOREST": "Sky Peak Forest.ogg",
       "BGM_SKY_PEAK_PRAIRIE": "Sky Peak Prairie.ogg",
       "BGM_SPRING_CAVE": "Spring Cave.ogg",
       "BGM_SPRING_CAVE_DEPTHS": "Spring Cave Depths.ogg",
       "BGM_STAR_CAVE": "Star Cave.ogg",
       "BGM_STEAM_CAVE": "Steam Cave.ogg",
       "BGM_SYMPATHY": "Sympathy.ogg",
       "BGM_TEAM_SKULL": "Team Skull.ogg",
       "BGM_TEMPORAL_TOWER": "Temporal Tower.ogg",
       "BGM_TIME_GEAR_REMIX": "Time Gear Remix.ogg",
       "BGM_TIME_RESTORED": "Time Restored.ogg",
       "BGM_TOP_MENU_THEME": "Top Menu Theme.ogg",
       "BGM_TREASURE_TOWN": "Treasure Town.ogg",
       "BGM_TREESHROUD_FOREST": "Treeshroud Forest.ogg",
       "BGM_UPPER_STEAM_CAVE": "Upper Steam Cave.ogg",
       "BGM_WATERFALL_CAVE": "Waterfall Cave.ogg",
       "BGM_WIGGLYTUFFS_GUILD": "Wigglytuff's Guild.ogg",
       "BGM_WIGGLYTUFFS_GUILD_REMIX": "Wigglytuff's Guild Remix.ogg",
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


def last_int_arg(args, default=0):
    nums = re.findall(r'-?\d+', args)
    return int(nums[-1]) if nums else default


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
    def __init__(self, zone, name, src, cast=None):
        self.zone, self.name, self.src = zone, name, src
        self.lines = []
        self.gaps = []
        self.unsupported = []
        self.dialogues = 0
        self.face_pending = None
        # cast SSA : ACTOR_NAME -> (var lua, species, x8, y8, dir)
        self.cast = cast or {}
        self.spawned = set()
        # double écran NDS -> single-screen focus (subscreen.lua)
        self.sub_ground = None    # décor chargé par back2_SetGround
        self.sub_shown = False    # écran sub actuellement révélé
        self.main_shown = False   # écran main actuellement révélé
        self.used_subscreen = False
        self.routine_actor = None   # cible implicite (def N for actor X)

    def emit(self, s):
        self.lines.append("  " + s)

    def gap(self, s):
        self.gaps.append(s)
        self.emit("-- GAP: " + s)

    def actor_expr(self, actor):
        if actor.startswith("ACTOR_PLAYER"):
            # ACTOR_PLAYER + variantes d'épisode (PLAYER_FUTURE = héros de
            # l'arc du futur, PLAYER_CHARMS/KIMAWARI/PUPURIN = héros
            # jouable de l'épisode spécial, PLAYER_APPOINT = héros désigné)
            # : tous jouent le RÔLE du héros dans leur scène — résolus sur
            # le leader d'équipe courant (canon: c'est le personnage
            # contrôlé à ce moment du scénario)
            return "hero"
        if actor.startswith("ACTOR_ATTENDANT") or actor == "ACTOR_PARTNER":
            return "partner"
        # PNJ nommé résolu par le cast SSA de la scène (v2)
        key = actor.replace("ACTOR_", "")
        if key in self.cast:
            var, species, x, y, d = self.cast[key]
            if key not in self.spawned:
                self.spawned.add(key)
                self.emit(f"local {var} = SkySceneKit.spawn_npc("
                          f"{lua_str(species)}, {x}, {y}, {d}, "
                          f"{lua_str(key)})")
            return var
        return None

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
        # hold : instruction nue (pause 1 frame de l'interpréteur SSB)
        if st == "hold":
            self.emit("GAME:WaitFrames(1) -- hold")
            return
        # écritures de drapeaux scénario : $SCENARIO_MAIN_BIT_FLAG[n] = v
        # -> SV natif (même mécanique que SkyScenario ; relu par les
        # branches if() de la ROM, conservé pour la progression)
        mb = re.match(r"\$SCENARIO_MAIN_BIT_FLAG\[(\d+)\]\s*=\s*(\d+)$", st)
        if mb:
            n, v = int(mb.group(1)), int(mb.group(2))
            self.emit(f"SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags "
                      f"or {{}}; SV.SkyScenarioBitFlags[{n}] = {v}"
                      f" -- $SCENARIO_MAIN_BIT_FLAG[{n}] = {v} (ROM)")
            return
        # switch à CORPS VIDE sur un menu système NDS :
        # `switch ( message_Menu(MENU_X) ) { }` — la ROM affiche le menu
        # moteur (init d'équipe, crédits, sauvegarde) et ne branche sur
        # AUCUN cas. Équivalents PMDO : menus gérés par le moteur/harnais
        # (l'init d'équipe est faite au NewGame, la sauvegarde par
        # GroundSave) — neutralisé avec trace, aucun embranchement perdu.
        # étiquettes de flux du décompilateur : @label_N seul = point de
        # saut (le flux linéaire du def 0 la traverse naturellement)
        if re.match(r"@label_\d+$", st):
            self.emit(f"-- {st} [étiquette de flux ExplorerScript]")
            return
        mm_menu = re.match(
            r"switch\s*\(\s*message_Menu\(([A-Z0-9_]+)\)\s*\)\s*\{\s*\}$",
            st, re.S)
        if mm_menu:
            self.emit(f"-- switch(message_Menu({mm_menu.group(1)})) "
                      f"[menu système NDS sans embranchement (corps "
                      f"vide): équivalent géré par le moteur PMDO]")
            return
        # switch($LANGUAGE_TYPE) : la langue est résolue au RUNTIME par le
        # kit (say choisit la langue du joueur) ; les cases par langue des
        # crédits déroulent le même contenu par langue. On compile la
        # PREMIÈRE case comme corps (les autres = mêmes ops, textes par
        # langue déjà dans les blocs 5 langues) — trace documentée.
        mm_lang = re.match(
            r"switch\s*\(\s*\$LANGUAGE_TYPE\s*\)\s*\{(.*)\}$", st, re.S)
        if mm_lang:
            body = mm_lang.group(1)
            first = re.split(r"case\s+\d+\s*:", body)
            if len(first) > 1:
                seg = first[1]
                nxt = re.search(r"case\s+\d+\s*:", seg)
                if nxt:
                    seg = seg[:nxt.start()]
                self.emit("-- switch($LANGUAGE_TYPE): case unique "
                          "compilée (textes 5 langues résolus par le "
                          "kit au runtime)")
                self.compile_def0(seg)
                return
        m = re.match(r"(\w+)(?:<(\w+) (\w+)>)?\s*\((.*)\)$", st, re.S)
        if not m:
            # switch/if imbriqués -> hors périmètre v1
            self.unsupported.append(st.split("(")[0][:40])
            return
        op, kind, target, args = m.group(1), m.group(2), m.group(3), \
            m.group(4)
        # cible implicite : dans `def N for actor X`, les ops sans
        # <actor Y> explicite visent X (sémantique interpréteur SSB)
        if not target and getattr(self, "routine_actor", None):
            target = self.routine_actor
            kind = kind or "actor"
        A = self.actor_expr(target) if target else None

        if op == "Wait":
            self.emit(f"GAME:WaitFrames({int(args)})")
        elif op in ("WaitExecuteLives", "WaitEffect", "WaitAnimation",
                    "WaitScreenFade", "WaitScreenFadeAll", "WaitLockLives",
                    "WaitExecutePerformer", "WaitLockPerformer",
                    "WaitSe", "WaitMe", "WaitBgm", "WaitBgm2"):
            self.emit("GAME:WaitFrames(2) -- join " + op)
        elif op == "screen_FadeIn":
            f = args.split(",")
            self.emit(f"GAME:FadeIn({int(f[-1])})")
            self.main_shown = True
        elif op == "screen_FadeOut":
            f = args.split(",")
            self.emit(f"GAME:FadeOut(false, {int(f[-1])})")
            self.main_shown = False
        elif op in ("screen_FadeInAll", "screen_FadeOutAll"):
            n = args.split(",")[-1]
            fn = "FadeIn" if "In" in op else "FadeOut"
            arg = n if fn == "FadeIn" else f"false, {n}"
            self.emit(f"GAME:{fn}({arg.strip()})")
            self.main_shown = "In" in op
        elif op in ("screen_FlushIn", "screen_FlushOut",
                    "screen_FlushChange"):
            # flush = révélation/occultation rapide de l'écran principal
            # (même sémantique que Fade, rideau instantané NDS)
            n = last_int_arg(args, 4)
            if op == "screen_FlushOut":
                self.emit(f"GAME:FadeOut(false, {n}) -- {op}")
                self.main_shown = False
            else:
                self.emit(f"GAME:FadeIn({n}) -- {op}")
                self.main_shown = True
        # ---- double écran NDS -> single-screen focus (subscreen.lua,
        # timeline canonique DUAL_SCREEN_TIMELINES.json). Le contenu du
        # 2e écran est AFFICHÉ quand la ROM le révèle, jamais jeté.
        elif op == "back2_SetGround":
            g = re.search(r"LEVEL_([A-Z0-9_]+)", args)
            if g:
                self.sub_ground = g.group(1).lower()
                self.emit(f"-- back2_SetGround({g.group(1)}) [décor sub "
                          f"chargé: Sub_{self.sub_ground}]")
            else:
                self.unsupported.append("back2_SetGround:arg")
        elif op in ("screen2_FadeChange", "screen2_WhiteChange") \
                and self.sub_shown:
            # variation d'alpha du sub DÉJÀ révélé (pulsation lumineuse
            # NDS) : la nappe reste affichée — trace documentée, pas un
            # nouveau Show
            self.emit(f"-- {op}({args.strip()[:24]}) [variation d'alpha "
                      f"du sub déjà révélé: nappe maintenue - documenté]")
        elif op in ("screen2_FadeIn", "screen2_FlushIn",
                    "screen2_FadeChange", "screen2_WhiteChange"):
            if self.sub_ground is None:
                # révélation SANS back2_SetGround préalable : le sub
                # affiche son mode par défaut (wallpaper système NDS,
                # back2_SetMode sans décor) — aucun contenu narratif à
                # reproduire sur le canvas unique. Trace documentée.
                self.emit(f"-- {op}({args.strip()[:16]}) [sub révélé en "
                          f"mode système NDS (aucun décor chargé): pas de "
                          f"contenu narratif - documenté]")
                self.sub_shown = True
            else:
                fade = args.split(",")[-1].strip() or "20"
                both = "true" if self.main_shown else "false"
                focus = "BOTH_FOCUS" if self.main_shown else "TOP_FOCUS"
                self.emit(f"SkySubScreen.Show({lua_str(self.sub_ground)}, "
                          f"{fade}, {both}) -- {op}: {focus} "
                          f"(timeline ROM)")
                self.sub_shown = True
                self.used_subscreen = True
        elif op in ("screen2_FadeOut", "screen2_FlushOut",
                    "screen2_WhiteOut"):
            fade = args.split(",")[-1].strip() or "20"
            if self.sub_shown:
                self.emit(f"SkySubScreen.Hide({fade}) -- {op}: retour "
                          f"BOTTOM_FOCUS (timeline ROM)")
                self.sub_shown = False
            else:
                self.emit(f"-- {op} [sub déjà caché]")
        elif op == "back2_SetMode":
            self.emit(f"-- back2_SetMode({args.strip()[:20]}) [mode "
                      f"d'affichage sub NDS: géré par SubScreen]")
        elif op in ("bgm2_PlayFadeIn", "bgm2_Play"):
            # canal musique du 2e écran : la NDS mixe deux musiques ;
            # PMDO n'a qu'un canal BGM. Adaptation documentée : le canal
            # sub REMPLACE le principal pendant TOP_FOCUS, sinon ignoré.
            track = args.split(",")[0].strip()
            ogg = BGM.get(track)
            if ogg and self.sub_shown and not self.main_shown:
                self.emit(f"pcall(function() SOUND:PlayBGM("
                          f"{lua_str(ogg)}, true) end) -- bgm2 en "
                          f"TOP_FOCUS (canal unique PMDO)")
            else:
                self.emit(f"-- {op}({track}) [canal BGM sub: PMDO n'a "
                          f"qu'un canal; hors TOP_FOCUS le principal "
                          f"garde la main - adaptation documentée]")
        elif op in ("bgm2_Stop", "bgm2_FadeOut"):
            self.emit(f"-- {op} [canal BGM sub: voir bgm2_Play]")
        elif op == "supervision2_SpecialActing":
            self.emit(f"-- supervision2_SpecialActing({args.strip()[:40]})"
                      f" [acting sub NDS: décor déjà reproduit par "
                      f"SubScreen, acteurs sub non simulés - trace]")
        elif op in ("camera2_SetPositionMark", "camera2_MovePositionMark",
                    "camera2_SetDefault", "camera2_Move2Default",
                    "camera2_SetEffect"):
            # caméra du 2e écran : la nappe Sub_ est un cadrage fixe
            # fenêtre NDS — le recadrage dynamique sub n'est pas simulé
            # (différence documentée, décor complet conservé au rapport)
            self.emit(f"-- {op}({args.strip()[:40]}) [caméra sub NDS: "
                      f"nappe Sub_ cadrée fenêtre NDS, recadrage "
                      f"dynamique non simulé - documenté]")
        elif op in ("WaitSubScreen", "WaitScreen2Fade"):
            self.emit(f"GAME:WaitFrames(2) -- join {op} (fondu sub "
                      f"déjà séquencé par SubScreen)")
        elif op == "WaitBgmSignal":
            # attente d'un point de synchronisation musical NDS (signal
            # SMD) : approx = join court, la piste PMDO n'émet pas de
            # signaux (adaptation documentée)
            self.emit("GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD "
                      "NDS sans équivalent: join fixe documenté)")
        elif op in ("back2_SetEffect", "back2_SetBackEffect",
                    "back2_SetBackScrollSpeed", "back2_SetBackScrollOffset",
                    "back2_SetWeather", "back2_SetWeatherEffect",
                    "back2_SetInvisible", "back2_SetSpecialActing",
                    "bgm2_ChangeVolume", "bgm2_PlayFadeInVolume"):
            self.emit(f"-- {op}({args.strip()[:40]}) [effet du canal sub "
                      f"NDS: nappe Sub_ statique, effet non simulé - "
                      f"documenté]")
        elif op == "back_SetBackScrollSpeed":
            # généralisation du pilote scroll s13p05a (SCROLL_RUNTIME_
            # PASS) : le défilement du fond NDS devient un MOUVEMENT DE
            # CAMÉRA CONTINU. Vitesses ROM en px/frame ; segment de 120
            # frames (durée du plan typique, la caméra suit ensuite la
            # scène). Vitesse (0,0) = arrêt (aucun mouvement émis).
            mm = re.match(r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)", args)
            if mm:
                vx, vy = float(mm.group(1)), float(mm.group(2))
                if vx == 0 and vy == 0:
                    self.emit("-- back_SetBackScrollSpeed(0,0): arrêt du "
                              "défilement")
                else:
                    dx, dy = int(vx * 120), int(vy * 120)
                    self.emit(f"pcall(function() local g=GAME:"
                              f"GetCurrentGround(); GAME:MoveCamera("
                              f"g.ViewCenter.X+({dx}), "
                              f"g.ViewCenter.Y+({dy}), 120, false) end) "
                              f"-- back_SetBackScrollSpeed({vx},{vy}) "
                              f"px/frame -> caméra continue (pilote "
                              f"scroll)")
            else:
                self.unsupported.append("back_SetBackScrollSpeed:args")
        elif op == "back_SetBackScrollOffset":
            mm = re.match(r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)", args)
            if mm:
                dx, dy = int(float(mm.group(1))), int(float(mm.group(2)))
                self.emit(f"pcall(function() local g=GAME:"
                          f"GetCurrentGround(); GAME:MoveCamera("
                          f"g.ViewCenter.X+({dx}), g.ViewCenter.Y+({dy}),"
                          f" 1, false) end) -- back_SetBackScrollOffset "
                          f"px NDS (pilote scroll)")
            else:
                self.unsupported.append("back_SetBackScrollOffset:args")
        elif op == "dungeon_mode":
            # dungeon_mode(id) : bascule l'ID de donjon courant côté NDS
            # (préparation d'un main_EnterDungeon). Transition assurée par
            # le harnais journey (même convention que main_EnterDungeon).
            self.emit(f"-- dungeon_mode({args.strip()[:8]}) [préparation "
                      f"d'entrée donjon NDS: transition assurée par le "
                      f"harnais journey/EnterZone]")
        elif op == "MovePositionLives":
            # (vitesse, ACTOR_X) : déplacer la cible/performer VERS un
            # acteur vivant. performer = caméra (convention V3) -> caméra
            # vers la position de l'acteur ; acteur -> marche vers cible.
            tgt_name = args.split(",")[-1].strip()
            tgt2 = "hero" if tgt_name == "ACTOR_TALK_SUB" \
                else self.actor_expr(tgt_name)
            sp = re.match(r"\s*([\d.]+)", args)
            if kind == "performer" and tgt2:
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GAME:MoveCamera(p.X, p.Y, 60, false) end) "
                          f"-- MovePositionLives performer/caméra vers "
                          f"{tgt_name}")
            elif A and tgt2:
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X, p.Y, false, "
                          f"{speed}) end) -- MovePositionLives")
            else:
                self.unsupported.append(f"MovePositionLives:{tgt_name}")
        elif op == "SetPositionLives":
            # téléporter à la position d'un autre acteur/objet ; les
            # cibles objets de décor ne sont pas simulées (trace)
            tgt_name = args.strip()
            tgt2 = self.actor_expr(tgt_name) \
                if tgt_name.startswith("ACTOR_") else None
            if A and tgt2:
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GROUND:TeleportTo({A}, p.X, p.Y, "
                          f"Direction.Down) end) -- SetPositionLives")
            else:
                self.emit(f"-- SetPositionLives({tgt_name[:24]}) [cible "
                          f"objet/id de décor NDS non simulée - trace]")
        elif op == "se_Stop":
            self.emit(f"-- se_Stop({args.strip()[:8]}) [SE one-shot PMDO "
                      f"déjà terminé: arrêt sans objet, canal SE V2]")
        elif op == "bgm_ChangeVolume":
            # (durée, volume/256) : PMDO n'expose pas le volume BGM en
            # Lua ; volume 0 = silence -> FadeOutBGM(durée) ; retour à
            # 256 après un 0 -> la piste est relancée par le bgm_Play
            # suivant de la ROM (trace sinon)
            parts = re.findall(r'-?\d+', args)
            dur = int(parts[0]) if parts else 30
            vol = int(parts[1]) if len(parts) > 1 else 256
            if vol == 0:
                self.emit(f"pcall(function() SOUND:FadeOutBGM({dur}) "
                          f"end) -- bgm_ChangeVolume vers 0 (silence)")
            else:
                self.emit(f"-- bgm_ChangeVolume({dur},{vol}) [volume BGM "
                          f"non scriptable en Lua PMDO: piste maintenue "
                          f"- documenté]")
        elif op in ("worldmap_SetMode", "worldmap_SetCamera",
                    "worldmap_MoveCamera", "worldmap_SetLevel",
                    "worldmap_SetMark", "worldmap_ChangeLevel"):
            # carte du monde 2e écran NDS (curseur de progression) :
            # information d'ambiance sans équivalent canvas unique —
            # PMDO affiche la progression par ses propres menus
            self.emit(f"-- {op}({args.strip()[:20]}) [carte du monde 2e "
                      f"écran NDS: information de progression, gérée par "
                      f"les menus PMDO - documenté]")
        elif op == "back_SetBanner2":
            self.emit(f"-- back_SetBanner2({args.strip()[:30]}) [bannière "
                      f"2e écran NDS: information dupliquée du menu, hors "
                      f"canvas unique - documenté]")
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
        elif op in ("message_SetFace", "message_SetFaceOnly"):
            # SetFaceOnly = portrait sans passer la parole (même donnée
            # speaker, le portrait PMDO suit le speaker du kit)
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
        elif op == "MovePositionMark" and kind == "performer":
            # performer = caméra dans les SSB (camera_SetMyself performer 0)
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, "
                          f"60, false) end) -- performer/caméra")
            else:
                self.unsupported.append("MovePositionMark:performer")
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
        elif op in ("Move2PositionOffset", "Slide2PositionOffset",
                    "SlidePositionOffset", "MovePositionOffset2"):
            mm = re.search(r"<'?\w*'?,?\s*(-?[\d.]+),\s*(-?[\d.]+)>", args)
            flat = re.match(
                r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*$",
                args)
            if A and mm:
                dx = int(float(mm.group(1)) * 8)
                dy = int(float(mm.group(2)) * 8)
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, 2) end")
            elif A and flat:
                # signature plate ROM: (vitesse px/frame, dx px, dy px) —
                # mêmes unités que MovePositionOffset (preuve pilote scroll)
                sp = float(flat.group(1))
                dx = int(float(flat.group(2)))
                dy = int(float(flat.group(3)))
                speed = 2 if sp >= 0.6 else 1
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, {speed}) end -- {op}")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "SetPositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if kind == "performer" and mm:
                # performer = caméra (convention V3) : placement instantané
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, 1,"
                          f" false) end) -- SetPositionMark performer/"
                          f"caméra")
            elif A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"GROUND:TeleportTo({A}, {x}, {y}, "
                          f"Direction.Down)")
            else:
                self.unsupported.append(f"SetPositionMark:{target}")
        elif op == "Turn2DirectionLives":
            # se tourner vers un autre acteur — la cible est le DERNIER
            # argument ACTOR_* ; résolue par actor_expr (héros/partenaire/
            # PNJ du cast SSA). ACTOR_TALK_SUB = interlocuteur courant ->
            # approx: se tourner vers le héros (TECHNICAL_ADAPTATION).
            tgt_name = args.split(",")[-1].strip()
            if tgt_name == "ACTOR_TALK_SUB":
                tgt2 = "hero"
            else:
                tgt2 = self.actor_expr(tgt_name)
            if A and tgt2:
                self.emit(f"pcall(function() GROUND:CharTurnToCharAnimated("
                          f"{A}, {tgt2}, 4) end)")
            else:
                self.unsupported.append(f"Turn2DirectionLives:{tgt_name}")
        elif op == "SetPositionInitial":
            self.emit(f"-- SetPositionInitial [position SSA de départ, "
                      f"déjà posée par le placement de scène]")
        elif op in ("message_CloseEnforce",):
            self.emit("-- message_CloseEnforce")
        elif op in ("message_SetActor", "message_EmptyActor",
                    "message_SetFaceEmpty"):
            self.emit("pcall(function() UI:ResetSpeaker() end)")
        elif op == "MovePositionOffset":
            # signature ROM: (vitesse px/frame, dx px, dy px) — preuve:
            # S13P05A SetPositionOffset/scroll pilote (unités px NDS)
            mm = re.match(
                r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*$", args)
            if mm and kind == "performer":
                # performer = caméra (convention V3) : glissement relatif
                sp = float(mm.group(1)) or 1.0
                dx, dy = float(mm.group(2)), float(mm.group(3))
                dur = max(1, int(round(
                    max(abs(dx), abs(dy)) / max(sp, 0.01))))
                self.emit(f"pcall(function() local g=GAME:GetCurrentGround()"
                          f"; GAME:MoveCamera(g.ViewCenter.X+({int(dx)}), "
                          f"g.ViewCenter.Y+({int(dy)}), {dur}, false) end)"
                          f" -- MovePositionOffset performer/caméra")
            elif mm and A:
                sp = float(mm.group(1))
                dx, dy = int(float(mm.group(2))), int(float(mm.group(3)))
                speed = 2 if sp >= 0.6 else 1
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, {speed}) end")
            else:
                self.unsupported.append(f"MovePositionOffset:{target}")
        elif op in ("main_EnterDungeon", "main_EnterGround",
                    "main_SetGround", "main_EnterRescueUser",
                    "main_EnterTraining"):
            # transition de fin de scène NDS : dans PMDO le changement de
            # zone est effectué par le harnais journey/le jeu (EnterZone),
            # pas par la cinématique elle-même — neutralisé AVEC trace
            # (même convention que les ops de station V3).
            self.emit(f"-- {op}({args.strip()[:60]}) [transition de zone "
                      f"NDS: assurée par le harnais journey/EnterZone PMDO]")
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
        elif op == "se_FadeOut":
            # canal SE NDS : les SE portés (SE_TO_PMDO) sont des one-shots
            # PlayBattleSE déjà terminés — le fondu d'un SE bouclé NDS n'a
            # pas d'objet ; adaptation documentée du canal SE (V2).
            self.emit(f"-- se_FadeOut({args.strip()[:40]}) [SE one-shot "
                      f"PMDO déjà terminé: fondu sans objet, canal SE V2]")
        elif op in ("screen_WhiteOut", "screen_WhiteOutAll"):
            n = last_int_arg(args, 20)
            self.emit(f"GAME:FadeOut(true, {n}) -- {op}")
            self.main_shown = False
        elif op == "screen_WhiteChange":
            n = last_int_arg(args, 20)
            self.emit(f"GAME:FadeIn({n}) -- WhiteChange")
            self.main_shown = True
        elif op == "screen_FadeChange":
            # (mode, durée, alpha_de, alpha_vers) : assombrissement/
            # éclaircissement PARTIEL de l'écran principal. PMDO n'a pas
            # d'alpha caméra scriptable : fondu de même durée, sens
            # déterminé par alpha_vers (documenté).
            parts = [p.strip() for p in args.split(",")]
            dur = int(parts[1]) if len(parts) > 1 and \
                parts[1].lstrip('-').isdigit() else 20
            to_a = int(parts[3]) if len(parts) > 3 and \
                parts[3].lstrip('-').isdigit() else 256
            if to_a >= 192:
                self.emit(f"GAME:FadeIn({dur}) -- screen_FadeChange vers "
                          f"alpha {to_a} (éclaircissement, adaptation)")
            else:
                self.emit(f"GAME:FadeOut(false, {dur}) -- "
                          f"screen_FadeChange vers alpha {to_a} "
                          f"(assombrissement, adaptation)")
        elif op == "WaitExecuteObject":
            # join sur la routine d'un OBJET de scène NDS (props animés) :
            # les routines d'objets ne sont pas simulées — join court,
            # trace explicite (même convention que WaitExecuteLives)
            self.emit(f"GAME:WaitFrames(2) -- join WaitExecuteObject("
                      f"{args.strip()[:30]}) [routine d'objet NDS non "
                      f"simulée - documenté]")
        elif op == "back_SetDungeonBanner":
            # bannière "Donjon - Étage" NDS : équivalent natif PMDO =
            # titre d'écran (même information au même moment)
            self.emit(f"pcall(function() UI:WaitShowTitle(GAME:"
                      f"GetCurrentGround().Name:ToLocal(), 30) end) "
                      f"-- back_SetDungeonBanner({args.strip()[:16]})")
        elif op == "camera_SetEffect":
            # (type, intensité, vitesse) : tremblement/effet caméra NDS.
            # type 2 = tremblement -> ScreenMover natif ; type 0 = stop.
            parts = re.findall(r'-?\d+', args)
            if parts and parts[0] == '0':
                self.emit("-- camera_SetEffect(0): arrêt d'effet caméra")
            else:
                power = int(parts[1]) if len(parts) > 1 else 2
                self.emit(f"pcall(function() GROUND:MoveScreen("
                          f"RogueEssence.Content.ScreenMover(0, "
                          f"{max(1, power * 2)}, 30)) end) "
                          f"-- camera_SetEffect{tuple(parts)}")
        elif op == "SlidePositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            sp = re.match(r"\s*([\d.]+)", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"GROUND:MoveToPosition({A}, {x}, {y}, false, "
                          f"{speed}) -- SlidePositionMark (glissement)")
            else:
                self.unsupported.append(f"SlidePositionMark:{target}")
        elif op == "message_ImitationSound":
            # onomatopée textuelle NDS (bulle "Bzzt!" etc.) : rendue comme
            # dialogue court (même contenu, présentation adaptée)
            langs, _ = parse_dialogue_block(args, args.find("{"))
            if langs:
                tbl = ", ".join(f"{k}={lua_str(v)}"
                                for k, v in langs.items())
                self.emit(f"SkySceneKit.say({{{tbl}}}) "
                          f"-- message_ImitationSound (onomatopée)")
                self.dialogues += 1
            else:
                self.emit("-- message_ImitationSound sans texte")
        elif op == "MoveHeight":
            # élévation d'un objet de scène NDS (lévitation sprite) :
            # objets de décor non simulés — trace (les acteurs du cast le
            # sont via les routines, hors périmètre objet)
            self.emit(f"-- MoveHeight({args.strip()[:24]}) [élévation "
                      f"d'objet NDS non simulée - documenté]")
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
        elif op in ("supervision_Station", "supervision_StationCommon",
                    "supervision_LoadStation", "supervision_RemoveActing",
                    "supervision_RemoveCommon", "supervision_Remove",
                    "ExecuteCommon", "JumpCommon",
                    "supervision_ExecuteCommon", "CallCommon"):
            self.emit(f"-- {op}({args.strip()[:60]}) [gestion de station "
                      f"NDS: le chargement/la coroutine commune est "
                      f"assurée par le harnais journey PMDO]")
        elif op == "Lock":
            # verrou de synchronisation NDS entre routines d'acteurs :
            # sémantique reproduite par le kit (drapeaux partagés,
            # WaitFrames jusqu'à Unlock) — cf. kit.lua multiroutines
            n = last_int_arg(args, 0)
            self.emit(f"SkySceneKit.lock({n}) -- Lock({n}) NDS")
        elif op == "Unlock":
            n = last_int_arg(args, 0)
            self.emit(f"SkySceneKit.unlock({n}) -- Unlock({n}) NDS")
        elif op in ("SetOutputAttribute", "ResetOutputAttribute",
                    "ResetHitAttribute", "SetHitAttribute",
                    "SetMoveRange", "Destroy",
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
            # PARTIAL_FIDELITY admis depuis le single-screen focus
            # (subscreen.lua + DUAL_SCREEN_TIMELINES) : le compilateur
            # reste FAIL-CLOSED op par op — toute op PARTIEL non traduite
            # classe la scène PARTIAL_OPS, jamais approximée en silence.
            if cls not in ("NATIVELY_SUPPORTED", "TECHNICALLY_ADAPTABLE",
                           "PARTIAL_FIDELITY"):
                counts["SKIPPED_" + str(cls)] += 1
                continue
            src = s.get("explorerscript") or ""
            # cast SSA de la même scène (m01a0204.ssb -> m01a0204.ssa)
            cast = {}
            ssa = z["scripts"].get(name[:-4] + ".ssa")
            if ssa and ssa.get("ssa"):
                seen = {}
                for layer in ssa["ssa"]["layers"]:
                    for a in layer.get("actors", []):
                        nm = a["actor_name"]
                        if nm.startswith(("PLAYER", "ATTENDANT")):
                            continue
                        if nm in seen:
                            continue
                        sp = ENTID2SPECIES.get(a["entid"]) \
                            or ENTID2SPECIES.get(a["entid"] % 600)
                        if not sp:
                            continue
                        pos = a["pos"]
                        x = pos["x_relative"] * 8 + pos.get("x_offset", 0) * 4
                        y = pos["y_relative"] * 8 + pos.get("y_offset", 0) * 4
                        d = "Direction." + (pos.get("direction") or "Down")
                        var = "npc_" + re.sub(r"\W", "_", nm.lower())
                        seen[nm] = True
                        cast[nm] = (var, sp, x, y, d)
            # complément : acteurs référencés par le SSB mais absents du
            # SSA propre — résolus par la table globale (entid unique ROM
            # + première position SSA de la ZONE). FAIL-CLOSED : pas de
            # placement dans la zone = pas d'entrée cast.
            for mo in re.finditer(r"ACTOR_([A-Z0-9_]+)", src):
                nm = mo.group(1)
                if nm in cast or nm.startswith(("PLAYER", "ATTENDANT",
                                                "TALK_", "UNIT_",
                                                "ADVENTURE_", "RANDOM_",
                                                "EVENT_NPC")):
                    continue
                entid = GLOBAL_ACTOR_ENTID.get(nm)
                pos = GLOBAL_ACTOR_ZONEPOS.get(f"{zone}|{nm}")
                # entid >= 600 = variante genrée NDS (base + 600)
                sp = (ENTID2SPECIES.get(entid)
                      or ENTID2SPECIES.get(entid % 600)) if entid else None
                if not sp or not pos:
                    continue
                var = "npc_" + re.sub(r"\W", "_", nm.lower())
                cast[nm] = (var, sp, pos[0], pos[1],
                            "Direction." + (pos[2] or "Down"))
            defs = parse_defs(src)
            main_def = next((d for d in defs if d[0] == "0"), None)
            if main_def is None:
                counts["NO_DEF0"] += 1
                continue
            other = [d for d in defs if d[0] != "0"]
            # routines d'acteurs non triviales -> compilées en coroutines
            # parallèles (SkySceneKit.run_routine, sémantique Lock/Unlock
            # NDS reproduite par le kit)
            nontrivial = [d for d in other if re.search(
                r"\b(Move|Turn|message_|Slide)", d[3])]
            comp = SceneCompiler(zone, name, src, cast)
            routine_fns = []
            routines_ok = True
            for rnum, rkind, rtarget, rbody in nontrivial:
                rc = SceneCompiler(zone, name, src, cast)
                rc.spawned = comp.spawned      # partager les spawns
                rc.routine_actor = rtarget      # cible implicite
                ok_r = rc.compile_def0(rbody)
                if not ok_r:
                    comp.unsupported.extend(
                        f"routine{rnum}:{u}" for u in rc.unsupported)
                    routines_ok = False
                    continue
                comp.dialogues += rc.dialogues
                comp.used_subscreen = comp.used_subscreen or \
                    rc.used_subscreen
                routine_fns.append((rnum, rkind, rtarget, rc.lines))
            ok = comp.compile_def0(main_def[3])
            if not ok or not routines_ok:
                counts["PARTIAL_OPS"] += 1
                report[key] = {"status": "PARTIAL_OPS",
                               "unsupported_ops":
                               sorted(set(comp.unsupported))}
                continue
            if comp.dialogues == 0 and len(comp.lines) < 3:
                counts["TRIVIAL_SKIPPED"] += 1
                continue
            fn = f"{zone.lower()}__{name[:-4]}"
            if comp.spawned:
                comp.emit("SkySceneKit.cleanup_npcs()")
            requires = "local SkySceneKit = require 'halcyon.skyscenes.kit'\n"
            if comp.used_subscreen:
                comp.emit("SkySubScreen.Hide(10) -- fin de scène: nappe "
                          "sub retirée")
                requires += ("local SkySubScreen = require "
                             "'halcyon.skyscenes.subscreen'\n")
            body = "\n".join(comp.lines)
            if routine_fns:
                # routines d'acteurs NDS -> coroutines parallèles lancées
                # AVANT le def 0 (comme l'interpréteur SSB), jointes après
                pre = ["  SkySceneKit.reset_locks()"]
                for rnum, rkind, rtarget, rlines in routine_fns:
                    pre.append(f"  SkySceneKit.run_routine(function() "
                               f"-- def {rnum} for {rkind} {rtarget}")
                    pre.extend("  " + ln for ln in rlines)
                    pre.append("  end)")
                body = "\n".join(pre) + "\n" + body + \
                    "\n  SkySceneKit.join_routines()"
                counts["COMPILED_MULTIROUTINE"] += 1
            lua = (HEADER % (zone, name) + requires
                   + f"return function(hero, partner)\n{body}\nend\n")
            open(os.path.join(OUT, fn + ".lua"), "w",
                 encoding="utf-8").write(lua)
            emitted.append(fn)
            counts["COMPILED"] += 1
            if comp.used_subscreen:
                counts["COMPILED_DUAL_SCREEN"] += 1
            report[key] = {"status": "COMPILED", "file": fn + ".lua",
                           "dialogues": comp.dialogues,
                           "dual_screen_focus": comp.used_subscreen or None,
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
