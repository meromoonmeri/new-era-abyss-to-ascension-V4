-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0306.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="I think it must have hurt\n[CS:N]Grovyle[CR] terribly to leave you.", french="Ça a dû être déchirant pour lui\nde te quitter.", german="Es muss [CS:N]Reptain[CR] fürchterlich\nwehgetan haben, dich zurückzulassen.", italian="Per [CS:N]Grovyle[CR] dev'essere stato\nterribile abbandonarti.", spanish="A [CS:N]Grovyle[CR] tiene que haberle\nresultado terriblemente duro separarse de ti."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(This is our last adventure.)", french="(C'est notre dernière aventure ensemble.)", german="(Dies ist unser letztes Abenteuer.)", italian="(Questa è la nostra ultima avventura.)", spanish="(Esta es nuestra última aventura.)"}) -- SwitchMonologue: branche default
  GROUND:MoveToPosition(partner, 276, 220, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(268, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
end
