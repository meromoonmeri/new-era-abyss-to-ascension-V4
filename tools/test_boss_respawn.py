#!/usr/bin/env python3
"""Simule les defaites contre les boss / mini-boss du chapitre 5.

Regle (demande utilisateur) : mourir contre un boss/mini-boss au ch5 ramene
au POINT MEDIAN du donjon (et non a l'entree), et la JOURNEE CONTINUE
(pas de Dinnertime/Bedtime/MorningWakeup/MorningAddress poses) — meme
patron que la defaite contre le boss du Tunnel (Creuset Ardent, carte 48).
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from simulate import build, S

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_rel(L, relpath):
    src = open(os.path.join(ROOT, 'Data/Script/halcyon', relpath), encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    L.execute(src)


def show(eng, keep=('GAME.', 'GeneralFunctions.')):
    out = []
    for k, a in eng.log:
        if any(k.startswith(p) for p in keep):
            args = ', '.join(str(x) for x in a if not hasattr(x, 'keys'))
            out.append('%s(%s)' % (k, args[:60]))
    return out


CASES = [
    ('mount_windswept_guardian', 'mount_windswept_guardian_ch_5', 'mount_windswept_midpoint'),
    ('vast_steppe_guardian',     'vast_steppe_guardian_ch_5',     'vast_steppe_midpoint'),
    ('vast_steppe_miniboss',     'vast_steppe_miniboss_ch_5',     'vast_steppe_midpoint'),
    ('searing_tunnel_miniboss',  'searing_tunnel_miniboss_ch_5',  'searing_tunnel_midpoint'),
]

ok = True
for gname, modname, expect_mid in CASES:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    # GeneralFunctions n'est pas charge par build() (echec avale) : stub
    # minimal journalise, suffisant pour le corps des cinematiques.
    L.execute("""
GeneralFunctions = {
  DoAnimation = function() end,
  SetEmotion = function() end,
  Hop = function() end,
  RestoreIdleAnim = function() end,
  CheckAllowSetRescue = function() end,
  EndDungeonRun = function(...) PYREC('GeneralFunctions.EndDungeonRun', ...) end,
  DeathFadeOutDialogue = function(...) PYREC('GeneralFunctions.DeathFadeOutDialogue', ...) end,
}
-- MakeCharactersFromList (CharacterEssentials) construit de vrais chars :
-- GroundChar doit renvoyer un objet complet (ReloadEvents, OnMapInit,
-- RunEvent) et la ground courante accepter AddTempChar.
RogueEssence.Ground.GroundChar = function(...)
  return {
    EntName = 'tmp',
    Position = {X = 0, Y = 0},
    ReloadEvents = function(self) end,
    OnMapInit = function(self) end,
    RunEvent = function(self, ...) return {} end,
  }
end
GAME.GetCurrentGround = function()
  return { AddTempChar = function() end, Name = { ToLocal = function() return 'map' end } }
end
""")
    load_rel(L, 'CharacterEssentials.lua')
    load_rel(L, os.path.join('ground', gname, modname + '.lua'))
    L.globals()[modname].DiedToBoss()

    acts = show(eng)
    joined = ' '.join(acts)
    m = re.findall(r'EnterGroundMap\(([^,)]+)', joined)
    last_dest = m[-1] if m else None
    dest_ok = (last_dest == expect_mid)

    tf = g.SV.TemporaryFlags
    dayflags = {k: tf[k] for k in ('Dinnertime', 'Bedtime', 'MorningWakeup', 'MorningAddress')}
    flags_ok = all(v == False for v in dayflags.values())

    status = 'OK' if (dest_ok and flags_ok) else 'ECHEC'
    if not (dest_ok and flags_ok):
        ok = False
    print('%-26s -> destination: %s (attendu %s) %s | flags jour: %s %s'
          % (gname, last_dest, expect_mid, 'OK' if dest_ok else 'ECHEC',
             dayflags, 'OK' if flags_ok else 'ECHEC'))
    if not (dest_ok and flags_ok):
        print('   log: %s' % acts[-3:])

print()
print('RESULTAT GLOBAL:', 'TOUS OK' if ok else 'AU MOINS UN ECHEC')
sys.exit(0 if ok else 1)
