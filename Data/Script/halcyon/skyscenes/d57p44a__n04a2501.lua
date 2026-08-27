-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P44A/n04a2501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_KIMAWARI
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 236, 260, false, 2)
    -- GAP: se_Play(9993) — id SE NDS sans portage PMDO identifié
    -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- CallCommon CORO_JUMP_SURPRISE_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(5) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:MoveToPosition(hero, 208, 260, false, 2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GROUND:MoveToPosition(hero, 264, 260, false, 2)
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
    GROUND:MoveToPosition(hero, 236, 260, false, 2)
    local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 240, 200, Direction.Down, "NPC_GOOSUTO")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_goosuto, 4) end)
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(164, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D57P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 240, Direction.Up, "NPC_DOGOOMU")
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Loudred[CR]! Are you all right?!", french=" [CS:N]Ramboum[CR]! Tu vas bien?!", german="[CS:N]Krakeelo[CR]! Ist alles in\nOrdnung?!?", italian=" [CS:N]Loudred[CR]! Tutto bene?!", spanish=" ¡[CS:N]Loudred[CR]! ¡¿Estás bien?!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Ow! Hot hot hot hot hot!", french="... Aouah! C'est chaud c'est chaud\nc'est chaud c'est chaud c'est chaud!", german=" ...Au! Heißheißheißheiß!", italian=" ... Ahia! BruciaBruciaBrucia!", spanish=" ¡Ay...! ¡Quema, quema, quema!"})
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Y-you're LATE, [CS:Y]SUNFLORA[CR]!", french="T-tu es en RETARD,\n[CS:Y]HELIATRONC[CR]!", german=" G-GANZ schön SPÄT, [CS:Y]Sonnflora[CR]!", italian=" S-Sei in RITARDO, [CS:Y]SUNFLORA[CR]!", spanish="Has tardado lo tuyo,\n[CS:Y]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="While I was WAITING for you\nto ARRIVE...", french=" En ATTENDANT que tu ARRIVES...", german="WÄHREND ich auf DEINE Ankunft\nGEWARTET habe...", italian="Mentre ASPETTAVO che\ntu ARRIVASSI...", spanish=" Mientras esperaba que llegaras..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I've been FIGHTING here ALL by\nMYSELF this WHOLE time!", french="... je me suis BATTU tout SEUL\ntout ce TEMPS!", german="Da HABE ich die GANZE ZEIT\nallein GEGEN die gekämpft!", italian="Ho LOTTATO da SOLO TUTTO\nquesto TEMPO!", spanish="¡Me ha tocado luchar a mí solito\ntodo este tiempo!"})
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Heh heh![K] The one who doesn't\nlearn has come back for another lesson!", french="Hé hé![K] La mauvaise élève est\nrevenue pour une nouvelle leçon!", german="Hehehe![K] Wer nicht dazulernt,\nkommt für eine weitere Lektion zurück!", italian="Eh eh![K] La nostra zuccona è\ntornata per avere un'altra lezione!", spanish="¡Je, je![K] La que nunca aprende\nha vuelto a por otra lección."})
  -- message_Close
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" All right!", french=" Qu'il en soit ainsi!", german=" Alles klar!", italian=" Va bene!", spanish=" ¡Pues muy bien!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="You asked for it! We'll defeat\nyou again, and this time...", french="Vous l'aurez voulu! On va vous\nbattre à nouveau, et cette fois-ci...", german="Du hast es so gewollt. Wir\nwerden dich noch mal besiegen. Und dieses\nMal...", italian="Te la sei cercata!\nTi sconfiggeremo di nuovo\ne questa volta...", spanish="¡Vosotros lo habéis querido! Os\nderrotaremos de nuevo, pero esta vez..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" We'll defeat you so thoroughly...", french=" ... votre défaite sera si lourde...", german=" Da machen wir es gründlich.", italian=" Ti daremo una lezione tale...", spanish=" Os venceremos de tal manera..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="That you'll be scared to ever\ncome after us again!", french="... que vous n'aurez plus jamais\nle courage de venir nous défier à nouveau!", german="Du wirst es nicht wagen, uns\nnoch einmal herauszufordern!", italian="... che non oserai mai più\ndarci la caccia!", spanish="¡Que se os quitarán las ganas de\nvolver más a por nosotros!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
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
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Here they COME, [CS:Y]SUNFLORA[CR]!", french=" Attention, [CS:Y]HELIATRONC[CR]!", german=" Sie GREIFEN an, [CS:Y]SONNFLORA[CR]!", italian=" Eccoli che ARRIVANO, [CS:Y]SUNFLORA[CR]!", spanish=" Vienen a por nosotros, [CS:Y]Sunflora[CR]."})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(164, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
