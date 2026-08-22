-- Searing Tunnel checkpoint mechanics, retextured for Sinister Woods.
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'

local sinister_woods_mid = {}

function sinister_woods_mid.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sinister_woods_mid.Enter(map)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons.SinisterWoodsCheckpoint = true
  GAME:FadeIn(20)
end

function sinister_woods_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer vers les profondeurs de la Forêt Sinistre ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(30)
    GAME:FadeOut(false, 30)
    GAME:EnterDungeon('gloomy_forest', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

function sinister_woods_mid.South_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Revenir à l’entrée de la Forêt Sinistre ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(30)
    GAME:FadeOut(false, 30)
    GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')
  end
end

function sinister_woods_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function sinister_woods_mid.Teammate1_Action(chara, activator)
  UI:SetSpeaker(chara)
  UI:WaitShowDialogue('Le rocher de Kangourex peut nous soigner et sauvegarder. Préparons-nous avant de continuer.')
  UI:ResetSpeaker()
end

return sinister_woods_mid
