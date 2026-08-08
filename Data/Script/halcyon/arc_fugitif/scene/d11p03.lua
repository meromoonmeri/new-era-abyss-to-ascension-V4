--- Mt. Freeze summit — Ninetales revelation adapted to New Era continuity.
require 'origin.common'
require 'halcyon.CharacterEssentials'
local scene={}
function scene.Cutscene()
  GAME:CutsceneMode(true)
  local hero,partner=CH('PLAYER'),CH('Teammate1')
  GROUND:TeleportTo(hero,176,240,Direction.Up); if partner then GROUND:TeleportTo(partner,152,240,Direction.Up) end
  local ninetales=CharacterEssentials.MakeCharactersFromList({{'Ninetales',176,136,Direction.Down}})
  GROUND:Hide('Ninetales'); GAME:MoveCamera(176,190,1,false); GAME:FadeIn(40)
  SOUND:PlayBGM('Mystifying Forest.ogg',true)
  UI:SetSpeaker(partner); UI:WaitShowDialogue("Ce sommet… J'ai l'impression qu'il nous reconnaît.")
  GROUND:Unhide('Ninetales'); GAME:WaitFrames(30)
  UI:WaitShowTitle("Ninetales — Témoin de la Légende",20); GAME:WaitFrames(40); UI:WaitHideTitle(20)
  UI:SetSpeaker(ninetales); UI:WaitShowDialogue("Il y a trente ans, deux fugitifs sont venus chercher ici la vérité sur une malédiction.")
  UI:WaitShowDialogue("La malédiction n'était pas la leur. Leur humanité ne fut jamais la cause des catastrophes.")
  UI:WaitShowDialogue("Aujourd'hui, d'autres voix déforment leur histoire pour condamner ceux qui leur ressemblent.")
  if partner then UI:SetSpeaker(partner); UI:WaitShowDialogue("Le Cercle du Suaire… Il utilise la vieille légende contre nous.") end
  UI:SetSpeaker(ninetales); UI:WaitShowDialogue("Alors emportez mon témoignage. Une vérité gardée trop longtemps devient l'arme de ceux qui mentent.")
  UI:ResetSpeaker(false); UI:WaitShowDialogue("Le renard aux neuf queues vous confie la mémoire du Mont Gelé.")
  SV.CanonicalDungeons=SV.CanonicalDungeons or {}; SV.CanonicalDungeons.NinetalesTestimony=true
  SOUND:FadeOutBGM(90); GAME:FadeOut(false,30); GAME:CutsceneMode(false)
end
return scene
