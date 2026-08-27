-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P43A/n04a2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=9} -- $SCENARIO_SIDE = scn[43,9] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(164, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There![K] Right there!", french=" Là![K] Droit devant!", german=" Da![K] Dort drüben!", italian=" Ecco![K] Laggiù!", spanish=" ¡Ahí![K] ¡Justo ahí!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Haunter[CR] is RIGHT THERE!", french=" [CS:N]Spectrum[CR] est juste là!!", german=" [CS:N]Alpollo[CR] ist dort drüben!", italian=" [CS:N]Haunter[CR] è laggiù!", spanish=" ¡[CS:N]Haunter[CR] está ahí mismo!"})
  -- message_Close
  GAME:WaitFrames(45)
  -- back_SetGround(LEVEL_D57P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_goosuto2 = SkySceneKit.spawn_npc("haunter", 240, 216, Direction.Down, "NPC_GOOSUTO2")
  -- SetOutputAttribute(128) [neutre/état moteur]
  local npc_npc_goosuto3 = SkySceneKit.spawn_npc("haunter", 240, 216, Direction.Down, "NPC_GOOSUTO3")
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've found you!", french=" Je t'ai trouvé!", german=" Habe ich dich gefunden!", italian=" Ti ho trovato!", spanish=" ¡Te he encontrado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Haunter[CR]![K] I'm going to arrest you!", french=" [CS:N]Spectrum[CR]![K] Je vais t'arrêter!", german="[CS:N]Alpollo[CR]![K]\nIch werde dich jetzt festnehmen!", italian=" [CS:N]Haunter[CR]![K] Sei in arresto!", spanish=" [CS:N]Haunter[CR]...[K] ¡Voy a arrestarte!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" You might as well give up!", french="Abandonne tant qu'il est\nencore temps!", german="Du könntest auch einfach\naufgeben!", italian=" Arrenditi!", spanish=" Ya puedes ir rindiéndote."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 240, 216, Direction.Down, "NPC_GOOSUTO")
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Heh heh![K] You've been more\npersistent than anyone else who's tried to\ncatch me!", french="Hé hé![K] Parmi tous les obstinés\nqui ont essayé de m'attraper, toi, tu gagnes\nla palme!", german="Hehe![K] Du bist hartnäckiger als\nalle anderen, die versucht haben, mich zu\nfangen!", italian="Eh eh![K] Sei l'esploratrice più\ntestarda che mi sia mai capitato d'incontrare!", spanish="¡Je, je![K] Creo que no recuerdo\na nadie que haya insistido tanto\nen intentar capturarme."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="You're ridiculously stubborn![K]\nBut it's still completely useless...", french="Tu es tellement têtue que ça en\ndevient ridicule![K] Mais encore une fois,\nc'est une perte de temps...", german="Einfach unglaublich sturköpfig![K]\nAber was du auch tust, es macht keinen\nUnterschied...", italian="La tua testardaggine è\nencomiabile![K] Ma completamente inutile...", spanish="¡Eres tozuda hasta el absurdo![K]\nPero sigue siendo totalmente inútil..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Don't you get it?! I'm invincible!", french="Tu n'as toujours pas compris?!\nJe suis invincible!", german="Kapierst du es nicht?!?\nIch bin un-be-sieg-bar!", italian="Possibile che tu non riesca\na capirlo?! Io sono invincibile!", spanish="¡¿Es que no lo pillas?!\n¡Soy invencible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I have...[K] I have proof that you're\nnot invincible!", french="J'ai...[K] J'ai la preuve\nque tu n'es pas invincible!", german="Ich habe...[K] Ich habe einen Beweis\ndafür, dass du es nicht bist!", italian="Ho...[K] Ho la prova che non\nsei affatto invincibile!", spanish="Puedo...[K] Puedo demostrar que\nno eres invencible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's no such thing as an\ninvincible Pokémon!", french="Un Pokémon invincible, ça n'a\njamais existé!", german="Es gibt keine unbesiegbaren\nPokémon!", italian=" Non esistono Pokémon invincibili!", spanish="¡No existe ningún\nPokémon invencible!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It was nothing but a ruse, right\nfrom the beginning!", french="Tout ça, c'était une ruse,\ndepuis le départ!", german="Von Anfang an war es nicht\nmehr als eine List!", italian="Non si tratta che di un\nsemplice stratagemma. Tutto qua!", spanish="No era más que un truco,\nde cabo a rabo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It wasn't invincibility or\nanything else![K] Was it, guys?!", french="Invincible, pfff... j'hallucine!![K]\nPas vrai, les gars?!", german="Von wegen Unbesiegbarkeit![K]\nHab ich recht, Jungs?!?", italian="Non esiste qualcosa come\nl'invincibilità![K] Vero, gente?!", spanish="No se trata de ser\ninvencible ni nada.[K] ¡¿A que no, chicos?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" G-[K]guys...[K] What do you mean?!", french="L-les[K] gars...[K] Qu'est-ce que\ntu veux dire?!", german=" J-[K]jungs...[K] Was meinst du damit?", italian=" G-[K]Gente...[K] Cosa vuoi dire?!", spanish=" Estooo...[K] Qué...[K] ¿Qué estás diciendo?"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" You found this out?!", french=" Tu as compris?!", german=" Du hast es herausbekommen?!?", italian=" Lo hai capito?!", spanish=" ¡¿Lo has descubierto?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Eso es."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I figured out there isn't\njust one of you.", french=" J'ai compris que tu n'es pas seul.", german="Ich habe herausbekommen,\ndass du nicht allein bist.", italian=" Ho capito che siete più di uno.", spanish="He descubierto que\nno eres solo uno."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Come on out![K] The rest of you!", french=" Montrez-vous![K] Les autres!", german=" Kommt schon raus![K] Ihr anderen!", italian=" Forza, voi![K] Uscite fuori!", spanish=" ¡Salid![K] ¡Que salgan los demás!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9996) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(8)
  -- StopAnimation() [neutre/état moteur]
  -- SetAnimation(768) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(4)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- MovePositionLives<object OBJECT_D57P43A1_448> vers ACTOR_NPC_GOOSUTO [prop décor NDS suit un acteur: géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P43A1_448) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P43A1_447) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P43A1_448) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Uwah!", french=" Aouah!", german=" Uwah!", italian=" Uaaah!", spanish=" ¡Uaah!"})
  GAME:WaitFrames(20)
  -- GAP: se_Play(9989) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(11, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GROUND:MoveToPosition(npc_npc_goosuto2, 204, 188, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_goosuto3, 268, 188, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Come pensavo!", spanish=" ¡Lo sabía!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Y...[K] You!", french=" T...[K] toi!", german=" D-[K]du!", italian=" T...[K] Tu!", spanish=" Ya...[K] ¡Ya te vale!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Lo sapevo!", spanish=" ¡Lo sabía!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There isn't just one [CS:N]Haunter[CR]...[K]\nThere's three!", french="Il n'y a pas qu'un [CS:N]Spectrum[CR]...[K]\nIl y en a trois!", german="Es gibt nicht nur ein [CS:N]Alpollo[CR]...[K]\nSondern drei!", italian="Non c'è un solo [CS:N]Haunter[CR]...[K]\nma tre!", spanish="No hay solo un [CS:N]Haunter[CR]...[K]\n¡Hay tres!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That time...", french=" L'autre fois...", german=" Dieses eine Mal...", italian=" Quella volta...", spanish=" Aquella vez..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
