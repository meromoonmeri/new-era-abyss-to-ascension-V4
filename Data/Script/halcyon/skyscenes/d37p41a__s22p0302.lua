-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D37P41A/s22p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D37P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I cannot fathom how you've\ncome here, but...", french="J'ignore comment vous avez\nréussi à arriver ici mais...", german="Ich kann mir nicht erklären, wie\nihr hierhergekommen seid, aber...", italian="Non capisco come abbiate fatto\nad arrivare qui.", spanish="No logro entender cómo\nhabéis llegado hasta aquí, pero..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I find your visit ever so\nconvenient!", french="Je trouve que votre visite\ntombe à point nommé!", german="Ich finde euren Besuch äußerst\npraktisch!", italian="Però la vostra visita capita\nal momento giusto!", spanish="¡Vuestra visita es de lo más\noportuna!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I've longed to meet both of you!", french="Cela fait longtemps que je\nsouhaite vous rencontrer!", german="Ich wollte euch beide schon\nlange mal treffen!", italian="È da tempo che\nvolevo incontrarvi!", spanish=" ¡Estaba deseando encontraros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="(In other words, it was still in a dream.)", french="(Autrement dit, c'était quand même dans\nun rêve.)", german="(Mit anderen Worten, ich war dennoch in\neinem Traum.)", italian="(In altre parole, mi trovavo\ncomunque in un sogno.)", spanish="(En otras palabras, que también era un sueño.)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
