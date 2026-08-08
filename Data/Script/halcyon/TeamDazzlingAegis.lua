-- Aegis Cave ending: Team Dazzling takes the narrative slot, not Team Charm.
require 'origin.common'
require 'halcyon.CharacterEssentials'
local D={}
function D.Aftermath()
 SV.Chapter6=SV.Chapter6 or {};if SV.Chapter6.DazzlingAegisAftermath then return false end
 SV.Chapter6.DazzlingAegisAftermath=true;GAME:CutsceneMode(true)
 local trio=CharacterEssentials.MakeCharactersFromList({
  {'Adagio',408,168,Direction.Left},
  {'Aria',432,192,Direction.Left},
  {'Sonata',408,216,Direction.Left},
 })
 local adagio,aria,sonata=CH('Adagio'),CH('Aria'),CH('Sonata');local hero,partner=CH('PLAYER'),CH('Teammate1')
 -- Leur leitmotiv est posé dès la première rencontre; le chapitre 6 le
 -- reprendra comme motif de retrouvailles, pas comme une nouvelle entrée.
 SOUND:PlayBGM('Team_Dazzling_Theme.ogg',true)
 GAME:FadeIn(30);GAME:MoveCamera(320,192,40,false)
 -- Aucun carton narratif en pleine scène : le partenaire voit le trio avant
 -- qu'il parle, puis chaque membre du groupe se réoriente vers la source.
 if partner then
  GROUND:CharAnimateTurnTo(partner,Direction.Right,4)
  GROUND:CharSetEmote(partner,'notice',1)
  UI:SetSpeaker(partner);UI:WaitShowDialogue("Attends...[pause=10] Il y a quelqu'un au bord du camp.")
 end
 pcall(function() GROUND:CharAnimateTurnTo(hero,Direction.Right,4) end)
 pcall(function() GROUND:CharTurnToCharAnimated(aria,partner or hero,4) end)
 UI:SetSpeaker(aria);UI:WaitShowDialogue("Joli final.[pause=10] Beaucoup de pierre,[pause=10] un géant antique…[pause=15] et vous êtes encore debout.")
 UI:SetSpeaker(sonata);UI:WaitShowDialogue("La pulsation s'est calmée,[pause=10] mais elle n'a pas disparu.[pause=0] Elle file vers le nord-est.[pause=10] Vers une forêt.")
 UI:SetSpeaker(adagio);UI:WaitShowDialogue("Nous sommes la Team Dazzling.[pause=15] Nous suivons cette anomalie depuis plusieurs semaines.")
 if partner then UI:SetSpeaker(partner);UI:WaitShowDialogue("Vous auriez pu nous prévenir avant qu'on descende affronter Regigigas.") end
 UI:SetSpeaker(aria);UI:WaitShowDialogue("Et gâcher votre entrée en scène ?[pause=10] Jamais.")
 UI:SetSpeaker(adagio);UI:WaitShowDialogue("Reposez-vous.[pause=10] Quand la forêt bougera,[pause=10] nous nous reverrons à Metano.")
 pcall(function() GROUND:CharTurnToCharAnimated(sonata,adagio,4) end)
 UI:SetSpeaker(sonata);UI:WaitShowDialogue("Le signal vient de changer.[pause=10] Les racines de Sinister Woods viennent de répondre.")
 if partner then
  GROUND:CharAnimateTurnTo(partner,Direction.UpRight,4)
  UI:SetSpeaker(partner);UI:WaitShowDialogue("Alors on les retrouvera là-bas.[pause=10] Et cette fois,[pause=10] elles nous expliqueront tout.")
 end
 SOUND:FadeOutBGM(60)
 pcall(function() GROUND:CharSetAnim(adagio,'Walk',true) end);pcall(function() GROUND:CharSetAnim(aria,'Walk',true) end);pcall(function() GROUND:CharSetAnim(sonata,'Walk',true) end)
 GAME:FadeOut(false,40);pcall(function() GROUND:Hide('Adagio');GROUND:Hide('Aria');GROUND:Hide('Sonata') end)
 SV.Chapter6.MissionAvailable=true;GAME:CutsceneMode(false);return true
end
return D
