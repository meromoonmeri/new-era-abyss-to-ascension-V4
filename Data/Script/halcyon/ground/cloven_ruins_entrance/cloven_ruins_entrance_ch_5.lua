--[[
    cloven_ruins_entrance_ch_5.lua
    Chapitre 5 (Finale de l'Expédition) : Le Campement des Ruines Fendues
    Modele : mount_windswept_entrance_ch_5 (campement du Mont Venteux)

    STRUCTURE EN PLUSIEURS PARTIES (template du Mont) :
      ArrivalCutscene  -> le duo arrive, le camp est deja etabli
      CampNightfall    -> LE repas + la veillee + le coucher + la nuit
      MorningCutscene  -> le briefing matinal + le depart vers les ruines

    ROUTEUR MODULAIRE (init.lua) : la scene se joue une seule fois
    (SV.Chapter5.ReachedClovenRuins), que le joueur arrive au ch5
    (finale de l'expedition) ou au ch7 (entree des Ruines Tordues).

    QUALITE : meme gabarit que le Mont Venteux.
      * le camp est DEFINIT PAR SON FOYER (CAMP_X/CAMP_Y) ;
      * 14 paillasses en fer a cheval (12 membres + le duo), posees
        seulement a la nuit (DeployBeds), autour d'un feu anime ;
      * places de repas en cercle autour du feu (MEALS) ;
      * coucher un par un, respiration desynchronisee ;
      * garde de nuit (Phileas veille) ;
      * reveil au matin, briefing, cri de ralliement.
    Positions verifiees libres / atteignables / hors statue Kangourex
    (633,738) et hors passage vers la porte du donjon (718,634) : le
    camp est au SUD de la statue, l'axe statue->porte reste degage.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

cloven_ruins_entrance_ch_5 = {}

--------------------------------------------------------------------
-- LE CAMP EST DEFINIT PAR RAPPORT A SON FOYER.
-- Reproduit le patron du Mont : un point d'origine unique (le feu),
-- et tout le reste (paillasses, places de repas) en decalage.
--------------------------------------------------------------------
cloven_ruins_entrance_ch_5.CAMP_X = 664
cloven_ruins_entrance_ch_5.CAMP_Y = 836
local CX = cloven_ruins_entrance_ch_5.CAMP_X
local CY = cloven_ruins_entrance_ch_5.CAMP_Y

-- STATUE KANGOUREX (Kangaskhan_Rock, 621,726,24x24 -> centre 633,738)
-- et PORTE DU DONJON (Dungeon_Entrance, 670,618,96x32 -> centre 718,634).
-- Le camp est au SUD de la statue ; l'axe statue->porte reste libre.
cloven_ruins_entrance_ch_5.STATUE = { X = 633, Y = 738 }
cloven_ruins_entrance_ch_5.PORTE  = { X = 718, Y = 634 }

-- LES 14 COUCHAGES, en fer a cheval autour du feu, ouverts au nord
-- (vers la statue et la porte). Valeurs verifiees : sol libre 3x3,
-- atteignables depuis le spawn, >= 70 px de la statue, >= 66 px de la
-- porte, >= 48 px entre deux paillasses.
cloven_ruins_entrance_ch_5.BEDS = {
    {CX - 104, CY -  68},  -- 1 Tropius
    {CX - 104, CY -  20},  -- 2 Noctowl
    {CX - 104, CY +  28},  -- 3 Flygon
    {CX -  56, CY +  60},  -- 4 Altaria
    {CX -   8, CY +  60},  -- 5 Shinx
    {CX +  56, CY +  60},  -- 6 Phanpy
    {CX +  88, CY +  12},  -- 7 Vulpix
    {CX + 120, CY -  36},  -- 8 Mareep
    {CX + 136, CY -  84},  -- 9 Zorua
    {CX + 120, CY - 132},  -- 10 Growlithe
    {CX +  72, CY - 132},  -- 11 Zigzagoon
    {CX +  24, CY - 148},  -- 12 Natu
    {CX -  40, CY -   4},  -- 13 HERO
    {CX +  40, CY -   4},  -- 14 PARTNER
}

-- LES 14 PLACES DE REPAS, en cercle autour du feu (rayon ~56-60 px).
cloven_ruins_entrance_ch_5.MEALS = {
    {CX -  44, CY -  56},  -- Tropius
    {CX -  24, CY -  60},  -- Noctowl
    {CX +   0, CY -  64},  -- Flygon
    {CX +  24, CY -  60},  -- Altaria
    {CX +  44, CY -  56},  -- Shinx
    {CX +  52, CY -  16},  -- Phanpy
    {CX +  44, CY +  24},  -- Vulpix
    {CX +  24, CY +  28},  -- Mareep
    {CX +   0, CY +  32},  -- Zorua
    {CX -  24, CY +  28},  -- Growlithe
    {CX -  44, CY +  24},  -- Zigzagoon
    {CX -  52, CY -  16},  -- Natu
    {CX -  32, CY -  16},  -- HERO
    {CX +  32, CY -  16},  -- PARTNER
}

--------------------------------------------------------------------
-- DECOR : paillasses + feu (+ son bloqueur), meme patron que le Mont
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local anims = GAME:GetCurrentGround().Decorations[0].Anims
    for i = anims.Count - 1, 0, -1 do
      anims:RemoveAt(i)
    end
  end)
  cloven_ruins_entrance_ch_5.RemoveFireBlocker()
end

function cloven_ruins_entrance_ch_5.AddFireBlocker()
  pcall(function()
    cloven_ruins_entrance_ch_5.RemoveFireBlocker()
    local blocker = RogueEssence.Ground.GroundObject(
      RogueEssence.Content.ObjAnimData("", 1),
      RogueElements.Rect(CX + 6, CY + 6, 24, 24),
      RogueElements.Loc(0, 0),
      false,
      "Campfire_Blocker")
    blocker:ReloadEvents()
    GAME:GetCurrentGround():AddTempObject(blocker)
    cloven_ruins_entrance_ch_5.fireBlocker = blocker
  end)
end

function cloven_ruins_entrance_ch_5.RemoveFireBlocker()
  pcall(function()
    local b = cloven_ruins_entrance_ch_5.fireBlocker
    if b ~= nil then
      GAME:GetCurrentGround():RemoveTempObject(b)
      cloven_ruins_entrance_ch_5.fireBlocker = nil
    end
  end)
end

-- Camp de jour : le feu anime, centre du camp.
function cloven_ruins_entrance_ch_5.BuildCampDay()
  cloven_ruins_entrance_ch_5.PurgeDecor()
  local ground = GAME:GetCurrentGround()
  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  ground.Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(CX, CY)))
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end

-- Camp du matin : feu eteint (calque vide), axe degage.
function cloven_ruins_entrance_ch_5.BuildCampMorning()
  cloven_ruins_entrance_ch_5.PurgeDecor()
end

-- Deploiement des couchages, la nuit seulement : 14 paillasses + feu.
function cloven_ruins_entrance_ch_5.DeployBeds()
  cloven_ruins_entrance_ch_5.PurgeDecor()
  local ground = GAME:GetCurrentGround()
  local hay_bed  = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  for _, b in ipairs(cloven_ruins_entrance_ch_5.BEDS) do
    ground.Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(b[1], b[2])))
  end
  ground.Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(CX, CY)))
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end

--------------------------------------------------------------------
-- LE CAMPEMENT — 12 membres de l'expedition
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.SetupGround()
  local npcs = CharacterEssentials.MakeCharactersFromList({
    {"Tropius",   660, 680, Direction.Down},
    {"Noctowl",   696, 688, Direction.DownLeft},
    {"Flygon",    632, 704, Direction.Right},
    {"Altaria",   712, 696, Direction.Left},
    {"Shinx",     640, 736, Direction.UpRight},
    {"Phanpy",    664, 736, Direction.Up},
    {"Vulpix",    696, 736, Direction.UpLeft},
    {"Mareep",    616, 760, Direction.Right},
    {"Zorua",     640, 760, Direction.UpRight},
    {"Growlithe", 680, 760, Direction.UpLeft},
    {"Zigzagoon", 712, 760, Direction.Left},
    {"Natu",      736, 736, Direction.Left}
  })
  cloven_ruins_entrance_ch_5.CAMP_NPCS = npcs
  for _, c in ipairs(npcs) do
    GAME:GetCurrentGround():AddTempChar(c)
  end
end

--------------------------------------------------------------------
-- PARTIE 1 : L'ARRIVEE — le lieu d'abord, puis le duo
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.ArrivalCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  UI:ResetSpeaker()

  --LE NOIR AVANT TOUT (correctif d'arrivee, patron 2026-07-30).
  pcall(function() GAME:FadeOut(false, 1) end)

  -- Etablir le lieu d'abord (grammaire : le lieu avant les personnages).
  GAME:MoveCamera(670, 690, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(40)
  SOUND:PlayBGM("In the Depths of the Pit.ogg", true)
  GAME:WaitFrames(30)

  cloven_ruins_entrance_ch_5.SetupGround()
  local penticus = cloven_ruins_entrance_ch_5.CAMP_NPCS[1]
  local phileas  = cloven_ruins_entrance_ch_5.CAMP_NPCS[2]
  local hyko     = cloven_ruins_entrance_ch_5.CAMP_NPCS[3]

  -- Le duo entre par le sud, vers le camp.
  GROUND:TeleportTo(hero, 656, 720, Direction.Up)
  GROUND:TeleportTo(partner, 680, 720, Direction.Up)

  -- Concret -> Abstrait -> Decision (grammaire cinématique).
  -- 1. Constat sensoriel : la roche froide, la fin du vent.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Le vent est tombé d'un coup...[pause=15] L'air est si calme sous ces voûtes de pierre.")
  GAME:WaitFrames(10)

  -- 2. Reaction affective & poids de l'histoire (Penticus).
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Nous y sommes.[pause=15] Les Ruines Fendues... le dernier palier de notre grande expédition.")
  UI:WaitShowDialogue("Ces pierres ont résisté aux siècles pour abriter le Cœur régional le plus profond.")
  GAME:WaitFrames(15)

  -- Reactivite en cascade : le duo leve les yeux vers l'entree.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(10)

  -- 3. Decision : on s'installe.
  UI:SetSpeaker(phileas)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Le campement est établi.[pause=15] Reposez-vous bien ce soir, car la descente s'annonce longue.")
  GAME:WaitFrames(20)

  -- LA VEILLEE — le camp mange, puis s'endort (patron du Mont).
  cloven_ruins_entrance_ch_5.CampNightfall(hero, partner)
end

--------------------------------------------------------------------
-- PARTIE 2 : LA VEILLEE — repas, histoires, coucher, nuit
-- (une seule fonction orchestratrice, comme CampNightfall du Mont)
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.CampNightfall(hero, partner)
  local npcs = cloven_ruins_entrance_ch_5.CAMP_NPCS
  local penticus = npcs[1]
  local phileas  = npcs[2]
  local hyko     = npcs[3]
  local bram     = npcs[4]   -- Altaria
  local volt     = npcs[5]   -- Shinx

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  UI:ResetSpeaker()

  pcall(function() GAME:FadeOut(false, 1) end)

  -- Le feu brille au centre du camp.
  cloven_ruins_entrance_ch_5.BuildCampDay()
  GROUND:TeleportTo(hero, 656, 720, Direction.Up)
  GROUND:TeleportTo(partner, 680, 720, Direction.Up)
  GAME:MoveCamera(CX, CY - 40, 1, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM("Cave Camp.ogg", true)
  GAME:WaitFrames(30)

  -- Chacun rejoint sa place autour du feu (MEALS), en cascade.
  local seats = {}
  for i, c in ipairs(npcs) do
    local m = cloven_ruins_entrance_ch_5.MEALS[i]
    seats[#seats+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(i * 3)
      pcall(function() GROUND:MoveToPosition(c, m[1], m[2], false, 1) end)
    end)
  end
  TASK:JoinCoroutines(seats)
  GAME:WaitFrames(20)

  -- Le repas : on s'installe autour du feu. Le lieu est deja pose.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Un feu,[pause=15] un toit de pierre,[pause=10] et toute l'expédition autour.[pause=15] On est bien, ici.")
  GAME:WaitFrames(10)

  -- Penticus fait le point sur la descente de demain (concret -> abstrait).
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Demain,[pause=10] nous descendons.[pause=15] Ces ruines ne nous feront pas de cadeau.")
  UI:WaitShowDialogue("Chacun connaît son rôle.[pause=10] Ce soir,[pause=10] on reprend des forces.")
  GAME:WaitFrames(15)

  -- Un jeune (Volt/Shinx) pose la question que tout le monde se fait.
  UI:SetSpeaker(volt)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Maître...[pause=15] Et si le Cœur,[pause=10] là-dessous,[pause=10] était déjà... éteint ?")
  GAME:WaitFrames(10)

  -- Phileas répond, érudit (il a inspecté les cartes).
  UI:SetSpeaker(phileas)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Les cartes anciennes parlent d'une lueur,[pause=10] pas d'un vide.[pause=15] Nous verrons demain.")
  GAME:WaitFrames(20)

  -- La veillee se termine : on envoie tout le monde dormir.
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Assez parlé.[pause=15] Repos pour tous.[pause=10] La descente commence à l'aube.")
  GAME:WaitFrames(15)

  -- LA NUIT TOMBE : on deroule les 14 paillasses sous le noir.
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(20)
  cloven_ruins_entrance_ch_5.DeployBeds()
  GROUND:AddMapStatus("darkness")
  GAME:WaitFrames(10)

  -- Texte de transition sur le noir, puis rallumage.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Les sacs s'ouvrent,[pause=10] les couchages se déroulent autour du feu.[pause=15] Quatorze paillasses, une expédition.")
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(15)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- Le duo, une derniere pensee avant la descente.
  GeneralFunctions.HeroDialogue(hero, "(Demain,[pause=10] on descend.[pause=15] Et si le Cœur nous attend vraiment là-dessous...)")
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Tu y penses aussi,[pause=10] hein ?[pause=15] À ce qui nous attend sous nos pieds.")
  GAME:WaitFrames(10)
  GeneralFunctions.HeroDialogue(hero, "(Oui.[pause=10] Mais on ne rentre pas à moitié chemin.[pause=15] Demain,[pause=10] on saura.)")
  GAME:WaitFrames(20)

  -- Le coucher un par un, respiration desynchronisee.
  local sleepOrder = {
    {npcs[1], 0}, {npcs[2], 14}, {npcs[3], 26}, {npcs[4], 40},
    {npcs[5], 52}, {npcs[6], 66}, {npcs[7], 80}, {npcs[8], 94},
    {npcs[9], 108}, {npcs[10], 122}, {npcs[11], 136}, {npcs[12], 150},
  }
  local vers = {}
  for i, s in ipairs(sleepOrder) do
    local chara, delay = s[1], s[2]
    local b = cloven_ruins_entrance_ch_5.BEDS[i]
    vers[#vers+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(delay)
      pcall(function()
        GROUND:MoveToPosition(chara, b[1] + 20, b[2] + 20, false, 1)
        GROUND:CharSetAnim(chara, "Sleep", true)
      end)
    end)
  end
  -- Phileas (Noctowl) prend le premier tour de garde : il monte au nord,
  -- entre les dormeurs et la statue/porte, et regarde le camp.
  vers[#vers+1] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    pcall(function()
      GeneralFunctions.EightWayMove(npcs[2], 688, 636, false, 1)
      GROUND:CharAnimateTurnTo(npcs[2], Direction.Down, 4)
    end)
  end)
  TASK:JoinCoroutines(vers)
  GAME:WaitFrames(20)

  -- Le duo se couche en dernier, sur leurs paillasses (13 et 14).
  local b13 = cloven_ruins_entrance_ch_5.BEDS[13]
  local b14 = cloven_ruins_entrance_ch_5.BEDS[14]
  pcall(function() GROUND:MoveToPosition(hero, b13[1] + 20, b13[2] + 20, false, 1) end)
  pcall(function() GROUND:MoveToPosition(partner, b14[1] + 20, b14[2] + 20, false, 1) end)
  GeneralFunctions.HeroDialogue(hero, "(Demain,[pause=10] on saura.[pause=15] Et quoi qu'il arrive,[pause=10] on l'aura fait ensemble.)")
  GAME:WaitFrames(20)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(30)

  -- La camera derive au-dessus du camp endormi ; Phileas pique du bec.
  SOUND:FadeOutSE('AMB_Fire_Loud', 90)
  local cam1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(CX, CY + 30, 90, false)
    GAME:MoveCamera(CX, CY - 120, 110, false)
  end)
  local cam2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(120)
    pcall(function()
      GROUND:CharSetAction(npcs[2], RogueEssence.Ground.FrameGroundAction(
        npcs[2].Position, npcs[2].Direction,
        RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
    end)
    GAME:WaitFrames(25)
    pcall(function() GROUND:CharEndAnim(npcs[2]) end)
  end)
  TASK:JoinCoroutines({cam1, cam2})
  GAME:WaitFrames(20)

  -- La nuit passe.
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(40)

  -- La scene est terminee : on pose le drapeau de fin d'intro.
  SV.Chapter5.ReachedClovenRuins = true
  -- L'aube arrive : on retire le noir, on rouvre sur le matin.
  GROUND:RemoveMapStatus("darkness")
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  GAME:CutsceneMode(false)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  end
end

--------------------------------------------------------------------
-- PARTIE 3 : LE MATIN — briefing + depart vers les ruines
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.MorningCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  UI:ResetSpeaker()

  pcall(function() GAME:FadeOut(false, 1) end)

  cloven_ruins_entrance_ch_5.SetupGround()
  cloven_ruins_entrance_ch_5.BuildCampMorning()
  local penticus = cloven_ruins_entrance_ch_5.CAMP_NPCS[1]
  local phileas  = cloven_ruins_entrance_ch_5.CAMP_NPCS[2]
  local hyko     = cloven_ruins_entrance_ch_5.CAMP_NPCS[3]

  GROUND:TeleportTo(hero, 656, 720, Direction.Up)
  GROUND:TeleportTo(partner, 680, 720, Direction.Up)

  GAME:MoveCamera(CX, CY - 40, 1, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM("Heartwarming.ogg", true)
  GAME:WaitFrames(30)

  -- Briefing matinal au seuil des Ruines.
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Bonjour à tous ![pause=15] C'est le jour solennel de notre descente finale.")
  UI:WaitShowDialogue("Le mystère de ce lieu nous tend les bras.[pause=15] Explorez ensemble, veillez les uns sur les autres !")
  GAME:WaitFrames(10)

  -- Cri de ralliement d'expedition.
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Shouting")
  UI:WaitShowDialogue("Expédition de Metano...[pause=15] En avant !")
  GAME:WaitFrames(15)

  local cheer = {}
  for i, c in ipairs({partner, hero}) do
    cheer[#cheer+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(i * 3)
      GeneralFunctions.Hop(c, "Idle", 8, 20, 0, false)
    end)
  end
  TASK:JoinCoroutines(cheer)
  GAME:WaitFrames(20)

  SV.TemporaryFlags.MorningAddress = false
  GAME:CutsceneMode(false)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  end
end

--------------------------------------------------------------------
-- DIALOGUES INTERACTIFS DES MEMBRES AU CAMP
--------------------------------------------------------------------
function cloven_ruins_entrance_ch_5.Tropius_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "Le Cœur régional des Ruines Fendues est le joyau de notre expédition.[pause=15] Soyez prudents.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance_ch_5.Noctowl_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "J'ai inspecté les cartes anciennes.[pause=15] Ces ruines descendent très profondément.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance_ch_5.Flygon_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "Je reste ici pour coordonner le relais.[pause=15] Allez-y, je veille sur l'entrée.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

return cloven_ruins_entrance_ch_5
