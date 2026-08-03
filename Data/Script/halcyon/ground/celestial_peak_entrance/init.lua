--[[
    init.lua — celestial_peak_entrance
    Entrée de donjon (patron cloven_ruins_entrance) : Dungeon_Entrance (Touch),
    rocher Kangourex (Action), spawners équipiers.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterScenes'

local celestial_peak_entrance = {}

function celestial_peak_entrance.Init(map)
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function celestial_peak_entrance.Enter(map)
  --Scene d'arrivee du chapitre : jouee une seule fois, elle etablit le lieu
  --avant que le joueur ne touche l'entree du donjon. Si elle a deja ete vue
  --(ou si on n'est pas dans le bon chapitre), fondu simple.
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
  UI:ChoiceMenuYesNo("Entrer dans la Tour Céleste ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    --LA TOUR SE DEVOILE. Une seule fois, juste avant la premiere montee :
    --le duo leve les yeux et le jeu montre plein ecran ce qu'il voit.
    --Placee ICI et non dans Enter() a dessein — le plan n'a de sens qu'au
    --moment ou l'on decide de monter, pas en arrivant sur les lieux.
    --Sous pcall : si la scene casse, l'entree du donjon reste possible.
    partner.IsInteracting = false
    pcall(function() GROUND:CharEndAnim(partner) end)
    pcall(function() GROUND:CharEndAnim(CH('PLAYER')) end)
    pcall(function() ChapterScenes.PeakTowerReveal() end)
    partner.IsInteracting = true
    pcall(function() GROUND:CharSetAnim(partner, 'None', true) end)
    pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'None', true) end)

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
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function celestial_peak_entrance.Teammate2_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

function celestial_peak_entrance.Teammate3_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

return celestial_peak_entrance
