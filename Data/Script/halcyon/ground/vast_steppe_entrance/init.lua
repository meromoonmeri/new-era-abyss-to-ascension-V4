--[[
    init.lua — Vast Steppe Entrance — Chapitre 5
    VERSION UNIQUE BIOME 2026-07-30 — Avenue en segments camp unique

    IDENTITÉ UNIQUE — L'Avenue des Herbes Hautes Taillées et de la Mère-Roche visible :
    - Combinaison : plaine bourg herbe rase champs Zigzaton → prairie basse verdoyante troupeaux → lisière herbes hautes taillées + Mère-Roche visible loin
    - Seg1 sud : plaine bourg, champs, terre rase, Kangaskhan sur terre ferme accessible, pas sur falaise, sentier battu
    - Seg2 centre : prairie basse verdoyante, souches taillées cercle 8 (comme relais), troupeaux Écrémeuh/Ponyta lointains inoffensifs, feu entre souches
    - Seg3 nord : lisière herbes hautes taillées à la machette chemin 2m large vers nord, point d'eau asséché fissures River_Stone_Round sec au fond, Mère-Roche visible au loin, Dungeon_Entrance
    - Disposition : avenue 3 segments sud→nord pente douce, pas lacet comme Mont, pas pierres chaudes comme Tunnel. Kangaskhan seg1, feu seg2 souches, teammates un par segment
    - Faune : Taillow rasent seg3 herbes hautes, Shinx joue point d'eau sec, Tropius mange seg2 — tous inoffensifs
    - Trace : famille Zigzaton Almotz 8 à table, gratin Baies Oran, cailloux souvenirs, premiers rapports expéditions qui ont tracé chemin
    - Cinématique SkyTremor : premier pulse phénomène sommet visible depuis camp nuit après mini-boss, lueur a peur
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.vast_steppe_entrance.vast_steppe_entrance_ch_5'
require 'halcyon.BossFX'

local vast_steppe_entrance = {}

function vast_steppe_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_vast_steppe_entrance UNIQ 2026-07-30 HERBES TAILLEES <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Grassy_Bag', 1)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(196, 224)))
  end)
end

function vast_steppe_entrance.Enter(map)
  vast_steppe_entrance.PlotScripting()
end

function vast_steppe_entrance.Exit(map) end
function vast_steppe_entrance.Update(map) end

function vast_steppe_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function vast_steppe_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  vast_steppe_entrance.PlotScripting()
end

function vast_steppe_entrance.PlotScripting()
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.FinishedSteppeIntro then
      vast_steppe_entrance_ch_5.ArrivalCutscene()
    elseif SV.Chapter5.EscapedSteppe or SV.Chapter5.DiedSteppe then
      vast_steppe_entrance_ch_5.SetupGround()
      vast_steppe_entrance_ch_5.FailedCutscene()
    elseif SV.Chapter5.SteppeMiniBossDefeated and not SV.Chapter5.SkyTremorSceneSeen then
      -- Cinématique majeure : premier pulse phénomène sommet visible depuis camp, voile
      vast_steppe_entrance_ch_5.SetupGround()
      vast_steppe_entrance_ch_5.SkyTremorScene()
    else
      vast_steppe_entrance_ch_5.SetupGround()
      GAME:FadeIn(20)
    end
  else
    GAME:FadeIn(20)
  end
end

function vast_steppe_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function vast_steppe_entrance.Teammate2_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Snubbull_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Teammate3_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Audino_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Kangaskhan_Rock_Action(obj, activator)
  -- Kangaskhan seg1 champs terre ferme accessible, pas sur falaise, PP/ventre
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function vast_steppe_entrance.Dungeon_Entrance_Touch(obj, activator)
  -- Avenue herbes hautes taillées → point d'eau asséché → Mère-Roche visible
  vast_steppe_entrance_ch_5.Dungeon_Entrance_Touch(obj, activator)
end

function vast_steppe_entrance.Tropius_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Tropius_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Noctowl_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Noctowl_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Breloom_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Breloom_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Girafarig_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Girafarig_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Growlithe_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Growlithe_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Zigzagoon_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Zigzagoon_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Snubbull_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Snubbull_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Audino_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Audino_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Cranidos_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Mareep_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), obj, activator))
end

return vast_steppe_entrance
