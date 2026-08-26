-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P10A/m26a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_V26P10A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P10A1_351) [routine d'objet NDS non simulée - documenté]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This...[K] It must be [CS:P]Treeshroud\nForest[CR].", french="Cet endroit...[K] c'est la [CS:P]Forêt\nLinceul[CR].", german="Dieser Ort...[K] Das muss das\n[CS:P]Schemengehölz[CR] sein.", italian="Questo posto...[K] è la [CS:P]Foresta[CR]\n[CS:P]Arcana[CR].", spanish="Este lugar...[K] es el [CS:P]Bosque[CR]\n[CS:P]Enraizado[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P10A1_351) [routine d'objet NDS non simulée - documenté]
  SkySceneKit.say({english=" Time is...[K] Time is moving again!", french="Le temps...[K] le temps a repris\nson cours!", german="Die Zeit...[K] Sie geht wieder ihren\nnormalen Gang!", italian="Il tempo...[K] è tornato a\nscorrere!", spanish="El tiempo...[K] ¡El tiempo ha vuelto\na fluir!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 60)
end
