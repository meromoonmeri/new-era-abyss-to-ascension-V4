-- Canonical Sinister Woods entrance.
require 'origin.common'
require 'halcyon.PartnerEssentials'

local sinister_woods_entrance = {}

function sinister_woods_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sinister_woods_entrance.Enter(map)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if not SV.CanonicalDungeons.SinisterWoodsApproachSeen then
    SV.CanonicalDungeons.SinisterWoodsApproachSeen = true
    UI:ResetSpeaker(false)
    UI:WaitShowDialogue('La Forêt Sinistre est silencieuse… Restons groupés.')
  end
  GAME:FadeIn(20)
end

function sinister_woods_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Entrer dans la Forêt Sinistre ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(30)
    GAME:FadeOut(false, 30)
    GAME:EnterDungeon('gloomy_forest', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end

function sinister_woods_entrance.South_Exit_Touch(obj, activator)
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end

function sinister_woods_entrance.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return sinister_woods_entrance
