-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m04a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_ANGRY sur PNJ non résolu (v2 cast SSA)
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Grrr...", french=" Grrr...", german=" Grrr...", italian=" Grrr...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  SkySceneKit.say({english="Yes, you have the right to be\nangry with us, but...", french="Oui, tu as le droit d'être en\ncolère contre nous, mais bon...", german="Ja, du hast das Recht, wütend\nauf uns zu sein, aber...", italian="Insomma, posso capire che tu\nsia arrabbiato con noi, ma...", spanish="Comprendo que estés\nenfadado, pero..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
end
