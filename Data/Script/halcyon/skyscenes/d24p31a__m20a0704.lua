-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P31A/m20a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR_REMIX non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D24P31B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Time...[K]is at a standstill here!", french=" Le temps...[K] il s'est arrêté!", german=" Die Zeit...[K] Sie steht hier still!", italian=" Il tempo...[K] qui è fermo!", spanish=" El tiempo...[K] ¡se ha detenido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="Just before we were dragged\noff to the future with you, [CS:N]Grovyle[CR]...", french="Juste avant qu'on parte dans\nle futur avec toi, [CS:N]Massko[CR]...", german="Kurz bevor wir mit dir in die\nZukunft verschleppt worden sind, [CS:N]Reptain[CR]...", italian="Poco prima di finire nel futuro\ncon te, [CS:N]Grovyle[CR]...", spanish="Justo antes de que nos\narrastrasen al futuro, [CS:N]Grovyle[CR]..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
end
