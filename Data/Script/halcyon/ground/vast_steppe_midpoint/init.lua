--[[
    init.lua
    Vast Steppe Midpoint — checkpoint entre la première moitie et la seconde.
    Miroir de searing_tunnel_midpoint/init.lua.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.vast_steppe_midpoint.vast_steppe_midpoint_ch_5'

-- [NREPROBE] sonde locale (audit runtime).
local function nre_snap(tag)
  local ok, msg = pcall(function()
    local zone = tostring(_ZONE.CurrentZoneID)
    local seg = tostring(_ZONE.CurrentMapID.Segment)
    local save_n = _DATA.Save.ActiveTeam.Players.Count
    return string.format('[NREPROBE][%s] zone=%s seg=%s Save.Team=%d', tag, zone, seg, save_n)
  end)
  PrintInfo(ok and msg or ('[NREPROBE]['..tag..'] snapshot FAILED: '..tostring(msg)))
end

local vast_steppe_midpoint = {}

function vast_steppe_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_vast_steppe_midpoint <<= [build 2026-08-01-H]')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vast_steppe_midpoint.Enter(map)
  nre_snap('vast_steppe_midpoint.Enter')
	if SV.Chapter5.PlayedSteppeMidpointIntro == nil then SV.Chapter5.PlayedSteppeMidpointIntro = false end
  vast_steppe_midpoint.PlotScripting()
end

function vast_steppe_midpoint.Update(map)
end

function vast_steppe_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function vast_steppe_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  vast_steppe_midpoint.PlotScripting()
end

function vast_steppe_midpoint.PlotScripting()
  if SV.Chapter5.SteppeMidState == 'DeathArrival' then
    SV.Chapter5.SteppeMidState = nil
    vast_steppe_midpoint_ch_5.WipedCutscene()
    return
  end
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.PlayedSteppeMidpointIntro then
      vast_steppe_midpoint_ch_5.FirstArrival()
    else
      vast_steppe_midpoint_ch_5.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- North exit : mini-boss d'abord (s'il n'est pas battu), sinon segment 2.
-- Fix audit : l'arène du mini-boss était orpheline (le relais sautait
-- directement au segment 2) et sa cinématique supposait une session active.
function vast_steppe_midpoint.North_Exit_Touch(obj, activator)
  nre_snap('vast_steppe_midpoint.North_Exit_Touch')
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
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    if SV.ChapterProgression.Chapter == 5 and not SV.Chapter5.SteppeMiniBossCleared then
      -- CAUSE RACINE du crash IsGameOver (NRE) : la cinématique du mini-boss
      -- appelait ContinueDungeon SANS session d'aventure active quand on
      -- venait du relais master_zone (respawn après mort). BeginSegment charge
      -- alors la carte de combat sans y attacher l'équipe -> CurrentMap.
      -- ActiveTeam = null -> premier tick d'input -> IsGameOver() -> NRE.
      -- Fix : router selon l'état de session.
      if _ZONE.CurrentZoneID == 'vast_steppe' then
        -- Session ouverte (on vient du segment 0) : transition de ground interne.
        PrintInfo("[BossSeq][steppe] midpoint(zone) -> miniboss ground (session active)")
        GAME:EnterGroundMap("vast_steppe_miniboss", "Main_Entrance_Marker")
      else
        -- Copie master_zone (respawn/checkpoint) : session fermée -> on en
        -- OUVRE une neuve directement sur le ground de cinématique
        -- (structure -1 = grounds de la zone ; index 1 = vast_steppe_miniboss).
        PrintInfo("[BossSeq][steppe] midpoint(master) -> miniboss ground (nouvelle session)")
        GAME:EnterDungeon("vast_steppe", -1, 1, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
    else
      -- Mini-boss déjà vaincu : direction les Profondeurs (segment 2).
      -- Session active -> ContinueDungeon ; session fermée -> EnterDungeon.
      if _ZONE.CurrentZoneID == 'vast_steppe' then
        PrintInfo("[BossSeq][steppe] midpoint(zone) -> seg2 (ContinueDungeon)")
        GAME:ContinueDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      else
        PrintInfo("[BossSeq][steppe] midpoint(master) -> seg2 (EnterDungeon)")
        GAME:EnterDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
    end
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- South exit : return to Vast Steppe entrance
function vast_steppe_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("vast_steppe")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage
function vast_steppe_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function vast_steppe_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    vast_steppe_midpoint_ch_5.Partner_Action(chara, activator)
  else
    PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
  end
end

function vast_steppe_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    vast_steppe_midpoint_ch_5.Hyko_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

function vast_steppe_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    vast_steppe_midpoint_ch_5.Almotz_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

return vast_steppe_midpoint
