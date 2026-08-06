require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local team_dazzling_duel = {}
local MapStrings = ""

function team_dazzling_duel.PlayCinematic()
  GAME:CutsceneMode(true)
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  -- Remplacement de la Team Meanies par la Team Dazzling aux mêmes coordonnées canoniques
  -- Les coordonnées GBA d'origine pour l'embuscade Meanies étaient approximativement (200, 240) et autour.
  local dazzling_leader = CharacterEssentials.MakeCharactersFromList({{"Raichu", 200, 240, Direction.Up}})[1] -- Leader Dazzling (Ex-Gengar position)
  local dazzling_sub1 = CharacterEssentials.MakeCharactersFromList({{"Milotic", 184, 256, Direction.UpRight}})[1] -- Ex-Ekans position
  local dazzling_sub2 = CharacterEssentials.MakeCharactersFromList({{"Gardevoir", 216, 256, Direction.UpLeft}})[1] -- Ex-Medicham position
  
  -- Le héros et le partenaire arrivent sur la place
  GROUND:TeleportTo(hero, 200, 300, Direction.Up)
  GROUND:TeleportTo(partner, 216, 300, Direction.Up)
  
  GAME:MoveCamera(200, 260, 1, false)
  
  -- La Team Dazzling s'approche
  GROUND:MoveToPosition(dazzling_leader, 200, 272, false, 1)
  GROUND:MoveToPosition(dazzling_sub1, 184, 288, false, 1)
  GROUND:MoveToPosition(dazzling_sub2, 216, 288, false, 1)
  
  GAME:PlayBGM("Team Dazzling Theme", true) -- Remplacement de la BGM Meanies
  
  UI:SetSpeaker(dazzling_leader)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Alors, c'est vous la fameuse équipe dont tout le monde parle ?")
  UI:WaitShowDialogue("Laissez-moi rire. Vous n'avez pas l'étoffe pour survivre dans ce nouveau monde.")
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Angry")
  UI:WaitShowDialogue("C'est ce qu'on va voir ! On ne vous laissera pas salir notre réputation !")
  
  UI:SetSpeaker(dazzling_sub2)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue("Une réputation ? Quelle réputation ? Vous n'êtes que des amateurs.")
  
  -- Mouvement d'intimidation
  GROUND:CharSetAnim(dazzling_leader, "Strike", false)
  SOUND:PlayBattleSE("EVT_Roar")
  GAME:WaitFrames(20)
  
  UI:SetSpeaker(dazzling_leader)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Si vous voulez prouver votre valeur, affrontez-nous. Ici et maintenant.")
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("On relève le défi ! En garde !")
  
  GAME:FadeOut(false, 30)
  GAME:CutsceneMode(false)
  
  -- Transition vers le combat de boss (Arène de la Place ou Combat sur la map)
  -- GAME:EnterGroundMap("place_pokemon_arene", "Spawn_Marker")
end

return team_dazzling_duel
