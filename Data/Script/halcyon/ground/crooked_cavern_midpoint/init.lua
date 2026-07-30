--[[
    init.lua
    Crooked Cavern midpoint — Relais Caverne Tortueuse — Chapitre 3
    VERSION UNIQUE BIOME 2026-07-30 — Exigence unicité totale.

    IDENTITÉ UNIQUE — La Salle du Puits de Lumière Zénithal :
    - Position exacte : charnière entrée berdée (seg0) → profondeurs (seg1).
      Exact : salle d'aérage où canopée rocheuse s'ouvre.
    - Élément distinctif 1 : Puits de lumière zénithal — ouverture plafond,
      rayon lumineux vertical, particules Leaf_Fall verticales qui tombent lentement.
      Seul puits lumière du jeu, seul endroit où on voit ciel en caverne.
    - Élément distinctif 2 : Stalagmite percée — formation 2x2 trouée au centre,
      trou au milieu comme beignet rocheux, laisse passer lumière. Unique.
    - Élément distinctif 3 : Graffitis anciens équipes sur paroi ouest — Paper_1
      mais neutralisé décor (trigger 0), dates gravées, "Team Brume 12F" etc.
    - Disposition ADAPTÉE topo : circulaire autour puits lumière, Kangaskhan sous
      lumière zénithale (symbolique seul endroit où ciel visible), feu au bord
      puits (lumière + chaleur), entrée sud basse (on rampe), sortie nord haute
      (on grimpe vers profondeurs). Pas plan rectangle.
    - Faune : Zubat inoffensif pendu plafond près puits + Woobat qui tourne
      autour lumière, non agressifs, cohérents caverne. Lumière attire.

    FONCTIONS : PP + ventre via Kangaskhan sous puits lumière, faune caverne.
    TRACE : hors-la-loi Caverne Tortueuse, équipe rivale Style.

    Base : rest_stop (456x456 CaveCamp) → enrichi puits lumière + stalagmite percée
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.crooked_cavern_midpoint.crooked_cavern_midpoint_ch_3'
require 'halcyon.BossFX'

local crooked_cavern_midpoint = {}

function crooked_cavern_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crooked_cavern_midpoint UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Anima_Root_Glow', 2)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(228, 208)))
  end)
end

function crooked_cavern_midpoint.Enter(map)
  crooked_cavern_midpoint.PlotScripting()
end

function crooked_cavern_midpoint.Exit(map) end
function crooked_cavern_midpoint.Update(map) end

function crooked_cavern_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function crooked_cavern_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  crooked_cavern_midpoint.PlotScripting()
end

function crooked_cavern_midpoint.PlotScripting()
  if SV.ChapterProgression.Chapter == 3 then
    if not SV.Chapter3.CrookedPlayedMidpointIntro then
      crooked_cavern_midpoint_ch_3.FirstArrival()
    elseif SV.CrookedCavern.DiedPastCheckpoint then
      crooked_cavern_midpoint_ch_3.WipedCutscene()
    else
      crooked_cavern_midpoint_ch_3.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

-- Sortie nord par-dessus stalagmite percée vers profondeurs — arche lumière
function crooked_cavern_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Continuer vers les profondeurs par la lumière zénithale\nqui perce la stalagmite ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    crooked_cavern_midpoint_ch_3.ContinueScene()
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crooked_cavern_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Revenir à l'entrée par le boyau bas sous les graffitis des anciennes équipes ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("crooked_cavern_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crooked_cavern_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function crooked_cavern_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Le puits de lumière zénithale...[pause=10] seul endroit de la caverne où on voit le ciel.[pause=0] Les Zubat pendus inoffensifs autour, les Woobat qui tournent dans le rayon...", "Normal")
  UI:WaitShowDialogue("Et la stalagmite percée au centre — trouée comme un beignet rocheux, la lumière passe à travers. Aucun autre relais n'a ça. Le Kangourex sous la lumière nous restaure — PP, ventre — à la lumière naturelle. C'est le seul endroit où la caverne respire.")
  GeneralFunctions.EndConversation(chara)
end

return crooked_cavern_midpoint
