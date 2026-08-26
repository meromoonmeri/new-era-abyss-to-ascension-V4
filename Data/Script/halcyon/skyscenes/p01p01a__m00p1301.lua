-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GROUND:MoveToPosition(hero, 236, 236, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 216, 120, Direction.Down, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 216, 204, false, 2)
  GAME:WaitFrames(20)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GROUND:MoveToPosition(partner, 200, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Anda, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Were you just at the café?", french=" Tu sors du café?", german=" Warst du gerade im Café?", italian=" Stavi uscendo dal caffè, vero?", spanish=" ¿Estabas en la cafetería?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Perfect timing![K]\nThe truth is... I have something to ask you...", french="Tu tombes bien![K]\nEn fait... j'ai un truc à te demander...", german="Das trifft sich ja hervorragend![K]\nUm ehrlich zu sein, habe ich eine Bitte an dich.", italian="Tempismo perfetto![K]\nA dire il vero... dovrei chiederti una cosa...", spanish="¡Justo a tiempo![K]\nLo cierto es que... quiero pedirte una cosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="In the past, when you've wanted\nto take team members with you to explore,\nthey waited for you at this Watering Hole...", french="Avant, quand tu ajoutais des\nmembres à ton équipe d'exploration,\nceux-ci t'attendaient près du Point d'Eau...", german="Bisher haben Team-Mitglieder,\ndie du mit auf Erkundung nehmen wolltest,\nimmer bei diesem Wasserloch gewartet...", italian="In passato, quando sceglievi dei\nmembri da portare in esplorazione, loro ti\naspettavano qui al pozzo...", spanish="Antes, cuando querías llevar\na más miembros del equipo a explorar,\nte esperaban en esta fuente..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But now that the café\nhas just opened...", french="Mais maintenant que le café\nvient d'ouvrir...", german="Aber jetzt, wo gerade das Café\neröffnet wurde...", italian="Ma ora che il caffè è stato\naperto...", spanish="Pero ahora que acaba de abrir\nla cafetería..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Everyone has been saying they'd\nlike to wait while relaxing at the café.", french="... tout le monde est d'avis que\nce serait mieux d'attendre tranquillement\nau café.", german="Da waren alle der Meinung, es\nwäre schöner, entspannt im Café zu warten.", italian="... tutti dicono che\npreferirebbero aspettare rilassandosi\nlì dentro.", spanish="Todos dicen que preferirían\nesperar pasando el rato en ella."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I completely understand that...[K]\nI mean, I understand how they feel.", french="C'est tout à fait\ncompréhensible...[K] Je veux dire,\nje comprends leur point de vue.", german="Das verstehe ich vollkommen...[K]\nIch meine, ich verstehe, dass sie das\nso sehen.", italian="Capisco benissimo che...[K]\nCioè, capisco come debbano sentirsi.", spanish="Y yo lo entiendo perfectamente...[K]\nVamos, que es lógico."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So, [hero], what do\nyou think?", french="Et toi, [hero], qu'en\npenses-tu?", german="Nun, [hero], wie denkst\ndu darüber?", italian="Allora, [hero]... Cosa ne\ndici?", spanish="¿A ti qué te parece,\n[hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Would you like to meet up with\nyour team members waiting at the café?", french="Aimerais-tu que les membres de\nton équipe t'attendent au café?", german="Würdest du dich mit deinen\nTeam-Mitgliedern auch im Café treffen?", italian="Ti andrebbe di incontrare\ni membri della tua squadra al caffè?", spanish="¿Te gustaría reunirte con los\nmiembros de tu equipo en la cafetería?"})
  SkySceneKit.cleanup_npcs()
end
