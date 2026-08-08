--- Mt. Blaze summit — New Era adaptation of the canonical Moltres encounter.
require 'origin.common'
require 'halcyon.CharacterEssentials'
local scene = {}
function scene.Cutscene()
  GAME:CutsceneMode(true)
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  GROUND:TeleportTo(hero,176,240,Direction.Up)
  if partner then GROUND:TeleportTo(partner,152,240,Direction.Up) end
  local moltres=CharacterEssentials.MakeCharactersFromList({{'Moltres',176,136,Direction.Down}})
  GROUND:Hide('Moltres'); GAME:MoveCamera(176,196,1,false); GAME:FadeIn(30)
  SOUND:PlayBGM('In the Depths of the Pit.ogg',true)
  UI:SetSpeaker(partner); UI:WaitShowDialogue("Cette chaleur… Ce lieu se souvient encore des fugitifs d'autrefois.")
  UI:ResetSpeaker(false); UI:SetCenter(true); UI:WaitShowDialogue("QUI FRANCHIT LE SOMMET SANS CRAINDRE SES CENDRES ?"); UI:SetCenter(false)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2'); GAME:FadeOut(true,3); GAME:FadeIn(10); GROUND:Unhide('Moltres')
  GROUND:CharSetAnim(moltres,'Attack',false); GAME:WaitFrames(20); GROUND:CharSetAnim(moltres,'Idle',true)
  UI:WaitShowTitle("Moltres — Flamme du Mont Ardent",20); GAME:WaitFrames(40); UI:WaitHideTitle(20)
  UI:SetSpeaker(moltres); UI:WaitShowDialogue("Trente années ont passé. La montagne, elle, n'a rien oublié.")
  UI:WaitShowDialogue("Prouvez que votre fuite ne vous a pas dépouillés de votre courage.")
  if partner then UI:SetSpeaker(partner); UI:WaitShowDialogue("Nous ne fuyons plus seuls. Cette fois, nous avançons ensemble.") end
  SOUND:FadeOutBGM(60); GAME:CutsceneMode(false)
end
return scene
