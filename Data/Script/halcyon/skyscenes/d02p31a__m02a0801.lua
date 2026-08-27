-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D02P31A/m02a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(ProcessSpecial(53, -1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_SetWaitMode(300, 300) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thanks for playing!\n[CN]We hope you enjoyed\n[CN]the demo!", french="[CN]Merci d'avoir joué!\n[CN]Nous espérons que vous avez\n[CN]aimé cette démo!", german="[CN]Vielen Dank fürs Spielen!\n[CN]Wir hoffen, dass dir die Demo-Version\n[CN]Spaß gemacht hat!", italian="[CN]Grazie per aver giocato!\n[CN]Ci auguriamo che la versione demo\n[CN]ti sia piaciuta!", spanish="[CN]¡Gracias por jugar!\n[CN]Para descubrir aún más aventuras,\n[CN]¡no te pierdas la versión completa!"})
  -- message_KeyWait
  -- switch(ProcessSpecial(PROCESS_SPECIAL_JUMP_TO_TITLE_SCREEN, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  else
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(3, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 3 then
  SkyProg.set(3, 6) -- $SCENARIO_MAIN = scn[3,6] (ROM)
  -- @label_3 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_D02P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(hero, 256, 284, false, 2)
  GROUND:MoveToPosition(partner, 224, 284, false, 2)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! There it is!", french=" Regarde! Là!", german=" Hey! Da ist sie!", italian=" Ehi! Eccola là!", spanish=" ¡Eh! ¡Allí está!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! Look at that!", french=" Regarde! Là!", german=" Oh! Sieh mal!", italian=" Oh! Guarda!", spanish=" ¡Oh! ¡Mira eso!"})
  else
  SkySceneKit.say({english=" Oh! Over there!", french=" Regarde! Là!", german=" Oh! Dort drüben!", italian=" Oh! Di qua!", spanish=" ¡Eh! ¡Mira allí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(240, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 256, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 224, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This has to be [CS:N]Spoink[CR]'s pearl!", french=" Ce doit être la perle de [CS:N]Spoink[CR]!", german="Das muss die Perle von [CS:N]Spoink[CR]\nsein!", italian="Questa dev'essere la perla\ndi [CS:N]Spoink[CR]!", spanish="¡Esa tiene que ser la perla\nde [CS:N]Spoink[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This must be [CS:N]Spoink[CR]'s pearl!", french=" Ce doit être la perle de [CS:N]Spoink[CR]!", german="Das muss die Perle von [CS:N]Spoink[CR]\nsein!", italian="Questa dev'essere la perla\ndi [CS:N]Spoink[CR]!", spanish="¡Seguro que esa es la perla\nde [CS:N]Spoink[CR]!"})
  else
  SkySceneKit.say({english=" This has to be [CS:N]Spoink[CR]'s pearl!", french=" Ce doit être la perle de [CS:N]Spoink[CR]!", german="Das muss die Perle von [CS:N]Spoink[CR]\nsein!", italian="Questa dev'essere la perla\ndi [CS:N]Spoink[CR]!", spanish="¡Creo que esa es la perla\nde [CS:N]Spoink[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's take it back right now!", french=" Prenons-la, vite!", german=" Bringen wir sie sofort zurück!", italian=" Riportiamogliela subito!", spanish="¡Vamos a llevársela\nahora mismo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hurry back with it!", french=" Prenons-la, vite!", german=" Bringen wir sie schnell zurück!", italian=" Riportiamogliela subito!", spanish="¡Vamos a devolvérsela\nahora mismo!"})
  else
  SkySceneKit.say({english=" Quick! Let's take it back!", french=" Prenons-la, vite!", german=" Schnell! Bringen wir sie zurück!", italian=" Riportiamogliela subito!", spanish="¡Tenemos que llevársela\ncuanto antes!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  elseif true then -- default
  -- @label_2 [étiquette de flux ExplorerScript]
  SkyProg.set(3, 7) -- $SCENARIO_MAIN = scn[3,7] (ROM)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
