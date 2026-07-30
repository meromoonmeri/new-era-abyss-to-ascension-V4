--[[
    init.lua — Cloven Ruins Entrance — Chapitre 7
    VERSION UNIQUE BIOME 2026-07-30 — Avenue segments unique

    IDENTITÉ UNIQUE — L'Avenue des Dalles Fissurées qui Convergent :
    - Combinaison : plaine → dalles fissurées extérieur → colonnes effondrées + glyphes + veines dorées début convergence
    - Seg1 sud : plaine dalles fissurées, herbe entre fissures, Kangaskhan sur dalle intacte rare
    - Seg2 centre : colonnes effondrées 2x2, éboulis, camp en ruine, graffitis équipes anciennes
    - Seg3 nord : glyphes au sol AntreDragon tiles, veines dorées début convergence vers socle vide central futur relais, Dungeon_Entrance sous arche à moitié effondrée
    - Disposition : 3 segments en progression chaos → ordre. Seg1 chaos léger, seg2 chaos fort colonnes, seg3 ordre commence (dalles dorées début). Teammates un par segment
    - Faune : Baltoy inoffensif tourne autour colonnes + Bronzor flottant, cohérent ruines
    - Trace : Rubble Aggron légende Trois Serviteurs et Colosse, Regigigas gardien Cœur Anima corrompu
    - Construction : outil generateur map_tileset base end_moonlit_temple, finalisation manuelle dalles fissurées + colonnes + glyphes
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_entrance UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Core_Deactivation', 2)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(196, 380)))
  end)
end

function cloven_ruins_entrance.Enter(map)
  GAME:FadeIn(20)
end

function cloven_ruins_entrance.Update(map) end

function cloven_ruins_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Descendre par les dalles fissurées qui convergent,\nvers les ruines où les colonnes se sont effondrées ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les dalles fissurées seg1...[pause=10] puis colonnes effondrées seg2...[pause=10] et glyphes + veines dorées qui commencent à converger seg3 vers le socle vide.[pause=0] L'avenue raconte déjà les ruines.", "Worried")
  UI:WaitShowDialogue("Rubble disait que les Trois Serviteurs montaient garde ici avant le Colosse. Et le Kangourex seg1 sur dalle intacte est prêt — PP, ventre — au milieu du chaos. Seul endroit intact dehors, comme dedans.")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Baltoy tourne autour colonnes effondrées seg2,[pause=10] inoffensif.[pause=0] Il cherche ses compagnons, comme nous le Cœur.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les glyphes seg3... on distingue trois petites silhouettes autour d'une immense. Les Serviteurs et le Colosse. Encore.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

return cloven_ruins_entrance
