-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m04a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_ANGRY, 3 — VFX NDS→PMDO non mappés v1
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Grrr...", french=" Grrr...", german=" Grrr...", italian=" Grrr...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8961) — table SE NDS→PMDO non mappée v1
  -- GAP: SetEffect EFFECT_SWEAT_DROP, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_SWEAT_DROP, 3 — VFX NDS→PMDO non mappés v1
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  SkySceneKit.say({english="Yes, you have the right to be\nangry with us, but...", french="Oui, tu as le droit d'être en\ncolère contre nous, mais bon...", german="Ja, du hast das Recht, wütend\nauf uns zu sein, aber...", italian="Insomma, posso capire che tu\nsia arrabbiato con noi, ma...", spanish="Comprendo que estés\nenfadado, pero..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
end
