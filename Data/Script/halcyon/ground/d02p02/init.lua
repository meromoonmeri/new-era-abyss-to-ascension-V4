-- d02p02 — fin authentifiée de la Grotte Éclair (D02).
-- Le Ground et son animation de palette viennent du port direct PMD Red EU.
require 'origin.common'
local Animation = require 'halcyon.ground.d02p02.animation_callbacks'

local d02p02 = {}

local function play_completion_scene()
  local ok, scene = pcall(require, 'halcyon.arc_fugitif.scene.d02p02')
  if ok and scene and scene.Cutscene then
    pcall(scene.Cutscene)
  end
end

function d02p02.Init(map)
  DEBUG.EnableDbgCoro()
  -- The authenticated direct-ROM Ground deliberately has no invented marker
  -- or teammate spawner.  Entry 0 therefore starts at the engine fallback and
  -- is immediately relocated onto the measured 8 px collision corridor.
  if SV.CanonicalDungeons and
      SV.CanonicalDungeons.Pending == 'thunderwave_cave_exit' then
    local hero = CH('PLAYER')
    if hero ~= nil then GROUND:TeleportTo(hero, 176, 240, Direction.Up) end
  end
  Animation.Init(map)
end

function d02p02.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if SV.CanonicalDungeons.Pending == 'thunderwave_cave_exit' then
    play_completion_scene()
    GAME:CutsceneMode(true)
    GAME:FadeIn(30)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D02_CLEAR_001']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D02_CLEAR_002']))
    SV.CanonicalDungeons.Pending = nil
    SV.CanonicalDungeons.D02Cleared = true
    GAME:FadeOut(false, 30)
    GAME:CutsceneMode(false)
    GAME:EnterZone('master_zone', -1, 1, 0)
  else
    GAME:FadeIn(20)
  end
end

function d02p02.Update(map)
  Animation.Update(map)
end

function d02p02.Exit(map)
  Animation.Exit(map)
end

function d02p02.GameSave(map) end
function d02p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d02p02
