-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/m19a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D22P11A, 'UM19') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 392, Direction.Up, "NPC_JUPUTORU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 228, false, 2)
  GROUND:MoveToPosition(partner, 260, 260, false, 2)
  GROUND:MoveToPosition(hero, 292, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(I've had that strange sensation before...)", french="(J'ai déjà ressenti ça auparavant...)", german="(Ich hatte dieses seltsame Gefühl noch nie\nzuvor...)", italian="(Ho già provato questa sensazione...)", spanish="(Yo he sentido algo así antes...)"}) -- SwitchMonologue: branche default
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english=" Where...[K] Where are we?", french=" Où...[K] où sommes-nous?", german=" Wo...[K] Wo sind wir?", italian=" Dove...[K] siamo?", spanish=" ¿Dónde...?[K] ¿Dónde estamos?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This is [CS:P]Dusk Forest[CR].[K] Its name\ncomes from the dark fog that perpetually\nshrouds it.", french="C'est la [CS:P]Forêt Crépuscule[CR].[K]\nElle doit son nom au brouillard obscur qui\nl'enveloppe continuellement.", german="Dies ist der [CS:P]Düsterwald[CR].[K] Sein\nName rührt von dem dunklen Nebel her, der ihn\nständig einhüllt.", italian="Questa è la [CS:P]Foresta Oscura[CR]...[K]\nPrende il nome dalla nebbia oscura che\nla copre incessantemente.", spanish="Este es el [CS:P]Bosque Sombrío[CR].[K]\nSu nombre proviene de las oscuras nieblas\nque lo cubren permanentemente."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Deep in this forest...", french=" Au cœur de cette forêt...", german=" Tief in diesem Wald...", italian=" Nel cuore di questa foresta...", spanish="En lo más profundo de este\nbosque..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We should find [CS:N]Celebi[CR].", french=" ... on devrait trouver [CS:N]Celebi[CR].", german="Tief in diesem Wald sollten wir\n[CS:N]Celebi[CR] finden.", italian=" Dovremmo trovare [CS:N]Celebi[CR].", spanish=" Deberíamos encontrar a [CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" Who is [CS:N]Celebi[CR]?", french=" Qui est [CS:N]Celebi[CR]?", german=" Wer ist [CS:N]Celebi[CR]?", italian=" Chi è [CS:N]Celebi[CR]?", spanish=" ¿Quién es [CS:N]Celebi[CR]?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR] is the legendary Time\nTravel Pokémon.", french="[CS:N]Celebi[CR] est le Pokémon Temporel\nlégendaire.", german="[CS:N]Celebi[CR] ist das legendäre\nZeitreise-Pokémon.", italian="[CS:N]Celebi[CR] è il leggendario\nPokémon Tempovia.", spanish="[CS:N]Celebi[CR] es el Pokémon\nViajetiempo, un Pokémon legendario."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="She has the ability to\ncross time.", french="Elle est capable de voyager dans\nle temps.", german="Es hat die Fähigkeit, die Zeit\nzu durchqueren.", italian="Ha l'abilità di attraversare\nil tempo.", spanish="Y puede viajar de una época a\notra."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But...[K] Well, she's a little odd...", french="Le problème, c'est que...[K] voilà,\nelle est un peu bizarre...", german="Aber...[K] Na ja, es ist ein bisschen\neigen...", italian=" Ma...[K] Beh, è un po' strana...", spanish="Aunque...[K] aquí, entre nosotros,\nes un poquito rara."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But anyway...[K][CS:N]Celebi[CR]'s ability enabled\nme to go to the past.", french="Enfin bref... [K]Si j'ai pu venir\ndans le passé, c'est grâce à [CS:N]Celebi[CR].", german="Wie auch immer...[K] [CS:N]Celebi[CR] half\nmir mit seiner Fähigkeit, in die Vergangenheit\nzu reisen.", italian="Comunque...[K] L'abilità di\n[CS:N]Celebi[CR] mi ha permesso di tornare nel passato.", spanish="Aunque eso da igual.[K]\nFue la habilidad de [CS:N]Celebi[CR] lo que me permitió\nviajar al pasado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" Can we get back to our world?", french="Elle pourra nous renvoyer\ndans notre monde?", german="Kommen wir dann wieder\nin unsere Welt?", italian="Potremo tornare nel nostro\nmondo?", spanish="¿Podremos volver a nuestro\nmundo?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yes, you can go back.[K] But...", french=" Oui, elle le fera.[K] Mais...", german="Ja, ihr könnt zurückkehren.[K]\nAber...", italian=" Sì, è possibile.[K] Ma...", spanish=" Sí, podréis volver.[K] Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR] is the Pokémon that sent\nme to the past.", french="C'est [CS:N]Celebi[CR] qui m'a envoyé\ndans le passé.", german="[CS:N]Celebi[CR] ist das Pokémon, das\nmich in die Vergangenheit geschickt hat.", italian="[CS:N]Celebi[CR] è il Pokémon che\nmi ha mandato nel passato.", spanish="[CS:N]Celebi[CR] es el Pokémon que me\nenvió al pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That means [CS:N]Celebi[CR] has lent her\nsupport to reshaping history.", french="Ce qui signifie qu'elle a\ncontribué à changer le cours de l'histoire.", german="Das bedeutet, dass [CS:N]Celebi[CR] die\nVeränderung der Geschichte unterstützt hat.", italian="Questo significa che [CS:N]Celebi[CR] mi ha\naiutato a riscrivere la storia.", spanish="Eso quiere decir que [CS:N]Celebi[CR]\nme ayudó en mi intento de cambiar la historia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Wait...[K] Are you saying that\n[CS:N]Celebi[CR] could be in trouble too?", french="Attends une seconde...[K] Tu veux\ndire que [CS:N]Celebi[CR] aussi va avoir des ennuis?", german="Warte mal...[K] Willst du damit\nsagen, [CS:N]Celebi[CR] könnte auch in Schwierigkeiten\nsein?", italian="Aspetta...[K] Stai dicendo che\nanche [CS:N]Celebi[CR] potrebbe essere nei guai?", spanish="Espera un segundo...[K] ¿Eso quiere\ndecir que [CS:N]Celebi[CR] también está en apuros?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right.[K] Primal [CS:N]Dialga[CR] is\nalso targeting [CS:N]Celebi[CR].", french="Exact.[K] [CS:N]Dialga[CR] Primal va\négalement s'en prendre à elle.", german="Genau richtig.[K] [CS:N]Schatten-Dialga[CR]\nhat es auch auf [CS:N]Celebi[CR] abgesehen.", italian="È così.[K] Anche [CS:N]Celebi[CR] è nel\nmirino di [CS:N]Dialga[CR] Oscuro.", spanish="Exacto.[K] El [CS:N]Dialga Primario[CR]\ntambién anda detrás de [CS:N]Celebi[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" So there's no time to waste.", french="Alors il n'y a pas de temps\nà perdre.", german="Es gilt also, keine Zeit zu\nverlieren.", italian="Dunque non c'è tempo da\nperdere.", spanish="Así que no hay tiempo que\nperder."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Get ready soon. We have to find\n[CS:N]Celebi[CR].", french="Préparez-vous vite. Il faut\ntrouver [CS:N]Celebi[CR].", german="Macht euch bereit. Wir müssen\n[CS:N]Celebi[CR] finden.", italian="Preparatevi in fretta. Dobbiamo\ntrovare [CS:N]Celebi[CR].", spanish="Preparaos cuanto antes.\nDebemos encontrar a [CS:N]Celebi[CR]."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
