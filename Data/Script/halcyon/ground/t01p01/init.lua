--[[
    init.lua — Place Pokémon (Époque Rescue Team)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.RescueTeamCampaign'

local t01p01 = {}

function t01p01.Init(map)
  PrintInfo("=>> Init_t01p01 (Place Pokémon)")
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
  RescueTeamCampaign.EnsureSV()
end

function t01p01.Enter(map)
  DEBUG.EnableDbgCoro()
  local sv = RescueTeamCampaign.EnsureSV()
  
  if sv.Chapter == 1 and not sv.TinyWoodsDone then
    pcall(function()
      GAME:CutsceneMode(true)
      SOUND:PlayBGM("Friend Area Forest.ogg", true)
      GAME:FadeIn(30)
      UI:SetSpeaker(CH('Teammate1'))
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue("Nous voici arrivés sur la Place Pokémon de cette époque ![pause=20] C'est exactement comme dans les légendes !")
      UI:WaitShowDialogue("Un Chenipan a besoin d'aide au Petit Bois.[pause=20] Allons accomplir notre première mission de secours !")
      GAME:WaitFrames(20)
      GAME:CutsceneMode(false)
    end)
  else
    GAME:FadeIn(20)
  end
end

function t01p01.Exit(map) end
function t01p01.Update(map, time) end
function t01p01.GameSave(map) end
function t01p01.GameLoad(map) GAME:FadeIn(20) end

-- PNJ Place Pokémon
function t01p01.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

-- Sortie vers les donjons de secours
function t01p01.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local sv = RescueTeamCampaign.EnsureSV()
  local dungeons = {"tiny_woods", "thunderwave_cave", "mt_steel", "sinister_woods", "silent_chasm", "mt_thunder", "great_canyon", "lapis_cave", "mt_blaze", "frosty_forest", "mt_freeze", "magma_cavern", "sky_tower"}
  
  local unlocked = {}
  for _, d in ipairs(dungeons) do
    if GAME:DungeonUnlocked(d) then
      unlocked[#unlocked + 1] = d
    end
  end
  
  if #unlocked > 0 then
    local names = {}
    for _, d in ipairs(unlocked) do
      local z = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(d)
      names[#names + 1] = z and z.Name:ToLocal() or d
    end
    names[#names + 1] = "(Annuler)"
    
    UI:BeginMultiPageMenu(24, 24, 220, "Destination de Secours", names, 6, 1, #names)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()
    if pick and pick <= #unlocked then
      GAME:FadeOut(false, 30)
      GAME:EnterDungeon(unlocked[pick], 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
  end
end

return t01p01
