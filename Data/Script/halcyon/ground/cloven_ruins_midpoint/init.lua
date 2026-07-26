--[[
    init.lua — Cloven Ruins Midpoint (Relais des Ruines Tordues)
    Chapitre 7 — relais mi-donjon type Statue Kangourex.
    Modèle : searing_tunnel_midpoint / vast_steppe_midpoint (patron validé).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local cloven_ruins_midpoint = {}

function cloven_ruins_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_midpoint.Enter(map)
  if SV.Chapter7.RuinsMidpointState == nil then SV.Chapter7.RuinsMidpointState = 'FirstArrival' end
  if SV.ChapterProgression.Chapter == 7 and SV.Chapter7.RuinsMidpointState == 'FirstArrival' then
    SV.Chapter7.RuinsMidpointState = 'RepeatArrival'
    GAME:FadeIn(40)
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Une esplanade calme s'ouvre au cœur des ruines.[pause=0] Un rocher de Kangourex se dresse là, intact.")
    UI:WaitShowDialogue("C'est le moment de préparer la descente vers les profondeurs.")
    UI:SetCenter(false)
  else
    GAME:FadeIn(20)
  end
end

function cloven_ruins_midpoint.Update(map)
end

function cloven_ruins_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie nord : continuer vers les profondeurs (segment 2)
function cloven_ruins_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Descendre dans les profondeurs des ruines ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("cloven_ruins", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Sortie sud : retour à l'entrée des ruines
function cloven_ruins_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("cloven_ruins")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Rocher Kangourex : sauvegarde + stockage
function cloven_ruins_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function cloven_ruins_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

return cloven_ruins_midpoint
