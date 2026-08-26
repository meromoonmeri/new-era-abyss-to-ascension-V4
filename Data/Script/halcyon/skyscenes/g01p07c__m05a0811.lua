-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0811.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.say({english="(It was always after touching something!\nThat's when I got those dizzy spells!)", french="(C'est toujours après avoir touché\nquelque chose que j'ai des vertiges!)", german="(Es passiert immer, nachdem ich etwas\nberührt habe! Dann bekomme ich diese\nSchwindelanfälle!)", italian="(Stavo sempre toccando qualcosa quando si\nsono verificati i capogiri!)", spanish="(¡Siempre me han dado los mareos después\nde tocar algo!)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="(When I touch something, I see something\nconnected to it...[K] Right?)", french="(En touchant un objet, je vois quelque\nchose qui s'y rapporte...[K] C'est bien ça?)", german="(Wenn ich etwas berühre, sehe ich etwas, das\ndamit in Verbindung steht...[K] Oder?)", italian="(Quando tocco qualcosa, ho una visione\ncollegata ad essa...[K] Giusto?)", spanish="(Cuando toco una cosa, tengo una visión\nrelacionada con ella...[K] ¿Verdad?)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english=" So that means...", french=" Cela signifie...", german=" Das heißt also...", italian=" Il che significa...", spanish=" Y eso quiere decir que..."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="This time, you saw something\nthat took place in the past.", french="... que cette fois, tu as vu\nun événement qui appartient au passé.", german="Diesmal hast du etwas gesehen,\ndas in der Vergangenheit passiert ist.", italian="... che questa volta hai visto\nqualcosa che è avvenuto nel passato.", spanish="Esta vez viste algo que ya había\nocurrido."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Th-that's true!)", french="(En effet!)", german="(D-das stimmt!)", italian="(È v-vero!)", spanish="(¡Es cierto!)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="You must have that kind of\nspecial ability!", french="Tu dois posséder une sorte\nde don!", german="Du musst eine besondere\nFähigkeit haben!", italian=" Hai un'abilità tutta particolare!", spanish=" ¡Debes de tener esa capacidad!"}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" It's amazing, [hero]!", french=" C'est super, [hero]!", german="Das ist verblüffend,\n[hero]!", italian=" È fantastico, [hero]!", spanish=" ¡Es increíble, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(It would be useful if I could have visions\nwhen I wanted, but...)", french="(Ce serait pratique d'avoir des visions à\nvolonté, mais...)", german="(Es wäre nützlich, wenn ich Visionen haben\nkönnte, wann immer ich will, aber...)", italian="(Sarebbe utile se potessi avere visioni a\ncomando, ma...)", spanish="(Sería muy útil tener una visión siempre\nque quisiera, pero...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 8, 184, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 120, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey, you two!", french=" Hé, vous deux!", german=" Hey, ihr zwei!", italian=" Ehi, voi due!", spanish=" ¡Atención! Necesito que vengáis."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster wants to see\nyou right away.", french="Le Maître de la Guilde voudrait\nvous voir immédiatement.", german="Der Gildenmeister will euch\nsofort sehen.", italian="Il Capitano vi vuole\nvedere immediatamente.", spanish="El Gran Bluff quiere veros\nahora mismo."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
