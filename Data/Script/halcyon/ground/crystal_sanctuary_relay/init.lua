--[[
    init.lua — crystal_sanctuary_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local crystal_sanctuary_relay = {}

function crystal_sanctuary_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crystal_sanctuary_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function crystal_sanctuary_relay.Enter(map)
  if SV.Chapter8.SanctuaryMidState == 'DeathArrival' then
    SV.Chapter8.SanctuaryMidState = nil
    crystal_sanctuary_relay.WipedCutscene()
    return
  end
  GAME:FadeIn(40)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSR_002']))
  UI:SetCenter(false)
end

function crystal_sanctuary_relay.Update(map, time) end

function crystal_sanctuary_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function crystal_sanctuary_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function crystal_sanctuary_relay.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("crystal_sanctuary", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crystal_sanctuary_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crystal_sanctuary")
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
    GAME:EnterGroundMap("crystal_sanctuary_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crystal_sanctuary_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function crystal_sanctuary_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function crystal_sanctuary_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function crystal_sanctuary_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function crystal_sanctuary_relay.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 400, 128, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 432, 136, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(416, 120, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Les cristaux...[pause=20] ils chantaient encore quand tout est devenu noir.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("C'est la gardienne qui a ramené la lumière autour de nous.[pause=10] Je crois...[pause=20] je crois qu'elle nous OBSERVE, {0}.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Alors on va lui montrer qui nous sommes.[pause=20] Debout.[pause=10] Le Sanctuaire attend.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then AI:EnableCharacterAI(partner) end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return crystal_sanctuary_relay
