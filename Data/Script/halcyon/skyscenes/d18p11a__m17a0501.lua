-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D18P11A/m17a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(60)
  SkySceneKit.say({english=" Say, [CS:N]Grovyle[CR]. I'm dead tired.", french="Ecoute, [CS:N]Massko[CR].\nJe n'en peux plus.", german=" Hey, [CS:N]Reptain[CR]. Ich bin erschöpft.", italian="Senti [CS:N]Grovyle[CR]. Sono stanca\nmorta!", spanish=" Oye, [CS:N]Grovyle[CR]... Estoy rendida."}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 120, 200, Direction.Right, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" There's no time to rest!", french=" Pas le temps de se reposer!", german="Wir haben keine Zeit, uns\nauszuruhen!", italian=" Non c'è tempo per riposarsi!", spanish=" ¡No hay tiempo para descansar!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If they catch us, we're done![K]\nTough it out and run!", french="S'ils nous rattrapent, on est\ncuits![K] Alors tiens bon et cours!", german="Wenn sie uns kriegen, sind wir\ndran![K] Haltet durch und lauft!", italian="Se ci prendono, siamo\nspacciati![K] Tenete duro e correte!", spanish="¡Si nos cogen, estamos acabados![K]\n¡Hay que seguir como sea!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" I can't.[K] I have to rest.", french="Je n'en peux plus.[K] Il faut que\nje récupère.", german="Ich kann nicht mehr.[K] Ich muss\nmich ausruhen.", italian="Non ce la faccio.[K] Mi devo\nriposare un attimo.", spanish=" No puedo.[K] Tengo que descansar."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" All right.", french=" Bon, d'accord.", german=" In Ordnung.", italian=" Va bene.", spanish=" De acuerdo."})
  -- message_Close
  -- back_SetGround(LEVEL_D18P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(npc_npc_juputoru, 312, 196, false, 2)
  GROUND:MoveToPosition(hero, 280, 212, false, 2)
  GROUND:MoveToPosition(partner, 264, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 336, 176, false, 2)
  GROUND:MoveToPosition(hero, 312, 156, false, 2)
  GROUND:MoveToPosition(partner, 280, 180, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This forms a natural alcove.", french="Là, il y a un renfoncement dans\nla paroi.", german="Hier ist eine natürliche\nAushöhlung.", italian=" Qui c'è un riparo naturale.", spanish=" Aquí hay un hueco en la roca."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This should shield us from view.", french=" On y sera à l'abri des regards.", german="Das sollte uns vor ihren Blicken\nschützen.", italian=" Non dovrebbero vederci.", spanish=" Dentro no nos verán."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="After a quick rest, we'll have to\nget moving again.", french="On fait une courte pause, et\naprès il faudra repartir.", german="Wenn wir uns kurz ausgeruht\nhaben, sollten wir uns wieder auf die Beine\nmachen.", italian="Dopo un breve riposo, dovremo\nrimetterci in marcia.", spanish=" Descansaremos un instante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="A bad Pokémon like you...[K]\nI can't trust you.", french="Un méchant Pokémon comme\ntoi...[K] Je ne suis pas près de te faire confiance.", german="Einem bösen Pokémon wie dir[K]\nwerde ich auf keinen Fall über den Weg trauen.", italian="Sei un Pokémon cattivo...[K] Non\nmi fido di te.", spanish="Eres un Pokémon perverso...[K]\nNo pienso confiar en ti."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"}) -- SwitchMonologue: branche default
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph!", french=" Pfff!", german=" Hrmpf!", italian=" Bah!", spanish=" ¡Vaya...!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So I'm the bad guy...[K] And that\n[CS:N]Dusknoir[CR] is the good guy?", french="Alors comme ça, c'est moi\nle sale type...[K] Et [CS:N]Noctunoir[CR], lui, est doux\ncomme un agneau?", german="Ich bin also der Bösewicht...[K]\nUnd dieser [CS:N]Zwirrfinst[CR] ist der Gute?", italian="E così io sarei quello cattivo...[K]\nE quel [CS:N]Dusknoir[CR] il buono?", spanish="Así que yo soy el malo.[K]\nY ese [CS:N]Dusknoir[CR] es el bueno, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Then how about explaining\n[CS:N]Dusknoir[CR]'s actions earlier?", french="Alors comment tu expliques\nle comportement de [CS:N]Noctunoir[CR] tout à l'heure?", german="Wie erklärt ihr euch dann das\nVerhalten von [CS:N]Zwirrfinst[CR]?", italian="Allora come vi spiegate quello\nche stava facendo [CS:N]Dusknoir[CR] poco fa?", spanish="Entonces, ¿cómo explicas el\ncomportamiento de [CS:N]Dusknoir[CR] allí dentro?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It wasn't just me...[K] They wanted\nyou gone too!", french="Ils n'en avaient pas seulement\naprès moi...[K] Vous aussi, ils voulaient vous\néliminer!", german="Sie wollten nicht nur mich...[K]\nSie wollten euch auch loswerden!", italian="Non volevano solo me...[K]\nVolevano sbarazzarsi anche di voi!", spanish="No solo iban a por mí...[K]\n¡Que yo sepa, también os atacaron!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="But...[K] That doesn't mean I can\ntrust you, [CS:N]Grovyle[CR]...", french="Mais...[K] ça ne veut pas dire pour\nautant que je dois te faire confiance, [CS:N]Massko[CR]...", german="Aber...[K] Das heißt nicht, dass wir\ndir vertrauen sollten, [CS:N]Reptain[CR]...", italian="Ma...[K] questo non significa che\nmi debba fidare di te, [CS:N]Grovyle[CR]...", spanish="Pero...[K] eso no significa\nque deba confiar en ti, [CS:N]Grovyle[CR]."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Earning your trust isn't an easy\ntask, it seems.", french="On dirait que ce n'est pas facile\nde gagner ta confiance.", german="Es ist anscheinend nicht leicht,\neuer Vertrauen zu gewinnen.", italian="Sembra che guadagnare la\nvostra fiducia non sia un compito facile.", spanish="Veo que ganarse tu confianza\nno es tarea fácil."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I thought that having allies\nwould help, but...", french="Je pensais que l'union ferait\nla force, mais...", german="Ich dachte, dass es helfen\nwürde, Verbündete zu haben, aber...", italian="Pensavo che avere degli alleati\nfosse d'aiuto, ma...", spanish="Creía que tener aliados sería\nde ayuda, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's no point continuing\ntogether without trust.", french="... ça ne sert à rien de rester\nensemble si la confiance ne règne pas.", german="Ohne Vertrauen ist es sinnlos,\ngemeinsam weiterzumachen.", italian="Se non mi credete non c'è\nmotivo di proseguire insieme.", spanish="No tiene sentido continuar juntos\nsi no hay confianza entre nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We'll go our separate ways.", french="C'est ici que nos chemins\nse séparent.", german=" Gehen wir getrennte Wege.", italian=" Le nostre strade si dividono qui.", spanish=" Tendremos que separarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm staying on the move.[K]\nYou two should get moving as soon as possible.", french="Je me remets tout de suite\nen route.[K] Vous devriez faire de même dès que\npossible.", german="Ich mache, dass ich\nweiterkomme.[K] Ihr solltet euch auch wieder\nauf den Weg machen.", italian="Io me ne vado.[K] Voi due\ncercate di muovervi il prima possibile.", spanish="Yo no pienso detenerme.[K] Y os\nrecomendaría que no perdierais tiempo aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Good luck.", french=" Bonne chance.", german=" Viel Glück.", italian=" Buona fortuna.", spanish=" Buena suerte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 368, 176, false, 1)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Wait a second!", french=" Attends un peu!", german=" Warte mal!", italian=" Aspetta un secondo!", spanish=" ¡Espera un momento!"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  SkySceneKit.say({english="Wouldn't it be better to leave\nwhen it gets light out?", french="On y verra plus clair quand\nle jour sera levé.", german="Können wir nicht warten, bis es\nhell wird?", italian="Non possiamo aspettare che\nsorga il sole?", spanish="¿No sería mejor esperar a que\nsalga el sol?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That isn't possible.", french=" C'est impossible.", german=" Das ist nicht möglich.", italian=" È impossibile.", spanish=" Eso no es posible."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I hate to say it, but...[K]morning\nnever comes.", french="Navré de vous l'apprendre,\nmais...[K] le jour ne se lève jamais.", german="Ich sage es nicht gern, aber...[K]\nEs wird niemals Morgen.", italian="Odio doverlo dire, ma...[K]\nIl mattino non arriverà mai.", spanish="Odio decir esto, pero...[K] aquí\nnunca amanece."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Pardon?!", french=" Hein?!", german=" Wie?!?", italian=" Scusa?!", spanish=" ¡¿Cómo dices?!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This world... Your future...\nIt's a world of perpetual darkness.", french="Ce monde... votre futur...\nC'est un monde perpétuellement plongé\ndans l'ombre.", german="Diese Welt, eure Zukunft... Sie\nist eine Welt von immerwährender Dunkelheit.", italian="Questo mondo... Il vostro\nfuturo... è un mondo di oscurità perpetua.", spanish="Este mundo... Vuestro futuro...\nEs un mundo de oscuridad permanente."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The sun never rises.[K] So morning\nnever comes.", french="Le soleil ne se lève jamais.[K]\nDonc le jour non plus.", german="Die Sonne geht nie auf.[K]\nAlso kommt kein Morgen.", italian="Il sole non sorge mai.[K]\nDunque non esiste nessun mattino.", spanish="El sol nunca sale.[K]\nAsí que la mañana nunca llega."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" The darkness persists forever.", french=" L'ombre perdure, constamment.", german="Die Dunkelheit dauert in alle\nEwigkeit fort.", italian=" L'oscurità è perenne.", spanish=" La oscuridad es perpetua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" Wh-why?", french=" Mais pourquoi?", german=" W-warum?", italian=" P-Perché?", spanish=" ¿Por... por qué?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Because...[K]the planet has been\nparalyzed.", french="Parce que...[K] la planète est\nparalysée.", german=" Weil[K] der Planet gelähmt wurde.", italian="Perché...[K] il pianeta è\nparalizzato.", spanish="Porque...[K] el planeta está\nparalizado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" The planet's paralysis...", french=" La Paralysie de la Planète...", german=" Die Lähmung des Planeten...", italian=" La paralisi del pianeta...", spanish=" La parálisis del planeta..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="...The planet's paralysis![K]\nThat's right! I remember now!", french="La Paralysie de la Planète![K]\nÇa y est! J'y suis!", german="Die Lähmung des Planeten![K]\nAch ja! Ich erinnere mich!", italian="La paralisi del pianeta![K]\nÈ vero! Ora ricordo!", spanish="¡La parálisis del planeta![K]\n¡Es verdad! ¡Ahora lo recuerdo!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] described the\nplanet's paralysis before...", french="[CS:N]Noctunoir[CR] en a déjà parlé\nune fois...", german="[CS:N]Zwirrfinst[CR] hat uns die\nLähmung des Planeten beschrieben.", italian="[CS:N]Dusknoir[CR] aveva già\ndescritto la paralisi del pianeta...", spanish="[CS:N]Dusknoir[CR] nos describió\nla parálisis del planeta..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
