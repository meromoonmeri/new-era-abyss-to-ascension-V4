-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0607.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK_SHORTENED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="But I've missed this...[K]\nfantastic sight.", french="Mais ça m'a beaucoup manqué...[K]\nC'est un spectacle féerique.", german="Aber ich habe es vermisst...[K]\nEin fantastischer Anblick.", italian="Ma mi è mancata...[K] questa\nsplendida vista.", spanish="Pero echaba de menos...[K] esta\nfantástica vista."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" The last time was...", french=" La dernière fois remonte à...", german=" Das letzte Mal war...", italian=" L'ultima volta è stata...", spanish=" La última vez..."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySceneKit.say({english="It was when...[K]when I met\n[hero]...", french="C'était quand...[K] quand j'ai\nrencontré [hero]...", german="Es war,[K] als ich [hero]\ntraf...", italian="... quando...[K] quando ho\nconosciuto [hero]...", spanish="Fue...[K] cuando conocí a\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
