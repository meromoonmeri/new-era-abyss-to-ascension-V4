-- Team Charme at Aegis Cave, thirty years after Explorers of Sky.
require 'origin.common'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'
local T={}
function T.Ensure()
 SV.TeamCharm=SV.TeamCharm or {AegisMet=false,BriefingSeen=false,RegisCommented={},Departed=false}
end
function T.Spawn()
 T.Ensure(); if SV.TeamCharm.Departed then return end
 local chars=CharacterEssentials.MakeCharactersFromList({
  {'TeamCharmLopunny',400,176,Direction.Left},
  {'TeamCharmGardevoir',424,192,Direction.Left},
  {'TeamCharmMedicham',400,208,Direction.Left},
 })
 return chars
end
function T.Arrival()
 T.Ensure(); if SV.TeamCharm.AegisMet then return false end
 SV.TeamCharm.AegisMet=true;GAME:CutsceneMode(true);GAME:FadeIn(25)
 local hero,partner=CH('PLAYER'),CH('Teammate1');local lop=CH('TeamCharmLopunny');local gar=CH('TeamCharmGardevoir');local med=CH('TeamCharmMedicham')
 UI:SetSpeaker(lop);UI:WaitShowDialogue("Vous avez donc rouvert les Aegis Cave.[pause=15] Trente ans, et cette porte grince toujours de la même façon.")
 if partner then UI:SetSpeaker(partner);UI:WaitShowDialogue("Team Charme ?[pause=10] La Team Charme des récits de la Guilde ?") end
 UI:SetSpeaker(med);UI:WaitShowDialogue("Un peu plus lentes,[pause=10] peut-être.[pause=0] Mais toujours capables de lire une tablette avant le déjeuner.")
 UI:SetSpeaker(gar);UI:WaitShowDialogue("Les mots GLACE, ROCHE et ACIER n'ont pas changé.[pause=15] En revanche, quelque chose pulse sous le Puits.[pause=10] Ce n'était pas là lors de notre première expédition.")
 UI:SetSpeaker(lop);UI:WaitShowDialogue("Cette exploration est la vôtre.[pause=10] Nous ne prendrons ni vos combats ni vos découvertes.[pause=0] Nous resterons au camp pour comparer vos pierres-lettres à nos anciens relevés.")
 UI:ResetSpeaker(false);UI:WaitShowDialogue("Les vétéranes de la Team Charme rejoignent temporairement le camp des Aegis Cave.")
 SV.TeamCharm.BriefingSeen=true;GAME:CutsceneMode(false);return true
end
function T.Talk(name,chara)
 T.Ensure()
 if name=='Lopunny' then
  GeneralFunctions.StartConversation(chara,"À notre époque,[pause=10] nous sommes entrées ici pour le frisson et le trésor.[pause=15] Vous,[pause=10] vous cherchez ce qui réveille la pierre.[pause=0] C'est une bien meilleure raison.","Normal")
 elseif name=='Gardevoir' then
  GeneralFunctions.StartConversation(chara,"Les inscriptions sont intactes,[pause=10] mais leur aura ne l'est pas.[pause=15] Chaque Regi vaincu calmera une couche du sceau.[pause=0] Écoutez aussi ce que les murs taisent.","Worried")
 else
  GeneralFunctions.StartConversation(chara,"J'ai recopié les trois mots pour vous :[pause=10] GLACE,[pause=10] ROCHE,[pause=10] ACIER.[pause=15] Même après trente ans,[pause=10] je refuse de perdre contre l'orthographe Zarbi.","Happy")
 end
 GeneralFunctions.EndConversation(chara)
end
return T
