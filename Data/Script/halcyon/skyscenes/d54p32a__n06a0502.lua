-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P32A/n06a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND4) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D54P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 224, Direction.Down, "NPC_PUKURIN")
  -- SetAnimation(25) [anim idle native]
  GAME:FadeIn(30)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 96, 264, Direction.Right, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 200, 260, false, 2)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 56, 232, Direction.Right, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 168, 228, false, 2)
  GROUND:MoveToPosition(hero, 144, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- message_FacePositionOffset(0, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" S-someone's...[K]unconscious!", french="Il y a quelqu'un...[K] par terre,\nsans connaissance!", german=" J-jemand ist...[K] bewusstlos!", italian=" C'è qualcuno...[K] privo di sensi!", spanish=" Hay... alguien...[K] ¡inconsciente!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(368, 248, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_saanaito, 372, 260, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_chaaremu, 332, 228, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 368, 252, false, 2)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Left)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]He's not moving...", french="...[K] Il est parfaitement\nimmobile...", german=" ...[K]Er bewegt sich nicht...", italian=" ...[K] Non si muove...", spanish=" Hum...[K] No se mueve..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Not moving...[K] It can't be...", french=" Immobile...[K] Serait-il...", german="Bewegungslos...[K]\nDas kann doch nicht sein...", italian=" Non si muove...[K] Non è possibile...", spanish=" No me digas...[K] No puede..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Huh?![K] Oh, no! Is he...?", french="Hein?![K] Oh, non! Dites-moi que\nce n'est pas vrai...?", german=" Was...[K] Oh nein! Ist er...", italian=" Uh?![K] Oh no! Che...?", spanish=" ¡¿Qué?![K] ¡No! ¿Está...?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="But...[K] He's not moving at all![K]\nOh, no!", french="Oh...[K] pas le moindre\nmouvement![K] Oh, non!", german="Aber...[K] Er bewegt sich gar nicht![K]\nOh nein!", italian="Ma...[K] non si muove\nassolutamente![K] Oh no!", spanish="Pero...[K] No se mueve nada.[K]\n¡Oh, no!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR]? [CS:N]Gardevoir[CR]?[K]\nWhat do we do? What do we do?!", french="[CS:Y]Lockpin[CR]? [CS:N]Gardevoir[CR]?[K]\nQu'est-ce qu'on fait? Qu'est-ce qu'on fait?!", german="[CS:Y]Schlapor[CR]? [CS:N]Guardevoir[CR]?[K]\nWas machen wir jetzt? Was machen wir\njetzt?!?", italian="[CS:Y]Lopunny[CR]? [CS:N]Gardevoir[CR]?[K]\nCosa facciamo?! Cosa facciamo?!", spanish="¿[CS:Y]Lopunny[CR]? ¿[CS:N]Gardevoir[CR]?[K]\n¡¿Qué hacemos, qué hacemos?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(10245) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]Guuuuuuuu!", french="[CN]Guuuuuuuu!", german="[CN]Guuuuuuuu!", italian="[CN]Guuuuuuuu!", spanish="[CN]¡Guuuuuuuu!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Th-that sound again!", french=" Encore ce bruit!", german="Sch-schon wieder dieses\nGeräusch!", italian=" D-Di nuovo quel rumore!", spanish=" ¡O... otra vez ese ruido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We heard it come from\nover here...", french=" Ça vient de là-bas...", german="Wir haben doch gehört, dass\nes von hier kam...", italian=" Proviene da lì...", spanish=" Parece provenir de allí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10245) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CN]Guuuuuuuu!", french="[CN]Guuuuuuuu!", german="[CN]Guuuuuuuu!", italian="[CN]Guuuuuuuu!", spanish="[CN]¡Guuuuuuuu!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweatdrop", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-is that from...?", french=" Est-ce que ça vient de...?", german=" K-kommt das von...", italian=" C-Che sia...?", spanish=" ¿Vi... viene de...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It looks like he just passed out\nfrom starvation...", french="On dirait qu'il est juste tombé\nd'inanition...", german="Anscheinend ist er gerade vor\nHunger ohnmächtig geworden...", italian="Sembra che sia svenuto\nper la fame...", spanish="Parece que se ha desmayado\npor el hambre..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]...[K]try giving him one\nof those...", french="[CS:N]Charmina[CR]...[K] donne-lui-en\nune...", german="[CS:N]Meditalis[CR]...[K] Versuch ihm mal\neinen davon zu verabreichen...", italian="[CS:N]Medicham[CR]...[K] prova a dargli\nuna di queste...", spanish="[CS:N]Medicham[CR]...[K] Prueba a darle\nuna de esas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Got it.[K] I'll put it down and see.", french="D'accord.[K] Je vais la poser\nà côté de lui. On verra bien.", german="Alles klar.[K] Ich kümmere mich\num ihn und dann sehen wir mal weiter.", italian="Ok.[K] La metto qui e vediamo\ncosa succede.", spanish="Vale.[K] La dejaré aquí,\na ver qué pasa."})
  -- message_Close
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-8), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]Next to the unconscious Pokémon,\n[CN][CS:N]Medicham[CR] placed...", french="[CN]A côté du Pokémon évanoui,\n[CN][CS:N]Charmina[CR] dépose...", german="[CN][CS:N]Meditalis[CR] legt etwas neben\n[CN]das ohnmächtige Pokémon...", italian="[CN]Di fianco al Pokémon svenuto,\n[CN][CS:N]Medicham[CR] mette...", spanish="[CN]Al lado del Pokémon inconsciente,\n[CN][CS:N]Medicham[CR] dejó..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]An extraordinarily delicious\n[CN]Perfect Apple.", french="[CN]... une irrésistible Pomme Parfaite,\n[CN]juteuse et sucrée à souhait.", german="[CN]Einen außergewöhnlich leckeren\n[CN]Perfekten Apfel!", italian="[CN]... una meravigliosa e succulenta\n[CN]Mela Perfetta.", spanish="[CN]Una Manzana Perfecta\n[CN]increíblemente deliciosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Ooogh...", french=" ...[K] Ooooooh...", german=" ...[K]Uuuuff...", italian=" ...[K] Ooogh...", spanish=" Uf...[K] Uf..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Ooogh...", french=" Aaargh...", german=" Uuuuff...", italian=" Ooogh...", spanish=" Uf..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Wh-what's...?[K] This smell...", french=" Qu'est-ce...?[K] Quel délicieux parfum...", german=" W-was...[K] Dieser Geruch...", italian=" C-Cos'è...?[K] Questo profumo...", spanish=" ¿Qué... es...?[K] Ese olor..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="This delicious...[K] It's a tiny bit sour...[K]\nBut of course sweet...", french="Fort appétissant...[K] Un poil acidulé...[K]\nMais néanmoins sucré...", german="Wie lecker...[K] Ein kleines bisschen sauer...[K]\nAber ganz sicher süß...", italian="È delizioso...[K] Leggermente aspro...[K]\nMa comunque dolcissimo...", spanish="Es delicioso...[K] Es un pelín ácido...[K]\nA la vez que dulce, claro..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" This smell!", french=" Ce parfum!", german=" Was für ein Geruch!", italian=" Questo profumo!", spanish=" ¡Ese olor!"})
  -- message_Close
  -- GAP: se_Play(10246) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I knew it! [K]A Perfect Apple! ♪", french=" Je le savais![K] Une Pomme Parfaite! ♪", german=" Ich wusste es![K] Ein Perfekter Apfel! ♪", italian=" Lo riconosco! [K]È una Mela Perfetta! ♪", spanish=" ¡Lo sabía![K] ¡Una Manzana Perfecta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- bgm2_PlayFadeIn(BGM_EATING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(7) [anim idle native]
  SkySceneKit.say({english="[CN]Crunch munch! Chomp chomp! Gobble gulp!\n[CN]Crunch munch! Chomp chomp! Gobble gulp!", french="[CN]Cronch cronch! Miam miam! Slurp slurp!\n[CN]Cronch cronch! Miam miam! Slurp slurp!", german="[CN]Stopf-schling! Schmatz! Schlabber-schlürf!\n[CN]Stopf-schling! Schmatz! Schlabber-schlürf!", italian="[CN]Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\n[CN]Gnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="[CN]¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n[CN]¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="[CN]Crunch munch! Chomp chomp! Gobble gulp!\n[CN]Crunch munch! Chomp chomp! Gobble gulp!", french="[CN]Cronch cronch! Miam miam! Slurp slurp!\n[CN]Cronch cronch! Miam miam! Slurp slurp!", german="[CN]Stopf-schling! Schmatz! Schlabber-schlürf!\n[CN]Stopf-schling! Schmatz! Schlabber-schlürf!", italian="[CN]Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\n[CN]Gnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="[CN]¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n[CN]¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- Destroy() [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Pwah![K] Thank you so much![K]\nIt was REALLY delicious! ♪", french="Youpi![K] Merci beaucoup![K]\nC'était succulentissime! ♪", german="Puuuh![K] Oh, vielen, vielen Dank![K]\nDas war WIRKLICH lecker! ♪", italian="Aaah![K] Grazie mille![K]\nEra DAVVERO squisita! ♪", spanish="¡Puf![K] ¡Muchísimas gracias![K]\n¡Estaba deliciosa de verdad! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Thank you! ♪[K] I'm feeling better\nthanks to you!", french="Merci, amies de moi! ♪[K] Je me sens bien\nmieux grâce à vous!", german="Vielen Dank! ♪[K] Dank euch fühle ich\nmich so viel besser!", italian="Vi sono riconoscente! ♪[K] Grazie al vostro\naiuto, mi sento molto meglio!", spanish="¡Gracias! ♪[K] Me siento mucho mejor,\n¡y todo gracias a vosotras!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Perfect Apples are my\nnumber-one-favorite food! ♪", french="Les Pommes Parfaites sont mon plat\npréféré! ♪", german="Perfekte Äpfel sind mein\nabsolutes Lieblingsessen! ♪", italian="Le Mele Perfette sono il mio cibo\npreferito! ♪", spanish="¡Las Manzanas Perfectas son\nmi alimento preferido! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Y-you like Perfect Apples\nthat much...?", french=" Tu les aimes à ce point...?", german="M-magst du Perfekte Äpfel\nwirklich so sehr?", italian="T-Ti piacciono così tanto\nle Mele Perfette...?", spanish="¿Ta... tanto te gustan\nlas Manzanas Perfectas...?"})
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Here, you can have mine too.", french=" Tiens, je t'en donne une aussi.", german="Hier, dann kannst du auch\nmeinen haben.", italian=" Ecco, puoi avere anche la mia.", spanish=" Pues toma también la mía."})
  -- message_Close
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" R-really?!", french=" V-vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¡¿En... En serio?!"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN][CS:Y]Lopunny[CR] gave the mysterious Pokémon\n[CN]a Perfect Apple!", french="[CN][CS:Y]Lockpin[CR] donne une Pomme Parfaite\n[CN]au mystérieux Pokémon!", german="[CN][CS:Y]Schlapor[CR] gibt dem mysteriösen Pokémon\n[CN]einen Perfekten Apfel!", italian="[CN][CS:Y]Lopunny[CR] dà una Mela Perfetta\n[CN]al Pokémon misterioso!", spanish="[CN][CS:Y]Lopunny[CR] le dio al Pokémon misterioso\n[CN]una Manzana Perfecta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Thank you so much! ♪", french=" Merci de tout cœur! ♪", german=" Oh, vielen Dank! ♪", italian=" Ti ringrazio tantissimo! ♪", spanish=" ¡Muchísimas gracias! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay! ♪", french=" Youpla! ♪", german=" Juchhu! ♪", italian=" Evviva! ♪", spanish=" ¡Yupi! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We're the treasure hunters--\nTeam [CS:X]Charm[CR]!", french="Nous sommes les chasseuses de\ntrésor de l'Equipe [CS:X]Charme[CR]!", german="Wir sind die Schatzjäger von\nTeam [CS:X]Charme[CR]!", italian="Noi siamo le cacciatrici\ndi tesori... Siamo il Team [CS:X]Malia[CR]!", spanish="Somos buscadoras de tesoros...\n¡El [CS:X]Equipo Carisma[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" And you are?", french=" Et toi, tu es?", german=" Und wer bist du?", italian=" E tu chi sei?", spanish=" ¿Y tú eres...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep. ♪[K] I'm [CS:N]Wigglytuff[CR].", french=" Youpla! ♪[K] Je m'appelle [CS:N]Grodoudou[CR].", german=" Ach, genau. ♪[K] Ich bin [CS:N]Knuddeluff[CR].", italian=" Oh. ♪[K] Io mi chiamo [CS:N]Wigglytuff[CR].", spanish=" ¡Chachi! ♪[K] Yo soy [CS:N]Wigglytuff[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm the first apprentice of the\nexplorer [CS:N]Armaldo[CR].", french="Je suis le premier apprenti de\nl'explorateur [CS:N]Armaldo[CR].", german="Ich bin der erste Lehrling des\ngroßen Erkunders [CS:N]Armaldo[CR].", italian="Sono il primo apprendista\ndell'esploratore [CS:N]Armaldo[CR].", spanish="Soy el primer aprendiz del\nexplorador [CS:N]Armaldo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]?[K] Nice to meet you.", french=" [CS:N]Grodoudou[CR]?[K] Enchantée.", german="[CS:N]Knuddeluff[CR]?[K]\nSchön, dich kennenzulernen.", italian="[CS:N]Wigglytuff[CR], hai detto?[K]\nPiacere di conoscerti.", spanish=" ¿[CS:N]Wigglytuff[CR]?[K] Encantada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've never heard of the explorer\n[CS:N]Armaldo[CR]...", french="Je n'ai jamais entendu parler\nd'un explorateur du nom d'[CS:N]Armaldo[CR]...", german="Von einem Erkunder namens\n[CS:N]Armaldo[CR] habe ich noch nie gehört...", italian="Non ho mai sentito parlare\ndell'esploratore [CS:N]Armaldo[CR]...", spanish="Nunca había oído hablar\ndel explorador [CS:N]Armaldo[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="But...[K] If you say you're an\nexplorer's apprentice...", french="Mais...[K] si tu es vraiment\nun apprenti explorateur...", german="Aber...[K] Wenn du sagst, dass\ndu ein Erkunder-Lehrling bist...", italian="Ma...[K] se dici di essere\nil suo apprendista...", spanish="Pero...[K] Si eres el aprendiz\nde un explorador, como dices..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Don't tell me you're also looking\nfor the treasure in the quarry?", french="Ne me dis pas que toi aussi\ntu cherches le trésor de la carrière...", german="Sag bloß, dass du auch\nauf den Schatz im Steinbruch aus bist?", italian="Ehi! Non starai mica cercando\nil tesoro della cava anche tu?", spanish="¿No me digas que tú también\nestás buscando el tesoro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I-it's no joke!", french=" Sans rire!", german=" A-aber sicher!", italian=" G-Guarda che non è uno scherzo!", spanish=" Ya... ¡Ya puedes ir olvidándote!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We're the ones who are going to\nfind that treasure!", french="C'est nous qui allons mettre la\nmain sur le trésor!", german="Wir sind diejenigen, die diesen\nSchatz finden werden!", italian="Siamo noi che metteremo le mani\nsu quel tesoro!", spanish="¡Ese tesoro lo vamos\na encontrar nosotras!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Treasure?[K] What are you\ntalking about?", french=" Un trésor?[K] Quel trésor?", german=" Schatz?[K] Wovon sprecht ihr?", italian=" Tesoro?[K] Di cosa state parlando?", spanish="¿Qué tesoro?[K] ¿Pero de qué\nme habláis?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I was just taking a walk\nthrough here, that's all.", french="Je faisais juste une petite\nbalade dans le coin, voilà tout.", german="Ich habe nur einen Spaziergang\ngemacht, das ist alles.", italian="Stavo solo facendo una\npasseggiata da queste parti, tutto qua.", spanish="Yo solo estaba dando un paseo,\nnada más."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And then, suddenly all my food\nitems were stolen by someone...", french="Et soudain, on m'a volé tous\nmes aliments...", german="Aber plötzlich war meine ganze\nVerpflegung weg! Gestohlen...", italian="Poi qualcuno mi ha\nimprovvisamente rubato tutte le\nprovviste di cibo che avevo...", spanish="De repente, alguien me robó\ntodos los objetos y la comida..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And I got really hungry and used\nup all my strength...", french="J'étais affamé et à bout\nde forces...", german="Dann bekam ich einen riesigen\nHunger und meine Kräfte schwanden.", italian="Mi è venuta una gran fame\ne ho consumato tutte le mie energie...", spanish="Estaba famélico, así que me fui\nquedando sin fuerzas..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And passed out here.\nThat's all. ♪", french="... et j'ai fini par m'évanouir ici.\nVoilà, vous savez tout. ♪", german="Mir wurde schwarz vor Augen.\nDas ist alles. ♪", italian="Così ho perso i sensi e sono\nsvenuto. È tutto. ♪", spanish="Hasta que me desmayé aquí.\nY eso es todo. ♪"})
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweatdrop", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Oh...[K] Is that it...?", french=" Oh...[K] Vraiment...?", german=" Oh...[K] So ist das also...", italian=" Oh...[K] Sul serio...?", spanish=" Ah...[K] ¿Eso es todo?..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" If that's it, that's fine...", french=" Si tu le dis...", german="Wenn das so ist, ist ja alles\nin Ordnung.", italian=" Se è così, non c'è problema...", spanish=" Si es así, vale..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" He's such a strange explorer...", french=" Quel étrange explorateur...", german="Was für ein sonderbarer\nErkunder...", italian=" Che strano esploratore...", spanish=" Qué explorador tan peculiar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Well, let's hurry on ahead.", french=" Bon, ne perdons pas de temps.", german="Nun gut, lasst uns schnell\nweiterziehen.", italian=" Forza, dobbiamo proseguire.", spanish=" Bueno, pues vamos a seguir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="See you later, [CS:N]Wigglytuff[CR].[K]\nTake care!", french="A plus, [CS:N]Grodoudou[CR].[K]\nFais attention à toi!", german="Also bis dann, [CS:N]Knuddeluff[CR].[K]\nPass auf dich auf!", italian="A presto, [CS:N]Wigglytuff[CR].[K]\nAbbi cura di te!", spanish=" Nos vemos, [CS:N]Wigglytuff[CR].[K] ¡Cuídate!"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(24), p.Y+(24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(104), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Bye-bye!", french=" Bye bye!", german=" Auf Wiedersehen!", italian=" Ciao ciao!", spanish=" ¡Adiós!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(88), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  -- SetAnimation(46) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Thanks again, so much! ♪[K]\nFriendly friends!", french=" Encore merci! ♪[K] Amies de moi!", german="Vielen Dank noch einmal! ♪[K]\nLiebe Freunde!", italian="Grazie ancora, di cuore! ♪[K]\nAmiche care!", spanish="¡Muchas gracias de nuevo! ♪[K]\n¡Amigas! ¡Amigas! ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 5 -- $COMPULSORY_SAVE_POINT_SIDE = 5 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
