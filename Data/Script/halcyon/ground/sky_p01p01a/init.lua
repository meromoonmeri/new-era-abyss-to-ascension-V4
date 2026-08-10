--[[
    init.lua — Plage / Falaise Sharpedo (Époque Explorateurs du Ciel)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
require 'halcyon.SkyCampaign'

local sky_p01p01a = {}

function sky_p01p01a.Init(map)
  PrintInfo("=>> Init_sky_p01p01a (Plage Sky)")
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
  SkyCampaign.EnsureSV()
end

function sky_p01p01a.Enter(map)
  DEBUG.EnableDbgCoro()
  local sv = SkyCampaign.EnsureSV()
  
  if sv.Chapter == 1 and not sv.BeachCaveDone then
    pcall(function()
      GAME:CutsceneMode(true)
      SOUND:PlayBGM("On the Beach at Dusk.ogg", true)
      GAME:FadeIn(30)
      UI:SetSpeaker(CH('Teammate1'))
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue("Les vagues de la plage...[pause=20] Nous avons atteint l'Époque des Explorateurs du Ciel !")
      UI:WaitShowDialogue("Deux forbans se sont enfuis vers la Grotte des Échoués avec le Fragment de Relique ![pause=20] Rattrapons-les !")
      GAME:WaitFrames(20)
      GAME:CutsceneMode(false)
    end)
  else
    GAME:FadeIn(20)
  end
end

function sky_p01p01a.Exit(map) end
function sky_p01p01a.Update(map, time) end
function sky_p01p01a.GameSave(map) end
function sky_p01p01a.GameLoad(map) GAME:FadeIn(20) end

-- PNJ
function sky_p01p01a.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

-- Sortie vers les donjons d'exploration
function sky_p01p01a.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local dungeons = {"beach_cave", "drenched_bluff", "mt_bristle", "waterfall_cave", "apple_woods", "craggy_coast", "foggy_forest", "steam_cave", "amp_plains", "northern_desert", "quicksand_cave", "crystal_cave", "chasm_cave", "dark_hill", "sealed_ruin", "dusk_forest", "treeshroud_forest", "brine_cave", "hidden_land", "temporal_tower"}
  
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
    
    UI:BeginMultiPageMenu(24, 24, 220, "Donjons d'Exploration", names, 6, 1, #names)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()
    if pick and pick <= #unlocked then
      GAME:FadeOut(false, 30)
      GAME:EnterDungeon(unlocked[pick], 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
  end
end

return sky_p01p01a
