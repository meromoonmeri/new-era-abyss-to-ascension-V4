-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s21p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="If we can meet with [CS:N]Palkia[CR],\nwe'd be able to ask about the distortion\nof space.", french="Si seulement on avait l'occasion\nde rencontrer [CS:N]Palkia[CR], on pourrait\nle questionner sur la distorsion de l'espace.", german="Wenn wir [CS:N]Palkia[CR] finden, können\nwir es auch über die Raumverzerrung\nbefragen.", italian="Se riuscissimo a trovare [CS:N]Palkia[CR],\npotremmo chiedergli cosa sa della\ndistorsione dello spazio.", spanish="Si logramos encontrar a [CS:N]Palkia[CR],\npodremos preguntarle sobre la deformación\ndel espacio."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="But we don't know where\n[CS:P]Spacial Rift[CR] is...", french="Mais on n'a aucune idée sur\nl'emplacement de la [CS:P]Faille Spatiale[CR]...", german="Aber wir wissen nicht, wo die\n[CS:P]Raumspalte[CR] ist...", italian="Ma non sappiamo dove si trova\nla [CS:P]Valle Dimensionale[CR]...", spanish="Pero no sabemos dónde está la\n[CS:P]Grieta Espacial[CR]..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Hmm...[K] I guess there isn't any\npoint in worrying about it right now.", french="Hum...[K] Ça ne sert à rien de\ns'inquiéter pour le moment.", german="Hmm...[K] Das ist jetzt\nwohl noch kein Grund zur Sorge.", italian="Mmm...[K] È inutile\npreoccuparsene adesso.", spanish="Hum...[K] Preocuparse ahora de\neso no servirá de nada."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de perdre\ncourage, [hero]!", german="Aufgegeben wird nicht,\n[hero]!", italian="Non possiamo arrenderci ora,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
end
