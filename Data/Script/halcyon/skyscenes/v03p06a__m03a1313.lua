-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P06A/m03a1313.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V03P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 344, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(1024) [anim idle native]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(15) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GROUND:MoveToPosition(npc_npc_juputoru, 204, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:FadeIn(0) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The flow of time in that region\nwill probably stop too.", french="... le temps cesse de s'y écouler\nnormalement.", german="Dann wird der Fluss der Zeit\nin dieser Region wahrscheinlich aufhören.", italian="... probabilmente il flusso\ndel tempo in quella regione si arresterebbe.", spanish="El tiempo dejaría de fluir en esa\nzona."}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(768) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-40), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(256) [anim idle native]
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:FadeIn(0) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(45)
  SkySceneKit.say({english="Even the most hardened criminal\nPokémon know to avoid messing with them.", french="Même les criminels les plus\nendurcis ne s'y trompent pas: ils savent\nqu'on ne plaisante pas avec ça.", german="Selbst skrupellose Verbrecher\nmachen sich lieber nicht an ihnen zu schaffen.", italian="Persino il più incallito dei\ncriminali sa che è meglio lasciarli stare.", spanish="Ni el malhechor más desalmado\nse atrevería a tocarlos."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
