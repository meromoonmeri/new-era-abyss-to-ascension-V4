#!/usr/bin/env python3
"""Simule les respawns des Ruines Tordues (zone/cloven_ruins) avec le vrai Lua.

Règle expédition (patron mount_windswept) :
  - mort/fuite AVANT le relais (segment 0) -> entree des Ruines (master_zone 65)
  - mort/fuite APRES le relais (segments 2 et 4) -> relais (master_zone 67)
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from simulate import build, S

RES = {'Downed': 0, 'Failed': 1, 'Cleared': 2, 'Escaped': 3, 'TimedOut': 4, 'GaveUp': 5}


def load_zone(L, zone):
    p = os.path.join(S, 'zone', zone, 'init.lua')
    src = open(p, encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    mod = L.execute(src)
    if mod is not None:
        L.globals()[zone] = mod
    return mod


def show(eng, keep=('GAME.', 'COMMON.')):
    out = []
    for k, a in eng.log:
        if any(k.startswith(p) for p in keep):
            args = ', '.join(str(x) for x in a if not hasattr(x, 'keys'))
            out.append('%s(%s)' % (k, args[:80]))
    return out


ok = True
CASES = [
    # (segment, resultat, attente_indice, flag, valeur, label)
    (0, 'Downed',  65, 'LostRuins',    True,            'seg0 KO    -> entree 65'),
    (0, 'Escaped', 65, 'LostRuins',    True,            'seg0 fuite -> entree 65'),
    (0, 'Cleared', None, None,         None,            'seg0 clear -> relais (ground)'),
    (2, 'Downed',  67, 'RuinsMidState', 'DeathArrival', 'seg2 KO    -> relais 67'),
    (2, 'Escaped', 67, 'RuinsMidState', None,           'seg2 fuite -> relais 67'),
    (4, 'Downed',  67, 'RuinsMidState', 'DeathArrival', 'seg4 KO    -> relais 67'),
]
for seg, res, want_idx, fkey, fval, label in CASES:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 7
    g.ReplayEnding = {'FollowsRoute': lambda z, c: True}
    # GeneralFunctions n'est pas charge par build() (echec avale) : stub
    # minimal journalise, identique au comportement des vrais appels.
    L.execute("""
GeneralFunctions = {
  RestoreIdleAnim = function() end,
  CheckAllowSetRescue = function(z) end,
  EndDungeonRun = function(result, zone, a, b, c, d, e)
    PYREC('GeneralFunctions.EndDungeonRun', result, zone, a, b, c, d, e)
  end,
  DeathFadeOutDialogue = function(ch, text, emote)
    PYREC('GeneralFunctions.DeathFadeOutDialogue', text)
  end,
}
""")
    load_zone(L, 'cloven_ruins')
    zone = L.eval('{ID="cloven_ruins"}')
    L.globals().cloven_ruins.ExitSegment(zone, RES[res], False, seg, 0)
    acts = show(eng, keep=('GAME.', 'COMMON.', 'GeneralFunctions.'))
    joined = ' '.join(acts)

    hit = True
    detail = ''
    if want_idx is not None:
        m = re.search(r'EndDungeonRun\([^)]*?, (\d+), 0,', joined)
        got = int(m.group(1)) if m else None
        hit = hit and got == want_idx
        detail = 'EndDungeonRun->%s' % got
        ev = re.search(r'EnterZone\([^)]*?, (\d+), 0,', joined)
        if ev:
            detail += ' EnterZone->%s' % ev.group(1)
    else:
        detail = ('EnterGroundMap->%s' % m.group(1)) if (
            m := re.search(r"EnterGroundMap\(([^,]+)", joined)) else 'AUCUN'

    fmsg = ''
    if fkey is not None:
        cur = getattr(g.SV.Chapter7, fkey, '<absent>')
        fok = (cur == fval)
        hit = hit and fok
        fmsg = ' %s=%s%s' % (fkey, cur, ' OK' if fok else ' != attendu %s' % fval)
    print('%-22s | %s | flags:%s' % (label, detail, fmsg or ' (aucun)'))
    print('   ---> %s' % ('OK' if hit else 'ECHEC'))
    if not hit:
        ok = False
        print('   log: %s' % acts[:6])

print()
print('RESULTAT GLOBAL:', 'TOUS OK' if ok else 'AU MOINS UN ECHEC')
sys.exit(0 if ok else 1)
