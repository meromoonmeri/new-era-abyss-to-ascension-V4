--[[
    init.lua
    Mount Windswept Midpoint — checkpoint entre la première moitie et la seconde.
    Miroir de searing_tunnel_midpoint/init.lua.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.mount_windswept_midpoint.mount_windswept_midpoint_ch_5'

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

local mount_windswept_midpoint = {}

function mount_windswept_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_mount_windswept_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mount_windswept_midpoint.Enter(map)
  nre_snap('mount_windswept_midpoint.Enter')
	if SV.Chapter5.PlayedMountMidpointIntro == nil then SV.Chapter5.PlayedMountMidpointIntro = false end
  mount_windswept_midpoint.PlotScripting()
end

function mount_windswept_midpoint.Update(map)
end

function mount_windswept_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function mount_windswept_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  mount_windswept_midpoint.PlotScripting()
end

function mount_windswept_midpoint.PlotScripting()
  if SV.Chapter5.WindsweptMidState == 'DeathArrival' then
    SV.Chapter5.WindsweptMidState = nil
    mount_windswept_midpoint_ch_5.WipedCutscene()
    return
  end
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.PlayedMountMidpointIntro then
      mount_windswept_midpoint_ch_5.FirstArrival()
    else
      mount_windswept_midpoint_ch_5.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- North exit : mini-boss d'abord (s'il n'est pas battu), sinon segment 2.
-- Fix audit : même correction que la Grande Steppe — l'arène du mini-boss
-- était orpheline, le relais sautait directement au segment 2.
function mount_windswept_midpoint.North_Exit_Touch(obj, activator)
  nre_snap('mount_windswept_midpoint.North_Exit_Touch')
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    if SV.ChapterProgression.Chapter == 5 and not SV.Chapter5.MountMiniBossCleared then
      -- Même fix que la Grande Steppe (cause racine IsGameOver NRE) :
      -- routage selon l'état de session. Index 1 = mount_windswept_miniboss.
      if _ZONE.CurrentZoneID == 'mount_windswept' then
        PrintInfo("[BossSeq][windswept] midpoint(zone) -> miniboss ground (session active)")
        GAME:EnterGroundMap("mount_windswept_miniboss", "Main_Entrance_Marker")
      else
        PrintInfo("[BossSeq][windswept] midpoint(master) -> miniboss ground (nouvelle session)")
        GAME:EnterDungeon("mount_windswept", -1, 1, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
    else
      -- Mini-boss déjà vaincu : direction les Crêtes (segment 2).
      if _ZONE.CurrentZoneID == 'mount_windswept' then
        PrintInfo("[BossSeq][windswept] midpoint(zone) -> seg2 (ContinueDungeon)")
        GAME:ContinueDungeon("mount_windswept", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      else
        PrintInfo("[BossSeq][windswept] midpoint(master) -> seg2 (EnterDungeon)")
        GAME:EnterDungeon("mount_windswept", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
    end
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- South exit : return to Mount Windswept entrance
function mount_windswept_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mount_windswept")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous redescendre\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage
function mount_windswept_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function mount_windswept_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Partner_Action(chara, activator)
  else
    PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
  end
end

function mount_windswept_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Hyko_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

function mount_windswept_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_midpoint_ch_5.Almotz_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end

return mount_windswept_midpoint
