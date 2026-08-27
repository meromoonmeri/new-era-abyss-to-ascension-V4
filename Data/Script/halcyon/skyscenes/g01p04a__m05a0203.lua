-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m05a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- ResetHitAttribute(31) [neutre/état moteur]
    -- SetAnimation(3) [anim idle native]
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM05') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's all. Do you understand\nwhat this mission entails?", french="Voilà. Vous avez compris en quoi\nconsiste votre mission?", german="Das ist alles. Versteht ihr,\nworum es bei der Mission geht?", italian="È tutto. Avete capito quali sono\ngli obiettivi della missione?", spanish="Eso es todo. ¿Entendéis el objetivo\nde la misión?"})
  do local __choice = SkySceneKit.ask({{english="Understood", french="Compris!", german="Verstanden", italian="Tutto chiaro", spanish="¡Pues claro!"}, {english="Please explain again", french="Tu pourrais réexpliquer?", german="Bitte noch mal erklären", italian="Spiega di nuovo", spanish="Explícalo de nuevo"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkyProg.set(6, 2) -- $SCENARIO_MAIN = scn[6,2] (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Good! ♪", french=" Bien! ♪", german=" Gut! ♪", italian=" Ottimo! ♪", spanish=" Bien. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, I'll leave you all to\nthoroughly investigate the waterfall! ♪", french="Allez, je vous laisse partir pour\nl'exploration de la cascade! ♪", german="In Ordnung, dann überlasse ich\neuch nun die gründliche Erkundung des\nWasserfalls! ♪", italian="Bene, vi lascio alla vostra\nminuziosa ispezione della cascata! ♪", spanish="Tendréis que investigar a fondo\nesa cascada. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Huh? What's wrong?\nYou're shivering.", french="Mais... qu'y a-t-il? On dirait\nque tu trembles.", german="Was? Stimmt etwas nicht? Du\nzitterst ja.", italian="Eh? C'è qualcosa che non va?\nStai tremando.", spanish="¿Eh? ¿Qué pasa?\nEstás temblando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" A-are you all right?", french=" Tout va bien?", german=" B-bist du in Ordnung?", italian=" S-Stai bene?", spanish=" ¿Te encuentras bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup. I'm OK. It's just the\nanticipation that's making me nervous.", french="Oui. Ça va. C'est juste que\nje brûle d'impatience. J'attendais ça\ndepuis si longtemps!", german="Ja. Alles okay. Ich bin nur\naufgeregt wegen der Erkundung.", italian="Sì. Sto bene. È solo l'attesa\nche mi rende un po' nervoso.", spanish="Sí. No pasa nada. Es solo que\nme entran nervios antes de explorar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes. I'm OK. It's just the\nanticipation that's making me nervous.", french="Oui. Ça va. C'est juste que\nje brûle d'impatience. J'attendais ça\ndepuis si longtemps!", german="Ja. Alles okay. Ich bin nur\naufgeregt wegen der Erkundung.", italian="Sì. Sto bene. È solo l'attesa\nche mi rende un po' nervoso.", spanish="Sí. No pasa nada. Es solo que\nme entran nervios antes de explorar."})
  else
  SkySceneKit.say({english="Yep. I'm OK. It's just the\nanticipation that's making me nervous.", french="Oui. Ça va. C'est juste que\nje brûle d'impatience. J'attendais ça\ndepuis si longtemps!", german="Ja. Alles okay. Ich bin nur\naufgeregt wegen der Erkundung.", italian="Sì. Sto bene. È solo l'attesa\nche mi rende un po' nervosa.", spanish="Sí. No pasa nada. Es solo que\nme entran nervios antes de explorar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This will be our first real job\nas an exploration team.", french="C'est notre première vraie\nmission en tant qu'équipe d'exploration.", german="Das ist unser erster echter\nJob als Erkundungsteam.", italian="Questa sarà la nostra prima\nvera missione come squadra d'esplorazione.", spanish="Esta será nuestra primera\nmisión de verdad como equipo explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This will be the first time we\nget to do a real job as an exploration team.", french="C'est notre première vraie\nmission en tant qu'équipe d'exploration.", german="Das wird unser erster richtiger\nJob als Erkundungsteam sein.", italian="Questa sarà la nostra prima\nvera missione come squadra d'esplorazione.", spanish="Esta será nuestra primera\nmisión de verdad como equipo explorador."})
  else
  SkySceneKit.say({english="This will be our first real job\nas an exploration team.", french="C'est notre première vraie\nmission en tant qu'équipe d'exploration.", german="Das wird unser erster richtiger\nJob als Erkundungsteam sein.", italian="Questa sarà la nostra prima\nvera missione come squadra d'esplorazione.", spanish="Esta será nuestra primera\nmisión de verdad como equipo explorador."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm feeling a little worked up...", french=" Je suis dans tous mes états...", german=" Ich bin ein bisschen angespannt.", italian=" Sono un po' emozionato...", spanish=" Estoy emocionado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm feeling a little worked up...", french=" Je suis dans tous mes états...", german=" Ich bin ein bisschen angespannt.", italian=" Sono un po' emozionato...", spanish=" Estoy emocionado."})
  else
  SkySceneKit.say({english=" I'm getting a bit emotional...", french=" Je suis dans tous mes états...", german="Ich bin deswegen ein bisschen\naufgekratzt.", italian=" Sono un po' emozionata...", spanish=" Estoy emocionada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah! I might just burst from\nthe excitement!", french="Oh! Comme c'est palpitant!\nJ'ai l'impression que ma tête va exploser!", german="Jaaa! Ich könnte vor Spannung\nplatzen!", italian="Sì! Sto per scoppiare\ndall'emozione!", spanish="¡Sí! ¡Me siento muy animado\ncon esta misión!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, I feel like I'm going to burst\nfrom excitement!", french="Oh! Comme c'est palpitant!\nJ'ai l'impression que ma tête va exploser!", german="Ach, ich könnte vor Spannung\nplatzen!", italian="Sì! Sto per scoppiare\ndall'emozione!", spanish="¡Sí! ¡Me siento muy animado\ncon esta misión!"})
  else
  SkySceneKit.say({english="Ooh... I'm bubbling over\nwith excitement!", french="Oh! Comme c'est palpitant!\nJ'ai l'impression que ma tête va exploser!", german="Uuh... Ich platze gleich vor\nAufregung!", italian="Sì! Sto per scoppiare\ndall'emozione!", spanish="¡Sí! ¡Me siento muy animada\ncon esta misión!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do this right, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german=" Wir schaffen das, [hero]!", italian="Facciamo le cose per bene,\n[hero]!", spanish="¡Vamos a hacer las cosas\nbien, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german=" Wir schaffen das, [hero]!", italian="Facciamo le cose per bene,\n[hero]!", spanish="¡Hagámoslo lo mejor que\npodamos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german=" Wir schaffen das, [hero]!", italian="Facciamo le cose per bene,\n[hero]!", spanish="¡Hagámoslo lo mejor que\npodamos, [hero]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 1 -- dungeon_mode(6) = DMODE_OPEN (ROM)
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Fine, I'll explain it again.", french="Bon, je vais vous expliquer\nencore une fois.", german=" Gut, ich erkläre es noch einmal.", italian="D'accordo, ve lo spiegherò\ndi nuovo.", spanish=" Vale, lo explicaré otra vez."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let me see your Wonder Map.", french="Faites-moi voir votre Carte\nMiracle.", german=" Zeigt mir eure Wunderkarte.", italian="Fatemi vedere la vostra Mappa\ndelle meraviglie.", spanish=" Enseñadme el Mapa Mágico."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN][hero] opened\n[CN]the Wonder Map.", french="[CN][hero] ouvre\n[CN]la Carte Miracle.", german="[CN][hero] öffnet\n[CN]die Wunderkarte.", italian="[CN][hero] apre\n[CN]la Mappa delle meraviglie.", spanish="[CN][hero] abrió\n[CN]el Mapa Mágico."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
