#!/usr/bin/env python3
"""Verifie le retrait du mini-boss de la Grande Steppe (ch5).

Demande utilisateur : « supprime les mini boss, le donjon doit avoir
qu'un boss final » (deja fait au Mont et au Tunnel). Depuis le relais,
la sortie Nord doit mener DIRECTEMENT aux Profondeurs (segment 2),
sans routage vers l'arene du mini-boss (vast_steppe_miniboss,
segment 1), que la session soit active (zone) ou fermee (master_zone),
et meme si SteppeMiniBossCleared est encore false (vieille sauvegarde).
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from simulate import build

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_rel(L, relpath, global_name=None):
    src = open(os.path.join(ROOT, 'Data/Script/halcyon', relpath), encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    mod = L.execute(src)
    if mod is not None and global_name:
        L.globals()[global_name] = mod


def show(eng):
    out = []
    for k, a in eng.log:
        if k.startswith('GAME.'):
            args = ', '.join(str(x) for x in a if not hasattr(x, 'keys'))
            out.append('%s(%s)' % (k, args[:70]))
    return out


ok = True
CASES = [
    # (label, zoneid a poser dans _ZONE, attendu segment 2)
    ('session active (zone)',   'vast_steppe', 'ContinueDungeon(vast_steppe, 2,'),
    ('session fermee (master)', None,          'EnterDungeon(vast_steppe, 2,'),
]
for label, zoneid, expect in CASES:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    g.SV.Chapter5.SteppeMiniBossCleared = False  # ne doit plus influencer le routage
    if zoneid:
        L.execute('_ZONE.CurrentZoneID = "%s"' % zoneid)
    load_rel(L, 'ground/vast_steppe_midpoint/init.lua', 'vast_steppe_midpoint')
    L.globals().vast_steppe_midpoint.North_Exit_Touch({}, {})

    acts = show(eng)
    joined = ' '.join(acts)
    to_seg2 = expect in joined
    to_miniboss = ('vast_steppe_miniboss' in joined) or ('EnterDungeon(vast_steppe, -1, 1,' in joined)
    hit = to_seg2 and not to_miniboss
    if not hit:
        ok = False
    print('%-26s -> seg2: %s | mini-boss: %s | %s' % (
        label, 'OUI' if to_seg2 else 'NON', 'OUI(!!)' if to_miniboss else 'non',
        'OK' if hit else 'ECHEC'))
    if not hit:
        print('   log: %s' % acts[-4:])

# Regression : seg0 cleared -> relais, seg2 cleared -> ground gardien
for seg, res, expect in [
    (0, 2, 'EnterGroundMap(vast_steppe_midpoint'),
    (2, 2, 'EnterGroundMap(vast_steppe_guardian'),
    (2, 0, 'EndDungeonRun'),  # 2e moitie perdue -> relais 63
]:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    g.ReplayEnding = {'FollowsRoute': lambda z, c: True}
    L.execute("""
GeneralFunctions = {
  DoAnimation = function() end,
  SetEmotion = function() end,
  RestoreIdleAnim = function() end,
  EndDungeonRun = function(...) PYREC('GeneralFunctions.EndDungeonRun', ...) end,
  DeathFadeOutDialogue = function(...) PYREC('GeneralFunctions.DeathFadeOutDialogue', ...) end,
}
""")
    load_rel(L, 'zone/vast_steppe/init.lua', 'vast_steppe')
    zone = L.eval('{ID="vast_steppe"}')
    L.globals().vast_steppe.ExitSegment(zone, res, False, seg, 0)
    joined = ' '.join(show(eng))
    hit = expect in joined
    if not hit:
        ok = False
    print('zone seg%d %s -> %s: %s' % (seg, {0: 'KO', 2: 'clear'}[res], expect, 'OK' if hit else 'ECHEC'))
    if not hit:
        print('   log: %s' % joined[:200])

print()
print('RESULTAT GLOBAL:', 'TOUS OK' if ok else 'AU MOINS UN ECHEC')
sys.exit(0 if ok else 1)
