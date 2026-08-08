--- Frosty Forest clearing — New Era adaptation of the canonical Articuno encounter.
require 'origin.common'
require 'halcyon.CharacterEssentials'
local scene={}
function scene.Cutscene()
  GAME:CutsceneMode(true)
  local hero,partner=CH('PLAYER'),CH('Teammate1')
  GROUND:TeleportTo(hero,176,240,Direction.Up); if partner then GROUND:TeleportTo(partner,152,240,Direction.Up) end
  local articuno=CharacterEssentials.MakeCharactersFromList({{'Articuno',176,136,Direction.Down}})
  GROUND:Hide('Articuno'); GAME:MoveCamera(176,190,1,false); GAME:FadeIn(40)
  SOUND:PlayBGM('Rising Fear.ogg',true)
  UI:SetSpeaker(partner); UI:WaitShowDialogue("Le vent s'est tu… même la neige attend.")
  UI:ResetSpeaker(false); UI:SetCenter(true); UI:WaitShowDialogue("LA FORÊT GELÉE N'ACCORDE PAS DE SECOND PASSAGE."); UI:SetCenter(false)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2'); GAME:FadeOut(true,4); GAME:FadeIn(12); GROUND:Unhide('Articuno')
  GROUND:CharSetAnim(articuno,'Attack',false); GAME:WaitFrames(24); GROUND:CharSetAnim(articuno,'Idle',true)
  UI:WaitShowTitle("Articuno — Silence des Neiges",20); GAME:WaitFrames(40); UI:WaitHideTitle(20)
  UI:SetSpeaker(articuno); UI:WaitShowDialogue("J'ai vu les anciens héros traverser cette clairière. Vous portez la même peur — mais pas la même solitude.")
  UI:WaitShowDialogue("Montrez-moi ce que trente années ont appris à ceux qui viennent après eux.")
  if partner then UI:SetSpeaker(partner); UI:WaitShowDialogue("La peur est là. Mais elle ne choisira pas notre route.") end
  SOUND:FadeOutBGM(60); GAME:CutsceneMode(false)
end
return scene
