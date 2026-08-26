-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(16, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 304, 228, false, 2)
  GROUND:MoveToPosition(hero, 344, 228, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="I feel like I'm being crushed...[K]\nby a terrible sense of danger...", french="J'ai un horrible pressentiment...\ncomme si un terrible danger nous guettait...", german="Es fühlt sich an, als würde mich\netwas erdrücken...[K] Irgendeine\nschreckliche Gefahr...", italian="Mi sento schiacciare...[K]\nda un forte senso di pericolo...", spanish="Tengo una sensación extraña.[K]\nComo si estuviera en peligro."}) -- SwitchTalk: branche default (canon générique)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...GRROOOOOOH...!", french="GRROOOOOOH... GRROOOOOOH...!", german="GRROOOOOOH... GRROOOOOOH!", italian="GRROOOOOOH... GRROOOOOOH...!", spanish="¡GRRRRRRRR! ¡GRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Argh!", italian=" Ehi!", spanish=" ¡Aaay!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="I thought it might...[K]be roaring!\nAnd it is!", french="Je le savais![K] C'est bel et bien\nun rugissement!", german="Ich wusste es.[K] Es war ein\nBrüllen! Ich hatte recht!", italian="È proprio come pensavo![K] Si\ntratta di un ruggito!", spanish="Sabía que podía ser un rugido.[K]\n¡Y lo es!"}) -- SwitchTalk: branche default (canon générique)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- GAP: se_Play(6915) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- GAP: se_Play(6915) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  SkySceneKit.say({english=" ...is...[K]coming!", french=" ... quelque chose...[K] se rapproche!", german=" Irgendetwas[K] kommt auf uns zu!", italian=" ... sta...[K] arrivando!", spanish=" Algo...[K] ¡se acerca!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 15)
end
