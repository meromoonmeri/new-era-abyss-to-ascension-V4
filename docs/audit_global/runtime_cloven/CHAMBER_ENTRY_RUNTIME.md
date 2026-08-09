# Cloven Ruin chamber-entry runtime — PMDO 0.8.12 / X11

Executed in real PMDO under an active Xvfb display with keyboard events.

| Ground | NDS scene | Fixed segment/map | Result |
|---|---|---|---|
| 144 Regice Chamber | s04p0501 | segment 1 / cloven_ruins_regice | DungeonFloorEnter PASS, team attached 4, foes 1, 0 Lua error after dialogue fix |
| 145 Regirock Chamber | s04p1001 | segment 3 / cloven_ruins_regirock | DungeonFloorEnter PASS, team attached 4, foes 1 |
| 146 Registeel Chamber | s04p1301 | segment 5 / cloven_ruins_registeel | DungeonFloorEnter PASS, team attached 4, foes 1 |
| 147 Regigigas Chamber | s04p1601 | segment 7 / sanctuaire_titans | DungeonFloorEnter PASS, team attached 4, foes 1, reinforcement dialogue keys fixed |

This validates chamber Ground → fixed-floor entry and pre-battle scene execution.
It does not validate victory, post-combat return, save/reload, or s04p1901→1902.
