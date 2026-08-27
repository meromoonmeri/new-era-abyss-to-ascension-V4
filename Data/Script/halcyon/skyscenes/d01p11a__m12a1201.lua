-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m12a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 344, 176, Direction.Left, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I see...[K]so you found our friend\nunconscious right here.", french="Je vois...[K] alors tu as trouvé\nce Pokémon ici sans connaissance.", german="Ich verstehe...[K] Du hast also\ndeinen Partner hier ohnmächtig vorgefunden.", italian="Mmm...[K] Così questo è il luogo\ndel vostro primo incontro.", spanish="Entiendo...[K] Así que encontraste\na tu camarada inconsciente en este sitio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep, this is the spot.", french=" Oui, c'est là que je l'ai trouvé.", german=" Ja, an dieser Stelle.", italian="Sì, aveva perso i sensi e si\ntrovava esattamente qui.", spanish=" Sí, fue aquí mismo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes, right here exactly.", french=" Oui, c'est là que je l'ai trouvé.", german=" Ja, genau hier.", italian="Sì, aveva perso i sensi e si\ntrovava esattamente qui.", spanish=" Sí, exactamente aquí."})
  else
  SkySceneKit.say({english=" Yes, this is the exact spot.", french=" Oui, c'est là que je l'ai trouvé.", german=" Ja, genau an dieser Stelle.", italian="Sì, aveva perso i sensi e si\ntrovava esattamente qui.", spanish=" Sí, en este punto exacto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Then you regained consciousness.", french="Ensuite, tu as repris\nconnaissance.", german="Dann bist du wieder zu\nBewusstsein gekommen.", italian=" Poi hai aperto gli occhi...", spanish="Y entonces recobraste la\nconsciencia."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Though you'd lost your memory.", french=" Mais tu avais perdu la mémoire.", german="Aber du hast dein Gedächtnis\nverloren.", italian="... ed hai scoperto di aver perso\nla memoria.", spanish="Aunque habías perdido\nla memoria."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end) -- bgm_ChangeVolume vers 0 (silence)
  -- bgm2_PlayFadeIn(BGM_TIME_GEAR_REMIX) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep. With a memory of a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. With a memory of a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  else
  SkySceneKit.say({english=" Yes. With a memory of a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  end
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...and the memory of being a\nhuman before this!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...and the memory of being a\nhuman before this!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  else
  SkySceneKit.say({english="...and the memory of being a\nhuman before this!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I beg your pardon?![K] H-human?!", french="Je vous demande pardon?![K]\nUn être humain?!", german=" Wie bitte?!?[K] Ein M-mensch?!?", italian="Che cosa hai detto?![K]\nU-Un essere umano?!", spanish="¡¿Cómo dices?![K]\n¡¿Un ser... humano?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But our friend here seems to be\na Pokémon in every obvious way!", french="Mais pourtant, on dirait bel et\nbien un Pokémon, jusqu'au bout des pattes!", german="Aber dein Partner scheint in\njeder Hinsicht ein Pokémon zu sein!", italian="Ma è impossibile! Sembra\ndavvero un Pokémon in tutto e per tutto!", spanish="¡Pero si salta a la vista que\ntu camarada es un Pokémon en todos\nlos sentidos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das stimmt...", italian=" Già...", spanish=" Eso es cierto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das stimmt...", italian=" È così...", spanish=" Eso es cierto..."})
  else
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das stimmt...", italian=" È così...", spanish=" Eso es cierto..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess this is even beyond the\ngreat [CS:N]Dusknoir[CR]'s understanding.", french="Je suppose que ça dépasse tout\nle monde, même le grand [CS:N]Noctunoir[CR].", german="Ich schätze, das kann sich nicht\neinmal der große [CS:N]Zwirrfinst[CR] erklären.", italian="A quanto pare, neanche il grande\n[CS:N]Dusknoir[CR] è in grado di aiutarci.", spanish="Supongo que esto sobrepasa\nincluso el entendimiento del gran [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess this is even beyond the\ngreat [CS:N]Dusknoir[CR]'s understanding.", french="Je suppose que ça dépasse tout\nle monde, même le grand [CS:N]Noctunoir[CR].", german="Ich schätze, das kann sich nicht\neinmal der große [CS:N]Zwirrfinst[CR] erklären.", italian="A quanto pare, neanche il grande\n[CS:N]Dusknoir[CR] è in grado di aiutarci.", spanish="Supongo que esto sobrepasa\nincluso el entendimiento del gran [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="I guess this is even beyond the\ngreat [CS:N]Dusknoir[CR]'s understanding.", french="Je suppose que ça dépasse tout\nle monde, même le grand [CS:N]Noctunoir[CR].", german="Ich schätze, das kann sich nicht\neinmal der große [CS:N]Zwirrfinst[CR] erklären.", italian="A quanto pare, neanche il grande\n[CS:N]Dusknoir[CR] è in grado di aiutarci.", spanish="Supongo que esto sobrepasa\nincluso el entendimiento del gran [CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we're sure that something\ncaused my partner's memory loss...", french="Mais son amnésie a forcément\nune cause...", german="Aber wir sind uns sicher, dass\nes irgendeinen Grund für den\nGedächtnisverlust gibt...", italian="Ma è certo che qualcosa ti ha\nfatto perdere la memoria...", spanish="Pero sin duda hay algo que\nha provocado su amnesia..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we're certain that something\ncaused my partner's memory loss...", french="Mais son amnésie a forcément\nune cause...", german="Aber wir sind uns sicher, dass\nes irgendeinen Grund für den\nGedächtnisverlust gibt...", italian="Ma è certo che qualcosa ti ha\nfatto perdere la memoria...", spanish="Pero sin duda hay algo que\nha provocado su amnesia..."})
  else
  SkySceneKit.say({english="But we're sure that something\ncaused my partner's memory loss...", french="Mais son amnésie a forcément\nune cause...", german="Aber wir sind uns sicher, dass\nes irgendeinen Grund für den\nGedächtnisverlust gibt...", italian="Ma è certo che qualcosa ti ha\nfatto perdere la memoria...", spanish="Pero sin duda hay algo que\nha provocado su amnesia..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...and caused the transformation\nfrom human to Pokémon!", french="... et sa transformation en\nPokémon aussi!", german="Und für die Verwandlung\nin ein Pokémon!", italian="... e ti ha trasformato da essere\numano in Pokémon!", spanish="¡Y que le ha convertido en\nun Pokémon!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...and caused the transformation\nfrom human to Pokémon!", french="... et sa transformation en\nPokémon aussi!", german="Und für die Verwandlung\nin ein Pokémon!", italian="... e ti ha trasformato da essere\numano in Pokémon!", spanish="¡Y que le ha convertido en\nun Pokémon!"})
  else
  SkySceneKit.say({english="...and caused the transformation\nfrom human to Pokémon!", french="... et sa transformation en\nPokémon aussi!", german="Und für die Verwandlung\nin ein Pokémon!", italian="... e ti ha trasformato da essere\numano in Pokémon!", spanish="¡Y que le ha convertido en\nun Pokémon!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="A human...[K]with the Dimensional\nScream ability...", french="Un être humain...[K] doté du Cri\nDimensionnel...", german="Ein Mensch...[K] Mit der Fähigkeit\ndes Dimensionalen Schreis...", italian="Un essere umano...[K] con il\npotere dello Squarcio Dimensionale...", spanish="Un humano...[K] que posee\nla Percepción de Cronos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You...are...?", french=" Tu... es...?", german=" Bist... du...", italian=" Tu... sei...?", spanish=" ¿Y... te llamas...?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="You said you know your name,\nat least?", french="Tu dis connaître au moins\nton nom?", german="Du sagtest, dass du zumindest\ndeinen Namen weißt, oder?", italian="Mi hai detto che almeno il tuo\nnome lo ricordi, giusto?", spanish="Todavía recuerdas tu nombre,\n¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" And...[K]that name would be...?", french="Et peut-on savoir...[K] quel est\nce nom...?", german=" Und...[K] Wie lautet dein Name?", italian=" E...[K] quel nome è...?", spanish=" Dime...[K] ¿Cómo te llamas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN][hero] told the\n[CN]name to [CS:N]Dusknoir[CR].", french="[CN][hero] dit son nom\n[CN]à [CS:N]Noctunoir[CR].", german="[CN][hero] nennt [CS:N]Zwirrfinst[CR]\n[CN]den Namen.", italian="[CN][hero] dice il suo nome a\n[CN][CS:N]Dusknoir[CR].", spanish="[CN][hero] le dijo su nombre\n[CN]a [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ah! I see...", french=" Ah, je vois...", german=" Ah! Ich verstehe...", italian=" Oh...", spanish=" Así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You're...[K][hero]...", french=" ... tu t'appelles [hero]...", german=" Du bist...[K] [hero]...", italian=" ... [hero]...", spanish=" [hero]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm2
  -- bgm_ChangeVolume(90,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Does that name ring a bell?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir dieser Name was?", italian=" Le dice niente questo nome?", spanish=" ¿Te suena de algo ese nombre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Does that name mean anything\nto you?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir dieser Name etwas?", italian=" Ha già sentito questo nome?", spanish=" ¿Te dice algo ese nombre?"})
  else
  SkySceneKit.say({english=" Does that name ring a bell?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir der Name irgendwas?", italian=" Ha già sentito questo nome?", spanish=" ¿Te suena de algo ese nombre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...[K]No.", french=" ...[K] Non.", german=" ...[K]Nein.", italian=" ...[K] No.", spanish=" ¿Eh?[K] No."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It means nothing to me,\nunfortunately.", french="Il ne m'évoque rien du tout,\nhélas.", german=" Leider sagt er mir nichts.", italian="Sfortunatamente... non ho mai\nsentito questo nome prima d'ora.", spanish="Por desgracia, no lo había oído\nen mi vida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Uh, what?!)", french="(Hein, quoi?!)", german="(Wie? Was?!?)", italian="(Mmm... Cos'è stato?)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(Uh, what?!)", french="(Hein, quoi?!)", german="(Wie? Was?!?)", italian="(Mmm... Cos'è stato?)", spanish="(¡¿Qué?!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Did I just see...[K]the faintest...)", french="(Est-ce que j'ai bien vu...[K] l'esquisse...)", german="(War das gerade...[K] der Anflug eines...)", italian="(Per un attimo...[K] mi è sembrato...)", spanish="(Me parece...[K] que...)"})
  else
  SkySceneKit.say({english="(Did I just see...[K]the faintest...)", french="(Est-ce que j'ai bien vu...[K] l'esquisse...)", german="(War das gerade...[K] der Anflug eines...)", italian="(Per un attimo...[K] mi è sembrato...)", spanish="(Me parece...[K] que...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Did [CS:N]Dusknoir[CR] just hide the faintest of\nsmiles?)", french="([CS:N]Noctunoir[CR] viendrait-il de réprimer l'esquisse\nd'un sourire?)", german="(Hat [CS:N]Zwirrfinst[CR] nicht gerade\nein Lächeln unterdrückt?)", italian="([CS:N]Dusknoir[CR] stava sorridendo?)", spanish="(Me ha parecido ver a [CS:N]Dusknoir[CR] esbozar una\nsonrisa...)"})
  else
  SkySceneKit.say({english="(Did [CS:N]Dusknoir[CR] just hide the faintest of\nsmiles?)", french="([CS:N]Noctunoir[CR] viendrait-il de réprimer l'esquisse\nd'un sourire?)", german="(Hat [CS:N]Zwirrfinst[CR] nicht gerade\nein Lächeln unterdrückt?)", italian="([CS:N]Dusknoir[CR] stava sorridendo?)", spanish="(Me ha parecido ver a [CS:N]Dusknoir[CR] esbozar una\nsonrisa...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Or did I imagine that...?)", french="(Ou c'était juste mon imagination...?)", german="(Oder habe ich mir das eingebildet?)", italian="(L'ho solo immaginato...?)", spanish="(¿O serán imaginaciones mías?)"})
  else
  SkySceneKit.say({english="(Or did I imagine that...?)", french="(Ou c'était juste mon imagination...?)", german="(Oder habe ich mir das eingebildet?)", italian="(L'ho solo immaginato...?)", spanish="(¿O serán imaginaciones mías?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm sincerely sorry I couldn't\nhelp you with that...", french="Je suis sincèrement désolé de\nne pouvoir vous aider davantage...", german="Es tut mir wirklich leid, dass ich\neuch nicht weiterhelfen kann.", italian="Sono desolato... Non sono stato\ndi nessun aiuto...", spanish="Lamento profundamente no poder\nayudaros con esto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" However...", french=" Cependant...", german=" Aber...", italian=" Tuttavia...", spanish=" Sin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I do know about the ability that\n[hero] possesses.", french="Je connais cette faculté\nspéciale que détient [hero].", german="Ich weiß über die Fähigkeit von\n[hero] Bescheid.", italian="So qualcosa del potere\ndi [hero].", spanish="Sí que conozco la habilidad que\nposee [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿Sí?! ¡¿De qué se trata?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Oh, wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿En serio?! ¡¿De qué se trata?!"})
  else
  SkySceneKit.say({english=" Oh, really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Oh, wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿Sí?! ¡¿De qué se trata?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The ability to see the future or\nthe past by touching something...", french="La faculté de voir le futur ou\nle passé en touchant quelque chose...", german="Die Fähigkeit, in die Zukunft\noder die Vergangenheit zu blicken, indem man\netwas berührt...", italian="Il potere di vedere nel passato o\nnel futuro...", spanish="La capacidad de ver el futuro\no el pasado mediante el tacto..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That ability is known as the\nDimensional Scream.", french="... porte un nom: le Cri\nDimensionnel.", german="Diese Fähigkeit nennt sich\nDimensionaler Schrei.", italian="... viene chiamato Squarcio\nDimensionale.", spanish="Es una habilidad conocida como\nla Percepción de Cronos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Dimensional...[K]Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Dimensional...[K]Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  else
  SkySceneKit.say({english=" Dimensional...[K]Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Indeed.", french=" Exact.", german=" Genau.", italian=" Precisamente.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="How such an ability is learned,\nthat is unknown.", french="Nul ne sait comment\non l'acquiert.", german="Woher solch eine Fähigkeit\nkommt, ist nicht bekannt.", italian="Come si possa acquisire questo\npotere è ancora sconosciuto.", spanish="Nadie sabe cómo se adquiere\ndicha habilidad."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But sounds and images slice\nacross the boundaries of time, breaching\nobjects and reaching into Pokémon...", french="Mais des sons et des images\ntraversent les frontières du temps et sont\ntransmis à des Pokémon via certains objets...", german="Doch Geräusche und Bilder\nreichen über Zeit und Raum hinweg bis\nin manche Pokémon...", italian="Quello che so è che i suoni e le\nimmagini attraversano i confini del tempo e\ndello spazio, raggiungono i Pokémon...", spanish="Un torrente de imágenes y\nsonidos atraviesa las barreras del tiempo, y\npueden pasar de los objetos a un Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" To manifest as visions...", french=" ... sous forme de visions.", german="Um als Visionen Gestalt\nanzunehmen.", italian=" ... e diventano visioni...", spanish=" Manifestándose como visiones..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And that is all that I know about\nthe extraordinary ability.", french="Voilà tout ce que je sais au sujet\nde ce pouvoir extraordinaire.", german="Das ist alles, was ich über diese\naußergewöhnliche Fähigkeit weiß.", italian="È tutto quel che so su questo\npotere straordinario.", spanish="Eso es todo lo que sé sobre\nesta extraordinaria habilidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="[hero] possiede lo\nSquarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="E così, [hero] ha il dono\ndello Squarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  else
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="E così, [hero] ha il dono\ndello Squarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Well, perhaps this is why we\nbecame friends.", french="Ma foi, c'est peut-être pour\ncela que nous nous sommes liés d'amitié.", german="Nun ja, vielleicht sind wir\naus diesem Grund Freunde geworden.", italian="Beh... Forse è questo il motivo\nper cui ci siamo incontrati.", spanish="Bueno, quizás por eso somos\namigos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="To help unravel the secret of\n[hero]'s transformation into a Pokémon!", french="Afin de percer le mystère\nde la métamorphose de [hero]\nen Pokémon!", german="Um das Geheimnis um die\nVerwandlung von [hero] in ein Pokémon\nzu lüften!", italian="Per svelare il mistero della\ntrasformazione di [hero] in Pokémon!", spanish="¡Para poder descubrir el secreto\nde la transformación en Pokémon de\n[hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I offer you my full cooperation!", french="Permettez-moi de vous offrir\nmon entière collaboration!", german="Ich biete euch meine volle\nZusammenarbeit an!", italian="Vi offro la mia completa\ncollaborazione!", spanish=" Os ayudaré todo lo que pueda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! Wirklich?!?", italian=" Oh! Davvero?", spanish=" ¡¿De verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! Wirklich?!?", italian=" Oh! Dice sul serio?", spanish=" ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! Wirklich?!?", italian=" Oh! Dice sul serio?", spanish=" ¡¿De verdad?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes. To be perfectly candid...", french="Certes. Pour être tout à fait\nfranc...", german=" Ja. Um offen zu sein...", italian="Certamente. Devo essere sincero\ncon voi...", spanish=" Sí. Para serte muy sincero..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I can't stand knowing that\nthere's something I don't know!", french="... je ne tolère point de savoir\nque quelque chose m'échappe!", german="Ich kann es nicht ertragen, wenn\nich etwas nicht weiß!", italian="Non sopporto quando scopro\ndi non sapere qualcosa!", spanish="¡No soporto saber que hay algo\nque desconozco!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Quite honestly, that is the full\ntruth of it!", french="Voilà la pure vérité, je le\nconfesse...", german="Ernsthaft, das ist die reine\nWahrheit!", italian=" Ecco, l'ho detto.", spanish=" Esa es la verdad."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ha-ha-ha! Hoo-hoo-ha!", french=" Ha ha ha! Ho ho ha!", german=" Baaahahahaha!", italian=" Uh-ah-ah-ah!", spanish=" ¡Ja, ja, ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's great to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist toll zu wissen, dass wir\nauf deine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Wow! È davvero fantastico\nsapere che possiamo contare su di lei, signor\n[CS:N]Dusknoir[CR]!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's thrilling to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist großartig, dass wir auf\ndeine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Sapere che possiamo contare su\ndi lei, signor [CS:N]Dusknoir[CR], ci è di grande conforto!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english="It's reassuring to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist beruhigend, dass wir\nauf deine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Sapere che possiamo contare su\ndi lei, signor [CS:N]Dusknoir[CR], ci è di grande conforto!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Isn't this awesome,\n[hero]?", french="C'est pas formidable,\n[hero]?", german="Ist das nicht super,\n[hero]?", italian=" Non è fantastico, [hero]?", spanish=" ¿No es increíble, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Isn't this great, [hero]?", french="C'est pas formidable,\n[hero]?", german=" Ist das nicht toll, [hero]?", italian=" Non è fantastico, [hero]?", spanish="¿No te parece genial,\n[hero]?"})
  else
  SkySceneKit.say({english=" Isn't this great, [hero]?", french="C'est pas formidable,\n[hero]?", german=" Ist das nicht toll, [hero]?", italian=" Non è fantastico, [hero]?", spanish="¿No te parece genial,\n[hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6662) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LAPRAS_WATER_SHADOW — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-400), g.ViewCenter.Y+(0), 67, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  -- GAP: se_Play(6662) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LAPRAS_WATER_SHADOW — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-400), g.ViewCenter.Y+(0), 67, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(73) [anim idle native]
  -- SetAnimation(73) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  else
  SkySceneKit.say({english=" Hey! Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V12P01A) [décor sub chargé: Sub_v12p01a]
  -- back2_SetEffect(7, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- SetOutputAttribute(2048) [neutre/état moteur]
  -- Move2PositionOffset<object OBJECT_V12P01A1_244> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A2_245> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A3_246> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A4_247> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A5_248> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A6_249> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A7_250> [prop décor NDS, géré par le rendu du ground]
  -- Move2PositionOffset<object OBJECT_V12P01A8_251> [prop décor NDS, géré par le rendu du ground]
  SkySubScreen.Show("v12p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(3)
  -- camera2_SetPositionMark(Position<'m1', 58.5, 16>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(3)
  -- camera2_SetPositionMark(Position<'m2', 97.5, 16>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(3)
  -- camera2_SetPositionMark(Position<'m3', 136.5, 16>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(120)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetGround(V01P03A) [décor sub chargé: Sub_v01p03a]
  -- camera2_SetPositionMark(Position<'m4', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(30)
  SkySubScreen.Show("v01p03a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There seems to be a lot more\nflying around than usual...", french="On dirait qu'il y en a bien plus\nque d'habitude...", german="Es scheinen viel mehr als\nnormalerweise unterwegs zu sein...", italian=" Ce ne sono molti più del solito...", spanish=" Hay muchos más de lo normal."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There appears to be a lot more\nin the air than usual...", french="On dirait qu'il y en a bien plus\nque d'habitude...", german="Es scheinen viel mehr als\nnormalerweise in der Luft zu sein...", italian=" Ce ne sono molti più del solito...", spanish=" Hay muchos más de lo normal."})
  else
  SkySceneKit.say({english="There seems to be a lot more\nflying than usual...", french="On dirait qu'il y en a bien plus\nque d'habitude...", german="Es scheinen viel mehr als\nnormalerweise unterwegs zu sein...", italian=" Ce ne sono molti più del solito...", spanish=" Hay muchos más de lo normal."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Could something be the matter?", french="Se pourrait-il qu'il y ait\nun problème?", german=" Ob irgendwas passiert ist?", italian=" Quale sarà la ragione?", spanish=" Puede que haya algún problema."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 536, 192, Direction.Left, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end) -- message_SetActor(ACTOR_NPC_BIPPA)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(400, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 432, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hi, [CS:N]Bidoof[CR]!", french=" Salut, [CS:N]Keunotor[CR]!", german=" Hi, [CS:N]Bidiza[CR]!", italian=" Ehilà, [CS:N]Bidoof[CR]!", spanish=" Hola, [CS:N]Bidoof[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hello, [CS:N]Bidoof[CR]!", french=" Salut, [CS:N]Keunotor[CR]!", german=" Hallo, [CS:N]Bidiza[CR]!", italian=" Buongiorno, [CS:N]Bidoof[CR]!", spanish=" Hola, [CS:N]Bidoof[CR]."})
  else
  SkySceneKit.say({english=" Oh, hello, [CS:N]Bidoof[CR]!", french=" Salut, [CS:N]Keunotor[CR]!", german=" Oh, hallo, [CS:N]Bidiza[CR]!", italian=" Buongiorno, [CS:N]Bidoof[CR]!", spanish=" Ah, hola, [CS:N]Bidoof[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I f-finally...f-found you all...", french="Pff, pff! Enfin... vous v'là,\npff pff...", german=" E-endlich... f-finde ich euch...", italian="F-F-Finalmente vi ho...\nt-t-trovato...", spanish=" Por... Por fin os encuentro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's the big rush? You're all\nout of breath!", french="Il y a urgence? Tu es tout\nessoufflé!", german="Was soll die Eile? Du bist\nganz außer Atem!", italian="Come mai tanta fretta? Mi\nsembri un po' a corto di fiato!", spanish="¿Por qué tanta prisa?\n¡Estás sin aliento!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the big hurry? You're all\nout of breath!", french="Il y a urgence? Tu es tout\nessoufflé!", german="Wieso bist du so in Eile? Du bist\nganz außer Atem!", italian="Come mai tanta fretta? Mi\nsembri un po' a corto di fiato!", spanish="¿Por qué tanta prisa?\n¡Respira, hombre!"})
  else
  SkySceneKit.say({english="What's the hurry? You're all\nout of breath!", french="Il y a urgence? Tu es tout\nessoufflé!", german="Wieso die Eile? Du bist\nganz außer Atem!", italian="Come mai tanta fretta? Mi\nsembri un po' a corto di fiato!", spanish="¿Por qué tanta prisa?\n¡Respira, hombre!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" The call has been put out!", french=" On bat l'rappel!", german=" Alle sollen zur Gilde kommen!", italian=" Siamo stati convocati!", spanish=" ¡Hay una reunión importante!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="All the apprentices are to report\nto the guild immediately!", french="Tous les apprentis, ils doivent\nrentrer à la Guilde illico!", german="Alle Lehrlinge sollen sich sofort\nbei der Gilde melden!", italian="Tutti i membri della Gilda devono\nrientrare in sede immediatamente!", spanish="Todos los aprendices tenemos\nque presentarnos en el [CS:N]Pokégremio[CR] de\ninmediato."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, no. Something is up!", french="Oh, non. Il se passe quelque\nchose!", german=" Oh nein. Es ist etwas passiert!", italian="Oh, no! Dev'essere successo\nqualcosa!", spanish=" Me temo que pasa algo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh-oh. Something is up!", french="Oh, non. Il se passe quelque\nchose!", german=" Oh-oh. Es ist etwas passiert!", italian=" Oh, no! Cosa sarà successo?", spanish=" Me temo que pasa algo."})
  else
  SkySceneKit.say({english=" Uh-oh. Something is up!", french="Oh, non. Il se passe quelque\nchose!", german=" Oh-oh. Es ist etwas passiert!", italian=" Oh, no! Cosa sarà successo?", spanish=" Me temo que pasa algo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I will go with you!", french=" Je vous accompagne!", german=" Ich gehe mit euch!", italian=" Vengo con voi!", spanish=" Voy con vosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Hurry, everyone!", french=" Allez vite, vous autres!", german=" Beeilt euch!", italian=" Sbrighiamoci!", spanish=" ¡Démonos prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(200), p.Y+(0), false, 2) end
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(200), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkyProg.set(14, 0) -- $SCENARIO_MAIN = scn[14,0] (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
