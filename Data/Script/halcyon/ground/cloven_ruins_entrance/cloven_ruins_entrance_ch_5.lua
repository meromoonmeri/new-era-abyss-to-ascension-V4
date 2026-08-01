--[[
    cloven_ruins_entrance_ch_5.lua
    Ruines Fendues (Aegis Cave) — Chapitre 5, climax de l'expedition
    ================================================================
    Apres la victoire sur Tornadus (Mont Venteux), l'expedition etablit
    un campement DEVANT l'entree des Ruines Fendues — pas de retour a
    Metano entre les deux (option 2 validee). C'est la respiration
    narrative avant le donjon final du chapitre 5.

    Structure en 4 actes, calquee sur le gabarit valide du camp du
    Mont Venteux (PLAN_cinematique_campement_windsep.md) :
      Acte 1 — Arrivee devant les Ruines, rassemblement
      Acte 2 — Repas + BRIEFING STRATEGIQUE autour du feu (le cœur :
               chacun partage ce qu'il sait, hypotheses sur les Ruines,
               doutes vs moral, le mystere qui s'assemble)
      Acte 3 — Coucher + reve de Gardevoir (bascule hero_dream)
      Acte 4 — Lendemain matin : lever du soleil, preparations,
               entree dans les Ruines Fendues (climax du ch5)

    Regles appliquees (non negociables) :
      - fondus a chaque changement de configuration majeure ;
      - OST propre par acte (verifiee presente dans Content/Music/) ;
      - le silence est un outil de mise en scene ;
      - budget de personnages respecte (l'expedition au complet) ;
      - deplacements reels, pas de teleportation ;
      - pensées du heros courtes, jamais de narration omnisciente ;
      - la Voix (uE040) ABSENTE de cette scene — echange entre
        personnages uniquement (directive "boss/personnages parlent").
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_entrance_ch_5 = {}

-- ================================================================
-- GEOMETRIE DU CAMP — tout derive du foyer (pattern Mont Venteux)
-- ================================================================
cloven_ruins_entrance_ch_5.CAMP_X = 570
cloven_ruins_entrance_ch_5.CAMP_Y = 800

local CX = cloven_ruins_entrance_ch_5.CAMP_X
local CY = cloven_ruins_entrance_ch_5.CAMP_Y

-- Les 12 places assises du briefing (cercle autour du feu), verifiees
-- sol libre sur la grille d'obstacles. Ordre : Penticus au sud (face
-- au sentier d'arrivee), puis horaire.
cloven_ruins_entrance_ch_5.SEATS = {
  {CX +  0, CY + 64},  -- 1  Penticus (sud, face au sentier)
  {CX - 42, CY + 56},  -- 2  Phileas
  {CX - 66, CY + 32},  -- 3  Coco
  {CX - 74, CY +  0},  -- 4  Rin
  {CX - 66, CY - 40},  -- 5  Almotz
  {CX - 42, CY - 64},  -- 6  Hyko
  {CX +  0, CY - 72},  -- 7  Kino (nord, face au feu)
  {CX + 30, CY - 64},  -- 8  Reinier
  {CX + 54, CY - 40},  -- 9  Shuca
  {CX + 70, CY +  0},  -- 10 Ganlon
  {CX + 54, CY + 16},  -- 11 partner
  {CX + 30, CY + 56},  -- 12 hero
}

-- Les 12 paillasses (deployees la nuit seulement), verifiees libres.
cloven_ruins_entrance_ch_5.BEDS = {
  {CX - 90, CY - 110}, {CX - 30, CY - 120}, {CX + 30, CY - 120}, {CX + 90, CY - 110},
  {CX + 120, CY - 50}, {CX + 120, CY + 10}, {CX + 86, CY + 56}, {CX + 30, CY + 80},
  {CX - 30, CY + 80}, {CX - 90, CY + 60}, {CX - 120, CY + 10}, {CX - 120, CY - 50},
}

-- Positions d'ouverture des PNJ (camp de jour, avant le rassemblement),
-- verifiees libres et a l'ecart des places assises.
local OPEN_POS = {
  Penticus = {464, 800},
  Phileas  = {480, 744},
  Coco     = {544, 704},
  Rin      = {632, 688},
  Hyko     = {664, 840},
  Almotz   = {656, 768},
  Kino     = {608, 904},
  Reinier  = {512, 904},
}

-- ================================================================
-- DECOR DU CAMP (feu, paillasses) — pattern Mont Venteux
-- ================================================================
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

-- Camp de jour : feu + materiel, AUCUNE paillasse (elles n'existent
-- qu'apres la transition jour -> soir, comme au Mont Venteux).
function cloven_ruins_entrance_ch_5.BuildCampDay()
  cloven_ruins_entrance_ch_5.PurgeDecor()
  local ground = GAME:GetCurrentGround()
  ground.Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(
      RogueEssence.Content.ObjAnimData('Campfire', 6),
      RogueElements.Loc(CX, CY)))
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end

-- Camp du matin : feu eteint (aucune animation de flammes), axe du
-- rassemblement degage.
function cloven_ruins_entrance_ch_5.BuildCampMorning()
  cloven_ruins_entrance_ch_5.PurgeDecor()
end

-- Deploiement des couchages — la nuit seulement.
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

-- ================================================================
-- SETUP — etat du camp a l'arrivee (avant la cinematique d'entree)
-- ================================================================
function cloven_ruins_entrance_ch_5.SetupGround()
  -- LE CAMP DEVANT LES RUINES — l'expedition au complet.
  -- Casting : Penticus (Tropius), Phileas (Noctowl), Coco (Snubbull),
  -- Rin (Audino), Hyko (Growlithe), Almotz (Zigzagoon) en PNJ ;
  -- Kino (Breloom) et Reinier (Girafarig) en escorte d'honneur (ce
  -- sont eux qui ont explore les ruines et les ont nommees) ;
  -- Ganlon (Cranidos) et Shuca (Mareep) sont dans l'equipe
  -- (Teammate2/3, spawners TEAMMATE_2/3 du ground).
  local tropius, noctowl, snubbull, audino, growlithe, zigzagoon, breloom, girafarig =
    CharacterEssentials.MakeCharactersFromList({
      {'Tropius',    OPEN_POS.Penticus[1], OPEN_POS.Penticus[2], Direction.Up},
      {'Noctowl',    OPEN_POS.Phileas[1],  OPEN_POS.Phileas[2],  Direction.UpRight},
      {'Snubbull',   OPEN_POS.Coco[1],     OPEN_POS.Coco[2],     Direction.Up},
      {'Audino',     OPEN_POS.Rin[1],      OPEN_POS.Rin[2],      Direction.Left},
      {'Growlithe',  OPEN_POS.Hyko[1],     OPEN_POS.Hyko[2],     Direction.Left},
      {'Zigzagoon',  OPEN_POS.Almotz[1],   OPEN_POS.Almotz[2],   Direction.Right},
      {'Breloom',    OPEN_POS.Kino[1],     OPEN_POS.Kino[2],     Direction.UpLeft},
      {'Girafarig',  OPEN_POS.Reinier[1],  OPEN_POS.Reinier[2],  Direction.UpRight},
    })

  -- Ganlon/Shuca : spawners d'equipe si presents (post-intro).
  if GAME:GetPlayerPartyCount() > 3 then
    GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
    GROUND:SpawnerDoSpawn("TEAMMATE_2")
    GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
    GROUND:SpawnerDoSpawn("TEAMMATE_3")
  end

  -- Camp de jour (feu + materiel, pas de paillasses).
  cloven_ruins_entrance_ch_5.BuildCampDay()

  -- Vie de fond : IA "ground_talking" pour que le camp respire en
  -- exploration (pas un diorama). Delais initiaux differencies.
  pcall(function()
    AI:SetCharacterAI(tropius, "halcyon.ai.ground_talking", false, 90, 60, 0, false, 'Default', {growlithe})
  end)
  pcall(function()
    AI:SetCharacterAI(growlithe, "halcyon.ai.ground_talking", false, 90, 60, 90, false, 'Default', {tropius})
  end)
  pcall(function()
    AI:SetCharacterAI(breloom, "halcyon.ai.ground_talking", false, 90, 60, 150, false, 'Default', {girafarig})
  end)
  pcall(function()
    AI:SetCharacterAI(girafarig, "halcyon.ai.ground_talking", false, 90, 60, 210, false, 'Default', {breloom})
  end)
end

-- ================================================================
-- ACTE 1 — ARRIVEE DEVANT LES RUINES
-- L'expedition debouche au camp deja installe. Kino et Reinier, qui
-- ont deja explore les ruines, sont a l'ecart en pleine discussion.
-- ================================================================
function cloven_ruins_entrance_ch_5.ArrivalCutscene()

  --LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee du projet).
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- L'equipe arrive du SUD (spawn 482,1112) et remonte vers le camp.
  -- La colonne x=568 est verifiee praticable en continu jusqu'au foyer.
  GROUND:TeleportTo(hero, 480, 1112, Direction.Up)
  GROUND:TeleportTo(partner, 520, 1112, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 512, 1136, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 552, 1136, Direction.Up) end
  GAME:MoveCamera(560, 1080, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  -- OST d'arrivee : Sealed Ruin.ogg (verifiee presente) — mysterieux,
  -- pose la gravite du lieu sans etre menacant.
  SOUND:PlayBGM('Sealed Ruin.ogg', false)
  GAME:WaitFrames(30)

  -- La montee vers le camp. Camera qui glisse avec la colonne.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 480, 1000, false, 1)
    GROUND:MoveToPosition(hero, 512, 900, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    GROUND:MoveToPosition(partner, 520, 1012, false, 1)
    GROUND:MoveToPosition(partner, 520, 916, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(24)
    if t2 ~= nil then GROUND:MoveToPosition(t2, 512, 1032, false, 1) end
  end)
  local coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(36)
    if t3 ~= nil then GROUND:MoveToPosition(t3, 552, 1032, false, 1) end
  end)
  local coro5 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(560, 1000, 130, false)
    GAME:MoveCamera(560, 860, 110, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
  GAME:WaitFrames(20)

  -- Le duo s'arrete au bord du camp, face aux ruines (au nord-est).
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)

  -- 1.1 PREMIERE VUE DES RUINES — la pensee du heros, breve.
  GAME:MoveCamera(560, 780, 40, false)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_001']), "Normal")
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_002']))
  GAME:WaitFrames(15)

  -- 1.2 KINO ET REINIER REMARQUENT L'ARRIVEE — en decale (pas en bloc).
  -- Ils etaient a l'ecart, en pleine discussion sur leur exploration.
  local kino = CH('Breloom')
  local reinier = CH('Girafarig')
  local coroK = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    if kino ~= nil then GROUND:CharTurnToCharAnimated(kino, hero, 4) end
  end)
  local coroR = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    if reinier ~= nil then GROUND:CharTurnToCharAnimated(reinier, hero, 4) end
  end)
  TASK:JoinCoroutines({coroK, coroR})
  GAME:WaitFrames(10)

  -- 1.3 KINO OUVRE — le lien personnel avec les ruines.
  if kino ~= nil then
    UI:SetSpeaker(kino)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_003']))
    GAME:WaitFrames(12)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_004']))
    GAME:WaitFrames(15)
  end

  -- 1.4 REINIER ENCHAINE — l'expert qui a deja fouille.
  if reinier ~= nil then
    UI:SetSpeaker(reinier)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_005']))
    GAME:WaitFrames(12)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_006']))
    GAME:WaitFrames(15)
  end

  -- 1.5 LE CAMP CONVERGE — tout le monde se dirige vers le duo.
  -- Penticus ouvre la voie, les autres suivent en decale.
  local tropius = CH('Tropius')
  local noctowl = CH('Noctowl')
  local snubbull = CH('Snubbull')
  local audino = CH('Audino')
  local growlithe = CH('Growlithe')
  local zigzagoon = CH('Zigzagoon')
  local converge = {}
  local cv = {
    {tropius,  {CX, CY + 40}},
    {snubbull, {CX - 30, CY + 24}},
    {audino,   {CX + 30, CY + 24}},
    {zigzagoon,{CX - 30, CY - 16}},
    {growlithe,{CX + 30, CY - 16}},
  }
  for i, e in ipairs(cv) do
    if e[1] ~= nil then
      converge[#converge+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 12)
        pcall(function()
          GeneralFunctions.EightWayMove(e[1], e[2][1], e[2][2], false, 1)
          GROUND:CharAnimateTurnTo(e[1], Direction.Up, 4)
        end)
      end)
    end
  end
  pcall(function() TASK:JoinCoroutines(converge) end)
  GAME:WaitFrames(15)

  -- 1.6 PENTICUS ACCUEILLE — ton d'autorite tranquille.
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_007']))
    GAME:WaitFrames(12)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_008']))
    GAME:WaitFrames(15)
  end

  -- 1.7 REINIER MONTRE LES RUINES — le point d'interet.
  if reinier ~= nil then
    GAME:MoveCamera(620, 700, 40, false)
    UI:SetSpeaker(reinier)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_009']))
    GAME:WaitFrames(12)
  end
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_010']), "Worried")
  GAME:WaitFrames(15)

  -- Transition 1 -> 2 : fondu (configuration debout -> repas assis).
  GAME:FadeOut(false, 40)
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)

  cloven_ruins_entrance_ch_5.CampBriefing(hero, partner, {
    penticus = tropius, phileas = noctowl, coco = snubbull, rin = audino,
    hyko = growlithe, almotz = zigzagoon, kino = kino, reinier = reinier,
  })
end

-- ================================================================
-- ACTE 2 — LE REPAS + BRIEFING STRATEGIQUE (le cœur de la scene)
-- Autour du feu, chacun partage ce qu'il a appris depuis le debut de
-- l'expedition. Hypotheses sur les Ruines, doutes vs moral, et le
-- mystere qui commence a s'assembler (sans tout reveler).
-- ================================================================
function cloven_ruins_entrance_ch_5.CampBriefing(hero, partner, t)
  local B = cloven_ruins_entrance_ch_5.SEATS

  -- Attribution des places autour du feu (fer a cheval ouvert au sud).
  local seats = {
    {t.penticus, 1,  Direction.Up},
    {t.phileas,  2,  Direction.Up},
    {t.coco,     3,  Direction.Up},
    {t.rin,      4,  Direction.Up},
    {t.almotz,   5,  Direction.Up},
    {t.hyko,     6,  Direction.Up},
    {t.kino,     7,  Direction.Down},
    {t.reinier,  8,  Direction.Down},
    {CH('Teammate3'), 9,  Direction.Down},  -- Shuca
    {CH('Teammate2'), 10, Direction.Down},  -- Ganlon
    {partner,    11, Direction.Down},
    {hero,       12, Direction.Down},
  }
  local function seatX(i) return B[i][1] end
  local function seatY(i) return B[i][2] end

  -- Helpers d'ecoute (pattern Mont Venteux) : le corps parle avant la
  -- bouche, decalage de 4 frames pour la respiration du groupe.
  local function Listen(speaker, listeners, emote)
    if speaker == nil or listeners == nil then return end
    local turns = {}
    for i, who in ipairs(listeners) do
      if who ~= nil and who ~= speaker then
        turns[#turns+1] = TASK:BranchCoroutine(function()
          pcall(function()
            GAME:WaitFrames((i - 1) * 4)
            GROUND:CharTurnToCharAnimated(who, speaker, 4)
            if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
          end)
        end)
      end
    end
    if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
  end
  local function Says(speaker, emotion, key, listeners, emote)
    Listen(speaker, listeners, emote)
    UI:SetSpeaker(speaker)
    GeneralFunctions.SetEmotion(emotion or "Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  end

  -- LES CONVIVES S'INSTALLENT. Chacun rejoint sa place, en decale.
  local settle = {}
  for i, s in ipairs(seats) do
    if s[1] ~= nil then
      settle[#settle+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(i * 8)
        pcall(function()
          GROUND:MoveToPosition(s[1], seatX(s[2]), seatY(s[2]), false, 1)
          GROUND:CharAnimateTurnTo(s[1], s[3], 4)
        end)
      end)
    end
  end
  TASK:JoinCoroutines(settle)
  GAME:WaitFrames(15)

  -- La nourriture apparait sous un fondu court (pattern Mont).
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(20)
  local foods = {}
  for i, s in ipairs(seats) do
    if s[1] ~= nil then
      local mx, my = seatX(s[2]), seatY(s[2])
      local fx = math.floor(mx + (CX - mx) / 6)
      local fy = math.floor(my + (CY - my) / 6)
      local anim = (my > CY) and "Food_Flipped" or "Food"
      local food = RogueEssence.Ground.GroundObject(
        RogueEssence.Content.ObjAnimData(anim, 1, 0, 0),
        RogueElements.Rect(fx, fy, 16, 16),
        RogueElements.Loc(0, 0),
        false,
        "CampFood" .. tostring(i))
      food:ReloadEvents()
      GAME:GetCurrentGround():AddTempObject(food)
      foods[#foods+1] = food
    end
  end
  GAME:FadeIn(30)
  GAME:WaitFrames(10)

  -- 2.1 OUVERTURE DU REPAS — OST Cave Camp.ogg (camp en grotte/ruines).
  SOUND:PlayBGM('Cave Camp.ogg', true)
  UI:SetSpeaker(t.penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_011']))
  GAME:WaitFrames(10)

  -- 2.2 LE BRIEFING — tour de table. Penticus cadre, Phileas
  -- synthetise, Kino/Reinier racontent leur exploration, le duo relie
  -- les evenements. Chaque membre a un beat (regle de mise en valeur).
  Says(t.penticus, "Normal", 'CR5_012', {t.phileas, t.rin, t.coco, t.hyko})
  GAME:WaitFrames(12)

  -- Phileas : la synthese des anomalies (Creuset, veines, orage).
  Says(t.phileas, "Normal", 'CR5_013', {t.penticus, t.rin})
  GAME:WaitFrames(10)
  Says(t.phileas, "Worried", 'CR5_014', {t.penticus, partner})
  GAME:WaitFrames(12)

  -- Rin : la soigneuse, le constat humain.
  Says(t.rin, "Worried", 'CR5_015', {t.coco, partner})
  GAME:WaitFrames(12)

  -- Kino : l'exploration des ruines (il les a nommees).
  Says(t.kino, "Normal", 'CR5_016', {t.reinier, hero, partner})
  GAME:WaitFrames(12)
  Says(t.kino, "Worried", 'CR5_017', {t.reinier})
  GAME:WaitFrames(12)

  -- Reinier : hypotheses sur l'origine.
  Says(t.reinier, "Normal", 'CR5_018', {t.kino, partner})
  GAME:WaitFrames(12)
  Says(t.reinier, "Worried", 'CR5_019', {t.kino, hero})
  GAME:WaitFrames(12)

  -- Le duo relie : les veines dont a parle Tornadus.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_020']), "Worried")
  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_021']))
  GAME:WaitFrames(12)

  -- 2.3 DOUTES VS MORAL — Coco pragmatique, Ganlon rale, Shuca
  -- remonte le moral. Le camp vit, ne debite pas des infos.
  Says(t.coco, "Normal", 'CR5_022', {t.rin, t.almotz})
  GAME:WaitFrames(10)
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')
  if ganlon ~= nil then
    Says(ganlon, "Sigh", 'CR5_023', {t.coco, t.kino})
    GAME:WaitFrames(10)
  end
  if shuca ~= nil then
    Says(shuca, "Happy", 'CR5_024', {ganlon, t.hyko})
    GAME:WaitFrames(10)
  end
  Says(t.hyko, "Determined", 'CR5_025', {t.almotz, partner})
  GAME:WaitFrames(10)
  Says(t.almotz, "Happy", 'CR5_026', {t.hyko})
  GAME:WaitFrames(12)

  -- 2.4 LE MYSTERE QUI S'ASSEMBLE — sans tout reveler. Les "angles"
  -- de Tornadus, les veines, la chaleur anormale : les pieces se
  -- rapprochent, mais aucune reponse n'est donnee.
  GAME:MoveCamera(CX, CY - 40, 40, false)
  Says(t.phileas, "Worried", 'CR5_027', {t.penticus, partner, hero})
  GAME:WaitFrames(12)
  Says(t.penticus, "Normal", 'CR5_028', {t.phileas, t.kino, t.reinier})
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_029']), "Determined")
  GAME:WaitFrames(15)

  -- 2.5 PENTICUS CLOT LE BRIEFING — la decision.
  Says(t.penticus, "Inspired", 'CR5_030', {t.phileas, t.kino, t.reinier, partner, hero})
  GAME:WaitFrames(15)

  -- Dessert sous fondu, fin du repas.
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(20)
  for _, food in ipairs(foods) do
    GAME:GetCurrentGround():RemoveTempObject(food)
  end
  GAME:FadeIn(30)
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(20)

  -- 2.6 LA SOIREE SE CALME — contemplation des ruines au loin.
  -- Silence musical : la nuit approche, on ne parle plus beaucoup.
  GAME:MoveCamera(620, 700, 60, false)
  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_031']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_032']), "Normal")
  GAME:WaitFrames(15)

  -- Transition 2 -> 3 : fondu (repas -> coucher), nuit qui tombe.
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(20)
  cloven_ruins_entrance_ch_5.CampNightfall(hero, partner, t)
end

-- ================================================================
-- ACTE 3 — LE COUCHER + LE REVE
-- Paillasses deployees sous le fondu, nuit ("darkness"), chacun se
-- couche. Discussion intime du duo, puis bascule vers le reve de
-- Gardevoir (hero_dream, retour parametre vers ce camp).
-- ================================================================
function cloven_ruins_entrance_ch_5.CampNightfall(hero, partner, t)
  local B = cloven_ruins_entrance_ch_5.BEDS
  local bedOf = {
    [t.penticus] = 1, [t.phileas] = 2, [t.coco] = 3, [t.rin] = 4,
    [t.almotz] = 5, [t.hyko] = 6, [t.kino] = 7, [t.reinier] = 8,
    [CH('Teammate3')] = 9, [CH('Teammate2')] = 10,
    [partner] = 11, [hero] = 12,
  }
  local function seatX(i) return B[i][1] + 13 end
  local function seatY(i) return B[i][2] + 10 end

  -- Deploiement des couchages + nuit.
  cloven_ruins_entrance_ch_5.DeployBeds()
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  pcall(function() GROUND:AddMapStatus("darkness") end)
  GAME:WaitFrames(10)

  -- Texte de transition sur le noir (ellipse jour -> nuit).
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_033']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(15)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- 3.1 CHACUN GAGNE SA PAILLASSE, en decale.
  local sleepOrder = {
    {t.penticus, 0}, {t.coco, 12}, {t.rin, 22}, {t.almotz, 32},
    {t.kino, 42}, {t.reinier, 52},
  }
  local vers = {}
  for _, s in ipairs(sleepOrder) do
    local chara, delay = s[1], s[2]
    if chara ~= nil and bedOf[chara] ~= nil then
      vers[#vers+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(delay)
        pcall(function()
          GROUND:MoveToPosition(chara, seatX(bedOf[chara]), seatY(bedOf[chara]), false, 1)
          GROUND:CharSetAnim(chara, "Sleep", true)
        end)
      end)
    end
  end
  -- Le duo s'attarde : le partenaire s'etire, le heros contemple les
  -- ruines une derniere fois avant de suivre.
  vers[#vers+1] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(18)
    pcall(function()
      GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", false)
      GROUND:MoveToPosition(partner, seatX(bedOf[partner]), seatY(bedOf[partner]), false, 1)
      GROUND:CharTurnToCharAnimated(partner, hero, 4)
    end)
  end)
  vers[#vers+1] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(32)
    pcall(function()
      GROUND:CharAnimateTurnTo(hero, Direction.Up, 6)
      GAME:WaitFrames(20)
      GROUND:MoveToPosition(hero, seatX(bedOf[hero]), seatY(bedOf[hero]), false, 1)
    end)
  end)
  TASK:JoinCoroutines(vers)
  GAME:WaitFrames(10)

  -- 3.2 LA DISCUSSION INTIME DU DUO — camera resserree.
  local duoX = (seatX(bedOf[hero]) + seatX(bedOf[partner])) // 2
  local duoY = (seatY(bedOf[hero]) + seatY(bedOf[partner])) // 2
  GAME:MoveCamera(duoX, duoY, 45, false)
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_034']))
  GAME:WaitFrames(12)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_035']))
  GAME:WaitFrames(12)
  GeneralFunctions.DoAnimation(hero, 'Nod')
  GAME:WaitFrames(15)

  -- Le partenaire s'endort en pleine phrase (dodeline, EventSleep).
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_036'], hero:GetDisplayName()))
  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_D01']))
  GAME:WaitFrames(10)
  pcall(function()
    GeneralFunctions.LookAround(partner, 2, 10, false, false, true, Direction.Up)
  end)
  GAME:WaitFrames(14)
  pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 6) end)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(35)

  -- Le heros ne dit rien : le corps repond (goutte de sueur amusee).
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 6) end)
  GAME:WaitFrames(28)
  pcall(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", true) end)
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_D02']), "Sigh")
  GAME:WaitFrames(20)

  -- 3.3 LE CAMP S'ENDORT — chacun EventSleep, le heros en dernier.
  local finalSleep = {
    {t.hyko, 0}, {t.almotz, 6}, {t.phileas, 12}, {t.coco, 18},
    {t.rin, 24}, {t.kino, 30}, {t.reinier, 36},
  }
  local fs = {}
  for _, s in ipairs(finalSleep) do
    if s[1] ~= nil then
      fs[#fs+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(s[2])
        pcall(function() GROUND:CharSetAnim(s[1], "Sleep", true) end)
      end)
    end
  end
  TASK:JoinCoroutines(fs)
  GAME:WaitFrames(10)

  -- La camera derive au-dessus du camp endormi, puis sur les ruines.
  local coro1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(CX, CY + 20, 90, false)
    GAME:MoveCamera(620, 700, 110, false)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(120)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_037']))
  UI:SetCenter(false)
  UI:ResetSpeaker()

  -- LA BASCULE VERS LE REVE. La carte de retour est ce camp : le
  -- routeur (PlotScripting) rejouera le matin au retour.
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  SV.Chapter5.RuinsCampNightDone = true
  PrintInfo('[CR5] fin de veillee — preparation de la bascule vers hero_dream (retour cloven_ruins_entrance)')

  --PREFLIGHT (meme niveau que le Mont) : la bascule ne doit JAMAIS
  --etre armee vers une carte non chargeable (NRE ProcessInput).
  local function zoneConnait(nom)
    local okZ, resZ = pcall(function()
      local z = _ZONE.CurrentZone
      if z == nil then return nil end
      for i = 0, z.GroundMaps.Count - 1 do
        if tostring(z.GroundMaps[i]) == nom then return true end
      end
      return false
    end)
    if not okZ then return nil end
    return resZ
  end
  local canDream = true
  local okPre, resPre = pcall(function()
    local summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
    if not summary:GroundValid('hero_dream') then return false end
    local reg = zoneConnait('hero_dream')
    if reg == false then
      PrintInfo('[CR5] hero_dream absente de la ZONE EN MEMOIRE — reve saute, retour au camp')
      return false
    end
    return _DATA:GetGround('hero_dream') ~= nil
  end)
  if okPre then canDream = (resPre == true) end

  if not canDream then
    PrintInfo('[CR5] hero_dream non chargeable — reve saute, retour au matin')
    SV.Chapter5.RuinsDreamSeen = true
    GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker', true)
    return
  end

  --On pose la carte de retour AVANT la bascule : hero_dream la lit
  --pour renvoyer le joueur ici (et non vers le Mont Venteux).
  SV.TemporaryFlags.DreamReturn = 'cloven_ruins_entrance'
  local okDream, errDream = pcall(function()
    GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
  end)
  if not okDream then
    PrintInfo('[CR5] hero_dream indisponible ('..tostring(errDream)..') — reve saute')
    SV.Chapter5.RuinsDreamSeen = true
    GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker', true)
  end
end

-- ================================================================
-- ACTE 4 — LENDEMAIN MATIN + ENTRÉE DANS LES RUINES
-- Retour du reve : on recompose le camp endormi, puis le matin se
-- leve. Lever du soleil, preparations, rassemblement, entree.
-- ================================================================
function cloven_ruins_entrance_ch_5.ResumeAfterDream()
  local okR, errR = pcall(cloven_ruins_entrance_ch_5.ResumeAfterDreamBody)
  if not okR then
    PrintInfo('[CR5] recomposition du camp ecourtee : '..tostring(errR))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.ResumeAfterDreamBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local B = cloven_ruins_entrance_ch_5.BEDS

  GAME:CutsceneMode(true)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GROUND:AddMapStatus("darkness") end)

  cloven_ruins_entrance_ch_5.DeployBeds()

  -- Recreation des membres sur leur couche, dans la pose de sommeil.
  local tropius, noctowl, snubbull, audino, growlithe, zigzagoon, breloom, girafarig =
    CharacterEssentials.MakeCharactersFromList({
      {'Tropius',   B[1][1]  + 13, B[1][2]  + 10, Direction.Up},
      {'Noctowl',   B[2][1]  + 13, B[2][2]  + 10, Direction.Up},
      {'Snubbull',  B[3][1]  + 13, B[3][2]  + 10, Direction.Up},
      {'Audino',    B[4][1]  + 13, B[4][2]  + 10, Direction.Up},
      {'Zigzagoon', B[5][1]  + 13, B[5][2]  + 10, Direction.Up},
      {'Growlithe', B[6][1]  + 13, B[6][2]  + 10, Direction.Up},
      {'Breloom',   B[7][1]  + 13, B[7][2]  + 10, Direction.Down},
      {'Girafarig', B[8][1]  + 13, B[8][2]  + 10, Direction.Down},
    })
  if GAME:GetPlayerPartyCount() > 3 then
    GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
    GROUND:SpawnerDoSpawn("TEAMMATE_2")
    GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
    GROUND:SpawnerDoSpawn("TEAMMATE_3")
  end
  GROUND:TeleportTo(partner, B[11][1] + 13, B[11][2] + 10, Direction.Down)
  GROUND:TeleportTo(hero,    B[12][1] + 13, B[12][2] + 10, Direction.Down)
  for _, c in ipairs({tropius, noctowl, snubbull, audino, growlithe,
                      zigzagoon, breloom, girafarig}) do
    pcall(function() GROUND:CharSetAnim(c, "Sleep", true) end)
  end
  pcall(function() GROUND:CharSetAnim(partner, "EventSleep", true) end)
  pcall(function() GROUND:CharSetAnim(hero, "EventSleep", true) end)

  cloven_ruins_entrance_ch_5.MorningAfterDream(
    hero, partner, {penticus = tropius, phileas = noctowl,
                    coco = snubbull, rin = audino,
                    hyko = growlithe, almotz = zigzagoon,
                    kino = breloom, reinier = girafarig})
end

function cloven_ruins_entrance_ch_5.MorningAfterDream(hero, partner, t)
  local okM, errM = pcall(cloven_ruins_entrance_ch_5.MorningAfterDreamBody, hero, partner, t)
  if not okM then
    PrintInfo('[CR5] scene du matin ecourtee : '..tostring(errM))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.MorningAfterDreamBody(hero, partner, t)
  local B = cloven_ruins_entrance_ch_5.BEDS
  local coro1, coro2

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  pcall(function() GAME:FadeOut(false, 1) end)

  -- 4.1 LE SURSAUT DU REVEIL — le heros se redresse d'un coup.
  local HERO_BED = 12
  local function seatX(i) return B[i][1] + 13 end
  local function seatY(i) return B[i][2] + 10 end
  GAME:MoveCamera(seatX(HERO_BED), seatY(HERO_BED), 1, false)
  GAME:FadeIn(45)
  GAME:WaitFrames(25)
  pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
  pcall(function() GROUND:CharEndAnim(hero) end)
  pcall(function() VoiceVisions.Nausea(hero, 1) end)
  GAME:WaitFrames(25)

  -- L'oubli immediat — le reve de Gardevoir s'efface.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_038']), "Pain")
  GAME:WaitFrames(30)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_039']), "Worried")
  GAME:WaitFrames(25)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_040']), "Sad")
  UI:ResetSpeaker()
  GAME:WaitFrames(35)

  -- Le partenaire se reveille a son tour.
  pcall(function() GROUND:CharEndAnim(partner) end)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_041']))
  GAME:WaitFrames(15)

  -- 4.2 LE LEVER DU SOLEIL — la nuit cede la place au jour.
  -- Retrait de "darkness" = l'aube se leve sur le camp.
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  SOUND:PlayBGM('Aegis Cave.ogg', false)
  GAME:MoveCamera(CX, CY - 20, 40, false)
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_042']))
  GAME:WaitFrames(12)

  -- 4.3 LES AUTRES SE REVEILLENT, en cascade.
  local wakeOrder = {
    {t.penticus, 0}, {t.rin, 10}, {t.coco, 20}, {t.hyko, 30},
    {t.almotz, 40}, {t.kino, 50}, {t.reinier, 60}, {t.phileas, 70},
  }
  local wks = {}
  for _, s in ipairs(wakeOrder) do
    if s[1] ~= nil then
      wks[#wks+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(s[2])
        pcall(function()
          GROUND:CharEndAnim(s[1])
          GeneralFunctions.DoAnimation(s[1], 'Wake')
        end)
      end)
    end
  end
  TASK:JoinCoroutines(wks)
  GAME:WaitFrames(20)

  -- 4.4 LE RASSEMBLEMENT DU MATIN — Penticus donne le signal.
  -- Le feu est eteint (camp du matin), l'axe est degage.
  cloven_ruins_entrance_ch_5.BuildCampMorning()
  local rally = {}
  local rv = {
    {t.penticus, {CX, CY + 40}},
    {t.kino,     {CX - 40, CY + 24}},
    {t.reinier,  {CX + 40, CY + 24}},
    {t.coco,     {CX - 30, CY - 16}},
    {t.rin,      {CX + 30, CY - 16}},
    {t.hyko,     {CX - 20, CY + 8}},
    {t.almotz,   {CX + 20, CY + 8}},
  }
  for i, e in ipairs(rv) do
    if e[1] ~= nil then
      rally[#rally+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 10)
        pcall(function()
          GeneralFunctions.EightWayMove(e[1], e[2][1], e[2][2], false, 1)
          GROUND:CharAnimateTurnTo(e[1], Direction.Up, 4)
        end)
      end)
    end
  end
  TASK:JoinCoroutines(rally)
  GAME:WaitFrames(15)

  -- Penticus s'adresse a l'expedition : la decision du jour.
  if t.penticus ~= nil then
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_043']))
    GAME:WaitFrames(12)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_044']))
    GAME:WaitFrames(15)
  end

  -- Le duo se prepare, face a l'entree.
  GAME:MoveCamera(620, 700, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_045']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_046']), "Determined")
  GAME:WaitFrames(20)

  -- 4.5 FIN DE CINEMATIQUE — le camp se disperse, le joueur reprend
  -- la main. C'est lui qui choisit le moment d'entrer dans les ruines.
  SV.Chapter5.RuinsCampDone = true
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GeneralFunctions.RendreLaMain(true)
end

return cloven_ruins_entrance_ch_5


