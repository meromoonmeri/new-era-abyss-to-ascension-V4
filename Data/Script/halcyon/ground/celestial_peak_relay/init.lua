--[[
    init.lua — celestial_peak_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local celestial_peak_relay = {}

function celestial_peak_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_celestial_peak_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function celestial_peak_relay.Enter(map)
  if SV.Chapter10.PeakMidState == 'DeathArrival' then
    SV.Chapter10.PeakMidState = nil
    celestial_peak_relay.WipedCutscene()
    return
  end
  GAME:FadeIn(40)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_001']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPR_002']))
  UI:SetCenter(false)
end

function celestial_peak_relay.Update(map, time) end

function celestial_peak_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function celestial_peak_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function celestial_peak_relay.North_Exit_Touch(obj, activator)
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
    -- Le relais sert deux fois : avant la Mer de Nuages (segment 2),
    -- puis après la course contre l'Escouade Fulgur (segment 4, Sommet Sacré).
    local nextSegment = 2
    if SV.Chapter10.OutranEscouadeFulgur then nextSegment = 4 end
    GAME:EnterDungeon("celestial_peak", nextSegment, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function celestial_peak_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("celestial_peak")
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
    GAME:EnterGroundMap("celestial_peak_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function celestial_peak_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function celestial_peak_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function celestial_peak_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function celestial_peak_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function celestial_peak_relay.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 88, 248, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 116, 256, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(100, 240, 1, false)

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
  UI:WaitShowDialogue("L'air...[pause=10] il n'y a presque plus d'air, là-haut...")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("On est retombés jusqu'à la corniche.[pause=20] Le Pic nous a repoussés — pas par méchanceté...[pause=10] on n'était juste pas prêts.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Alors on se prépare.[pause=20] Respire, {0}.[pause=10] Le ciel, lui, ne bouge pas.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then AI:EnableCharacterAI(partner) end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return celestial_peak_relay
