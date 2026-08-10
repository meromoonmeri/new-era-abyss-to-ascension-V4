--[[ Station du Mont Cendré — midpoint de mt_blaze (route canonique PMD Red).
     Patron new_era_sky : clone exact de la station-relais (Terminal Kangourex
     + réserve, sortie Nord = suite, sortie Sud = retour Metano). ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.MidpointTemplate'

local mt_blaze_midpoint = {}

function mt_blaze_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

-- Reveil sobre apres un KO dans la 2e moitie (template point median).
local function WakeAfterKO()
  MidpointTemplate.QuickWake({
    skin = {
      status = 'falling_ash',
      wakeMusic = 'Mt. Horn.ogg',
      wake = {
        hero = {208, 176}, partner = {232, 176},
        camera = {228, 200},
      },
    },
    line = { spk='partner', emo='Worried',
             txt="Le relais...[pause=0] La chaleur nous a recraches ici.[pause=10] Reprenons notre souffle avant de remonter." },
  })
end

function mt_blaze_midpoint.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  if SV.MtBlaze ~= nil and SV.MtBlaze.DiedPastCheckpoint then
    SV.MtBlaze.DiedPastCheckpoint = false
    WakeAfterKO()
    return
  end
  GAME:FadeIn(20)
end

function mt_blaze_midpoint.Update(map) end

function mt_blaze_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function mt_blaze_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function mt_blaze_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("mt_blaze", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function mt_blaze_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Redescendre et rentrer ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
  end
end

-- Terminal de Sauvegarde (statue Kangourex) : sauvegarde + réserve natives.
function mt_blaze_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function mt_blaze_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return mt_blaze_midpoint
