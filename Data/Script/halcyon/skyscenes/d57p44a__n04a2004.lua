-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P44A/n04a2004.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_KIMAWARI
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
    -- CallCommon CORO_JUMP_SURPRISE_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(5) [anim idle native]
    SkySceneKit.lock(6) -- Lock(6) NDS
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
    local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 240, 216, Direction.Down, "NPC_GOOSUTO")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_goosuto, 4) end)
    SkySceneKit.lock(7) -- Lock(7) NDS
    GAME:WaitFrames(1) -- hold
  end)
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D57P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(45) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:WaitFrames(30)
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(15)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: se_Play(9993) — id SE NDS sans portage PMDO identifié
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K] Hot hot hot hot\nhot hot hot hot hot hot hot hot!!!", french="Ben mince alors![K] C'est chaud\nc'est chaud c'est chaud c'est chaud c'est chaud!", german="Auweia![K] Heißheißheißheißheiß\nheißheißheißheißheißheißheißheißheißheiß!!!", italian="Shock![K] BRUCIABRUCIABRUCIA\nBRUCIABRUCIABruciaBruciaBruciaBrucia\nBRUCIABRUCIABRUCIA!!!", spanish="¡Aaaaayyy![K] ¡¡¡Quema, quema,\nquema, quema, quema, quema, quema!!!"})
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Heh heh heh![K] This is the\n[CS:P]Spring Cave Pit[CR]...", french="Hé hé hé![K] Nous sommes\nau fond de la [CS:P]Caverne Source[CR]...", german="Hehehe![K] Dies ist die\n[CS:P]Quellhöhlengrube[CR]...", italian="Eh eh eh![K] Questa è\nla [CS:P]Voragine Sorgente[CR]...", spanish="¡Je, je, je![K] Estamos en la\n[CS:P]Sima Fuente[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Lava flows directly\nbeneath here.", french="Sous le sol, des rivières\nde lave s'écoulent.", german=" Direkt unter uns fließt Lava.", italian=" Qui sotto scorre della lava.", spanish="Hay lava fluyendo justo\npor debajo de nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="You've been incredibly\npersistent.", french="Tu as fait preuve d'une\nobstination rare.", german="Du bist wirklich unglaublich\nhartnäckig gewesen.", italian=" Sapevamo quanto fossi testarda.", spanish=" Has sido increíblemente tenaz."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Knowing that, we ran here!", french="C'est pour ça que nous avons\nchoisi de nous réfugier ici!", german="Deswegen sind wir\nhierhergelaufen!", italian=" Così siamo venuti qui!", spanish=" Por eso vinimos aquí."})
  -- message_Close
  local npc_npc_goosuto2 = SkySceneKit.spawn_npc("haunter", 208, 192, Direction.Down, "NPC_GOOSUTO2")
  GROUND:MoveToPosition(npc_npc_goosuto2, 204, 212, false, 1)
  GAME:WaitFrames(5)
  local npc_npc_goosuto3 = SkySceneKit.spawn_npc("haunter", 272, 192, Direction.Down, "NPC_GOOSUTO3")
  GROUND:MoveToPosition(npc_npc_goosuto3, 268, 212, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="It's the best place to knock out\nGrass-type Pokémon like you!", french="Il n'y a pas de meilleur endroit\npour mettre K.O. un Pokémon de type Plante!", german="Das ist nun mal der beste Ort,\num sich eines Pflanzen-Pokémon wie dir\nzu entledigen!", italian="È il posto migliore per\nsconfiggere i Pokémon di tipo Erba\ncome te!", spanish="¡Es el mejor sitio para tumbar a\nPokémon de tipo Planta como tú!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Brace yourself!", french=" Prépare-toi!", german=" Mach dich bereit!", italian=" Preparati!", spanish=" ¡Prepárate!"})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitLockLives
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
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" Ben mince alors!", german=" Auweia!", italian=" Shock!", spanish=" ¡Jo, qué fuerte!"})
  GAME:WaitFrames(15)
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(7180) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 240, Direction.Up, "NPC_DOGOOMU")
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  -- message_CloseEnforce
  GAME:FadeIn(15)
  GAME:WaitFrames(15)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-8), 3, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_goosuto.Position; GROUND:MoveToPosition(npc_npc_goosuto, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto2, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_goosuto2.Position; GROUND:MoveToPosition(npc_npc_goosuto2, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto3, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_goosuto3.Position; GROUND:MoveToPosition(npc_npc_goosuto3, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_ONE_FOR_ALL_ALL_FOR_ONE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Huch!", italian=" Uh?!", spanish=" ¡¿Eh?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect 692 — VFX sans émote PMDO équivalente
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]L[CR]-[CS:N]Loudred[CR]!", french=" [CS:N]R[CR]-[CS:N]Ramboum[CR]!", german=" [CS:N]K-Krakeelo[CR]!", italian=" [CS:N]L-Loudred[CR]!", spanish=" ¡[CS:N]Lo[CR]... [CS:N]Loudred[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Are you ALL RIGHT, [CS:Y]Sunflora[CR]?", french=" TOUT va BIEN, [CS:Y]Héliatronc[CR]?", german=" ALLES in ORDNUNG, [CS:Y]Sonnflora[CR]?", italian=" Stai BENE, [CS:Y]Sunflora[CR]?", spanish=" ¿Estás bien, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh? Whaaat?[K] What are you\ndoing here?", french="Hein? Quoiiii?[K] Qu'est-ce que tu\nfais ici?", german="Wie? Waaas?[K]\nWas machst du hier?", italian=" Eh? Cooosa?[K] Che ci fai qui?", spanish="¿Eh? ¿Quéeee?[K]\n¿Pero qué haces tú aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" FORGET that!", french=" OUBLIE ça!", german=" DAS ist jetzt EGAL!", italian=" Non c'è TEMPO adesso!", spanish=" ¡Eso da igual!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Here they COME![K] Look OUT!", french="On PARLERA plus TARD![K]\nATTENTION!", german=" PASS auf![K] Da KOMMEN sie!", italian="Stanno per ATTACCARCI![K]\nFai ATTENZIONE!", spanish=" ¡Ya vienen![K] ¡Cuidado!"})
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
  SkySceneKit.say({english=" That is...hot hot hot hot hot!", french="C'est... chaud c'est chaud\nc'est chaud c'est chaud c'est chaud!", german="GANZ schön... heißheißheißheiß\nheißheißheißheißheißheißheißheißheißheiß!", italian=" BRUCIABRUCIABRUCIABRUCIA!", spanish=" Uf... ¡Quema, quema, quema!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- message_Close
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-48), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(96), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-96), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(96), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(164, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
