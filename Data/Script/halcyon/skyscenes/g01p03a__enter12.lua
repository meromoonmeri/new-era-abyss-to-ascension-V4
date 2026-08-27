-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N01_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
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
  SkySceneKit.say({english=" We should ask [CS:N]Bidoof[CR] first.", french=" Demandons d'abord à [CS:N]Keunotor[CR].", german="Wir sollten zuerst [CS:N]Bidiza[CR]\nfragen.", italian="Dovremmo prima chiedere a\n[CS:N]Bidoof[CR].", spanish="Deberíamos preguntarle a\n[CS:N]Bidoof[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- switch(message_Menu(MENU_OUTLAW_BOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
end
