--[[ d09p03 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d09p03 = {}

function d09p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d09p03.Enter(map)
  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending == 'mt_blaze_summit' then
    local ok, scene = pcall(require, 'halcyon.arc_fugitif.scene.d09p03')
    if ok and scene and scene.Cutscene then pcall(scene.Cutscene) end
    SV.CanonicalDungeons.Pending = nil
    GAME:FadeOut(false, 30)
    GAME:EnterDungeon('mt_blaze', 2, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    FugitiveArc.Play('d09p03')
  end
end

function d09p03.Update(map) end
function d09p03.GameSave(map) end
function d09p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d09p03
