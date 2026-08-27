-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N01_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if (SkyProg.cmp(4, 3) <= 0) then -- if ROM: scn($SCENARIO_MAIN) <= [4, 3]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Say, [hero].", french=" Dis, [hero].", german=" Sag mal, [hero].", italian=" Senti, [hero].", spanish=" Dime, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Today, they didn't want us to do\nany jobs from the Job Bulletin Board.", french="Aujourd'hui, nous ne devons pas\nnous occuper des missions du Tableau des\nMissions.", german="Sie wollten nicht, dass wir heute\nirgendwelche Jobs vom Job-Infobrett\nerledigen.", italian="Oggi ci hanno chiesto di non\noccuparci della Bacheca delle missioni.", spanish="Nos han dicho que hoy dejemos\nde lado las misiones del Tablón de Anuncios."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="We're supposed to check the\njobs on the Outlaw Notice Board, right?", french="Nous devons consulter les\nmissions affichées sur les Avis de\nRecherche, non?", german="Wir sollen uns die Jobs auf dem\nGanoven-Infobrett ansehen, richtig?", italian="Dobbiamo controllare le missioni\nnella Bacheca dei ricercati, giusto?", spanish="¿No teníamos que mirar las\nmisiones del Tablón \"Se Busca\"?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="If we're ready to go do the job,\nwe have to tell [CS:N]Bidoof[CR] by the Outlaw\nNotice Board.", french="Les préparatifs de mission\nterminés, il faudra aller prévenir [CS:N]Keunotor[CR].\nIl nous attend devant les Avis de Recherche.", german="Wenn wir bereit sind, den Job\nin Angriff zu nehmen, sollten wir es [CS:N]Bidiza[CR]\nbeim Ganoven-Infobrett wissen lassen.", italian="Quando decidiamo di partire,\ndobbiamo dirlo a [CS:N]Bidoof[CR] vicino alla Bacheca dei\nricercati.", spanish="Teníamos que hablar con [CS:N]Bidoof[CR],\ncerca del Tablón \"Se Busca\", tras reunir el\ncoraje para realizar la misión."}) -- SwitchTalk: branche default (canon générique)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- switch(message_Menu(MENU_JOB_BOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
end
