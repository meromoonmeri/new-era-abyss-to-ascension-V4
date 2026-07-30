--[[
    init.lua — celestial_peak_entrance
    Entrée Pic Céleste — Chapitre 10
    VERSION UNIQUE BIOME 2026-07-30 — Avenue segments unique

    IDENTITÉ UNIQUE — L'Avenue du Vent qui Porte les Voix :
    - Combinaison : plaine → contreforts avec nuages bas Genesis_Fade → corniche pied pic avec mer nuages
    - Seg1 sud : plaine vent léger SE5_Wind_Background faible, herbe penchée, Kangaskhan
    - Seg2 centre : contreforts nuages bas qui rampent au sol, traces Fulgur griffes Luxray + éclair jaune bs_plant, empreintes rapides
    - Seg3 nord : corniche pied pic avec mer nuages visible loin en bas, autel vent, vent fort, Dungeon_Entrance face ciel
    - Disposition : 3 segments sud→nord vent croissant, Kangaskhan seg1 accessible, feu seg2 ancré pierres lourdes sinon s'envole, teammates un par segment pas alignés
    - Faune : Swablu, Wingull, Drifloon inoffensifs ventés
    - Trace : Escouade Fulgur course, Luxray arrogant mais code honneur, Lugia juge
    - Cinématique PeakArrival correspond : vent frappe côté, 3 silhouettes corniche, voix portées vent
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterScenes'
require 'halcyon.BossFX'

local celestial_peak_entrance = {}

function celestial_peak_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_celestial_peak_entrance UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    BossFX.Overlay('SE5_Wind_Background', 0, 0, 10, 400, 40, 1, -120, 0)
  end)
end

function celestial_peak_entrance.Enter(map)
  if not ChapterScenes.PeakArrival() then
    GAME:FadeIn(20)
  end
end

function celestial_peak_entrance.Update(map) end

function celestial_peak_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function celestial_peak_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function celestial_peak_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Grimper par la corniche venteuse face au vide,\nvers la course de l'Escouade Fulgur ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("celestial_peak", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function celestial_peak_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function celestial_peak_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Le vent frappe côté dès seg1...[pause=10] Il faut se pencher dedans pour tenir debout seg3.[pause=0] Et les nuages bas seg2 qui rampent — Genesis_Fade — on marche dedans.", "Worried")
  UI:WaitShowDialogue("Traces Fulgur seg2 — griffes Luxray sur roche, éclair jaune bs_plant... Ils sont déjà à mi-hauteur, ils savent où est la mer de nuages. Et le Kangourex seg1 est prêt — PP, ventre — avant que vent n'emporte tout.")
  GeneralFunctions.EndConversation(chara)
end

function celestial_peak_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Wingull emporté vent seg3,[pause=10] inoffensif,[pause=10] il lutte pour rester. Comme nous vers le Pic.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function celestial_peak_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "La mer de nuages seg3 nord...[pause=10] On voit Metano dessous, tout petit. On est vraiment au pied du ciel.", "Surprised")
  GeneralFunctions.EndConversation(chara)
end

return celestial_peak_entrance
