-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P09C/n04a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_KIMAWARI
    -- SetAnimation(44) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(2) [anim idle native]
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
    pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    GROUND:EntTurn(hero, Direction.UpLeft)
    -- CallCommon CORO_JUMP_SURPRISE_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
    GROUND:MoveToPosition(hero, 244, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GROUND:MoveToPosition(hero, 212, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 228, 156, false, 2)
    local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 208, 128, Direction.Up, "NPC_CHIRIIN")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
    SkySceneKit.lock(7) -- Lock(7) NDS
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
    pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    SkySceneKit.lock(8) -- Lock(8) NDS
    -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
    pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    SkySceneKit.lock(9) -- Lock(9) NDS
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
    GROUND:MoveToPosition(hero, 244, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GROUND:MoveToPosition(hero, 212, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    end
    end
    -- @label_2 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 228, 156, false, 2)
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- CallCommon CORO_HEAD_SHAKE_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(11) -- Lock(11) NDS
    -- @label_5 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- GAP: SetEffect 438 — VFX sans émote PMDO équivalente
    GROUND:MoveToPosition(hero, 244, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GROUND:MoveToPosition(hero, 212, 156, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    end
    end
    -- @label_4 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 212, 156, false, 2)
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
    SkySceneKit.lock(12) -- Lock(12) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P09C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  -- bgm2_PlayFadeIn(BGM_OCEAN2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Hey, [CS:Y]Sunflora[CR], look.[K] The moon\ntonight is really pretty.", french="Hé, [CS:Y]Héliatronc[CR], regarde.[K] La lune\nest vraiment belle ce soir.", german="Hey, [CS:Y]Sonnflora[CR], sieh mal.[K]\nDer Mond sieht heute wirklich toll aus.", italian="Ehi [CS:Y]Sunflora[CR], guarda![K]\nLa luna è davvero bellissima stasera.", spanish="Eh, [CS:Y]Sunflora[CR], mira.[K] Hoy la luna\nestá preciosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Huh?[K] [CS:Y]Sunflora[CR]?", french=" Hein?[K] [CS:Y]Héliatronc[CR]?", german=" Huch![K] [CS:Y]Sonnflora[CR]?", italian=" Uh?[K] [CS:Y]Sunflora[CR]?", spanish=" ¿Me escuchas?[K] ¿[CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chiriin, 228, 124, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" What are you doing?", french=" Qu'est-ce que tu fais?", german=" Was machst du da?", italian=" Che stai facendo?", spanish=" ¿Qué haces?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Huh?[K] You're writing something!", french=" Hein?[K] Tu écris quelque chose!", german=" Was?[K] Du schreibst etwas!", italian=" Uh?[K] Stai scrivendo qualcosa!", spanish="No me haces ni caso, chica...[K]\n¿Qué estás escribiendo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh![K] D-don't look!", french="Ben mince alors![K]\nN-ne regarde pas!", german=" Auweia![K] N-nicht gucken!", italian=" Shock![K] N-Non guardare!", spanish=" ¡Oyeee![K] No... ¡No mires, porfa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm so embarrassed!", french=" C'est super gênant!", german=" Das ist mir ja so peinlich!", italian=" Oh, che imbarazzo!", spanish=" ¡Jo, qué corte!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K]\nOh my gosh![K]\nOh my gosh!", french="Mince alors![K] Mince alors![K]\nMince alors!", german="Auweia![K]\nAuweia![K]\nAuweia!", italian=" Shock![K] Shock![K] Shock!", spanish="¡Si lo llegas a ver, me da algo![K]\n¡Qué nerviooos![K] ¡Pero qué nerviooos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Wh-what?", french=" Q-quoi?", german=" W-was?", italian=" C-Cosa?", spanish=" Qué... ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh! Don't tell me!", french=" Oh! Ne me dis pas!", german=" Ah! Jetzt verstehe ich!", italian=" Oh! Non mi dire!", spanish=" ¡Ah, no me lo digas!"})
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I know![K] You just started\nkeeping a diary, right, [CS:Y]Sunflora[CR]?", french="J'y suis![K] Tu as commencé à\ntenir un journal intime, pas vrai, [CS:Y]Héliatronc[CR]?", german="Das muss es sein![K] Du hast\nangefangen, ein Tagebuch zu führen. Nicht\nwahr, [CS:Y]Sonnflora[CR]?", italian="Ho capito![K] Hai iniziato a tenere\nun diario, vero, [CS:Y]Sunflora[CR]?", spanish="¡Ya sé![K] Has empezado a escribir\nun diario, ¿verdad, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Pues sí! ¡Jo, qué lista eres!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" To reflect on my day...", french="Pour méditer sur les\névénements de la journée...", german="Um einen vergangenen Tag\nnoch einmal Revue passieren zu lassen...", italian="D'ora in poi, per riflettere su\nquel che mi succede durante la giornata...", spanish="Quería reflexionar sobre mi día\na día..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've decided to start keeping a\ndiary from now on!", french=" ... j'ai décidé de tenir un journal!", german="Aus diesem Grund habe ich mich\ndazu entschlossen, von nun an ein Tagebuch\nzu führen!", italian="... ho deciso di scrivere\nun diario!", spanish="¡Así que he decidido empezar\na escribir un diario!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm incredibly embarrassed\nabout it...", french="Mais c'est super gênant,\ntout ça...", german="Das ist mir irgendwie\nunglaublich peinlich...", italian="Sono così imbarazzata all'idea\ndi averne uno...", spanish=" Me da muchísima vergüenza..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyway...[K] I'll do my best\nto write in it!", french="Mais bon...[K] Je ferai de mon\nmieux pour y écrire tous les jours!", german="Aber ich stelle mich bloß an...[K]\nIch werde versuchen, jeden Tag etwas\nhineinzuschreiben!", italian="Comunque...[K] farò del mio meglio\nper tenerlo aggiornato!", spanish="En fin...[K] ¡Escribiré lo mejor\nque sepa mis memorias literarias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That's wonderful![K] Do your best,\n[CS:Y]Sunflora[CR]!", french="C'est merveilleux![K]\nBonne chance, [CS:Y]Héliatronc[CR]!", german="Das ist großartig![K]\nGib dein Bestes, [CS:Y]Sonnflora[CR]!", italian="È meraviglioso![K] Buon\ndivertimento, [CS:Y]Sunflora[CR]!", spanish="¡Qué maravilla![K] ¡Dalo todo,\n[CS:Y]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Don't worry, I promise not to\nsneak any peeks at it!", french="Ne t'en fais pas, je te promets\nde ne pas le lire.", german="Und mach dir keine Sorgen, ich\nwerde nicht versuchen, heimlich darin zu\nlesen!", italian="Non preoccuparti, prometto che\nnon sbircerò!", spanish="Tranquila, te prometo que no le\necharé ningún vistacillo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="S-sneak a peek?![K] That's not\nallowed. Not at all!", french="Le lire?![K]\nJ'espère bien! C'est interdit de chez interdit!", german="H-heimlich darin lesen?!?[K]\nDas ist nicht erlaubt. Ganz und gar nicht!", italian="S-Sbirciare?![K] Assolutamente no.\nÈ vietato!", spanish="¡¿Echar... un vistazo?![K] Ni se\nte ocurra. ¡O sea, para nada!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-if someone sneaked a peek...", french=" S-si quelqu'un le lisait...", german="W-wenn es jemand heimlich\nlesen würde...", italian="S-Se qualcuno dovesse sbirciare\nnel mio diario...", spanish=" Si... Si alguien lo viera..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh! Oh my gosh!\nOh my gosh! Oh my gosh! Oh my gosh!", french="Ben mince alors! Mince alors!\nMince alors! Mince alors! Mince alors!", german="Auweia! Auweia!\nAuweia! Auweia! Auweia!", italian="Shock! Shock! Shock! Shock!\nShock! Shock! Shock! Shock! Shock! Shock!", spanish="¡Aaayyyy! ¡Qué corte! ¡Qué corte!\n¡Qué corte! ¡Pero qué corteee!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]Well...[K] If it's only\na little peek...?", french="...[K] Bon...[K] en même temps,\nsi c'est juste une page?", german="...[K]Nun...[K] Und wenn es nur ein\nganz kurzes Durchblättern wäre?", italian="...[K] Beh...[K] forse se si tratta solo\ndi una sbirciatina...", spanish="Aunque...[K] Bueno...[K] ¿Y si solo\nfuera un vistacito chiquitín?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Nope![K] No good!", french=" Non![K] Pas question!", german=" Nein![K] Gar nicht gut!", italian=" No, no![K] Mai!", spanish=" ¡Huy, no![K] ¡Qué va!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's just no good!", french=" C'est juste hors de question!", german=" Das ist einfach nicht gut!", italian=" Non si può!", spanish=" ¡O sea, es que no, vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm too embarrassed![K]\nOh my gosh!", french="C'est hyper-gênant![K]\nMince alors!", german=" Viel zu peinlich![K] Auweia!", italian="Oh, che imbarazzo![K]\nShock!", spanish="¡Me da demasiado corte![K]\n¡Jo, qué fuerte sería!"})
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
