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
      Acte 3 — Coucher + histoires + reve de Gardevoir (hero_dream)
      Acte 4 — Lendemain matin : lever du soleil, preparations,
               entree dans les Ruines Fendues (climax du ch5)

    Niveau de finition : aligne sur la veillee du Mont Venteux
    (mount_windswept_entrance_ch_5.lua) — rotations de tete
    systematiques vers le locuteur, reactions collectives en cascade
    (emotes variees par personnage), gestes marques, silences,
    mouvements de camera a chaque beat, deplacements reels.

    Regles appliquees (non negociables) :
      - fondus a chaque changement de configuration majeure ;
      - OST propre par acte (verifiee presente dans Content/Music/) ;
      - le silence est un outil de mise en scene ;
      - budget de personnages respecte (l'expedition au complet) ;
      - deplacements reels, pas de teleportation ;
      - pensees du heros courtes, jamais de narration omnisciente ;
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
-- Ground réutilisé : aegis_cave_entrance (ExplorersOfSkyOrigins), carte
-- 576x408 px (TexSize 3, 24px, orientation paysage), collision ouverte.
-- GEOGRAPHIE (verifiee sur le rendu de la carte) :
--   - SABLE (zone du camp) : x 0-430, y 136-296
--   - GROTTE (entree du donjon) : bouche sombre x 400-440, y 120-164,
--     avec la pente (montee) claire dessous (y 164-196)
--   - ROCHERS : bord droit x 440+, rive y 296+
-- Foyer pose sur le sable au centre (220,215) ; tout le footprint du
-- camp (x 70-330, y 146-282) reste sur le sable, loin des rochers.
cloven_ruins_entrance_ch_5.CAMP_X = 220
cloven_ruins_entrance_ch_5.CAMP_Y = 215

local CX = cloven_ruins_entrance_ch_5.CAMP_X
local CY = cloven_ruins_entrance_ch_5.CAMP_Y

-- Les 12 places assises du briefing (cercle autour du feu, rayon 52),
-- posees sur le sable. Cercle REGULIER : 30° entre chaque siege, distance
-- entre voisins 26,9 px (>= 26 px, convention Tunnel — l'ancien cercle
-- irregulier laissait des paires a 16-24 px, chevauchement de sprites).
-- Ordre : Penticus au sud (face au sentier d'arrivee), puis horaire.
-- Chaque siege est "l'assiette" du convive.
cloven_ruins_entrance_ch_5.SEATS = {
  {CX +  0, CY + 48},  -- 1  Penticus (sud, face au feu) — tuile propre (9,10), hors graviers (9,11)
  {CX - 26, CY + 45},  -- 2  Phileas
  {CX - 45, CY + 26},  -- 3  Coco
  {CX - 52, CY +  0},  -- 4  Rin
  {CX - 45, CY - 26},  -- 5  Almotz
  {CX - 26, CY - 45},  -- 6  Hyko
  {CX +  0, CY - 52},  -- 7  Kino (nord, face au feu)
  {CX + 26, CY - 45},  -- 8  Reinier
  {CX + 45, CY - 26},  -- 9  Shuca
  {CX + 52, CY +  0},  -- 10 Ganlon
  {CX + 45, CY + 26},  -- 11 partner
  {CX + 26, CY + 45},  -- 12 hero
}

-- Les 12 paillasses (deployees la nuit seulement), posees en 2 rangees
-- N/S sur le sable (y 155 / y 275, x 70-330), hors du cercle de siege
-- et loin des rochers (x>=360) et de la rive (y>=296).
cloven_ruins_entrance_ch_5.BEDS = {
  {CX - 150, CY - 60}, {CX - 98, CY - 60}, {CX - 46, CY - 60}, {CX + 6, CY - 60}, {CX + 58, CY - 60}, {CX + 92, CY - 60},
  {CX - 150, CY + 60}, {CX - 98, CY + 60}, {CX - 46, CY + 60}, {CX + 6, CY + 60}, {CX + 58, CY + 60}, {CX + 110, CY + 60},
}

--LA PAILLASSE DE PLUM — posee SEULEMENT si elle est au camp (elle
--s'est incrustee au Mont Venteux et a suivi l'expedition). Elle dort
--en bout de rang nord-ouest, pres de sa cuisine (48,245), a l'ecart
--du cercle. Posee sur le sable (48,160).
cloven_ruins_entrance_ch_5.PLUM_BED = {36, 160}

-- Positions d'ouverture des PNJ (camp de jour) : chacun a cote de son
-- siege (son assiette), sur le sable, juste derriere sa place assise.
local OPEN_POS = {
  Penticus = {220, 255},
  Phileas  = {168, 264},
  Coco     = {150, 244},
  Rin      = {150, 215},
  Hyko     = {176, 166},
  Almotz   = {155, 186},
  Kino     = {220, 146},
  Reinier  = {266, 168},
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
  --LA COUCHE DE PLUM — uniquement si elle est au camp (running gag).
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    local pb = cloven_ruins_entrance_ch_5.PLUM_BED
    ground.Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(pb[1], pb[2])))
  end
  ground.Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(CX, CY)))
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end

-- ================================================================
-- SETUP — etat du camp a l'arrivee (avant la cinematique d'entree)
-- ================================================================
function cloven_ruins_entrance_ch_5.SetupGround(includeRecon)
  -- LE CAMP DEVANT LES RUINES — repartition des equipes (logique PMD).
  -- Au repos (apres le briefing du matin), PENTICUS a reparti les
  -- equipes : seule la BASE LOGISTIQUE reste au camp. Kino et Reinier
  -- (les explorateurs qui connaissent les ruines) sont partis en
  -- RECONNAISSANCE dans les premiers etages — ils ne sont pas au camp.
  --
  --  BASE LOGISTIQUE (toujours presente) :
  --    Penticus (Tropius)   -> commandement / coordination
  --    Phileas  (Noctowl)   -> renseignement / analyse des notes
  --    Rin      (Audino)    -> poste medical (soigne les retours)
  --    Coco     (Snubbull)  -> intendance / le camp
  --    Hyko     (Growlithe) -> garde du perimetre
  --    Almotz   (Zigzagoon) -> auxiliaire / coursier
  --  RECONNAISSANCE (absente au repos, incluse si includeRecon) :
  --    Kino (Breloom), Reinier (Girafarig) -> deja dans les Ruines
  --    (presentes a l'arrivee, et presentes lors d'un KO car ce sont
  --    EUX qui ramenent l'equipe vaincue au camp).
  --
  --  includeRecon = true  -> arrivee au camp / retour apres KO (ils
  --                          sont la : ils ont explore / ils ont sauve)
  --  includeRecon = false -> etat de camp libre apres le matin (ils
  --                          sont partis en eclaircage dans les ruines)
  local spawnList = {
    {'Tropius',    OPEN_POS.Penticus[1], OPEN_POS.Penticus[2], Direction.Up},
    {'Noctowl',    OPEN_POS.Phileas[1],  OPEN_POS.Phileas[2],  Direction.UpRight},
    {'Snubbull',   OPEN_POS.Coco[1],     OPEN_POS.Coco[2],     Direction.Up},
    {'Audino',     OPEN_POS.Rin[1],      OPEN_POS.Rin[2],      Direction.Left},
    {'Growlithe',  OPEN_POS.Hyko[1],     OPEN_POS.Hyko[2],     Direction.Left},
    {'Zigzagoon',  OPEN_POS.Almotz[1],   OPEN_POS.Almotz[2],   Direction.Right},
  }
  if includeRecon then
    spawnList[#spawnList+1] = {'Breloom',   OPEN_POS.Kino[1],    OPEN_POS.Kino[2],    Direction.UpLeft}
    spawnList[#spawnList+1] = {'Girafarig', OPEN_POS.Reinier[1], OPEN_POS.Reinier[2], Direction.UpRight}
  end
  --PLUM (Jigglypuff) — elle s'est incrustee au camp du Mont Venteux
  --(SV.Chapter5.PlumAtMountCamp) et elle a SUIVI l'expedition jusqu'aux
  --Ruines. C'est un running gag volontaire : personne ne la renvoie.
  --Position cuisine, a l'ouest du feu, hors du cercle de briefing.
  local jigglypuff = nil
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    spawnList[#spawnList+1] = {'Jigglypuff', 48, 245, Direction.Right}
  end
  local tropius, noctowl, snubbull, audino, growlithe, zigzagoon, breloom, girafarig, jigglypuff2 =
    CharacterEssentials.MakeCharactersFromList(spawnList)
  jigglypuff = jigglypuff2

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
  -- (Les appels sont proteges : breloom/girafarig peuvent etre nil
  -- quand la reconnaissance est absente.)
  pcall(function()
    AI:SetCharacterAI(tropius, "halcyon.ai.ground_talking", false, 90, 60, 0, false, 'Default', {growlithe})
  end)
  pcall(function()
    AI:SetCharacterAI(growlithe, "halcyon.ai.ground_talking", false, 90, 60, 90, false, 'Default', {tropius})
  end)
  if breloom ~= nil then
    pcall(function()
      AI:SetCharacterAI(breloom, "halcyon.ai.ground_talking", false, 90, 60, 150, false, 'Default', {girafarig})
    end)
  end
  if girafarig ~= nil then
    pcall(function()
      AI:SetCharacterAI(girafarig, "halcyon.ai.ground_talking", false, 90, 60, 210, false, 'Default', {breloom})
    end)
  end
  if jigglypuff ~= nil then
    pcall(function()
      --Plum s'affaire : IdleTime plus court (la plus remuante).
      AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", false, 60, 60, 120, false, 'Default', {tropius})
    end)
  end
end

-- ================================================================
-- HELPERS DE MISE EN SCENE — alignes sur la veillee du Mont Venteux
--   Listen(speaker, listeners, emote) : les auditeurs se tournent
--     vers le locuteur, EN DECALE (4 frames) — un groupe qui pivote
--     d'un bloc a l'air mecanique.
--   Says(speaker, emotion, key, listeners, emote) : le corps parle
--     avant la bouche.
--   ReactAll(table personnage->emote) : cascade de reactions avec
--     EMOTES DIFFERENTES par personnage (jamais le meme bloc).
--   Silence(frames) : boite fermee, rien a l'ecran — un vrai temps.
-- ================================================================
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

-- Cascade de reactions : table {personnage = emote}. Chacun reagit a
-- son rythme (decalage 5 frames) avec SON emote — jamais un bloc.
local function ReactAll(reactions)
  if reactions == nil then return end
  local turns = {}
  local i = 0
  for who, emote in pairs(reactions) do
    i = i + 1
    if who ~= nil then
      turns[#turns+1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames((i - 1) * 5)
          GeneralFunctions.EmoteAndPause(who, emote, true)
        end)
      end)
    end
  end
  if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
end

local function Silence(frames)
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(frames or 40)
end

-- ================================================================
-- ACTE 1 — ARRIVEE DEVANT LES RUINES
-- L'expedition debouche au camp deja installe. Kino et Reinier, qui
-- ont deja explore les ruines, sont a l'ecart en pleine discussion.
-- ================================================================
-- ================================================================
-- CINEMATIQUE DU CAMP — REFONTE COMPLETE (6 ACTES)
-- Patron d'arrivee : Spring Tunnel (noir -> dialogues en marchant ->
-- ouverture du fondu -> decouverte du camp).
--   Acte 1 : Arrivee vers les Ruines (marche sous le noir, revelation)
--   Acte 2 : La surprise de Plum (la camera la decouvre, reactions)
--   Acte 3 : La crise de Plum (bouderie, explosion, fierte, diner)
--   [fondu + boite narrative « Plusieurs heures plus tard... »]
--   Acte 4 : Le repas (camp vivant, petits groupes, chaleur)
--   Acte 5 : La nuit (les paillasses, les reves et les ambitions)
--   Acte 6 : La comedie (Ganlon taquine Plum, la tsundere)
--   Coucher + bascule vers hero_dream (patron valide du Mont).
-- Regles appliquees : sortie garantie (wrapper pcall), fondus aux
-- changements de configuration majeurs, orientations selon la position
-- reelle, reactions individualisees et decalees, distances >= 26 px,
-- chemins reels (BFS verifies), musique par acte, silence comme outil.
-- ================================================================

-- Installation des convives a leur siege (utilisee sous les fondus :
-- redisposition complete = fondu justifie). Cercle regulier rayon 52,
-- orientations face au feu (les sieges du sud regardent vers le nord,
-- ceux du nord vers le sud).
local function SeatEveryone(t, t2, t3, partner, hero)
  local seats = {
    {t.penticus, 1,  Direction.Up},
    {t.phileas,  2,  Direction.Up},
    {t.coco,     3,  Direction.Up},
    {t.rin,      4,  Direction.Up},
    {t.almotz,   5,  Direction.Up},
    {t.hyko,     6,  Direction.Up},
    {t.kino,     7,  Direction.Down},
    {t.reinier,  8,  Direction.Down},
    {t3,         9,  Direction.Down},
    {t2,         10, Direction.Down},
    {partner,    11, Direction.Down},
    {hero,       12, Direction.Down},
  }
  for _, s in ipairs(seats) do
    if s[1] ~= nil then
      GROUND:TeleportTo(s[1], cloven_ruins_entrance_ch_5.SEATS[s[2]][1],
                              cloven_ruins_entrance_ch_5.SEATS[s[2]][2], s[3])
    end
  end
end

-- Les plats du repas (temp objects, purges au changement d'acte).
local function SpawnFoods()
  local foods = {}
  local seatList = {
    {'Penticus', 1}, {'Phileas', 2}, {'Coco', 3}, {'Rin', 4},
    {'Almotz', 5}, {'Hyko', 6}, {'Kino', 7}, {'Reinier', 8},
    {'Shuca', 9}, {'Ganlon', 10}, {'partner', 11}, {'hero', 12},
  }
  local CX = cloven_ruins_entrance_ch_5.CAMP_X
  local CY = cloven_ruins_entrance_ch_5.CAMP_Y
  for i, s in ipairs(seatList) do
    local seat = cloven_ruins_entrance_ch_5.SEATS[s[2]]
    local mx, my = seat[1], seat[2]
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
  return foods
end

function cloven_ruins_entrance_ch_5.ArrivalCutscene()
  local ok, err = pcall(cloven_ruins_entrance_ch_5.ArrivalCutsceneBody)
  if not ok then
    PrintInfo('[CR5] cinematique du camp ecourtee : '..tostring(err))
    --Sortie garantie : on ne rejoue pas la scene, le joueur reprend la
    --main au camp (le routeur bascule sur l'etat de camp libre).
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() SV.Chapter5.RuinsCampNightDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.ArrivalCutsceneBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local t = {
    penticus = CH('Tropius'), phileas = CH('Noctowl'), coco = CH('Snubbull'),
    rin = CH('Audino'), hyko = CH('Growlithe'), almotz = CH('Zigzagoon'),
    kino = CH('Breloom'), reinier = CH('Girafarig'),
  }
  local plum = nil
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    plum = CH('Jigglypuff')
  end

  --LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee du projet).
  pcall(function() GAME:FadeOut(false, 1) end)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- ============ ACTE 1 — ARRIVEE VERS LES RUINES ============
  -- Le groupe arrive par l'ouest (patron Spring Tunnel : dialogues sous
  -- le noir — le joueur imagine la marche — puis ouverture du fondu sur
  -- la decouverte du camp).
  GROUND:TeleportTo(hero, 24, 210, Direction.Right)
  GROUND:TeleportTo(partner, 24, 240, Direction.Right)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 52, 200, Direction.Right) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 52, 232, Direction.Right) end
  GAME:MoveCamera(60, 225, 1, false)

  --Plum n'est pas encore visible : elle sera decouverte a l'acte 2.
  if plum ~= nil then pcall(function() GROUND:Hide('Jigglypuff') end) end

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  -- Le groupe marche sous le noir : echanges pendant la progression.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W01']))
  GAME:WaitFrames(12)
  if t3 ~= nil then
    UI:SetSpeaker(t3)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W02']))
    GAME:WaitFrames(12)
  end
  if t2 ~= nil then
    UI:SetSpeaker(t2)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W03']))
    GAME:WaitFrames(12)
  end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W04']))
  GAME:WaitFrames(12)

  -- FORESHADOWING PLUM : le partenaire se demande ou elle est passee.
  -- La question reste sans reponse — le joueur la garde en tete pour
  -- l'acte 2 (la surprise de Plum).
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W05']))
  GAME:WaitFrames(12)
  if t2 ~= nil then
    UI:SetSpeaker(t2)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W06']))
    GAME:WaitFrames(15)
  end

  -- OUVERTURE DU FONDU : le camp se revele. La marche se termine.
  -- ARRIVEE SILENCIEUSE (brief) : pas d'OST — le silence porte la
  -- decouverte. La musique ne revient qu'a la crise de Plum
  -- (Wigglytuff's Guild, acte 3) puis au repas (Cave Camp, acte 4).
  GAME:FadeIn(50)

  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 120, 210, false, 1)
    GROUND:MoveToPosition(hero, 168, 274, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    GROUND:MoveToPosition(partner, 120, 240, false, 1)
    GROUND:MoveToPosition(partner, 256, 274, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(24)
    if t2 ~= nil then GROUND:MoveToPosition(t2, 100, 205, false, 1) end
  end)
  local coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(36)
    if t3 ~= nil then GROUND:MoveToPosition(t3, 100, 235, false, 1) end
  end)
  local coro5 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(150, 240, 130, false)
    GAME:MoveCamera(220, 250, 110, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
  GAME:WaitFrames(20)

  -- Le duo s'arrete au bord du camp, face aux ruines (au nord-est).
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)

  -- LA DECOUVERTE : le camp d'abord, puis la grotte au fond.
  GAME:MoveCamera(220, 215, 40, false)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_001']), "Normal")
  Silence(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_002']))
  Silence(12)
  -- Echo de la victoire sur Tornadus (transition emotionnelle).
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_047']))
  Silence(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_048']), "Determined")
  Silence(15)

  -- Le camp remarque l'arrivee : Kino et Reinier en premier, en decale.
  local kino = t.kino
  local reinier = t.reinier
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

  -- Reinier montre la grotte : le point d'interet.
  if reinier ~= nil then
    GAME:MoveCamera(420, 142, 40, false)
    Listen(reinier, {hero, partner, kino})
    UI:SetSpeaker(reinier)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_009']))
    Silence(12)
  end
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_010']), "Worried")
  Silence(15)

  -- Penticus accueille : retour camera sur le camp.
  GAME:MoveCamera(220, 250, 40, false)
  if t.penticus ~= nil then
    Listen(t.penticus, {t.phileas, t.coco, t.rin, t.hyko, t.almotz, hero, partner})
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_007']))
    Silence(12)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_008']))
    Silence(15)
  end

  -- ============ ACTE 2 — LA SURPRISE DE PLUM ============
  if plum ~= nil then
    -- La camera glisse vers Plum EN ECHELONS : trois paliers qui
    -- l'approchent progressivement, dans le silence de l'arrivee.
    GAME:MoveCamera(150, 240, 40, false)
    GAME:WaitFrames(18)
    GAME:MoveCamera(100, 240, 40, false)
    GAME:WaitFrames(18)
    GAME:MoveCamera(70, 240, 40, false)
    GAME:WaitFrames(18)

    -- Plum se revele, SANS bruit : elle etait deja la, installee avec
    -- ses marmites, a les regarder arriver.
    pcall(function()
      GROUND:Unhide('Jigglypuff')
      GROUND:CharTurnToCharAnimated(plum, hero, 4)
    end)
    GAME:WaitFrames(15)

    -- Elle fait DEUX PAS vers le groupe, sans un mot.
    pcall(function()
      GROUND:MoveToPosition(plum, 72, 245, false, 1)
    end)
    GAME:WaitFrames(14)
    pcall(function()
      GROUND:MoveToPosition(plum, 96, 245, false, 1)
      GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
    end)
    GAME:WaitFrames(15)

    -- LA GUILDE, EMBARRASSEE : personne ne l'a vue arriver, personne
    -- n'a de reponse. Sueurs froides et regards qui se detournent.
    ReactAll({
      [t.coco] = "Sweatdrop",
      [t.hyko] = "Sweatdrop",
      [t.almotz] = "Sweatdrop",
      [t.phileas] = "Notice",
      [kino] = "Shock",
    })
    GAME:WaitFrames(10)
    -- Penticus, gene, tente de sauver les apparences.
    if t.penticus ~= nil then
      UI:SetSpeaker(t.penticus)
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_W07']))
      Silence(12)
    end

    -- Puis la surprise eclate vraiment.
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_P01']))
    Silence(12)
    if kino ~= nil then
      UI:SetSpeaker(kino)
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_P02']))
      Silence(12)
    end
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_P03']))
    Silence(12)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_P05']))
    Silence(15)

    -- ============ ACTE 3 — LA CRISE DE PLUM ============
    -- Plum boude : elle se detourne du groupe.
    pcall(function()
      GROUND:CharAnimateTurnTo(plum, Direction.Up, 4)
      GeneralFunctions.EmoteAndPause(plum, "Angry", false)
    end)
    GAME:WaitFrames(18)
    -- DRAMA QUEEN : elle tape du pied, une fois, bien visible.
    pcall(function()
      GROUND:AnimateInDirection(plum, "Hop", Direction.Up, Direction.Up, 4, 1, 1)
    end)
    GAME:WaitFrames(12)
    -- Le groupe echange des regards perplexes.
    ReactAll({
      [t.coco] = "Sweatdrop",
      [t.phileas] = "Sweatdrop",
      [t.almotz] = "Shock",
      [kino] = "Notice",
    })
    Silence(25)
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Angry")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X01']))
    GAME:WaitFrames(15)

    -- La musique comique de la Guilde demarre.
    SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
    GAME:WaitFrames(10)
    -- Plum explose.
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Angry")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X02']))
    GAME:WaitFrames(12)
    -- Elle se reprend aussitot.
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X03']))
    GAME:WaitFrames(12)
    -- Puis retrouve toute sa fierte.
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X04']))
    GAME:WaitFrames(15)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X05']))
    GAME:WaitFrames(15)

    -- Le groupe la remercie, amusement et embarras melanges.
    ReactAll({
      [t.almotz] = "Happy",
      [t.coco] = "Happy",
      [t.hyko] = "Sweatdrop",
    })
    if t.penticus ~= nil then
      UI:SetSpeaker(t.penticus)
      GeneralFunctions.SetEmotion("Sigh")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X06']))
      GAME:WaitFrames(12)
    end
    if t2 ~= nil then
      UI:SetSpeaker(t2)
      GeneralFunctions.SetEmotion("Happy")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X07']))
      GAME:WaitFrames(12)
    end
    GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_P10']), "Sigh")
    Silence(15)
  end

  -- TRANSITION — Plusieurs heures plus tard...
  SOUND:FadeOutBGM(50)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(30)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_X08']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(15)

  -- ============ ACTE 4 — LE REPAS ============
  -- Sous le fondu : tout le monde s'installe aux sieges, les plats
  -- apparaissent. Le fondu s'ouvre sur le repas deja commence.
  SeatEveryone(t, t2, t3, partner, hero)
  local foods = SpawnFoods()
  GAME:FadeIn(30)
  SOUND:PlayBGM('Cave Camp.ogg', true)
  GAME:WaitFrames(10)

  -- Le camp vit : tout le monde mange, bruit de repas, camera douce.
  local seatList = {
    {t.penticus, 1}, {t.phileas, 2}, {t.coco, 3}, {t.rin, 4},
    {t.almotz, 5}, {t.hyko, 6}, {t.kino, 7}, {t.reinier, 8},
    {t3, 9}, {t2, 10}, {partner, 11}, {hero, 12},
  }
  for _, s in ipairs(seatList) do
    if s[1] ~= nil then
      GROUND:CharSetAnim(s[1], "Eat", true)
      GROUND:CharSetEmote(s[1], "eating", 0)
    end
  end
  SOUND:LoopSE('Dinner Eating')

  -- Petits echanges pendant le repas (le camp respire).
  GAME:MoveCamera(cloven_ruins_entrance_ch_5.CAMP_X - 40, cloven_ruins_entrance_ch_5.CAMP_Y + 10, 110, false)
  GAME:WaitFrames(20)
  if t2 ~= nil then
    UI:SetSpeaker(t2)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_M01']))
    Silence(10)
  end
  if t.coco ~= nil then
    UI:SetSpeaker(t.coco)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_M02']))
    Silence(10)
  end
  GAME:MoveCamera(cloven_ruins_entrance_ch_5.CAMP_X + 40, cloven_ruins_entrance_ch_5.CAMP_Y - 10, 130, false)
  GAME:WaitFrames(20)
  if t3 ~= nil then
    UI:SetSpeaker(t3)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_M04']))
    Silence(10)
  end
  if t.penticus ~= nil then
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_012']))
    Silence(12)
  end
  GAME:MoveCamera(cloven_ruins_entrance_ch_5.CAMP_X, cloven_ruins_entrance_ch_5.CAMP_Y, 80, false)
  GAME:WaitFrames(30)

  -- Fin du repas : purge des plats sous le fondu.
  SOUND:FadeOutSE('Dinner Eating', 60)
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(25)
  for _, food in ipairs(foods) do
    GAME:GetCurrentGround():RemoveTempObject(food)
  end

  -- ============ ACTE 5 — LA NUIT : LES REVES ============
  -- Les paillasses se deploient, la nuit tombe.
  cloven_ruins_entrance_ch_5.DeployBeds()
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  pcall(function() GROUND:AddMapStatus("darkness") end)
  GAME:WaitFrames(10)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_033']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(15)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- La conversation derive vers les reves et les ambitions. Chacun a sa
  -- vision ; le heros, lui, reste discret.
  Says(t.kino, "Inspired", 'CR5_V01', {t.reinier, partner, hero})
  Silence(10)
  Says(t.reinier, "Normal", 'CR5_V02', {t.kino, partner, hero})
  Silence(10)
  Says(t.coco, "Happy", 'CR5_V03', {t.rin, partner})
  Silence(10)
  Says(t.rin, "Normal", 'CR5_V04', {t.coco, partner})
  Silence(10)
  Says(t.phileas, "Normal", 'CR5_V05', {t.penticus, partner})
  Silence(10)
  Says(t.hyko, "Determined", 'CR5_V06', {t.almotz, partner})
  Silence(10)
  Says(t.almotz, "Happy", 'CR5_V07', {t.hyko, partner, hero})
  Silence(10)
  if t2 ~= nil then
    Says(t2, "Normal", 'CR5_V08', {t3, partner})
    Silence(10)
  end
  if t3 ~= nil then
    Says(t3, "Happy", 'CR5_V09', {t2, partner})
    Silence(10)
  end
  Says(t.penticus, "Inspired", 'CR5_V10', {t.phileas, partner, hero})
  Silence(10)
  Says(partner, "Determined", 'CR5_V11', {hero})
  Silence(15)

  -- Le heros : il n'a toujours aucun souvenir de sa vie passee.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_V12']), "Worried")
  Silence(20)

  -- ============ ACTE 6 — LA COMEDIE : PLUM, LA TSUNDERE ============
  if plum ~= nil and t2 ~= nil then
    -- Ganlon taquine Plum.
    Listen(t2, {plum, partner, hero, t.coco, t.almotz})
    UI:SetSpeaker(t2)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T01']))
    GAME:WaitFrames(12)
    -- Plum explose.
    pcall(function()
      if plum ~= nil then GROUND:CharTurnToCharAnimated(plum, t2, 4) end
    end)
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Angry")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T02']))
    GAME:WaitFrames(8)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T03']))
    GAME:WaitFrames(15)
    -- Almotz rit.
    if t.almotz ~= nil then
      GeneralFunctions.EmoteAndPause(t.almotz, "Joyous", false)
      UI:SetSpeaker(t.almotz)
      GeneralFunctions.SetEmotion("Joyous")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T04']))
      GAME:WaitFrames(12)
    end
    -- Plum se defend (c'est le feu, evidemment).
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Angry")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T05']))
    GAME:WaitFrames(15)
    -- Penticus calme le jeu.
    if t.penticus ~= nil then
      Listen(t.penticus, {t.coco, t.rin, t.hyko, t.almotz, partner, hero})
      UI:SetSpeaker(t.penticus)
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T06']))
      GAME:WaitFrames(12)
    end
    -- Plum, fierte, a part.
    UI:SetSpeaker(plum)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_T07']))
    Silence(15)
  end

  -- ============ COUCHER + BASCULE VERS LE REVE ============
  -- Chacun gagne sa paillasse, en decale (respiration du groupe).
  local B = cloven_ruins_entrance_ch_5.BEDS
  local bedOf = {
    [t.penticus] = 1, [t.phileas] = 2, [t.coco] = 3, [t.rin] = 4,
    [t.almotz] = 5, [t.hyko] = 6, [t.kino] = 7, [t.reinier] = 8,
    [t3] = 9, [t2] = 10, [partner] = 11, [hero] = 12,
  }
  local function seatX(i) return B[i][1] + 13 end
  local function seatY(i) return B[i][2] + 10 end
  local sleepOrder = {
    {t.penticus, 0}, {t.coco, 12}, {t.rin, 22}, {t.almotz, 32},
    {t.kino, 42}, {t.reinier, 52}, {t2, 62}, {t3, 72},
  }
  local vers = {}
  -- Plum rejoint sa paillasse (pres de sa cuisine).
  if plum ~= nil then
    local pb = cloven_ruins_entrance_ch_5.PLUM_BED
    vers[#vers+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(82)
      pcall(function()
        GROUND:MoveToPosition(plum, pb[1] + 13, pb[2] + 10, false, 1)
        GROUND:CharAnimateTurnTo(plum, Direction.Right, 4)
        GROUND:CharSetAnim(plum, "Sleep", true)
      end)
    end)
  end
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
  -- ruines une derniere fois.
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

  -- La discussion intime du duo, avant de s'endormir.
  local duoX = (seatX(bedOf[hero]) + seatX(bedOf[partner])) // 2
  local duoY = (seatY(bedOf[hero]) + seatY(bedOf[partner])) // 2
  GAME:MoveCamera(duoX, duoY, 45, false)
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_034']))
  Silence(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_D02']), "Normal")
  Silence(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_036'], hero:GetDisplayName()))
  GAME:WaitFrames(15)

  -- Le heros s'endort en dernier.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_D03']), "Normal")
  Silence(20)
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(30)

  -- La camera derive au-dessus du camp endormi, puis sur la grotte.
  local coroD1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(cloven_ruins_entrance_ch_5.CAMP_X, cloven_ruins_entrance_ch_5.CAMP_Y + 20, 90, false)
    GAME:MoveCamera(420, 142, 110, false)
  end)
  local coroD2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(120)
  end)
  TASK:JoinCoroutines({coroD1, coroD2})
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

  --PLUM DORT AUSSI, SUR SA PAILLASSE — elle est au camp (running gag).
  --Recreee exactement sur PLUM_BED, comme au Mont. Sans elle, elle
  --disparaitrait entre le coucher et le reveil (defaut de causalite).
  local plumMorning = nil
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    pcall(function()
      local pb = cloven_ruins_entrance_ch_5.PLUM_BED
      plumMorning = CharacterEssentials.MakeCharactersFromList({
        {'Jigglypuff', pb[1] + 13, pb[2] + 10, Direction.Right}
      })
      if plumMorning ~= nil then
        GROUND:CharSetAnim(plumMorning, "Sleep", true)
      end
    end)
  end

  -- VIE DE FOND — le camp DOIT continuer de vivre apres le reveil.
  -- Sans IA, les PNJ recrees resteraient figes comme des statues
  -- apres la reprise de controle (le defaut « diorama » interdit).
  -- Meme IA que SetupGround : ground_talking, delais differencies.
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

  cloven_ruins_entrance_ch_5.MorningAfterDream(
    hero, partner, {penticus = tropius, phileas = noctowl,
                    coco = snubbull, rin = audino,
                    hyko = growlithe, almotz = zigzagoon,
                    kino = breloom, reinier = girafarig,
                    plum = plumMorning})
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
  Silence(30)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_039']), "Worried")
  Silence(25)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_040']), "Sad")
  UI:ResetSpeaker()
  Silence(35)

  -- Le partenaire se reveille a son tour.
  pcall(function() GROUND:CharEndAnim(partner) end)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_041']))
  Silence(15)

  -- 4.2 LE LEVER DU SOLEIL — la nuit cede la place au jour.
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  SOUND:PlayBGM('Aegis Cave.ogg', false)
  GAME:MoveCamera(CX, CY - 20, 40, false)
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_042']))
  Silence(12)

  -- 4.3 LES AUTRES SE REVEILLENT, en cascade — chacun a son rythme.
  local wakeOrder = {
    {t.penticus, 0}, {t.rin, 10}, {t.coco, 20}, {t.hyko, 30},
    {t.almotz, 40}, {t.kino, 50}, {t.reinier, 60}, {t.phileas, 70},
    {t.plum, 80},
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

  -- 4.4 LE RASSEMBLEMENT DU MATIN — chacun s'affaire, puis converge.
  cloven_ruins_entrance_ch_5.BuildCampMorning()
  -- Petits echanges matinaux pendant que le camp s'eveille :
  -- Rin tend une baie a Coco, Hyko fait sa ronde, Kino et Reinier
  -- regardent les ruines une derniere fois avant de rejoindre.
  pcall(function()
    if t.rin ~= nil and t.coco ~= nil then
      GROUND:CharTurnToCharAnimated(t.rin, t.coco, 4)
      GeneralFunctions.EmoteAndPause(t.rin, "Happy", false)
    end
  end)
  GAME:WaitFrames(18)
  pcall(function()
    if t.hyko ~= nil then GROUND:CharAnimateTurnTo(t.hyko, Direction.Up, 4) end
  end)
  GAME:WaitFrames(12)

  -- CONVERGENCE vers le point de rassemblement.
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
  -- TOUT LE CERCLE se tourne vers lui.
  if t.penticus ~= nil then
    Listen(t.penticus, {t.phileas, t.kino, t.reinier, t.coco, t.rin, t.hyko, t.almotz})
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_043']))
    Silence(12)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_044']))
    Silence(15)
  end

  -- ============================================================
  -- 4.4bis PENTICUS REPARTIT LES EQUIPES (logique PMD : tout le
  -- monde ne reste pas groupe devant l'entree).
  --   - Kino + Reinier (les explorateurs des ruines) -> RECONNAISSANCE,
  --     partent les premiers baliser les etages. Depart VISIBLE.
  --   - Hyko -> garde du camp.
  --   - Rin + Coco -> base logistique (soins / intendance).
  --   - Le duo + Ganlon/Shuca -> equipe principale, partent quand le
  --     joueur est pret.
  -- ============================================================
  if t.penticus ~= nil then
    Listen(t.penticus, {t.kino, t.reinier, t.hyko, t.rin, t.coco, partner, hero})
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E01']))
    Silence(12)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E02']))
    Silence(12)
  end
  -- Kino accepte, Reinier acquiesce.
  if t.kino ~= nil then
    pcall(function() GeneralFunctions.DoAnimation(t.kino, 'Nod') end)
    UI:SetSpeaker(t.kino)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E03']))
    Silence(12)
  end
  if t.reinier ~= nil then
    pcall(function() GeneralFunctions.DoAnimation(t.reinier, 'Nod') end)
    UI:SetSpeaker(t.reinier)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E04']))
    Silence(12)
  end
  -- Penticus repartit le reste.
  if t.penticus ~= nil then
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E05']))
    Silence(12)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E06']))
    Silence(12)
  end
  -- Le partenaire demande pour le duo.
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E07']))
    Silence(12)
  end
  -- Penticus repond : le duo est l'equipe principale.
  if t.penticus ~= nil then
    UI:SetSpeaker(t.penticus)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_E08']))
    Silence(15)
  end

  -- DEPART DE LA RECONNAISSANCE : Kino et Reinier marchent vers
  -- l'entree de la grotte et disparaissent dans l'ombre de la porte.
  -- C'est un depart VU, pas une disparition silencieuse.
  -- Porte pile sur la bouche de la grotte (398-442,118-166), montee
  -- (pente) dessous. Chemin sur le sable puis entree dans la bouche :
  --   Kino (220,146) -> (350,235) -> (420,160) ; Reinier (266,168) ->
  --   (330,252) -> (415,175) -> porte.
  local depart = {}
  if t.kino ~= nil then
    depart[#depart+1] = TASK:BranchCoroutine(function()
      pcall(function()
        GeneralFunctions.EightWayMove(t.kino, 350, 235, false, 1)
        GeneralFunctions.EightWayMove(t.kino, 420, 160, false, 1)
        GROUND:CharAnimateTurnTo(t.kino, Direction.UpRight, 4)
      end)
      GAME:WaitFrames(30)
      pcall(function() GAME:GetCurrentGround():RemoveTempChar(t.kino) end)
    end)
  end
  if t.reinier ~= nil then
    depart[#depart+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(12)
      pcall(function()
        GeneralFunctions.EightWayMove(t.reinier, 330, 252, false, 1)
        GeneralFunctions.EightWayMove(t.reinier, 415, 175, false, 1)
        GROUND:CharAnimateTurnTo(t.reinier, Direction.UpRight, 4)
      end)
      GAME:WaitFrames(30)
      pcall(function() GAME:GetCurrentGround():RemoveTempChar(t.reinier) end)
    end)
  end
  if #depart > 0 then TASK:JoinCoroutines(depart) end
  GAME:WaitFrames(15)

  -- Le duo les regarde disparaitre dans l'entree. Pensee du heros.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_E09']), "Determined")
  Silence(15)

  -- Le duo se prepare, face a l'entree (la grotte). Ils s'avancent
  -- sur le sable et regardent l'ouverture. Les ruines s'embrasent au
  -- soleil levant.
  pcall(function()
    GROUND:MoveToPosition(partner, 360, 240, false, 1)
    GROUND:MoveToPosition(hero, 372, 248, false, 1)
  end)
  GAME:MoveCamera(420, 142, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_045']))
  Silence(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CR5_046']), "Determined")
  Silence(20)

  -- ============================================================
  -- 4.4ter DISPERSION DU CAMP (fix audit : les PNJ restaient
  -- agglutines au point de rassemblement, effet « paquet »).
  -- Chacun regagne son poste (OPEN_POS) : Penticus au commandement,
  -- Hyko a la garde du perimetre, Rin/Coco a la base, Almotz
  -- auxiliaire, Plum retourne a sa cuisine (48,245). Le camp vit.
  -- ============================================================
  local disperse = {}
  local disp = {
    {t.penticus, {220, 282}},
    {t.phileas,  {168, 264}},
    {t.coco,     {150, 244}},
    {t.rin,      {150, 215}},
    {t.hyko,     {176, 166}},
    {t.almotz,   {155, 186}},
    {t.plum,     {48, 245}},
  }
  for i, e in ipairs(disp) do
    if e[1] ~= nil then
      disperse[#disperse+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 8)
        pcall(function()
          GeneralFunctions.EightWayMove(e[1], e[2][1], e[2][2], false, 1)
          GROUND:CharAnimateTurnTo(e[1], Direction.Up, 4)
        end)
      end)
    end
  end
  TASK:JoinCoroutines(disperse)
  GAME:WaitFrames(15)

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

-- ================================================================
-- RETOUR APRES UN KO DANS LES RUINES — reveil au camp
-- Le duo a ete vaincu dans le donjon. Les membres de l'expedition
-- les ont ramenes au camp (ils attendaient devant l'entree). Rin
-- soigne, on discute brievement, on decide de retenter. Patron du
-- Mont Venteux (KODefeatCutscene).
-- ================================================================
function cloven_ruins_entrance_ch_5.KODefeatCutscene()
  local okK, errK = pcall(cloven_ruins_entrance_ch_5.KODefeatCutsceneBody)
  if not okK then
    PrintInfo('[CR5] reveil apres KO ecourte : '..tostring(errK))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.KODefeatCutsceneBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius = CH('Tropius')
  local noctowl = CH('Noctowl')
  local audino = CH('Audino')
  local snubbull = CH('Snubbull')
  local growlithe = CH('Growlithe')
  local zigzagoon = CH('Zigzagoon')
  local breloom = CH('Breloom')
  local girafarig = CH('Girafarig')
  --PLUM est a la base logistique (elle cuisine) : presente aussi.
  local jigglypuff = nil
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    jigglypuff = CH('Jigglypuff')
  end

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- Le duo est couche pres du feu : on les a ramenes du donjon.
  GROUND:TeleportTo(hero, CX + 8, CY + 32, Direction.Left)
  GROUND:TeleportTo(partner, CX - 24, CY + 32, Direction.Right)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(CX, CY + 30, 1, false)

  -- Les membres veillent autour : Rin proche (soins), les autres en
  -- cercle elargi (rayon 52-56, espacement >= 24 px entre chaque paire —
  -- l'ancien cercle serre laissait des paires a 15-20 px, chevauchement
  -- de sprites). Personne ne s'agite — on a porte les blesses.
  -- Plum, elle, prepare deja de quoi remonter les troupes (cuisine).
  pcall(function()
    if audino ~= nil then GROUND:TeleportTo(audino, CX - 52, CY + 32, Direction.Right) end
    if tropius ~= nil then GROUND:TeleportTo(tropius, CX + 0, CY + 56, Direction.Up) end
    if noctowl ~= nil then GROUND:TeleportTo(noctowl, CX - 56, CY + 0, Direction.Right) end
    if snubbull ~= nil then GROUND:TeleportTo(snubbull, CX + 56, CY + 0, Direction.Left) end
    if growlithe ~= nil then GROUND:TeleportTo(growlithe, CX + 36, CY - 41, Direction.Down) end
    if zigzagoon ~= nil then GROUND:TeleportTo(zigzagoon, CX - 36, CY - 41, Direction.Down) end
    if breloom ~= nil then GROUND:TeleportTo(breloom, CX + 0, CY - 56, Direction.Down) end
    if girafarig ~= nil then GROUND:TeleportTo(girafarig, CX + 36, CY + 41, Direction.Up) end
    if jigglypuff ~= nil then GROUND:TeleportTo(jigglypuff, 48, 245, Direction.Right) end
  end)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  -- Le heros se reveille en sursaut.
  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  -- RIN : la soigneuse, aux petits soins. Elle ecarte le duo d'un
  -- geste avant qu'il ne se redresse trop vite.
  if audino ~= nil then
    GROUND:CharTurnToCharAnimated(audino, hero, 4)
    GeneralFunctions.EmoteAndPause(audino, "Sweatdrop", false)
  end
  UI:SetSpeaker(audino)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K01']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K02']))
  GAME:WaitFrames(14)

  -- PENTICUS : il cadre, sans reproche — un chef rassemble.
  if tropius ~= nil then
    GROUND:CharTurnToCharAnimated(tropius, hero, 4)
  end
  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K03']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K04']))
  GAME:WaitFrames(14)
  -- PENTICUS EXPLIQUE LE SAUVETAGE : ce sont Kino et Reinier, partis
  -- en reconnaissance, qui ont trouve et ramene l'equipe vaincue.
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K10']))
    GAME:WaitFrames(14)
  end
  if breloom ~= nil then
    GROUND:CharTurnToCharAnimated(breloom, hero, 4)
  end
  UI:SetSpeaker(breloom)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K11']))
  GAME:WaitFrames(14)

  -- Le partenaire : la lecon du jour, sans dramatiser.
  if partner ~= nil then
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
  end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K05']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K06'], hero:GetDisplayName()))
  GAME:WaitFrames(14)

  -- KINO : le mot de l'expert — les ruines ne font pas de cadeaux.
  if breloom ~= nil then
    GROUND:CharTurnToCharAnimated(breloom, hero, 4)
    GeneralFunctions.EmoteAndPause(breloom, "Determined", false)
  end
  UI:SetSpeaker(breloom)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K07']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K08']))
  GAME:WaitFrames(14)

  --PLUM, depuis sa cuisine : le ragoût attend. Elle remonte le moral
  --a sa maniere — le running gag continue meme dans les moments durs.
  if jigglypuff ~= nil then
    pcall(function()
      GROUND:CharTurnToCharAnimated(jigglypuff, hero, 4)
      GeneralFunctions.EmoteAndPause(jigglypuff, "Happy", false)
    end)
    UI:SetSpeaker(jigglypuff)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K12']))
    GAME:WaitFrames(14)
  end

  -- On clot : le camp est pret, on retentera quand on sera remis.
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_K09']))
    GAME:WaitFrames(14)
  end

  -- Fin : le flag est consomme, le joueur reprend la main au camp.
  SV.Chapter5.PlayTempRuinsScene = false
  SV.Chapter5.RuinsLastExitReason = ''
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GeneralFunctions.RendreLaMain(true)
end

-- ================================================================
-- RETOUR APRES UN ABANDON VOLONTAIRE — repli digne
-- L'expedition a fait demi-tour d'elle-meme. Pas de KO : Penticus
-- salue la sagesse du repli, on se repose, on retentera. Patron du
-- Mont Venteux (RetreatReturnCutscene).
-- ================================================================
function cloven_ruins_entrance_ch_5.RetreatReturnCutscene()
  local okR, errR = pcall(cloven_ruins_entrance_ch_5.RetreatReturnCutsceneBody)
  if not okR then
    PrintInfo('[CR5] repli ecourte : '..tostring(errR))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.RetreatReturnCutsceneBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius = CH('Tropius')
  local noctowl = CH('Noctowl')
  local audino = CH('Audino')
  local snubbull = CH('Snubbull')
  local zigzagoon = CH('Zigzagoon')
  --Kino/Reinier sont dans les Ruines (reconnaissance) : absents du camp.
  local breloom = nil
  local girafarig = nil

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- L'equipe revient par la gauche, la tete baissee mais pas vaincue.
  GROUND:TeleportTo(hero, 24, 210, Direction.Right)
  GROUND:TeleportTo(partner, 24, 240, Direction.Right)
  GAME:MoveCamera(60, 225, 1, false)

  -- Les membres attendent au camp, disposes autour du feu.
  pcall(function()
    if tropius ~= nil then GROUND:TeleportTo(tropius, CX, CY + 40, Direction.Down) end
    if noctowl ~= nil then GROUND:TeleportTo(noctowl, CX - 40, CY + 20, Direction.Down) end
    if audino ~= nil then GROUND:TeleportTo(audino, CX + 40, CY + 20, Direction.Down) end
    if snubbull ~= nil then GROUND:TeleportTo(snubbull, CX - 30, CY - 10, Direction.Down) end
    if breloom ~= nil then GROUND:TeleportTo(breloom, CX + 30, CY - 10, Direction.Down) end
    if girafarig ~= nil then GROUND:TeleportTo(girafarig, CX + 56, CY - 16, Direction.Down) end
  end)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Cave Camp.ogg', true)
  GAME:WaitFrames(30)

  -- La traverse vers le camp.
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 120, 215, false, 1)
    GROUND:MoveToPosition(hero, 168, 260, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    GROUND:MoveToPosition(partner, 120, 240, false, 1)
    GROUND:MoveToPosition(partner, 256, 260, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  -- PENTICUS ACCUEILLE — pas de reproche : un chef sait quand on
  -- revient plus prudent.
  if tropius ~= nil then
    GROUND:CharTurnToCharAnimated(tropius, hero, 4)
    GeneralFunctions.EmoteAndPause(tropius, "Nod", false)
  end
  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R01']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R02']))
  GAME:WaitFrames(14)

  -- Le partenaire, honnete.
  if partner ~= nil then
    GROUND:CharTurnToCharAnimated(partner, tropius, 4)
  end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R03']))
  GAME:WaitFrames(14)

  -- PHILEAS : la lecon, sans jugement.
  if noctowl ~= nil then
    GROUND:CharTurnToCharAnimated(noctowl, partner, 4)
    GeneralFunctions.EmoteAndPause(noctowl, "Glowing", false)
  end
  UI:SetSpeaker(noctowl)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R04']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R05']))
  GAME:WaitFrames(14)

  -- ALMOTZ : l'auxiliaire du camp, pragmatique et chaleureux.
  -- (Kino et Reinier sont restes dans les Ruines en reconnaissance :
  -- c'est Almotz, resté au camp, qui accueille le repli.)
  if zigzagoon ~= nil then
    GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4)
    GeneralFunctions.EmoteAndPause(zigzagoon, "Sweatdrop", false)
  end
  UI:SetSpeaker(zigzagoon)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R06']))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R07']))
  GAME:WaitFrames(14)

  -- Penticus clot : repos, puis on retente.
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R08']))
    GAME:WaitFrames(14)
  end

  --PLUM, depuis sa cuisine : elle accueille le repli sans poser de
  --question. Le ragoût est pret, c'est tout ce qui compte.
  local jigglypuffR = nil
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.PlumAtMountCamp then
    jigglypuffR = CH('Jigglypuff')
  end
  if jigglypuffR ~= nil then
    pcall(function()
      GROUND:CharTurnToCharAnimated(jigglypuffR, hero, 4)
      GeneralFunctions.EmoteAndPause(jigglypuffR, "Happy", false)
    end)
    UI:SetSpeaker(jigglypuffR)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_R09']))
    GAME:WaitFrames(14)
  end

  SV.Chapter5.PlayTempRuinsScene = false
  SV.Chapter5.RuinsLastExitReason = ''
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GeneralFunctions.RendreLaMain(true)
end

return cloven_ruins_entrance_ch_5
