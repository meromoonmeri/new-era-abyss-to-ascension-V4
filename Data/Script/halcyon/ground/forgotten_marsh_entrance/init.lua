--[[
    init.lua — forgotten_marsh_entrance
    Entrée Marais de l'Oubli — Chapitre 9
    VERSION UNIQUE BIOME 2026-07-30 — Avenue segments unique

    IDENTITÉ UNIQUE — L'Avenue des Roseaux Couchés :
    - Combinaison : berges terre ferme → vase + roseaux couchés même sens sans vent → sentier qui s'assèche vers îlot
    - Seg1 sud : berges terre ferme, Kangaskhan sur terre sèche, senteurs normales
    - Seg2 centre : vase, roseaux couchés tous même sens sans vent, empreintes qui évitent, odeur sucrée fausse commence
    - Seg3 nord : sentier s'assèche vers îlot, eau croupie bulles ps_bubble, fleurs fanent un côté, Dungeon_Entrance dans vase
    - Disposition : 3 segments, Kangaskhan seg1 terre ferme accessible, feu seg2 sur pierre surélevée pas dans vase, teammates un par segment
    - Faune : Croagunk, Toxel, Grimer évite, inoffensifs
    - Trace : Gloom brume trois silhouettes, Cercle Suaire Banette/Ectoplasma/Nostenfer
    - Cinématique MarshArrival correspond : odeur sucrée fausse, roseaux couchés même sens sans vent
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterScenes'
require 'halcyon.BossFX'

local forgotten_marsh_entrance = {}

function forgotten_marsh_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_forgotten_marsh_entrance UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Anima_Root', 2)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(160, 180)))
  end)
end

function forgotten_marsh_entrance.Enter(map)
  if not ChapterScenes.MarshArrival() then
    GAME:FadeIn(20)
  end
end

function forgotten_marsh_entrance.Update(map) end

function forgotten_marsh_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function forgotten_marsh_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function forgotten_marsh_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("S'enfoncer par le sentier qui s'assèche,\nvers le marais où les roseaux sont couchés ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("forgotten_marsh", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function forgotten_marsh_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function forgotten_marsh_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les berges terre ferme seg1... puis vase seg2 avec roseaux couchés tous même sens sans vent... et sentier qui s'assèche seg3 vers l'îlot. L'avenue raconte déjà le donjon.", "Worried")
  UI:WaitShowDialogue("Odeur sucrée fausse qui commence seg2, fleurs qui fanent un côté — Gloom avait raison. Mais le Kangourex seg1 sur terre sèche est prêt — PP, ventre — avant la vase.")
  GeneralFunctions.EndConversation(chara)
end

function forgotten_marsh_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Croagunk inoffensif patauge vase seg2,[pause=10] il évite le centre. Même Grimer évite. Qu'est-ce qui fait peur à la vase ?", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function forgotten_marsh_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les empreintes seg3 s'arrêtent au bord...[pause=10] comme si quelque chose n'osait pas aller vers l'îlot. Le Cercle ?", "Worried")
  GeneralFunctions.EndConversation(chara)
end

return forgotten_marsh_entrance
