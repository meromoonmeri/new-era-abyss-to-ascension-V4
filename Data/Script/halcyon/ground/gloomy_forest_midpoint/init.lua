--[[
    init.lua
    Gloomy Forest midpoint — relais mi-donjon Forêt Lugubre — Chapitre 6
    VERSION UNIQUE BIOME 2026-07-30 — Exigence unicité totale.

    IDENTITÉ UNIQUE — La Clairière de l'Arbre-Racines :
    - Position exacte : charnière entrée claire-obscure (seg0) → profondeurs sombres corrompues (seg1)
      Exact : lisière où lumière ne passe plus, canopée se ferme.
    - Élément distinctif 1 : Arbre-Racines — chêne énorme dont racines forment arche naturelle
      vers profondeurs, tiles ForestCampFront avec racines en travers. Arche vivante. UNIQUE.
    - Élément distinctif 2 : Tapis mousse épais vert sombre + champignons luminescents
      si_light_1.6.png etc attestés, lumière douce au sol même quand canopée fermée.
    - Élément distinctif 3 : Statue Kangourex couverte mousse, à moitié enfoncée dans sol,
      ancienne, raconte que lieu existe avant guilde. Seule statue à moitié enterrée.
    - Élément distinctif 4 : Sortie UNIQUE vers profondeurs, pas de retour (règle ch6) —
      fonctionnellement unique, déjà OK, mais renforcée visuellement par racines qui
      forment arche seule sortie nord. Sud condamné par racines.
    - Disposition ADAPTÉE topo : cuvette sous racines, protégé canopée, camp sous arche,
      feu petit presque caché (peur attirer), sacs sous racines, Kangaskhan sous lumière
      filtrée (symbolique seul endroit où on voit ciel). Entrée sud via trou canopée,
      sortie nord via arche racines (seule).
    - Faune : Oddish / Gloom inoffensifs qui poussent dans mousse + Woobat pendu racine,
      Musharna lointain. Non agressifs, cohérents forêt sombre.

    FONCTIONS : PP + ventre via Kangaskhan mousseux, faune forêt.
    TRACE : Team Dazzling campe ici tant que duel pas fait — 3 tentes distinctes
    Tsareena Adagio / Lopunny Aria / Mismagius Sonata. Épreuve des Trois.

    Base : forest_camp (912x720) → enrichi Arbre-Racines arche + mousse + Kangourex enterré
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_midpoint.gloomy_forest_midpoint_ch_6'
require 'halcyon.BossFX'

local gloomy_forest_midpoint = {}

function gloomy_forest_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_gloomy_forest_midpoint UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Anima_Root', 2)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(292, 260)))
    local obj2 = RogueEssence.Content.ObjAnimData('Anima_Root_Glow', 3)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj2, RogueElements.Loc(324, 270)))
  end)
end

function gloomy_forest_midpoint.Enter(map)
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.Exit(map) end
function gloomy_forest_midpoint.Update(map) end

function gloomy_forest_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.PlotScripting()
  gloomy_forest_midpoint_ch_6.SetupDazzlingTrial()

  if SV.ChapterProgression.Chapter == 6 then
    if not SV.Chapter6.GloomyPlayedMidpointIntro then
      gloomy_forest_midpoint_ch_6.FirstArrival()
    elseif SV.GloomyForest.DiedPastCheckpoint then
      gloomy_forest_midpoint_ch_6.WipedCutscene()
    else
      gloomy_forest_midpoint_ch_6.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- Sortie nord UNIQUE par arche Arbre-Racines — seule issue vers profondeurs
function gloomy_forest_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Passer sous l'arche des racines de l'Arbre-Racines\nvers les profondeurs où la lumière ne passe plus ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    gloomy_forest_midpoint_ch_6.ContinueScene()
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function gloomy_forest_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function gloomy_forest_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "L'Arbre-Racines...[pause=10] ses racines forment une arche naturelle vers les profondeurs. C'est le seul endroit où la canopée ne ferme pas complètement — la lumière filtre par les champignons luminescents sur la mousse.", "Worried")
  UI:WaitShowDialogue("Et le Kangourex à moitié enfoncé dans la mousse, couvert de lichen... il est là depuis avant la guilde, j'en suis sûre. PP et ventre restaurés sous sa garde moussue, mais doucement — on ne réveille pas ce qui dort sous les racines.")
  GeneralFunctions.EndConversation(chara)
end

function gloomy_forest_midpoint.Adagio_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Adagio_Action(chara, activator)
end

function gloomy_forest_midpoint.Aria_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Aria_Action(chara, activator)
end

function gloomy_forest_midpoint.Sonata_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Sonata_Action(chara, activator)
end

return gloomy_forest_midpoint
