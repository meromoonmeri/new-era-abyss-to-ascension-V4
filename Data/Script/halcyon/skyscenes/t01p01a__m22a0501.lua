-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m22a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Oh, right, [hero]!", french=" D'accord, [hero]!", german=" Oh, richtig, [hero]!", italian=" Ah, [hero]!", spanish=" Por cierto, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Let's go check out Sharpedo\nBluff, [hero]!", french="Allons voir à la Falaise\nSharpedo, [hero]!", german="Lass uns bei der Tohaido-Klippe\nvorbeischauen, [hero]!", italian="Andiamo a controllare al\nPromontorio Sharpedo, [hero]!", spanish="¡Echemos un vistazo al Risco\nSharpedo, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[121] = 1 -- $SCENARIO_TALK_BIT_FLAG[121] = 1 (ROM)
end
