-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P41A/m03a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(partner, 328, 324, false, 2)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- SetAnimation(3) [anim idle native]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(1)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(1)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(5, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(4, 6) -- $SCENARIO_MAIN = scn[4,6] (ROM)
  -- back_SetGround(LEVEL_D03P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 352, 320, Direction.Up, "NPC_RURIRI")
  GROUND:MoveToPosition(npc_npc_ruriri, 348, 156, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 352, 352, Direction.Up, "NPC_SURIIPU")
  GROUND:MoveToPosition(npc_npc_suriipu, 348, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Uh-oh. It's a dead end.", french=" Oh oh... C'est un cul-de-sac.", german=" Oh-oh. Das ist eine Sackgasse.", italian=" Uh-oh. È un vicolo cieco.", spanish=" Vaya. No hay salida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ruriri, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Excuse me, Mr. [CS:N]Drowzee[CR]. Where\nis my lost item?", french="M. [CS:N]Soporifik[CR]. Il est où, mon\nobjet perdu?", german="Verzeihung, Herr [CS:N]Traumato[CR].\nWo ist mein verlorenes Item?", italian="Scusi, signor [CS:N]Drowzee[CR]. Dov'è lo\nstrumento che ho perso?", spanish="Disculpe, Sr. [CS:N]Drowzee[CR].\n¿Dónde está mi objeto?"})
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Could you show me where the\nitem is now?", french=" Vous pouvez me montrer?", german="Wo genau ist mein verlorenes\nItem denn?", italian="Potrebbe mostrarmi dov'è lo\nstrumento?", spanish=" ¿Me puede decir dónde está?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Sorry, kiddo.", french=" Désolé, p'tit gars.", german=" Tut mir leid, Kleiner.", italian=" Spiacente, ragazzo.", spanish=" Lo siento, chaval."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Your lost item? It's not here,\nthat's for sure.", french="Mais pour ton objet perdu, c'est\npas la bonne adresse.", german="Dein verlorenes Item? Hier ist\nes nicht, so viel ist sicher.", italian="Il tuo strumento? Non è qui,\npoco ma sicuro.", spanish="¿Que dónde está tu objeto?\nDesde luego, aquí no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Was?!?", italian=" Eh?", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" My...big brother...", french=" Mon... grand frère...", german=" Mein... großer Bruder...", italian=" Il mio fratellone...", spanish=" Mi... mi hermano mayor..."})
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="My big brother's following us,\nright? He's coming soon?", french="Mon grand frère nous suit,\nhein? Est-ce qu'il arrive bientôt?", german="Mein großer Bruder kommt doch\nnach, oder? Ist er bald da?", italian="Il mio fratello maggiore è dietro\ndi noi, giusto? Ci raggiungerà presto?", spanish="Mi hermano mayor nos sigue,\n¿no? ¿Estará aquí pronto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Nope. Your big brother's\nnot coming.", french="Non. Ton grand frère\nne viendra pas.", german="Nein. Dein großer Bruder wird\nnicht kommen.", italian=" No. Tuo fratello non verrà.", spanish=" No. Tu hermano mayor no viene."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I'll let you in on a little secret.\nThis was all a trick.[K] I deceived you.", french="Je vais te raconter un petit\nsecret. Je vous ai menti.[K] Je\nvous ai joué un tour.", german="Ich verrate dir ein kleines\nGeheimnis... Das war alles nur ein Trick.[K]\nUm euch zu täuschen.", italian="Ti rivelerò un piccolo segreto.\nÈ stato tutto un trucco.[K] Ti ho ingannato.", spanish="Te voy a confesar una cosa.\nTodo era mentira.[K] Te he engañado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Was?!?", italian=" Eh?!", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="But let's not dwell on that.\nThere's a little favor I need to ask.", french="Mais ne nous attardons pas\nlà-dessus. J'ai une petite faveur à te\ndemander.", german="Aber vergessen wir das. Ich\nmuss dich um einen kleinen Gefallen bitten.", italian="Ma non soffermiamoci troppo su\nquesta cosa. Ho un piccolo favore da chiederti.", spanish="Pero basta de perder el tiempo\ncon eso. Tengo que pedirte un pequeño favor."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" See that hole behind you?", french=" Tu vois l'ouverture derrière toi?", german=" Siehst du dieses Loch hinter dir?", italian=" Vedi quel buco dietro di te?", spanish="¿Ves ese agujero que tienes\ndetrás?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 48, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(80)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Well...", french=" Eh bien...", german=" Nun...", italian=" Beh...", spanish=" Pues bien..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="There's a rumor that there's a\ntrove of thief treasure inside there!", french="On raconte qu'un sacré butin est\ncaché à l'intérieur!", german="Angeblich soll darin der\nerbeutete Schatz eines Diebes liegen!", italian="Si dice che dentro si trovi il\ntesoro di un ladro!", spanish="Dicen que un ladrón escondió\nsu botín ahí dentro."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="But as you can see, I'm too big\nto squirm my way through that hole.", french="Mais comme tu le vois, je suis\ntrop grand pour y entrer.", german="Aber wie du siehst, bin ich zu\ngroß, um mich durch das Loch zu quetschen.", italian="Ma come puoi vedere, io sono\ntroppo grande per infilarmici dentro.", spanish="El problema es que, como verás,\nyo soy demasiado grande y no quepo por ahí."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" And that's where you come in!", french=" C'est là que tu entres en jeu!", german=" Und da kommst du ins Spiel!", italian=" Ed è qui che entri in gioco tu!", spanish=" Y por eso te necesito."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Don't worry. Just do as I say.", french="Ne t'inquiète pas. Fais seulement\nce que je te dis.", german="Keine Angst. Tu einfach, was ich\ndir sage.", italian="Non preoccuparti. Fai come ti\ndico.", spanish="Tú no te preocupes por nada.\nLimítate a seguir mis instrucciones."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Do that, then I'll help you get\nback out of there.", french="Si tu m'écoutes bien gentiment,\nje t'aiderai à en ressortir.", german="Wenn du das tust, helfe ich dir\nwieder heraus.", italian="Fallo e io ti aiuterò a uscire da\nlì.", spanish="Hazlo y luego te ayudaré\na salir de ahí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_ruriri, 348, 140, false, 2) -- SlidePositionMark (glissement)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" B-but...", french=" Mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Go on, get going!", french=" Allez, vas-y!", german=" Los, mach schon!", italian=" Forza, datti una mossa!", spanish=" Venga, ¡en marcha!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_suriipu, 348, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Go into that hole. And don't\nforget to bring back the treasure!", french="Rentre dans ce trou. Et surtout\nn'oublie pas de me rapporter le trésor!", german="Kriech in das Loch. Und vergiss\nnicht, den Schatz mitzubringen!", italian="Infilati in quel buco. E non\ndimenticarti di portare fuori il tesoro!", spanish="Métete en el agujero.\n¡Y no te olvides de volver con el tesoro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" I want my big brother!", french=" Je veux mon grand frère!", german="Mein großer Bruder soll\nkommen!", italian=" Voglio mio fratello!", spanish=" ¡Quiero ir con mi hermano!"})
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(16), p.Y+(16), false, 2) end
  GROUND:EntTurn(npc_npc_suriipu, Direction.Down)
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(0), p.Y+(32), false, 2) end
  -- message_CloseEnforce
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(-16), p.Y+(16), false, 2) end
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" H-hey! Stop that!", french=" Hé! Tais-toi!", german=" H-hey! Hör auf damit!", italian=" E-Ehi! Smettila di piagnucolare!", spanish=" ¡Cállate!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_ruriri, 348, 244, false, 2)
  pcall(function() GAME:MoveCamera(348, 268, 60, false) end) -- performer/caméra
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(16), p.Y+(16), false, 2) end
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(0), p.Y+(64), false, 2) end
  GROUND:MoveToPosition(npc_npc_suriipu, 348, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_suriipu, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Sheesh! I said that I'll take you\nhome when you're done!", french="Chut! Je t'ai dit que je\nte ramènerais chez toi seulement quand\non aura fini!", german="Verflixt! Ich sage doch, dass\nich dich heimbringe, wenn du fertig bist!", italian="Ho detto che ti porterò\na casa quando avrai finito!", spanish="¡Silencio! ¡Ya te he dicho que\nte llevaré a casa cuando hayamos terminado!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="If you keep being difficult, it\nwill mean big trouble for you!", french="Si tu continues à faire des\ncaprices, tu vas avoir de gros ennuis!", german="Wenn du weiter Ärger machst,\nbringst du dich in große Schwierigkeiten!", italian="Se continui a fare storie...[K]\nte ne pentirai!", spanish="Si no haces lo que te pido...[K]\nTendrás serios problemas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" H-h-h...HELP!", french=" A... A L'AIDE!", german=" H-h-h...HILFE!", italian=" A-A-A... Aiuto!", spanish=" ¡So... socorro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Stop right there!", french=" Arrête tout de suite!", german=" Hör sofort auf!", italian=" Fermo lì!", spanish=" ¡Alto ahí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Stop right there!", french=" Arrête tout de suite!", german=" Hör sofort auf!", italian=" Fermo lì!", spanish=" ¡Alto ahí!"})
  else
  SkySceneKit.say({english=" Stop right there!", french=" Arrête tout de suite!", german=" Hör sofort auf!", italian=" Fermo lì!", spanish=" ¡Alto ahí!"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "exclaim", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.Down)
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(348, 372, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() GAME:MoveCamera(348, 308, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 368, 324, false, 2)
  GAME:WaitFrames(5)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We won't let you do that![K]\n[CS:N]Drowzee[CR], you bully!", french="On ne te laissera pas t'en sortir\ncomme ça![K] [CS:N]Soporifik[CR], tu n'es qu'un monstre!", german="Das lassen wir nicht zu![K]\n[CS:N]Traumato[CR], du Bösewicht!", italian="Non te lo permetteremo![K]\n[CS:N]Drowzee[CR], brutto delinquente!", spanish="¡No te permitiremos hacerle\neso![K] [CS:N]Drowzee[CR], ¡eres un abusón!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We won't let you do that![K]\n[CS:N]Drowzee[CR], you bully!", french="On ne te laissera pas t'en sortir\ncomme ça![K] [CS:N]Soporifik[CR], tu n'es qu'un monstre!", german="Das lassen wir nicht zu![K]\n[CS:N]Traumato[CR], du Bösewicht!", italian="Non te lo permetteremo![K]\nVigliacco di un [CS:N]Drowzee[CR]!", spanish="¡No tiene por qué hacer eso![K]\n[CS:N]Drowzee[CR], ¡eres un abusón!"})
  else
  SkySceneKit.say({english="We won't let you do that![K]\n[CS:N]Drowzee[CR], you bully!", french="On ne te laissera pas t'en sortir\ncomme ça![K] [CS:N]Soporifik[CR], tu n'es qu'un monstre!", german="Das lassen wir nicht zu![K]\n[CS:N]Traumato[CR], du Bösewicht!", italian="Non te lo permetteremo![K]\n[CS:N]Drowzee[CR], brutto scellerato!", spanish="¡No te permitiremos que le\nobligues a hacer eso![K]\n[CS:N]Drowzee[CR], ¡eres un abusón!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" H-how did you find this place?!", french="Comment avez-vous fait pour\narriver jusqu'ici?!", german=" W-wie habt ihr uns gefunden?!?", italian="C-Come avete fatto ad arrivare\nqui?!", spanish="¡¿Cómo habéis encontrado\neste sitio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're Team [team:]![K]\nAn exploration team!", french="Nous sommes une équipe\nd'exploration![K] Nous sommes l'Equipe\n[team:]!", german="Wir sind Team [team:]![K]\nEin Erkundungsteam!", italian="Siamo il Team [team:]![K]\nUna squadra d'esplorazione!", spanish="¡Somos el [CS:X]Equipo[CR] [team:]![K]\n¡Somos un equipo explorador!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're Team [team:]![K]\nAn exploration team!", french="Nous sommes une équipe\nd'exploration![K] Nous sommes l'Equipe\n[team:]!", german="Wir sind Team [team:]![K]\nEin Erkundungsteam!", italian="Siamo il Team [team:]![K]\nUna squadra d'esplorazione!", spanish="¡Somos el [CS:X]Equipo[CR] [team:]![K]\n¡Somos un equipo explorador!"})
  else
  SkySceneKit.say({english="We're Team [team:]![K]\nAn exploration team!", french="Nous sommes une équipe\nd'exploration![K] Nous sommes l'Equipe\n[team:]!", german="Wir sind Team [team:]![K]\nEin Erkundungsteam!", italian="Siamo il Team [team:]![K]\nUna squadra d'esplorazione!", spanish="¡Somos el [CS:X]Equipo[CR] [team:]![K]\n¡Somos un equipo explorador!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No criminal can escape us!", french=" Aucun criminel ne nous échappe!", german=" Kein Ganove ist vor uns sicher!", italian="Siamo lo spauracchio di tutti i\ncriminali!", spanish="¡Ningún malhechor puede\nescapársenos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No criminal can escape us!", french=" Aucun criminel ne nous échappe!", german=" Kein Ganove ist vor uns sicher!", italian="Nessun criminale ci può\nsfuggire!", spanish="¡Ningún malhechor puede\nescapársenos!"})
  else
  SkySceneKit.say({english=" No criminal can escape us!", french=" Aucun criminel ne nous échappe!", german=" Kein Ganove ist vor uns sicher!", italian="Nessun criminale può sentirsi\nsicuro con noi alle calcagna!", spanish="¡Ningún malhechor puede\nescapársenos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.spin(npc_npc_suriipu, 1, 2, 2)
  GAME:WaitFrames(8)
  SkySceneKit.spin(npc_npc_suriipu, 1, 1, 3)
  GAME:WaitFrames(8)
  SkySceneKit.spin(npc_npc_suriipu, 1, 2, 4)
  GAME:WaitFrames(8)
  SkySceneKit.spin(npc_npc_suriipu, 1, 1, 1)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="An exploration team?![K] You came\nto apprehend...", french="Une équipe d'exploration?![K] Alors\nvous venez m'arrêter...", german="Ein Erkundungsteam?!?[K] Ihr wollt\nmich festnehmen...", italian="Una squadra d'esplorazione?![K]\nSiete qui per arrestare...", spanish="¿Un equipo explorador?[K]\nAsí que habéis venido a detenerme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" ...Huh?[K] Are you...trembling?", french=" ... Hein?[K] ... Tu trembles?", german=" ...Was ist?[K] Zitterst du etwa?", italian=" Eh?[K] Stai... tremando?", spanish=" Un segundo...[K] ¿Estás temblando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" A-ha! I've figured it out!", french=" Ah ah! J'ai saisi!", german=" Aha! Ich durchschaue euch!", italian=" A-ha! Ci sono!", spanish=" ¡Ajá! ¡Me lo figuraba!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="You say you're on an exploration\nteam, but you're total rookies!", french="Vous faites bien partie d'une\néquipe d'exploration... mais vous débutez\nà peine!", german="Ihr sagt, ihr seid ein\nErkundungsteam, aber ihr seid ja noch totale\nGrünschnäbel!", italian="Dite di essere una squadra\nd'esplorazione, ma siete ancora alle prime\narmi!", spanish="¿Cómo que sois un equipo\nexplorador? ¡No sois más que un par\nde principiantes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  else
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Heh.[K] That's right, I'm a wanted\nPokémon with a bounty on my head.", french="Oui.[K] C'est vrai, je suis\nun Pokémon recherché et il y aura une prime\nsi vous me capturez.", german="Heh.[K] Es ist wahr, ich bin ein\nper Kopfgeld gesuchtes Pokémon.", italian="Eh.[K] Già, sono un Pokémon\nricercato e c'è una taglia sulla mia testa.", spanish="Je, je...[K] Pues sí. Soy un\nmalhechor y ofrecen una recompensa por mí."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" But can you two do the job?", french="Mais qui me dit que vous\nallez y arriver?", german=" Aber was ist mit euch?", italian="Ma voi siete in grado di\ncatturarmi?", spanish=" ¿Pero estáis a la altura?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Can you confront this outlaw and\nbring him to justice?", french="Pensez-vous sincèrement\npouvoir me vaincre pour me ramener\naux autorités?", german="Könnt ihr mich stellen und zur\nRechenschaft ziehen?", italian="Potete affrontare questo\nfuorilegge e consegnarlo alla giustizia?", spanish="¿Podéis plantarme cara\ny capturarme?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  else
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Y-yes. We can![K] Yes, we can!", french="Oui. On peut y arriver![K]\nOn y arrivera!", german=" J-ja. Wir können![K] Wir können!", italian=" S-Sì. Possiamo![K] Sì, possiamo!", spanish="Esto... Sí. ¡Claro que sí![K]\n¡Por supuesto que podemos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Y-yes. We can![K] Yes, we can!", french="Oui. On peut y arriver![K]\nOn y arrivera!", german=" J-ja. Wir können![K] Wir können!", italian=" S-Sì. Possiamo![K] Sì, possiamo!", spanish="Esto... Sí. ¡Claro que sí![K]\n¡Por supuesto que podemos!"})
  else
  SkySceneKit.say({english=" Y-yes. We can![K] Yes, we can!", french="Oui. On peut y arriver![K]\nOn y arrivera!", german=" J-ja. Wir können![K] Wir können!", italian=" S-Sì. Possiamo![K] Sì, possiamo!", spanish="Esto... Sí. ¡Claro que sí![K]\n¡Por supuesto que podemos!"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'd never lose to a bad guy\nlike you!", french="On ne perdra jamais face à\nun méchant Pokémon comme toi!", german="So einen Bösewicht wie dich\nlassen wir nicht entkommen!", italian="Non perderemmo mai contro un\ndelinquente come te!", spanish="¡Nunca perderíamos ante un\nmaleante como tú!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'd never lose to a bad guy\nlike you!", french="On ne perdra jamais face à\nun méchant Pokémon comme toi!", german="So einen Bösewicht wie dich\nlassen wir nicht entkommen!", italian="Non perderemmo mai contro un\nfuorilegge come te!", spanish="¡Nunca perderíamos ante un\nmaleante como tú!"})
  else
  SkySceneKit.say({english="We'd never lose to a bad guy\nlike you!", french="On ne perdra jamais face à\nun méchant Pokémon comme toi!", german="So einen Bösewicht wie dich\nlassen wir nicht entkommen!", italian="Non perderemmo mai contro un\ncattivo come te!", spanish="¡Nunca perderíamos ante un\nmaleante como tú!"})
  end
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_suriipu, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Ha ha ha![K] I've been chased by\nall sorts of exploration teams in my day...", french="Ha ha ha![K] J'ai été\npoursuivi par de nombreuses équipes au\ncours de ma carrière...", german="Hahaha![K] Mich haben schon\nviele Erkundungsteams gejagt...", italian="Ah ah ah![K] Un sacco di squadre\nd'esplorazione mi hanno dato la caccia...", spanish="¡Ja, ja, ja![K] Me han perseguido\ntodo tipo de equipos de exploración..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="But never a sorrier-looking\nbunch than you two!", french="... et pourtant, je n'ai jamais\ncroisé une équipe aussi pathétique que\nla vôtre!", german="Aber noch keines war so\nerbärmlich wie ihr!", italian="Ma nessuna era così ridicola\ncome la vostra!", spanish="¡Pero ninguno tan patético\ncomo el vuestro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  else
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Uf!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="This should be a laugh.[K] Let's see\nif you can take me down.", french="Quelle plaisanterie![K] Montrez-moi\nce que vous savez faire.", german="Das wird sicher lustig.[K] Mal\nsehen, ob ihr mich besiegen könnt.", italian="Sarà un gioco da ragazzi.[K]\nFatemi vedere di cosa siete capaci!", spanish="Creo que me voy a reír de lo\nlindo.[K] Veamos si podéis conmigo."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Show me what you've got!", french="Montrez-moi ce que vous avez\ndans le ventre!", german=" Zeigt mir, was ihr draufhabt!", italian="Date il meglio di voi,\nprincipianti!", spanish=" ¡A ver de lo que sois capaces!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkyProg.set(4, 6) -- $SCENARIO_MAIN = scn[4,6] (ROM)
  -- main_EnterDungeon(5, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
