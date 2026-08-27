-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P42A/n04a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=6} -- $SCENARIO_SIDE = scn[43,6] (ROM)
  -- back_SetGround(LEVEL_D57P42A) [neutre/état moteur]
  -- supervision_Acting(5) [neutre/état moteur]
  -- supervision_Acting(6) [neutre/état moteur]
  -- supervision_Acting(7) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(228, 220, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: BGM BGM_HEAVY_WIND2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(15)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 232, 200, Direction.Down, "NPC_GOOSUTO")
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  do local p=npc_npc_goosuto.Position; GROUND:MoveToPosition(npc_npc_goosuto, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(22) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Ugh!", french=" Argh!", german=" Uff!", italian=" Urgh!", spanish=" ¡Uf!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" GAAAAAAAAAAAaaaaaaaaaaaah!!!", french=" OUAAAAAAAAAAaaaaaaaaaaaah!!!", german=" GAAAAAAAAAAAaaaaaaaaaaaah!!!", italian=" GAAAAAAAAAaaaaaaaaaaaah!!!", spanish=" ¡¡¡Aaaaaaah!!!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(3)
  -- GAP: se_Play(9987) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Anyway...", french=" ...[K] Enfin...", german=" ...[K]Immerhin...", italian=" ...[K] Bene...", spanish=" Hum...[K] En fin..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I managed to knock him out...", french=" J'ai fini par le mettre K.O...", german="Ich habe es geschafft.\nEr ist K.O. gegangen...", italian=" Sono riuscita a sconfiggerlo...", spanish=" He conseguido tumbarlo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(9990) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" Ben mince alors!", german=" Auweia!", italian=" Shock!", spanish=" ¡Jo, pero qué fuerte!"})
  -- message_Close
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A-[K]again!", french=" En-[K]encore!", german=" Sch-[K]schon wieder!", italian=" D-[K]Di nuovo?!", spanish=" O sea...[K] ¡Otra vez!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I really thought I knocked him\nout this time!", french="J'étais pourtant sûre de l'avoir\nmis K.O. cette fois!", german="Ich dachte, diesmal wäre es das\nendgültig gewesen!", italian="Questa volta pensavo di avercela\nfatta per davvero!", spanish="¡Pensaba que esta vez lo había\ntumbado de verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="GAH HA HA HA HA HA![K]\nGAH HA HA HA HA HA HA HA HA!!", french="OUAH HA HA HA HA HA![K]\nOUAH HA HA HA HA HA HA HA HA!!", german="GAHAHAHAHAHAHAHAHA![K]\nGAHAHAHAHAHAHAHAHAHAHAHAHA!!!", italian="GAH AH AH AH AH AH AH AH AH![K]\nGAH AH AH AH AH AH AH AH AH AH AH AH!!!", spanish="¡Jua, ja, ja, ja, ja, ja![K]\n¡Juaaa, ja, ja, ja, ja, ja, ja, ja, ja!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="It doesn't matter how many\ntimes you knock me out! Your efforts\nare useless!", french="Tu peux bien me mettre K.O.\nun nombre incalculable de fois, peu importe!\nTes efforts sont vains!", german="Ganz egal, wie häufig du mich\numhaust! Deine Anstrengungen sind\nvollkommen umsonst!", italian="Non importa quanto ci provi!\nI tuoi sforzi sono inutili, non mi batterai mai!", spanish="Da igual las veces que me tumbes.\n¡Te esfuerzas en vano!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" I'm invincible!", french=" Je suis invincible!", german=" Ich bin unbesiegbar!", italian=" Sono invincibile!", spanish=" ¡Soy invencible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...[K] Why...", french=" Oooh...[K] Mais pourquoi...?", german=" Uuuuff...[K] Warum nur...", italian=" Urgh...[K] Ma come...", spanish=" Uuuf...[K] Por qué..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Why is it...", french=" Pourquoi est-ce que...", german=" Warum ist...", italian=" Come...", spanish=" No lo entiendo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Why is it [CS:N]Haunter[CR] is still so\nfull of energy, even after being knocked out...", french="Pourquoi [CS:N]Spectrum[CR] est-il\ntoujours en pleine forme même après\navoir été mis K.O.?", german="Warum ist [CS:N]Alpollo[CR] immer noch\nso voller Energie, direkt nach einem K.O.?", italian="Come fa quell'[CS:N]Haunter[CR] ad avere\nancora così tante energie dopo essere\nfinito al tappeto?", spanish="¿Por qué sigue [CS:N]Haunter[CR] lleno de\nenergía, cuando se acaba de debilitar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9988) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A1_443) [routine d'objet NDS non simulée - documenté]
  -- supervision_Acting(2) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  local npc_npc_magumaggu = SkySceneKit.spawn_npc("slugma", 168, 248, Direction.Right, "NPC_MAGUMAGGU")
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(9988) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A1_444) [routine d'objet NDS non simulée - documenté]
  -- supervision_Acting(3) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  local npc_npc_magumaggu2 = SkySceneKit.spawn_npc("slugma", 288, 248, Direction.Left, "NPC_MAGUMAGGU2")
  -- SetAnimation(4) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Waaah![K] Wh-what is it?!", french="Ouaaah![K] Qu'est-ce que\nc'est que ça?!", german=" Waaah![K] W-was ist das?!?", italian="Uaaah![K] C-Che succede?!\nCosa sono questi?", spanish=" ¡Uaaah![K] ¡¿Qué... Qué pasa?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(-8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" These are [CS:N]Slugma[CR]!", french=" Des [CS:N]Limagma[CR]!", german=" Das sind [CS:N]Schneckmag[CR]!", italian=" Questi sono [CS:N]Slugma[CR]!", spanish=" Son [CS:N]Slugma[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="I thought you'd keep\nfollowing me...", french="Je pensais bien que tu\ncontinuerais à me suivre...", german="Ich rechnete damit, dass du mir\nimmer weiter folgst...", italian="Sapevo che avresti continuato\na inseguirmi...", spanish="Me imaginé que ibas a continuar\nsiguiéndome..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" So I hired them in advance...", french="Alors j'ai prévu le coup et j'ai\nappelé du renfort...", german="Also habe ich sie im Vorhinein\num Hilfe gebeten.", italian="Così ho chiesto loro di darmi\nuna mano...", spanish="Así que me adelanté a tus intenciones\ny les pedí que me echaran una mano..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" They are Fire-type Pokémon!", french="Ce sont des Pokémon\nde type Feu!", german=" Es sind Feuer-Pokémon!", italian=" Sono Pokémon di tipo Fuoco!", spanish=" Son Pokémon de tipo Fuego."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! (Fire type!)", french=" ...! (De type Feu!)", german=" Aaaah! (Feuer-Pokémon!)", italian=" ...! (Di tipo Fuoco!)", spanish=" ¡¿Qué...?! (¡De tipo Fuego!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(-8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GURURURURURURU...", french=" GRRRRRRROAAAOUH...", german=" GURURURURURURU...", italian=" GURURURURURURU...", spanish=" Gurururu..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GURURURURURU!", french=" GRRRRRRROAAAOUH!", german=" GURURURURURU!", italian=" GURURURURURU!", spanish=" ¡Gururu!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="GAH HA HA HA HA![K]\nThey can burn you with their fire!", french="OUAH HA HA HA HA![K]\nIls peuvent te brûler avec leur feu!", german="GAHAHAHAHA![K]\nSie können dich mit ihrem Feuer verbrennen!", italian="GAH AH AH AH![K]\nLe loro fiamme ti arrostiranno per bene!", spanish="¡Jua, ja, ja, ja, ja![K]\n¡Van a chamuscarte un poco los pétalos!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" See ya!", french=" A la revoyure!", german=" Bis dann!", italian=" Ci vediamo!", spanish=" ¡Nos vemos!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_goosuto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey! Don't run away!", french=" Hé! Ne t'enfuis pas!", german=" Hey! Lauf nicht davon!", italian=" Ehi! Non scappare!", spanish=" ¡Eh, no huyas!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 228, 196, false, 2)
  GROUND:EntTurn(npc_npc_magumaggu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.UpLeft)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(9991) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  do local p=npc_npc_goosuto.Position; GROUND:MoveToPosition(npc_npc_goosuto, p.X+(0), p.Y+(-64), false, 1) end
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(npc_npc_magumaggu, 192, 196, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 264, 196, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_magumaggu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_magumaggu2, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! (Was I...unprepared?!)", french="...! (Je ne suis peut-être\npas assez bien préparée?!)", german="Iiiek! (War ich...\nunvorbereitet?!?)", italian=" ...! (Non me l'aspettavo!)", spanish="¡Horror! (¡¿Acaso...\nno estaba bien preparada?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9995) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(8) [neutre/état moteur]
  -- supervision_Acting(9) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(4)
  -- supervision_Acting(7) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- Move2PositionLives<object OBJECT_D57P42A2_445> [prop décor NDS suit un acteur: géré par le rendu du ground]
  -- Move2PositionLives<object OBJECT_D57P42A2_446> [prop décor NDS suit un acteur: géré par le rendu du ground]
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K]\nI got burned!", french="Ben mince alors![K]\nJe brûle!", german=" Auweia![K] Ich brenne!", italian="Shock![K]\nMi hanno colpita!", spanish="¡Aaaayyy![K]\n¡Me he churruscado todaaa!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hot hot hot hot hot hot hot!!", french="C'est chaud c'est chaud\nc'est chaud c'est chaud c'est chaud!!", german=" Heißheißheißheißheißheiß!!!", italian="BRUCIABRUCIABRUCIABrucia\nBruciaBruciaBruciaBruciaBruciaBRUCIA!!!", spanish=" ¡¡Quema, quema, quema, quema!!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.Down)
  GROUND:MoveToPosition(hero, 184, 228, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_magumaggu, 188, 284, false, 2)
  GROUND:MoveToPosition(hero, 260, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 280, 220, false, 2)
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_magumaggu, Direction.Up)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9995) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(8) [neutre/état moteur]
  -- SetPositionLives(365) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D57P42A3_458> [prop décor NDS]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-40), p.Y+(12), false, 2) end -- Slide2PositionOffset
  GROUND:EntTurn(npc_npc_magumaggu, Direction.UpLeft)
  -- SetPositionMark OBJECT_D57P42A2_445 [cible sans placement SSA zone: placement non joué]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- Move2PositionOffset<object OBJECT_D57P42A2_445> [prop décor NDS, géré par le rendu du ground]
  -- SetAnimation(1) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GOOOooooohhhh!", french=" GROUaaaoooooh!", german=" GOOOoooooh!", italian=" GUOOOoooooohhh!", spanish=" ¡Grooo!"})
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.Down)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" Zut de zut!", german=" Auweia!", italian=" Shock!", spanish=" ¡Aaayy!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- message_Close
  GROUND:EntTurn(npc_npc_magumaggu, Direction.Left)
  GROUND:MoveToPosition(hero, 232, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 232, 284, false, 2)
  GROUND:MoveToPosition(hero, 184, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 240, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu, 304, 228, false, 2)
  GROUND:EntTurn(npc_npc_magumaggu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.Right)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9995) — id SE NDS sans portage PMDO identifié
  -- SetPositionLives(364) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D57P42A3_458> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end -- Slide2PositionOffset
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.DownRight)
  -- SetPositionMark OBJECT_D57P42A2_445 [cible sans placement SSA zone: placement non joué]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- Move2PositionOffset<object OBJECT_D57P42A2_445> [prop décor NDS, géré par le rendu du ground]
  -- SetAnimation(1) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GOOOOOooooooohhhhhh!", french=" GROUAAAAAAAooooooooooh!", german=" GOOOOOoooooooh!", italian=" GUOOOOOOoooooohhhhhh!", spanish=" ¡Grooo!"})
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_magumaggu, Direction.DownLeft)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" Mince alors!", german=" Auweia!", italian=" Shock!", spanish=" ¡Aaaayy!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- message_Close
  GROUND:MoveToPosition(hero, 232, 284, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 232, 284, false, 2)
  GROUND:MoveToPosition(hero, 224, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu, 256, 196, false, 2)
  GROUND:EntTurn(npc_npc_magumaggu, Direction.Left)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.UpRight)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9995) — id SE NDS sans portage PMDO identifié
  -- SetPositionLives(364) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D57P42A3_458> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(12), p.Y+(24), false, 2) end -- Slide2PositionOffset
  GROUND:EntTurn(npc_npc_magumaggu2, Direction.Right)
  -- SetPositionMark OBJECT_D57P42A2_445 [cible sans placement SSA zone: placement non joué]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- Move2PositionOffset<object OBJECT_D57P42A2_445> [prop décor NDS, géré par le rendu du ground]
  -- SetAnimation(1) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GAAAAAaaaaah!!", french=" GAAAAAaaaaah!!", german=" GAAAAAaaaaah!!!", italian=" GUAAAAAAaaaaaah!!", spanish=" ¡¡Gruaaaaah!!"})
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D57P42A2_445) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_magumaggu, Direction.DownLeft)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" Ben mince alors!", german=" Auweia!", italian=" Shock!", spanish=" ¡Aaaayy!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- message_Close
  -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
  GROUND:MoveToPosition(hero, 240, 332, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 240, 332, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_magumaggu, 240, 332, false, 2)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_KIMAWARI)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh!\nOh my gosh!\nOh my gosh!", french="Mince alors! Mince alors!\nMince alors!", german="Auweia!\nAuweia!\nAuweia!", italian="Shock!\nShock!\nShock!", spanish="¡Aaayy! ¡Pupa, pupaaa!\n¡Uf, uf, uf, uf!"})
  GROUND:MoveToPosition(hero, 176, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu2, 176, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_magumaggu, 176, 268, false, 2)
  GROUND:MoveToPosition(hero, 296, 268, false, 2)
  -- SetPositionLives(7) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(284, 268, 60, false) end) -- performer/caméra
  GAME:WaitFrames(20)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Uhhn...huhhn...", french=" Ouuufff... ouuufff...", german=" Pffff... Pfffffff...", italian=" Anf... Anf...", spanish=" Uf... Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GURURURURU!", french=" GRRRRRRROAAAOUH!", german=" GURURURURU!", italian=" GURURURURU!", spanish=" ¡Gurururu!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh! I'm losing hope!", french="Ben mince alors! Je ne sais plus\nquoi faire!", german=" Auweia! Es ist hoffnungslos!", italian=" Shock! Non ce la farò mai!", spanish=" ¡Jo, qué mal! ¡Lo llevo claro!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" HELP!", french=" A L'AIDE!", german=" HILFE!", italian=" AIUTO!", spanish=" ¡Socorro!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- supervision_Acting(4) [neutre/état moteur]
  -- GAP: se_Play(7180) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeIn(15)
  GAME:WaitFrames(15)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 272, Direction.Left, "NPC_DOGOOMU")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-8), g.ViewCenter.Y+(0), 3, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(-24), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu2, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(-24), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" Bugyaaaaaaaah!", french=" Bleurghblaaaaah!", german=" Bugyaaaaaaaah!", italian=" Bugaaaaaaaaah!", spanish=" ¡Bruuuuuaaaaaaar!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_ONE_FOR_ALL_ALL_FOR_ONE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! ([CS:N]L[CR]-[CS:N]Loudred[CR]?!)", french=" ...! ([CS:N]R[CR]-[CS:N]Ramboum[CR]?!)", german=" ...([CS:N]K-Krakeelo[CR]?!?)", italian=" ...! ([CS:N]L-Loudred[CR]?!)", spanish="¡Qué ven mis ojos!\n(¡¿[CS:N]Lo[CR]... [CS:N]Loudred[CR]?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Ugaaaaah!", french=" Yaaaa-taaa!", german=" Ugaaaaah!", italian=" Ugaaaaaah!", spanish=" ¡Largo de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-24), g.ViewCenter.Y+(0), 12, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(-32), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu2, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(-32), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu, "sweating", 1) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_magumaggu2, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" Gyah!", french=" Bleurgh!", german=" Gyah!", italian=" Guah!", spanish=" ¡Giah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_magumaggu) end)
  SkySceneKit.say({english=" GYAAAAaaaaaaaah!!", french=" BLEURGHblaaaaah!", german=" GYAAAAaaaaaaaah!!!", italian=" GUAAAaaaaaaaaah!!", spanish=" ¡¡Giaaaaaaaaaaah!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_magumaggu.Position; GROUND:MoveToPosition(npc_npc_magumaggu, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_magumaggu2.Position; GROUND:MoveToPosition(npc_npc_magumaggu2, p.X+(0), p.Y+(120), false, 2) end
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(120)
  pcall(function() GAME:MoveCamera(284, 268, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" A-are you ALL RIGHT, [CS:Y]Sunflora[CR]?", french=" Tout va BIEN, [CS:Y]Héliatronc[CR]?", german=" G-geht ES dir GUT, [CS:Y]Sonnflora[CR]?", italian=" T-Tutto BENE, [CS:Y]Sunflora[CR]?", spanish=" ¿Es... estás bien, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-yeah... (Y-you saved me...)", french="Heu oui... (T-tu viens\nde me sauver...)", german="J-ja...\n(D-du hast mich gerettet...)", italian=" S-Sì... (M-Mi hai salvata...)", spanish=" Esto... sí... (Me ha salvado...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I-is that SO?[K] GOOD.", french=" C'est VRAI?[K] PARFAIT.", german=" W-wirklich?[K] GUT.", italian=" D-DAVVERO?[K] BENE.", spanish=" ¿De verdad?[K] Menos mal."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Anyway...[K] It's not LIKE you to\nFALL BEHIND those guys like THAT.", french="C'est drôle...[K] ÇA ne te\nressemble PAS de te laisser IMPORTUNER\ncomme ÇA.", german="Komisch...[K] SIEHT dir GAR nicht\nÄHNLICH, mit DENEN so viel ÄRGER zu haben.", italian="Però...[K] Non è da TE farti\nMETTERE SOTTO da SIMILI tipi.", spanish="En fin...[K] No es propio de ti\ndejarte atosigar por tipos así."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Then AGAIN, you DID just\ntake a LOT of DAMAGE.", french="Et POURTANT, tu as PRIS un\nPAQUET de DEGATS.", german="ABER du HAST ganz schön\netwas ABBEKOMMEN.", italian=" EPPURE, hai subito MOLTI DANNI.", spanish="Pero bueno, la verdad es que\nhas recibido un montón de daño."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="On THAT note, I just GOT here,\nso I'm doing FINE![K] Ha ha ha!", french="Mais MOI, je viens d'arriver\nalors je vais BIEN![K] Ha ha ha!", german="DAHER ist es wohl GUT, dass ich\nhier RECHTZEITIG aufgetaucht bin![K] Das FREUT\nmich! Hahaha!", italian="A proposito, io SONO appena\narrivato QUI, quindi sto BENE![K] Ah ah ah!", spanish="Por cierto, yo acabo de llegar,\nasí que estoy como una rosa.[K] ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  GAME:WaitFrames(15)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="B-but...[K] Why are you here,\n[CS:N]Loudred[CR]?", french="M-mais...[K] que fais-tu là,\n[CS:N]Ramboum[CR]?", german="A-aber...[K] Warum bist du hier,\n[CS:N]Krakeelo[CR]?", italian="M-Ma...[K] Cosa ci fai qui,\n[CS:N]Loudred[CR]?", spanish="Pe... pero...[K] ¿Qué haces aquí,\n[CS:N]Loudred[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Huh?[K] WHY?", french=" Hein?[K] CE que je FAIS là?", german=" Häh?[K] WARUM?", italian=" Uh?[K] COSA ci faccio?", spanish=" ¿Eh?[K] ¿Que qué hago aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" OH...", french=" OH...", german=" OH...", italian=" OH...", spanish=" Pues..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="N-no REASON. It's not because\nI was WORRIED about you, [CS:Y]Sunflora[CR]!", french="R-rien de SPECIAL. Ce n'est PAS\nparce que j'étais INQUIET pour toi, [CS:Y]Héliatronc[CR]!", german="K-kein bestimmter GRUND. Vor\nallem NICHT, weil ICH mir SORGEN um DICH\ngemacht HÄTTE, [CS:Y]Sonnflora[CR]!", italian="N-Non c'è NESSUN motivo. E non\nè perché ero PREOCCUPATO per te, [CS:Y]Sunflora[CR]!", spanish="Pues... nada. No vayas a pensar\nque me tenías preocupado, [CS:Y]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR] ASKED me to come CHECK\non you. That's the ONLY reason!", french="C'est juste parce que [CS:N]Pijako[CR] m'a\ndemandé de VENIR voir COMMENT tu allais.\nRIEN de PLUS!", german="[CS:N]Plaudagei[CR] hat MICH gebeten,\nauf DICH aufzupassen. Das ist der EINZIGE\nGrund!", italian="[CS:N]Chatot[CR] mi ha CHIESTO di venire\na CONTROLLARE, ecco PERCHÉ!", spanish="[CS:N]Chatot[CR] me pidió que viniera\na ver cómo te iba. ¡Eso es todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...! (Only because [CS:N]Chatot[CR]\nasked you to!?)", french="...! (Juste parce que [CS:N]Pijako[CR]\nle lui a demandé!?)", german="...(Nur weil es dir [CS:N]Plaudagei[CR]\naufgetragen hat?!?)", italian="...! (Solo perché [CS:N]Chatot[CR] te l'ha\nchiesto?!)", spanish="Entiendo... (¿O sea que solo has\nvenido porque [CS:N]Chatot[CR] te lo ha pedido?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Humph! What's that?", french=" Humph! Sérieusement?", german=" Humpf! Was soll das?", italian=" Umpf! Ma cosa credi?", spanish=" ¡Jum! Pues muy bien."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You only helped me once, so don't\nget carried away!", french="Tu ne m'as aidée qu'une seule\nfois, alors ne t'emballe pas!", german="Gut, du hast mir vielleicht\ngeholfen, aber das hat nichts zu bedeuten!", italian="Mi hai aiutata solo una volta,\nquindi non metterti in testa strane idee!", spanish="Solo me has ayudado una vez,\nasí que no te lo creas tanto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Wh...[K] What's WITH that\nATTITUDE?!", french="Que...[K] AH, tu le PRENDS\ncomme ÇA?!", german="W-[K]was IST das für eine\nEINSTELLUNG?!?", italian="Ma...[K] Che ATTEGGIAMENTO è\nQUESTO?!", spanish="Pe...[K] ¡¿pero a qué viene\nesa actitud?!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GOT IT![K] I'm NOT HELPING\nanymore!", french="PARFAIT![K] Dans ce CAS,\nne COMPTE plus sur mon AIDE!", german="ICH VERSTEHE![K] Ich werde NICHT\nMEHR helfen!", italian="VA BENE![K] Non ti AIUTERÒ mai\nPIÙ!", spanish="¡Pues vale![K] ¡Ya no te ayudo\nmás, hale!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I'm NOT helping YOU AGAIN![K]\nHUMPH!", french="Tu peux COURIR pour que je\nT'AIDE ENCORE![K] HUMPH!", german="Ich werde DIR NICHT noch\neinmal helfen![K] HUMPF!", italian="HAI capito? SCORDATELO![K]\nUMPF!", spanish="¡No pienso volver a ayudarte![K]\n¡Jum!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(120), false, 2) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(32), g.ViewCenter.Y+(0), 64, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Humph...", french=" Bouh...", german=" Humpf...", italian=" Uff...", spanish=" Bah..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh, now I've done it...[K] After all,\nwe weren't speaking to each other...", french="Cette fois, c'est irrécupérable...[K]\nBon, on ne se parlait déjà plus trop...", german="Oh, jetzt habe ich es doch\ngetan...[K] Eigentlich sprechen wir ja nicht mehr\nmiteinander...", italian="Oh, che sciocca sono stata...[K]\nÈ vero, era da tanto che non ci rivolgevamo\nla parola...", spanish="Jo, qué tonta, la he fastidiado\naún más...[K] Aunque ya ni nos hablábamos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But honestly, I was happy\nto see him.", french="Mais honnêtement, j'ai été\nheureuse de le voir.", german="Aber ganz im Ernst, ich war\nfroh, ihn hier zu sehen.", italian="Ma a essere onesta ero felice\ndi vederlo.", spanish="Pero tengo que admitir que\nme he puesto supercontenta al verlo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I really wanted to thank him...", french="Je voulais vraiment\nle remercier...", german=" Ich wollte ihm wirklich danken...", italian="Avrei voluto davvero\nringraziarlo...", spanish=" Quería darle las gracias..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] For some reason, I just\ncouldn't say it...", french="Mais...[K] les mots ne sont\ntout simplement pas sortis...", german="Aber...[K] Aus irgendeinem Grund\nhabe ich es einfach nicht geschafft...", italian="Però...[K] per qualche ragione\nnon ci sono riuscita...", spanish="Pero...[K] no me ha salido decírselo,\nno sé por qué..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh, forget it![K] I'm mad at myself\nfor not being able to say it...", french="Ben mince alors![K] J'aurais\ndû le lui dire...", german="Ach, vergiss es![K] Ich bin sauer\nauf mich selbst dafür, dass ich es nicht\nfertiggebracht habe...", italian="Oh, accidenti![K] Sono così\narrabbiata con me stessa per non\nessere riuscita a dirgli niente...", spanish="¡Jo, qué rabia![K] Ya me vale, mira\nque no poder decírselo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Just then...", french=" Mais enfin...", german=" Dieses Mal...", italian=" Poco fa...", spanish=" Pero, ahora que lo pienso..."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
