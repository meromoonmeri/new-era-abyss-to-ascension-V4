-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/s31a2401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 24) -- $SCENARIO_MAIN = scn[29,24] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 360, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh! I can see the tunnel![K]\nWe're almost to the 7th Station Clearing!\nJust a little more!", french="Oh! J'aperçois la sortie![K]\nEncore un effort et nous atteindrons la\ntrouée du 7[F:E] Relais!", german="Oh, ich kann den Tunnel sehen![K]\nWir haben die 7. Zwischenlagerlichtung fast\nerreicht! Nur noch ein kleines Stück!", italian="Oh! Vedo il tunnel![K]\nSiamo in prossimità del Bivacco 7!\nAncora un piccolo sforzo!", spanish="¡Ah, ya veo el túnel![K]\n¡Ya casi hemos llegado a la Base del Séptimo\nPuerto! ¡Hagamos un último esfuerzo!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P27A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P27A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 176, 192, Direction.Down, "NPC_NYUURA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 192, 168, Direction.DownLeft, "NPC_KUCHIITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 184, 216, Direction.Up, "NPC_GOORIKII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 152, 216, Direction.UpRight, "NPC_KINOGASSA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 276, false, 2)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 308, false, 2) end end
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sheimi, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Wow, Team [CS:X]Frontier[CR]\nsure are quick...", french="Waouh, l'Equipe [CS:X]Eclaireurs[CR]\nest vraiment rapide...", german="Wow, Team [CS:X]Grenzland[CR]\nist ganz schön schnell...", italian="Wow, il Team [CS:X]Pioniere[CR]\nè proprio veloce...", spanish="Caray, qué velocidad la del\n[CS:X]Equipo Frontera[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 24, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(7)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2)
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sheimi, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" What happened?!", french=" Que s'est-il passé?!", german=" Was ist passiert?!?", italian=" Che cos'è successo?", spanish=" ¡¿Qué ha ocurrido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-56), 37, false) end) -- waypoint caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-32), g.ViewCenter.Y+(0), 21, false) end) -- waypoint caméra
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(0), p.Y+(-48), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(-16), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-48), false, 2) end -- waypoint MovePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 212, false, 2) end end
  GAME:WaitFrames(2)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 244, false, 2) end end
  GROUND:EntTurn(npc_npc_sheimi, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I don't know, he had fainted\nbefore we got here...", french="Je ne sais pas, il était déjà\ninconscient quand nous sommes arrivés...", german="Kann ich nicht sagen. Er war\nschon ohnmächtig, als wir hier ankamen...", italian="Non lo so, era già in questo\nstato quando siamo arrivati...", spanish="Ni idea. Ya estaba debilitado\ncuando llegamos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kinogassa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I don't know if it's because of\nthe cold or because he ran out of items,\nbut I do know this is dangerous.", french="Difficile de dire si c'est à cause\ndu froid ou parce qu'il n'avait plus d'objets,\nmais ceci est très préoccupant.", german="Ich weiß nicht, ob wegen der\nKälte oder weil er alle Items aufgebraucht\nhat. Auf jeden Fall ist er in Gefahr.", italian="Non so se sia stato a causa\ndel freddo o perché ha finito gli strumenti,\nma di certo questo posto è molto pericoloso.", spanish="No sé si habrá sido por el frío\no si se quedaría sin objetos, pero lo que sé\nes que esto es peligroso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" This isn't good at all...", french=" Ce n'est pas bon du tout...", german=" Das ist wirklich nicht gut...", italian=" Non va bene per niente...", spanish=" Esto no pinta nada bien..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" I'll go get help.", french=" Je vais chercher de l'aide.", german=" Ich werde Hilfe holen.", italian=" Vado a cercare aiuto.", spanish=" Iré a buscar ayuda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kuchiito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_goorikii, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Huh? Who are you going to call\nfor help?!", french="Hein? Et qui comptes-tu appeler\nà l'aide?", german="Wie bitte? Wen willst du denn\nzur Hilfe rufen?!?", italian=" Eh? E chi vorresti chiamare?!", spanish="¿Cómo? Pero... ¡¿a quién vas\na pedir ayuda?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="There's a rescue expert at the\n8th Station Clearing.", french="Il y a un pro du sauvetage\nà la trouée du 8[F:E] Relais.", german="Ein Experte für Bergrettung lebt\nauf der 8. Zwischenlagerlichtung.", italian="Al Bivacco 8 c'è un esperto di\nsoccorsi.", spanish="Hay un experto en rescates en\nla Base del Octavo Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We don't call him for the little\nthings, but emergencies are different.", french="On ne le dérange pas pour des\nbroutilles, mais les urgences, c'est différent.", german="Bei kleinen Vorfällen rufen wir\nihn nicht, aber Notfälle sind etwas anderes.", italian="Di solito non lo disturbiamo\nper delle sciocchezze, solo per situazioni\nd'emergenza.", spanish="Normalmente no le molestaríamos\npor una nimiedad, pero esto es una emergencia."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Could you please keep an eye on\n[CS:N]Sneasel[CR], Team [CS:X]Frontier[CR]?", french="Pourriez-vous garder un œil sur\n[CS:N]Farfuret[CR], Equipe [CS:X]Eclaireurs[CR]?", german="Könntet ihr auf [CS:N]Sniebel[CR]\nachtgeben, Team [CS:X]Grenzland[CR]?", italian="Potreste dare un'occhiata\na [CS:N]Sneasel[CR], Team [CS:X]Pioniere[CR]?", spanish="¿Os importa echarle un vistazo\na [CS:N]Sneasel[CR], [CS:X]Equipo Frontera[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" We're going ahead!", french=" Nous, on continue!", german=" Wir machen uns auf den Weg!", italian=" Noi andiamo avanti!", spanish=" ¡Así nos adelantamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" I see. We're counting on you!", french=" Soit. On compte sur vous!", german=" Klaro. Wir zählen auf euch!", italian=" Va bene. Contiamo su di voi!", spanish="De acuerdo, contamos\ncon vuestra ayuda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_sheimi, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Let's hurry, [player]!", french=" Dépêchons-nous, [player]!", german="Wir müssen uns beeilen,\n[player]!", italian=" Sbrighiamoci, [player]!", spanish=" ¡Deprisa, [player]!"})
  -- message_Close
  -- GAP: BGM BGM_SKY_PEAK_SNOWFIELD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.cleanup_npcs()
end
