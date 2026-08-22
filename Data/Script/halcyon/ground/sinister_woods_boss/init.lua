-- Fixed canonical 13F boss staging Ground.
require 'origin.common'
require 'halcyon.PartnerEssentials'

local sinister_woods_boss = {}

function sinister_woods_boss.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sinister_woods_boss.Enter(map)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  UI:ResetSpeaker(false)
  if SV.CanonicalDungeons.SinisterWoodsBossFailed then
    UI:WaitShowDialogue('La Team Meanies garde toujours la clairière. Cette fois, nous pouvons les vaincre.')
  else
    UI:WaitShowDialogue('Au cœur de la Forêt Sinistre, la Team Meanies nous attend.')
  end
  SV.CanonicalDungeons.SinisterWoodsBossStarted = true
  SOUND:FadeOutBGM(30)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('gloomy_forest', 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return sinister_woods_boss
