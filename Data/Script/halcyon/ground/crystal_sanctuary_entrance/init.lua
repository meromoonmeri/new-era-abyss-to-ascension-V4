--[[
    init.lua — crystal_sanctuary_entrance
    Entrée Sanctuaire de Cristal — Chapitre 8
    VERSION UNIQUE BIOME 2026-07-30 — Avenue en segments camp unique

    IDENTITÉ UNIQUE — L'Avenue de la Cascade sans Bruit :
    - Combinaison biomes : cascade silencieuse (Crystal Crossing) → galeries chantantes petites cristaux → chambre préparatoire silence respectueux
    - Seg1 sud : cascade tombe sans bruit, première chose qui cloche, halo bleu pâle traverse. Son manquant. Tiles cascade + Genesis_Cores BG
    - Seg2 centre : cristaux petits chantants Core_Activation faible, reflets bleus au sol, sol qui résonne léger écho
    - Seg3 nord : chambre préparatoire où silence commence, Cristaux muets en préparation, Dungeon_Entrance derrière rideau eau
    - Disposition : 3 segments sud→nord, Kangaskhan seg1 clairière cascade (accessible, pas dans eau), feu seg2 entre cristaux chantants, teammates un par segment
    - Faune : Carbink petits qui chantent seg2 inoffensifs, Snom
    - Trace : vieux Relicanth Trois Lacs, Phileas Fourneau Cœurs, Diancie gardienne
    - Cinématique ChapterScenes.CrystalArrival correspond exactement : cascade sans bruit, halo, silence couvercle
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterScenes'
require 'halcyon.BossFX'

local crystal_sanctuary_entrance = {}

function crystal_sanctuary_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crystal_sanctuary_entrance UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Anima_Core', 3)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(160, 140)))
  end)
end

function crystal_sanctuary_entrance.Enter(map)
  if not ChapterScenes.CrystalArrival() then
    GAME:FadeIn(20)
  end
end

function crystal_sanctuary_entrance.Update(map) end

function crystal_sanctuary_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function crystal_sanctuary_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function crystal_sanctuary_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Passer sous le rideau d'eau de la cascade sans bruit,\nvers les galeries où les cristaux chantent ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("crystal_sanctuary", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function crystal_sanctuary_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function crystal_sanctuary_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "La cascade silencieuse...[pause=10] Elle tombe sans bruit, c'est la première chose qui cloche. Le halo bleu qui traverse...[pause=10] Il bat comme un souffle.", "Worried")
  UI:WaitShowDialogue("Seg2, les petits cristaux chantants... écoute, ils chantent déjà. Et seg3, la chambre où ils se tairont. L'avenue elle-même raconte le donjon. Et le Kangourex seg1 près de la cascade est prêt — PP, ventre.")
  GeneralFunctions.EndConversation(chara)
end

function crystal_sanctuary_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Ces petits Carbink chantants,[pause=10] inoffensifs,[pause=10] ils préparent le silence de la chambre muette au nord.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function crystal_sanctuary_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Le sol résonne sous nos pas ici,[pause=10] léger écho. Comme si le sanctuaire nous écoutait avant Diancie.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

return crystal_sanctuary_entrance
