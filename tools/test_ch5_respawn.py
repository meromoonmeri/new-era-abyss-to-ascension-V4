#!/usr/bin/env python3
"""Verifie la regle respawn du chapitre 5, pour tous les donjons au schema
segmente (seg0 -> point median -> 2e moitie -> boss) : Vast Steppe, Tunnel
Incandescent, Mont Venteux.

Regle (demande utilisateur) : si on ABANDONNE ou si on est KO, on revient
a la CINEMATIQUE DE RESPAWN du donjon :
  - mort/abandon AVANT le point median (seg0)      -> entree + cinematique de retour
  - mort/abandon APRES le point median (2e moitie) -> relais + scene de reveil
  - defaite contre le boss/mini-boss               -> cinematique de defaite puis relais
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from simulate import build

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = {'KO': 0, 'Escaped': 3}


def load(L, relpath, gname=None):
    src = open(os.path.join(ROOT, 'Data/Script/halcyon', relpath), encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    mod = L.execute(src)
    if mod is not None and gname:
        L.globals()[gname] = mod


def zone_acts(eng):
    out = []
    for k, a in eng.log:
        if k.startswith('GAME.') or k.startswith('GeneralFunctions.') or k.startswith('SCENE.'):
            args = ', '.join(str(x) for x in a if not hasattr(x, 'keys'))
            out.append('%s(%s)' % (k, args[:55]))
    return out


ENTRANCE_STUB = """
%s = {
  SetupGround = function() PYREC('SCENE.SetupGround') end,
  ArrivalCutscene = function() PYREC('SCENE.ArrivalCutscene') end,
  ArrivalDinnerNightAndAddressCutscene = function() PYREC('SCENE.ArrivalDinnerNightAndAddressCutscene') end,
  KODefeatCutscene = function() PYREC('SCENE.KODefeatCutscene') end,
  RetreatReturnCutscene = function() PYREC('SCENE.RetreatReturnCutscene') end,
  RetreatedCutscene = function() PYREC('SCENE.RetreatedCutscene') end,
  EscapedCutscene = function() PYREC('SCENE.EscapedCutscene') end,
  FailedCutscene = function() PYREC('SCENE.FailedCutscene') end,
  DiedCutscene = function() PYREC('SCENE.DiedCutscene') end,
  SkyTremorScene = function() PYREC('SCENE.SkyTremorScene') end,
}
"""

MIDPOINT_STUB = """
%s = {
  SetupGround = function() PYREC('SCENE.SetupGround') end,
  WipedCutscene = function() PYREC('SCENE.WipedCutscene') end,
  FirstArrival = function() PYREC('SCENE.FirstArrival') end,
  RepeatArrival = function() PYREC('SCENE.RepeatArrival') end,
  HasPendingScene = function() return false end,
}
"""

GENERAL_STUB = """
GeneralFunctions = {
  DoAnimation = function() end, SetEmotion = function() end, Hop = function() end,
  RestoreIdleAnim = function() end,
  EndDungeonRun = function(...) PYREC('GeneralFunctions.EndDungeonRun', ...) end,
  DeathFadeOutDialogue = function(...) PYREC('GeneralFunctions.DeathFadeOutDialogue', ...) end,
}
"""

# (donjon, segment, resultat, destination attendue, scene attendue, via, [intro_done])
CASES = [
    # --- Mont Venteux ---
    ('mount_windswept', 0, 'KO',      ('entrance', 50), 'KODefeatCutscene',     'entrance'),
    ('mount_windswept', 0, 'Escaped', ('entrance', 50), 'RetreatReturnCutscene', 'entrance'),
    ('mount_windswept', 2, 'KO',      ('midpoint', 64), 'WipedCutscene',         'midpoint'),
    ('mount_windswept', 2, 'Escaped', ('midpoint', 64), 'WipedCutscene',         'midpoint'),
    # --- Vast Steppe ---
    ('vast_steppe', 0, 'KO',      ('entrance', 46), 'FailedCutscene', 'entrance'),
    ('vast_steppe', 0, 'Escaped', ('entrance', 46), 'FailedCutscene', 'entrance'),
    ('vast_steppe', 2, 'KO',      ('midpoint', 63), 'WipedCutscene',  'midpoint'),
    ('vast_steppe', 2, 'Escaped', ('midpoint', 63), 'WipedCutscene',  'midpoint'),
    # --- Tunnel Incandescent ---
    ('searing_tunnel', 0, 'KO',      ('entrance', 47), 'DiedCutscene',    'entrance'),
    ('searing_tunnel', 0, 'Escaped', ('entrance', 47), 'EscapedCutscene', 'entrance'),
    ('searing_tunnel', 1, 'KO',      ('midpoint', 48), 'WipedCutscene',   'midpoint'),
    # 2e moitie ABANDONNEE : reveil au relais comme un KO (demande utilisateur)
    ('searing_tunnel', 1, 'Escaped', ('midpoint', 48), 'WipedCutscene',   'midpoint'),
    ('searing_tunnel', 3, 'KO',      ('midpoint', 48), 'WipedCutscene',   'midpoint'),  # boss Creuset
    # --- INTRO NON TERMINEE (partie neuve / debug warp, cas du log utilisateur) :
    # le retour du donjon doit jouer la scene de RESPAWN, jamais l'arrivee.
    ('mount_windswept', 0, 'KO',      ('entrance', 50), 'KODefeatCutscene', 'entrance', False),
    ('vast_steppe', 0, 'KO',          ('entrance', 46), 'FailedCutscene',   'entrance', False),
    ('searing_tunnel', 0, 'KO',       ('entrance', 47), 'DiedCutscene',     'entrance', False),
]

ZONES = {
    'mount_windswept': ('zone/mount_windswept/init.lua', 'mount_windswept'),
    'vast_steppe':     ('zone/vast_steppe/init.lua',     'vast_steppe'),
    'searing_tunnel':  ('zone/searing_tunnel/init.lua',  'searing_tunnel'),
}
ENTRANCES = {
    'mount_windswept': ('mount_windswept_entrance', 'mount_windswept_entrance_ch_5'),
    'vast_steppe':     ('vast_steppe_entrance',     'vast_steppe_entrance_ch_5'),
    'searing_tunnel':  ('searing_tunnel_entrance',  'searing_tunnel_entrance_ch_5'),
}
MIDPOINTS = {
    'mount_windswept': ('mount_windswept_midpoint', 'mount_windswept_midpoint_ch_5'),
    'vast_steppe':     ('vast_steppe_midpoint',     'vast_steppe_midpoint_ch_5'),
    'searing_tunnel':  ('searing_tunnel_midpoint',  'searing_tunnel_midpoint_ch_5'),
}


def run_case(zone, seg, outcome, intro_done=True):
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    g.ReplayEnding = {'FollowsRoute': lambda z, c: True}
    for k in ('FinishedMountWindsweptIntro', 'FinishedSteppeIntro', 'FinishedTunnelIntro'):
        g.SV.Chapter5[k] = intro_done
    for k in ('PlayedMountMidpointIntro', 'PlayedSteppeMidpointIntro', 'PlayedMidpointIntro'):
        g.SV.Chapter5[k] = True
    L.execute(GENERAL_STUB)

    zfile, zname = ZONES[zone]
    load(L, zfile, zname)
    L.globals()[zname].ExitSegment(L.eval('{ID="%s"}' % zone), RES[outcome], False, seg, 0)
    joined = ' '.join(zone_acts(eng))

    # destination de la zone
    m = re.findall(r'(?:EndDungeonRun|EnterZone)\([^)]*?, (-?\d+), 0,', joined)
    dest_idx = int(m[-1]) if m else None
    dest_kind = 'entrance' if dest_idx in (50, 46, 47) else ('midpoint' if dest_idx in (64, 63, 48) else '?')

    # dispatch de la cinematique sur la ground d'arrivee
    if dest_kind == 'entrance':
        eg, ch5 = ENTRANCES[zone]
        L.execute(ENTRANCE_STUB % ch5)
        load(L, 'ground/%s/init.lua' % eg, eg)
    else:
        mg, ch5 = MIDPOINTS[zone]
        L.execute(MIDPOINT_STUB % ch5)
        load(L, 'ground/%s/init.lua' % mg, mg)
    L.globals()[eg if dest_kind == 'entrance' else mg].PlotScripting()
    acts = ' '.join(zone_acts(eng))
    scenes = re.findall(r'SCENE\.([A-Za-z]+)', acts)
    return dest_idx, dest_kind, scenes


ok = True
for case in CASES:
    zone, seg, outcome, (exp_kind, exp_idx), exp_scene, via = case[:6]
    intro_done = case[6] if len(case) > 6 else True
    try:
        dest_idx, dest_kind, scenes = run_case(zone, seg, outcome, intro_done)
    except Exception as e:
        print('%-26s | ERREUR simulation: %s' % ('%s seg%d %s' % (zone, seg, outcome), str(e)[:120]))
        ok = False
        continue
    dest_ok = (dest_kind == exp_kind and dest_idx == exp_idx)
    scene_ok = exp_scene in scenes
    # Regle utilisateur : la cinematique D'ENTREE ne doit jamais etre rejouee
    # au respawn — seule la cinematique liee au respawn est rejouee.
    arrival_scenes = ('ArrivalCutscene', 'ArrivalDinnerNightAndAddressCutscene')
    no_arrival_replay = not any(a in arrival_scenes for a in scenes)
    hit = dest_ok and scene_ok and no_arrival_replay
    if not hit:
        ok = False
    print('%-26s | -> %s(%s) %s | scene: %s %s'
          % ('%s seg%d %s' % (zone, seg, outcome), dest_kind, dest_idx,
             'OK' if dest_ok else 'ECHEC (attendu %s %d)' % (exp_kind, exp_idx),
             scenes if scenes else 'AUCUNE', 'OK' if scene_ok else 'ECHEC (attendu %s)' % exp_scene))
    if not no_arrival_replay:
        print('   !!! CINEMATIQUE D\'ENTREE REJOUEE AU RESPAWN (interdit)')

print()
print('RESULTAT GLOBAL:', 'TOUS OK' if ok else 'AU MOINS UN ECHEC / DIVERGENCE SIGNALEE')
sys.exit(0 if ok else 1)
