--[[ 
     Bourg du Comptoir — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE de Treasure Town (expansion ch11+)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.bourg_comptoir.bourg_comptoir_ch_11'

local bourg_comptoir = {}

function bourg_comptoir.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  
  -- Si aucune cinematique n'est a venir, on libere la main des maintenant
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 11 then
      sceneAVenir = not SV.Chapter11.FinishedTreasureTownIntro
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function bourg_comptoir.Enter(map)
  bourg_comptoir.PlotScripting()
end

function bourg_comptoir.Update(map, time)
end

function bourg_comptoir.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function bourg_comptoir.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  bourg_comptoir.PlotScripting()
end

function bourg_comptoir.PlotScripting()
  if SV.ChapterProgression.Chapter == 11 then
    if not SV.Chapter11.FinishedTreasureTownIntro then
      bourg_comptoir_ch_11.ArrivalCutscene()
    else
      bourg_comptoir_ch_11.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- Callback d'interaction avec Loaklass pour rentrer à Metano Town
function bourg_comptoir.Lapras_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)

  UI:SetSpeaker(chara)
  UI:ChoiceMenuYesNo("Voulez-vous retourner à l'Autel Céleste de Metano ?", true)
  UI:WaitForChoice()

  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    
    -- Courte transition de voyage
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Loaklass fend à nouveau les nuages à contre-courant, nous ramenant en sécurité vers le continent de Metano...")
    UI:SetCenter(false)
    GAME:WaitFrames(40)
    
    -- Retour à Metano Town (Mare Altérée)
    GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")
  else
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("Prenez votre temps. La mer de nuages ne bougera pas d'ici.")
  end

  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

return bourg_comptoir
