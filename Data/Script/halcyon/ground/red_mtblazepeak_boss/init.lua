require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local red_mtblazepeak_boss = {}
function red_mtblazepeak_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function red_mtblazepeak_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('red_mtblazepeak', 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return red_mtblazepeak_boss
