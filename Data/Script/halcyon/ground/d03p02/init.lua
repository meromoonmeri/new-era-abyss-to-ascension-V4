-- d03p02 — sortie authentifiée du Mt Acier (D03).
require 'origin.common'
local Animation = require 'halcyon.ground.d03p02.animation_callbacks'

local d03p02 = {}

function d03p02.Init(map)
  DEBUG.EnableDbgCoro()
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending == 'mt_steel_exit' then
    local hero = CH('PLAYER')
    if hero ~= nil then GROUND:TeleportTo(hero, 216, 256, Direction.Up) end
  end
  Animation.Init(map)
end

function d03p02.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then
    GAME:CutsceneMode(false)
    GAME:FadeIn(1)
    return
  end
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if SV.CanonicalDungeons.Pending == 'mt_steel_exit' then
    GAME:CutsceneMode(true)
    GAME:FadeIn(30)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D03_CLEAR_001']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D03_CLEAR_002']))
    SV.CanonicalDungeons.Pending = nil
    SV.CanonicalDungeons.D03Cleared = true
    GAME:FadeOut(false, 30)
    GAME:CutsceneMode(false)
    GAME:EnterZone('master_zone', -1, 1, 0)
  else
    GAME:FadeIn(20)
  end
end

function d03p02.Update(map) Animation.Update(map) end
function d03p02.Exit(map) Animation.Exit(map) end
function d03p02.GameSave(map) end
function d03p02.GameLoad(map) GAME:FadeIn(20) end

return d03p02
