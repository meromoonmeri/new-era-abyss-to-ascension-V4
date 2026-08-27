-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It happened again!)", french="(Ça recommence!)", german="(Es ist wieder passiert!)", italian="(Sta succedendo di nuovo!)", spanish="(¡Está volviendo a pasar!)"})
  else
  SkySceneKit.say({english="(It happened again!)", french="(Ça recommence!)", german="(Es ist wieder passiert!)", italian="(Sta succedendo di nuovo!)", spanish="(¡Está volviendo a pasar!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I saw something...)", french="(J'ai vu quelque chose...)", german="(Ich habe etwas gesehen...)", italian="(Ho visto qualcosa...)", spanish="(He vuelto a ver algo.)"})
  else
  SkySceneKit.say({english="(I saw something...)", french="(J'ai vu quelque chose...)", german="(Ich habe etwas gesehen...)", italian="(Ho visto qualcosa...)", spanish="(He vuelto a ver algo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But what did I just see?)", french="(Mais qu'est-ce que c'était?)", german="(Aber was habe ich gesehen?)", italian="(Ma cos'era?)", spanish="(¿Pero de qué se trata?)"})
  else
  SkySceneKit.say({english="(But what did I just see?)", french="(Mais qu'est-ce que c'était?)", german="(Aber was habe ich gesehen?)", italian="(Ma cos'era?)", spanish="(¿Pero de qué se trata?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's up, [hero]?", french="Hé? Qu'y a-t-il,\n[hero]?", german=" Huch? Was ist, [hero]?", italian="Eh? Cosa succede,\n[hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? What's the matter,\n[hero]?", french="Hé? Qu'y a-t-il,\n[hero]?", german=" Huch? Was ist, [hero]?", italian="Eh? Cosa succede,\n[hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english="Oh? What's the matter,\n[hero]?", french="Hé? Qu'y a-t-il,\n[hero]?", german="Huch? Was ist denn los,\n[hero]?", italian="Eh? Cosa succede,\n[hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! You had another vision?", french="Quoi?! Tu as eu une nouvelle\nvision?", german="Was?!? Du hattest noch eine\nVision?", italian="Cosa?! Hai avuto un'altra\nvisione?", spanish="¡¿Cómo?! ¿Has tenido otra\nvisión?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! You had another vision?", french="Quoi?! Tu as eu une nouvelle\nvision?", german="Was?!? Du hattest noch eine\nVision?", italian="Cosa?! Hai avuto un'altra\nvisione?", spanish="¡¿Cómo?! ¿Has tenido otra\nvisión?"})
  else
  SkySceneKit.say({english=" What?! You had another vision?", french="Quoi?! Tu as eu une nouvelle\nvision?", german="Was?!? Du hattest noch eine\nVision?", italian="Cosa?! Hai avuto un'altra\nvisione?", spanish="¡¿Cómo?! ¿Has tenido otra\nvisión?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this time, you saw a lone\nPokémon leap into this waterfall?!", french="Et cette fois, tu as vu un\nPokémon sauter à travers la cascade?!", german="Aber diesmal hast du ein\neinzelnes Pokémon in diesen Wasserfall\nspringen sehen?!?", italian="Ma questa volta hai visto un\nPokémon saltare in questa cascata?!", spanish="Así que esta vez has visto a un\nPokémon saltar a la cascada..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This time, you saw a lone\nPokémon leap into this waterfall?!", french="Et cette fois, tu as vu un\nPokémon sauter à travers la cascade?!", german="Diesmal hast du ein einzelnes\nPokémon in diesen Wasserfall springen\nsehen?!?", italian="Ma questa volta hai visto un\nPokémon saltare in questa cascata?!", spanish="Así que esta vez has visto a un\nPokémon saltar a la cascada..."})
  else
  SkySceneKit.say({english="This time, a Pokémon leaped\ninto this waterfall?! You saw that?!", french="Et cette fois, tu as vu un\nPokémon sauter à travers la cascade?!", german="Diesmal ist ein einzelnes\nPokémon in diesen Wasserfall gesprungen?!?\nDas hast du gesehen?!?", italian="Ma questa volta hai visto un\nPokémon saltare in questa cascata?!", spanish="Así que esta vez has visto a un\nPokémon saltar a la cascada..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And not only that...", french=" Ce n'est pas tout...", german=" Und nicht nur das...", italian=" E non è tutto...", spanish=" Y a continuación creíste ver..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And not only that...", french=" Ce n'est pas tout...", german=" Und nicht nur das...", italian=" E non è tutto...", spanish=" Y a continuación creíste ver..."})
  else
  SkySceneKit.say({english=" And not only that...", french=" Ce n'est pas tout...", german=" Und nicht nur das...", italian=" E non è tutto...", spanish=" Y a continuación creíste ver..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's a hidden cave behind the\nwaterfall?!", french="... tu dis qu'il y a une grotte\ncachée derrière la cascade?!", german="Hinter dem Wasserfall ist eine\nverborgene Höhle?!?", italian="C'è una caverna nascosta dietro\nla cascata?!", spanish="¡¿Que hay una cueva oculta\ntras la cascada?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's a hidden cave behind the\nwaterfall?!", french="... tu dis qu'il y a une grotte\ncachée derrière la cascade?!", german="Hinter dem Wasserfall ist eine\nverborgene Höhle?!?", italian="C'è una caverna nascosta dietro\nla cascata?!", spanish="¡¿Que hay una cueva oculta\ntras la cascada?!"})
  else
  SkySceneKit.say({english="There's a hidden cave behind the\nwaterfall?!", french="... tu dis qu'il y a une grotte\ncachée derrière la cascade?!", german="Hinter dem Wasserfall ist eine\nverborgene Höhle?!?", italian="C'è una caverna nascosta dietro\nla cascata?!", spanish="¡¿Que hay una cueva oculta\ntras la cascada?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it looks like that water is\ncoming down really hard.", french="Mais le courant a l'air tellement\npuissant...", german="Aber das Wasser scheint\nwirklich mit einer Riesenwucht\nherunterzukommen.", italian="Ma l'acqua sembra scendere\ndavvero forte.", spanish="El problema es que el agua\ncae con demasiada fuerza."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it looks like that water is\ncoming down really heavily.", french="Mais le courant a l'air tellement\npuissant...", german="Aber das Wasser scheint\nwirklich mit einer großen Wucht\nherunterzukommen.", italian="Ma l'acqua sembra scendere\ndavvero forte.", spanish="El problema es que el agua\ncae con demasiada fuerza."})
  else
  SkySceneKit.say({english="But it looks like that water is\ncrashing down really hard.", french="Mais le courant a l'air tellement\npuissant...", german="Aber das Wasser scheint\nwirklich mit einer großen Wucht\nherunterzukrachen.", italian="Ma l'acqua sembra scendere\ndavvero forte.", spanish="El problema es que el agua\ncae con demasiada fuerza."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Imagine if there was actually a\nsolid cliff wall behind that waterfall!", french="Et si jamais la cascade ne cache\nen fait qu'une paroi rocheuse!", german="Stell dir vor, hinter dem\nWasserfall wäre in Wirklichkeit eine\nharte Felswand!", italian="E se in realtà ci fosse una\nparete di roccia dietro la cascata?", spanish="¡Imagínate lo que pasaría\nsi detrás solo hubiera rocas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Imagine if there was actually a\nsolid cliff wall behind that waterfall!", french="Et si jamais la cascade ne cache\nen fait qu'une paroi rocheuse!", german="Stell dir vor, hinter dem\nWasserfall wäre in Wirklichkeit eine\nharte Felswand!", italian="Pensa se in realtà ci fosse una\nparete di roccia dietro la cascata!", spanish="¡Imagínate lo que pasaría\nsi detrás solo hubiera rocas!"})
  else
  SkySceneKit.say({english="Imagine if there was actually a\nsolid cliff wall behind that waterfall!", french="Et si jamais la cascade ne cache\nen fait qu'une paroi rocheuse!", german="Stell dir vor, hinter dem\nWasserfall wäre in Wirklichkeit eine\nharte Felswand!", italian="Dietro la cascata potrebbe\nesserci una parete di roccia, non ci\npensi?", spanish="¡Imagínate lo que pasaría\nsi detrás solo hubiera rocas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ouch!", french=" Ouille!", german=" Autsch!", italian=" Ahia!", spanish=" ¡Ay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ouch!", french=" Ouille!", german=" Autsch!", italian=" Ahia!", spanish=" ¡Ay!"})
  else
  SkySceneKit.say({english=" Yeesh...", french=" Ouille!", german=" Auweia...", italian=" Ahia!", spanish=" ¡Ay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If we tried to jump through...", french="Si on essaie de sauter à\ntravers...", german="Wenn wir versuchen würden,\ndurchzuspringen...", italian=" Se provassimo a saltare...", spanish=" Si intentásemos saltar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If we tried to jump through...", french="Si on essaie de sauter à\ntravers...", german="Wenn wir versuchen würden,\ndurchzuspringen...", italian=" Se provassimo a saltare...", spanish=" Si intentásemos saltar..."})
  else
  SkySceneKit.say({english=" If we tried to jump through...", french="Si on essaie de sauter à\ntravers...", german="Wenn wir versuchen würden,\ndurchzuspringen...", italian=" Se provassimo a saltare...", spanish=" Si intentásemos saltar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'd be pounded badly!", french="... on va se faire assommer par\ncette trombe d'eau!", german="Dann würden wir ziemlich hart\naufschlagen!", italian="Potremmo farci molto, ma molto\nmale!", spanish="¡Nos podríamos llevar\nun buen tortazo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'd be pounded badly!", french="... on va se faire assommer par\ncette trombe d'eau!", german="Dann würden wir ziemlich hart\naufschlagen!", italian=" Potremmo farci male!", spanish="¡Nos podríamos llevar\nun buen tortazo!"})
  else
  SkySceneKit.say({english=" We'd be pounded badly!", french="... on va se faire assommer par\ncette trombe d'eau!", german="Dann würden wir ziemlich hart\naufschlagen!", italian="Potremmo farci veramente\nmale!", spanish="¡Nos podríamos llevar\nun buen tortazo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So [hero]...", french=" [hero]...", german=" Also, [hero]...", italian=" Quindi, [hero]...", spanish=" Entonces, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So [hero]...", french=" [hero]...", german=" Also, [hero]...", italian=" Quindi, [hero]...", spanish=" Entonces, [hero]..."})
  else
  SkySceneKit.say({english=" So [hero]...", french=" [hero]...", german=" Also, [hero]...", italian=" Quindi, [hero]...", spanish=" Entonces, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you think,\n[hero]?", french=" Tu en penses quoi?", german=" Was denkst du, [hero]?", italian="Cosa dici,\n[hero]?", spanish="¿Qué crees que deberíamos\nhacer, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What do you think,\n[hero]?", french=" Tu en penses quoi?", german=" Was denkst du, [hero]?", italian="Cosa ne pensi,\n[hero]?", spanish="¿Qué crees que deberíamos\nhacer, [hero]?"})
  else
  SkySceneKit.say({english="What do you think,\n[hero]?", french=" Tu en penses quoi?", german=" Was denkst du, [hero]?", italian="Cosa credi,\n[hero]?", spanish="¿Qué crees que deberíamos\nhacer, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is there really something behind\nthis waterfall?", french="Il y a vraiment quelque chose\nderrière cette cascade?", german="Ist da wirklich etwas hinter dem\nWasserfall?", italian="C'è davvero qualcosa dietro\nquesta cascata?", spanish="¿Habrá algo detrás de la\ncascada?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is there really something behind\nthis waterfall?", french="Il y a vraiment quelque chose\nderrière cette cascade?", german="Ist da wirklich etwas hinter dem\nWasserfall?", italian="C'è davvero qualcosa dietro\nquesta cascata?", spanish="¿Habrá algo detrás de la\ncascada?"})
  else
  SkySceneKit.say({english="Is there really something behind\nthis waterfall?", french="Il y a vraiment quelque chose\nderrière cette cascade?", german="Ist da wirklich etwas hinter dem\nWasserfall?", italian="C'è davvero qualcosa dietro\nquesta cascata?", spanish="¿Habrá algo detrás de la\ncascada?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you really think there's a\ncave there?", french="Tu crois vraiment qu'il y a une\ngrotte?", german="Glaubst du wirklich, dass da eine\nHöhle ist?", italian="Pensi davvero che ci sia una\ncaverna lì dietro?", spanish="¿Crees que realmente puede\nhaber una cueva?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you really convinced that\nthere is a cave there?", french="Tu crois vraiment qu'il y a une\ngrotte?", german="Bist du wirklich überzeugt, dass\nda eine Höhle ist?", italian="Pensi davvero che ci sia una\ncaverna lì dietro?", spanish="¿Crees que realmente puede\nhaber una cueva?"})
  else
  SkySceneKit.say({english="You're sure that there really is\na cave there?", french="Tu crois vraiment qu'il y a une\ngrotte?", german="Bist du sicher, dass da wirklich\neine Höhle ist?", italian="Pensi davvero che ci sia una\ncaverna lì dietro?", spanish="¿Crees que realmente puede\nhaber una cueva?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well... All right.", french=" Bon... d'accord.", german=" Nun... Okay.", italian=" Beh... Va bene.", spanish=" Bueno... De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well... OK.", french=" Bon... d'accord.", german=" Nun... In Ordnung.", italian=" Beh... Va bene.", spanish=" Bueno... Vale."})
  else
  SkySceneKit.say({english=" Well... OK.", french=" Bon... d'accord.", german=" Nun... In Ordnung.", italian=" Beh... Va bene.", spanish=" Bueno... De acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to believe you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich glaube dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Me fiaré de ti, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm putting my faith in you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich vertraue dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Confiaré en ti, [hero]!"})
  else
  SkySceneKit.say({english="I'm going to believe you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich glaube dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Confiaré en ti, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero]!", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero].", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  else
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero]!", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 40, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(40), false, 2) end
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(40), false, 2) end
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yikes!", french=" Oh là là...", german=" Oh Mann!", italian=" Iiiiiiiiiih!", spanish=" ¡Síiii!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yikes!", french=" Oh là là...", german=" Oh Mann!", italian=" Iiiiiiiiiih!", spanish=" ¡Ayyy!"})
  else
  SkySceneKit.say({english=" Eek!", french=" Oh là là...", german=" Ieeek!", italian=" Iiiiiiiiiih!", spanish=" ¡Ayyy!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, I gotta be brave now!", french=" Il faut que je sois courageux!", german=" Okay, ich muss jetzt tapfer sein!", italian=" Ok, devo farmi coraggio adesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, I gotta be brave now!", french=" Il faut que je sois courageux!", german=" Okay, ich muss jetzt tapfer sein!", italian=" Ok, devo avere coraggio adesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  else
  SkySceneKit.say({english=" OK, I gotta be brave now!", french="Il faut que je prenne mon\ncourage à deux mains!", german=" Okay, ich muss jetzt tapfer sein!", italian="Ok, devo essere coraggiosa\nadesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se ho troppa paura e non salto\na tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se mi faccio prendere dalla\npaura e non salto a tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  else
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se sono troppo spaventata e\nnon salto a tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciato qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar hecho fosfatina!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciato qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar hecho fosfatina!"})
  else
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciata qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar muy mal!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If I'm going for it, I have to go\nfor it without any hesitation.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, dann darf ich\nnicht zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If I'm doing it, I have to do it\nwithout hesitating.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, dann darf ich\nkein bisschen zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  else
  SkySceneKit.say({english="If I'm going for it, it has to be\nwithout any hesitation.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, darf ich dabei\nkein bisschen zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I need to...[K]summon my courage!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Ich muss[K] meinen ganzen Mut\nzusammennehmen!", italian=" Devo...[K] farmi coraggio!", spanish=" Necesito...[K] ¡armarme de valor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Be brave...[K] Be the bravest ever!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Sei tapfer...[K] Sei so tapfer wie\nnoch nie!", italian="Sii coraggioso...[K] Sii il più\ncoraggioso di tutti!", spanish="Debo ser valiente...[K]\n¡El más valiente!"})
  else
  SkySceneKit.say({english=" Be brave...[K] Use all your courage!", french=" Il faut que...[K] je sois courageuse!", german="Sei tapfer...[K] Nimm all deinen\nMumm zusammen!", italian="Sii coraggiosa...[K] Sii la più\ncoraggiosa di tutti!", spanish="Debo ser valiente...[K]\n¡Tengo que echarle coraje!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready! Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig! Los, [hero]!", italian="Sono pronto! Andiamo,\n[hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ready! Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig! Los, [hero]!", italian="Sono pronto! Andiamo,\n[hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  else
  SkySceneKit.say({english=" Ready! Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig! Los, [hero]!", italian="Sono pronta! Andiamo,\n[hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  else
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  end
  -- message_Close
  -- Move2PositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  GROUND:MoveToPosition(hero, 268, 196, false, 2)
  GROUND:MoveToPosition(partner, 236, 196, false, 2)
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 164, false, 2)
  GROUND:MoveToPosition(partner, 236, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6675) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Waaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeIn(0)
  GAME:WaitFrames(90)
end
