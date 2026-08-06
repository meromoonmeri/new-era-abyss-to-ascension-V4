require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local mont_gel_sommet = {}
local MapStrings = ""

function mont_gel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  MapStrings = COMMON.AutoLoadLocalizedStrings()
end

function mont_gel_sommet.Enter(map)
  if SV.chapter12.NinetalesRevealed == false then
    mont_gel_sommet.PlayClimaxScene()
  end
end

function mont_gel_sommet.PlayClimaxScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  -- Create Alakazam Team and Gengar dynamically if not on map
  local alakazam = CharacterEssentials.MakeCharactersFromList({{"Alakazam", 160, 260, Direction.Up}})[1]
  local gengar = CharacterEssentials.MakeCharactersFromList({{"Gengar", 192, 260, Direction.Up}})[1]
  
  GAME:CutsceneMode(true)
  
  -- Le duo est acculé contre la falaise de glace
  GROUND:TeleportTo(hero, 160, 240, Direction.Down)
  GROUND:TeleportTo(partner, 192, 240, Direction.Down)
  
  UI:SetSpeaker(gengar)
  GeneralFunctions.SetEmotion("Angry")
  UI:WaitShowDialogue("On vous tient ! C'est la fin du voyage, criminels !")

  -- Flash of light and appearance of Ninetales
  SOUND:PlayBattleSE("EVT_Roar") -- SFX Aura
  GAME:FadeOut(true, 10)
  
  local ninetales = CharacterEssentials.MakeCharactersFromList({{'Ninetales', 176, 200, Direction.Down}})[1]
  
  GAME:FadeIn(20)
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("Halte.[pause=20] Rangez vos armes, explorateurs de la Fédération.")
  
  UI:SetSpeaker(gengar)
  GeneralFunctions.SetEmotion("Shock")
  UI:WaitShowDialogue("Qu-Quoi ?! Le Feunard de la prophétie !!")
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("L'humain maudit de la légende d'il y a trente ans n'est pas celui qui se tient devant vous.")
  UI:WaitShowDialogue("La prophétie a déjà accompli, et le péché d'autrefois a été pardonné par la bravoure de l'ancienne équipe de secours.")
  UI:WaitShowDialogue("Celui-ci... n'est qu'un voyageur du temps envoyé par le destin pour sceller l'Abîme de l'Éternité.")
  
  UI:SetSpeaker(alakazam)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Alors...[pause=15] les séismes ne sont pas leur œuvre ?")
  
  UI:SetSpeaker(ninetales)
  UI:WaitShowDialogue("Non.[pause=20] C'est le réveil d'Eternatus, tapi sous l'Abîme, qui dévore la structure de notre dôme terrestre.")
  UI:WaitShowDialogue("Allez, Alakazam.[pause=15] Votre véritable ennemi n'est pas ici, il est sous nos pieds.")
  
  -- Alakazam baisse les bras, Gengar s'enfuit de rage
  GROUND:EntTurn(gengar, Direction.Down)
  GROUND:CharSetAnim(gengar, "Run", true)
  SOUND:PlayBattleSE("EVT_Run_Away")
  GROUND:Hide('Gengar')
  
  SV.chapter12.NinetalesRevealed = true
  GAME:CutsceneMode(false)
end

return mont_gel_sommet
