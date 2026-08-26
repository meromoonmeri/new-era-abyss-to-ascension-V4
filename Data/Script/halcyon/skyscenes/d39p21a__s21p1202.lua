-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P21A/s21p1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D39P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  SkySceneKit.say({english=" Ugh...[K] This is so rough...", french=" Argh...[K] Ce que c'est difficile...", german=" Uff...[K] Das ist so grob...", italian=" Uff...[K] È davvero dura...", spanish=" Uf...[K] Esto es todo un reto..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="This dungeon led to a\ndead end too...", french=" C'est un cul-de-sac ici aussi...", german="Dieser Dungeon hat uns auch in\neine Sackgasse geführt...", italian="Questo dungeon porta a\nun vicolo cieco...", spanish="Estamos en un callejón sin\nsalida..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="There's nowhere left we can\nrun to...", french="Je crois bien qu'on n'a nulle part\noù se réfugier...", german="Ich glaube, jetzt gibt es keinen\nAusweg mehr...", italian="Mi sembra che non si possa\nandare da nessun'altra parte...", spanish="No hay ningún sitio por donde\nescapar..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(But, to do so...)", french="(Mais pour ce faire...)", german="(Aber um das zu tun...)", italian="(Ma per farlo...)", spanish="(Pero para eso...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="(We must defeat [CS:N]Palkia[CR]!)", french="(... on doit d'abord le vaincre!)", german="(Damit dies gelingt, müssen wir [CS:N]Palkia[CR]\nbesiegen!)", italian="(... dobbiamo sconfiggere [CS:N]Palkia[CR]!)", spanish="(¡Tendremos que derrotarlo primero!)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="And we have to find out why\nhe keeps attacking us.", french="Et il faut aussi qu'on découvre\npourquoi il n'arrête pas de nous attaquer.", german="Und wir müssen herausfinden,\nwarum es uns angreift.", italian="E dobbiamo scoprire perché\ncontinua ad attaccarci.", spanish="Además, tenemos que averiguar\npor qué nos ataca."}) -- SwitchTalk: branche default (canon générique)
end
