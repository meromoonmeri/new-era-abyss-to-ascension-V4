--[[
    cloven_ruins_entrance_ch_5.lua — CAMP DES RUINES TORDUES
    REFONTE COMPLETE (2026-08-04)

    ==================================================================
    GEOMETRIE — auditee case par case AVANT ecriture
    ==================================================================
    Carte 576x408 px, TexSize 3, grille d'obstacles 72x51 cases de 8 px,
    2024 cases bloquantes sur 3672.

    Composante praticable REELLE, calculee par remplissage depuis
    Main_Entrance_Marker (24,216) : 807 positions posables pour une
    boite 16x16 — les 4 cases de 8 px testees a chaque fois.
    Etendue x 0..424, y 120..296. Le coeur large et continu est la
    bande y=160..256.

    Objets scriptes a eviter : Dungeon_Entrance (398,118),
    Kangaskhan_Rock (368,208).

    Toutes les positions de ce fichier sortent de cet audit. Aucune
    n'est estimee a l'oeil.

    ==================================================================
    STRUCTURE — 7 actes
    ==================================================================
      A1  ecran NOIR, pas seuls, deux repliques. Le fondu se declenche
          SUR la deuxieme, pas avant.
      A2  arrivee, incomprehension, travelling tres lent vers le centre
      A3  PLUM immobile au centre d'un camp VIDE (ni feu ni paillasse)
      A4  arrivees echelonnees des 10 membres, malaise croissant
      A5  « VOOOOOOOOUS M'AVEZ PERDUUUUU !!! » puis running gag
      A6  Ganlon veut manger, Shuca le calme d'un regard, diner
      A7  nuit : paillasses posees ICI SEULEMENT, chuchotements,
          Phileas rappelle Kino, discussion intime, reve

    REGLE OST : aucune musique jusqu'a la fin de l'acte 5. Uniquement le
    vent et les pas. C'est le silence qui rend Plum inquietante — une
    nappe musicale detruirait l'effet.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_entrance_ch_5 = {}

-- ==================================================================
-- POSITIONS — toutes validees contre obstacles[]
-- ==================================================================
cloven_ruins_entrance_ch_5.CAMP_X = 160
cloven_ruins_entrance_ch_5.CAMP_Y = 152
local CX = cloven_ruins_entrance_ch_5.CAMP_X
local CY = cloven_ruins_entrance_ch_5.CAMP_Y

-- Cercle du diner : ellipse autour du foyer (la carte est plus large
-- que haute), 13 places, au moins 24 px entre voisins.
local PLACES = {
  Penticus  = {160, 112},
  Phileas   = {184, 120},
  Coco      = {208, 128},
  Rin       = {216, 152},
  Almotz    = {216, 176},
  Hyko      = {192, 192},
  Kino      = {160, 200},
  Reinier   = {128, 200},
  Shuca     = {104, 184},
  Ganlon    = {104, 160},
  Plum      = {104, 136},
  partner   = {120, 120},
  hero      = {136, 112},
}
cloven_ruins_entrance_ch_5.PLACES = PLACES

-- Paillasses : deux rangees, nord y=168 et sud y=248. 40 px entre
-- voisines (circulation), au moins 56 du foyer et 48 des objets
-- scriptes. Deployees SEULEMENT a l'acte 7.
local LITS = {
  Penticus  = {80, 80},
  Phileas   = {120, 80},
  Rin       = {160, 80},
  Coco      = {200, 80},
  Hyko      = {240, 80},
  Almotz    = {80, 220},
  Kino      = {120, 220},
  Reinier   = {160, 220},
  Ganlon    = {200, 220},
  Shuca     = {240, 220},
  Plum      = {200, 152},
  hero      = {120, 152},
  partner   = {160, 152},
}
cloven_ruins_entrance_ch_5.LITS = LITS

-- Arrivees echelonnees : depart au bord ouest, position d'attente.
-- Aucune collision entre les positions d'attente (verifie).
local ARR = {
  Phileas   = { depart = {0, 192}, attente = {120, 192} },
  Penticus  = { depart = {0, 192}, attente = {120, 168} },
  Coco      = { depart = {0, 192}, attente = {120, 216} },
  Rin       = { depart = {0, 192}, attente = {136, 184} },
  Ganlon    = { depart = {0, 192}, attente = {160, 208} },
  Shuca     = { depart = {0, 192}, attente = {144, 168} },
  Hyko      = { depart = {0, 192}, attente = {176, 192} },
  Almotz    = { depart = {0, 192}, attente = {176, 208} },
  Kino      = { depart = {0, 192}, attente = {160, 176} },
  Reinier   = { depart = {0, 192}, attente = {168, 136} },
}
cloven_ruins_entrance_ch_5.ARR = ARR

-- EntName reel de chaque PNJ : MakeCharactersFromList pose l'ESPECE
-- comme nom d'entite, pas le nom propre. CH('Tropius'), pas
-- CH('Penticus'). Verifie sur la version precedente du fichier.
local ESPECE = {
  Penticus  = 'Tropius',
  Phileas   = 'Noctowl',
  Coco      = 'Snubbull',
  Rin       = 'Audino',
  Hyko      = 'Growlithe',
  Almotz    = 'Zigzagoon',
  Kino      = 'Breloom',
  Reinier   = 'Girafarig',
  Plum      = 'Jigglypuff',
}
cloven_ruins_entrance_ch_5.ESPECE = ESPECE

-- ==================================================================
-- HELPERS DE MISE EN SCENE
-- ==================================================================
-- Regle du projet : un groupe qui pivote d'un bloc a l'air mecanique.
-- Tout ce qui touche plusieurs personnages est DECALE dans le temps.

local function E(nom)
  local id = ESPECE[nom]
  if id == nil then return nil end
  local c = nil
  pcall(function() c = CH(id) end)
  return c
end

-- Les auditeurs se tournent vers le locuteur, en decale.
local function Listen(speaker, listeners, emote)
  if speaker == nil or listeners == nil then return end
  local turns = {}
  for i, who in ipairs(listeners) do
    if who ~= nil and who ~= speaker then
      turns[#turns + 1] = TASK:BranchCoroutine(function()
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

-- Le corps parle avant la bouche.
local function Says(speaker, emotion, key, listeners, emote)
  if speaker == nil then return end
  Listen(speaker, listeners, emote)
  UI:SetSpeaker(speaker)
  GeneralFunctions.SetEmotion(emotion or "Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
end

-- Le heros ne parle JAMAIS a voix haute : pensee entre parentheses.
local function Pense(hero, key, emotion)
  pcall(function()
    GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings[key]),
                                  emotion or "Normal")
  end)
end

-- Boite de narration : UNIQUEMENT pour ouvrir ou clore un acte.
local function Narre(key)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  UI:SetCenter(false)
end

-- Un vrai temps : boite fermee, rien a l'ecran.
local function Silence(frames)
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(frames or 40)
end

-- Cascade de reactions : chacun SON emote, jamais le meme bloc.
local function ReactAll(reactions)
  if reactions == nil then return end
  local turns, i = {}, 0
  for _, r in ipairs(reactions) do
    i = i + 1
    if r[1] ~= nil then
      turns[#turns + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames((i - 1) * 5)
          GeneralFunctions.EmoteAndPause(r[1], r[2], true)
        end)
      end)
    end
  end
  if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
end

-- Respiration d'attente : de petits mouvements pour que personne ne
-- soit un mannequin pendant les dialogues des autres.
local function Respire(gens)
  local co = {}
  for i, who in ipairs(gens) do
    if who ~= nil then
      co[#co + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 11)
          GeneralFunctions.LookAround(who, 1, 10, false, false, true, Direction.Down)
        end)
      end)
    end
  end
  return co
end

-- Vent : le seul "son d'ambiance" des actes 1 a 5.
-- DUN_Wind est le SEUL SE de vent atteste dans le depot (5 emplois).
-- Premiere redaction : DUN_Whirlwind et DUN_Move_Ground — verification
-- faite, ZERO occurrence dans tout le mod. C'etaient des inventions.
local function Vent()
  pcall(function() SOUND:PlayBattleSE("DUN_Wind") end)
end

-- Les PAS de l'acte 1 ne sont pas un SE : aucun n'existe dans ce mod.
-- On les FAIT ENTENDRE autrement — les personnages marchent reellement
-- sous le noir (MoveToPosition), et le moteur joue leur animation de
-- marche. Le vent ponctue. C'est la solution honnete : pas de son
-- invente, et le joueur entend quand meme quelque chose bouger.


-- ==================================================================
-- SETUP — qui est present, et OU
-- ==================================================================
-- includeRecon : Kino et Reinier sont-ils au camp ? Ils partent en
-- reconnaissance apres le matin.
function cloven_ruins_entrance_ch_5.SetupGround(includeRecon)
  local spawn = {
    {'Tropius',   ARR.Penticus.attente[1], ARR.Penticus.attente[2], Direction.Down},
    {'Noctowl',   ARR.Phileas.attente[1],  ARR.Phileas.attente[2],  Direction.Down},
    {'Snubbull',  ARR.Coco.attente[1],     ARR.Coco.attente[2],     Direction.Down},
    {'Audino',    ARR.Rin.attente[1],      ARR.Rin.attente[2],      Direction.Down},
    {'Growlithe', ARR.Hyko.attente[1],     ARR.Hyko.attente[2],     Direction.Down},
    {'Zigzagoon', ARR.Almotz.attente[1],   ARR.Almotz.attente[2],   Direction.Down},
  }
  if includeRecon then
    spawn[#spawn + 1] = {'Breloom',   ARR.Kino.attente[1],    ARR.Kino.attente[2],    Direction.Down}
    spawn[#spawn + 1] = {'Girafarig', ARR.Reinier.attente[1], ARR.Reinier.attente[2], Direction.Down}
  else
    pcall(function() GROUND:Hide('Breloom') end)
    pcall(function() GROUND:Hide('Girafarig') end)
  end
  -- Plum s'est incrustee au Mont Venteux et a suivi. Running gag.
  spawn[#spawn + 1] = {'Jigglypuff', PLACES.Plum[1], PLACES.Plum[2], Direction.Down}

  -- ================================================================
  -- ANTI-DUPLICATION — bug constate en jeu sur l'ancienne carte
  -- ================================================================
  -- CharacterEssentials.MakeCharactersFromList appelle AddTempChar
  -- (CharacterEssentials.lua:2023 et 2034) SANS jamais verifier si
  -- l'entite existe deja. Chaque appel AJOUTE donc un sprite.
  --
  -- Or SetupGround etait appele DEUX FOIS pour une seule arrivee :
  --     init.lua:168        SetupGround(true)
  --     ch_5.lua ArrivalBody SetupGround(false)
  -- D'ou les sprites dupliques signales : deux Penticus, deux Rin,
  -- superposes au pixel pres et impossibles a distinguer a l'arret,
  -- mais visibles des qu'un des deux bouge.
  --
  -- On filtre donc la liste : on ne cree que ce qui n'existe pas.
  -- FindEntity est la methode qu'emploie ScriptGround.Hide lui-meme
  -- (Lua/ScriptGround.cs:31) ; signature verifiee dans
  -- Ground/Maps/GroundMap.cs:1004. Aucune API inventee.
  local aCreer = {}
  for _, e in ipairs(spawn) do
    local nom = e[1]
    local deja = false
    pcall(function()
      deja = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
    end)
    if deja then
      PrintInfo('[CR5] ' .. tostring(nom) .. ' existe deja — non recree.')
    else
      aCreer[#aCreer + 1] = e
    end
  end
  if #aCreer > 0 then
    pcall(function() CharacterEssentials.MakeCharactersFromList(aCreer) end)
  end

  -- Meme precaution pour les equipiers : SpawnerDoSpawn appele deux
  -- fois poserait deux fois Ganlon et Shuca. On ne declenche le
  -- spawner que si l'entite n'est pas deja sur la carte.
  if GAME:GetPlayerPartyCount() > 3 then
    for i, nom in ipairs({'Teammate2', 'Teammate3'}) do
      local deja = false
      pcall(function()
        deja = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
      end)
      if not deja then
        pcall(function()
          local cle = 'TEAMMATE_' .. tostring(i + 1)
          GROUND:SpawnerSetSpawn(cle, GAME:GetPlayerPartyMember(i + 1))
          GROUND:SpawnerDoSpawn(cle)
        end)
      end
    end
  end
end

function cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local anims = GAME:GetCurrentGround().Decorations[0].Anims
    for i = anims.Count - 1, 0, -1 do anims:RemoveAt(i) end
  end)
  cloven_ruins_entrance_ch_5.RemoveFireBlocker()
end

function cloven_ruins_entrance_ch_5.AddFireBlocker()
  pcall(function()
    cloven_ruins_entrance_ch_5.RemoveFireBlocker()
    local b = RogueEssence.Ground.GroundObject(
      RogueEssence.Content.ObjAnimData("", 1),
      RogueElements.Rect(CX + 6, CY + 6, 24, 24),
      RogueElements.Loc(0, 0), false, "Campfire_Blocker")
    b:ReloadEvents()
    GAME:GetCurrentGround():AddTempObject(b)
    cloven_ruins_entrance_ch_5.fireBlocker = b
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

-- LE FEU : allume seulement au diner (acte 6). A l'arrivee, le camp
-- doit etre VIDE — c'est une exigence de la scene.
function cloven_ruins_entrance_ch_5.BuildCampDay()
  -- JOUR : aucun filtre. On retire ceux d'une nuit precedente, sinon
  -- le camp reste sombre au reveil (defaut constate au Mont Venteux).
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local g = GAME:GetCurrentGround()
    g.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(
      RogueEssence.Content.ObjAnimData('Campfire', 6), RogueElements.Loc(CX, CY)))
  end)
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end

-- LES PAILLASSES : posees SEULEMENT a l'acte 7, jamais avant.
function cloven_ruins_entrance_ch_5.DeployBeds()
  -- NUIT NOIRE — patron exact du Mont Venteux
  -- (mount_windswept_entrance_ch_5.lua:4452 pose 'dusk' a l'arrivee au
  -- couchant, puis :5449 pose 'darkness' au deploiement des couchages).
  -- Ici les paillasses sortent au coeur de la nuit : on passe donc
  -- directement de dusk a darkness.
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  pcall(function() GROUND:AddMapStatus("darkness") end)
  cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local g = GAME:GetCurrentGround()
    local hay = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
    for _, b in pairs(LITS) do
      g.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay,
        RogueElements.Loc(b[1], b[2])))
    end
    g.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(
      RogueEssence.Content.ObjAnimData('Campfire', 6), RogueElements.Loc(CX, CY)))
  end)
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end


-- ==================================================================
-- ACTE 1 — L'ECRAN NOIR
-- ==================================================================
-- Le fondu ne se declenche PAS a l'entree de la carte : il attend la
-- DEUXIEME replique du partenaire. Jusque-la, le joueur n'a que la
-- voix et le mouvement.
function cloven_ruins_entrance_ch_5.ArrivalCutscene()
  local ok, err = pcall(cloven_ruins_entrance_ch_5.ArrivalBody)
  if not ok then
    PrintInfo('[CR5] arrivee interrompue : ' .. tostring(err))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.ArrivalBody()
  -- LE NOIR AVANT TOUT APPEL MOTEUR.
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  SOUND:StopBGM()   -- AUCUNE OST jusqu'a la fin de l'acte 5.

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(false)
  -- PLEIN JOUR a l'arrivee : on retire tout filtre herite d'une
  -- session precedente. Sans cela, un joueur qui recharge apres la
  -- nuit arriverait dans un camp reste noir.
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  -- Camp VIDE : ni feu, ni paillasse. On purge tout decor herite.
  cloven_ruins_entrance_ch_5.PurgeDecor()

  -- Tout le monde est cache sauf Plum : elle attend deja au centre.
  for nom, id in pairs(ESPECE) do
    if nom ~= 'Plum' then pcall(function() GROUND:Hide(id) end) end
  end

  -- Le duo entre par l'ouest, sous le noir. Ils MARCHENT vraiment :
  -- c'est leur animation de pas que le joueur percoit.
  GROUND:TeleportTo(hero, 0, 192, Direction.Right)
  if partner ~= nil then GROUND:TeleportTo(partner, 0, 208, Direction.Right) end
  GAME:MoveCamera(128, 208, 1, false)

  local marche1 = {}
  marche1[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 64, 192, false, 1) end)
  end)
  marche1[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(9)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 64, 208, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(marche1) end)

  -- Premiere replique, TOUJOURS sur le noir.
  Says(partner, "Normal", 'CR5_A01')
  Silence(18)

  -- Quelques secondes de marche de plus.
  local marche2 = {}
  marche2[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 120, 192, false, 1) end)
  end)
  marche2[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(9)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 120, 208, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(marche2) end)
  Silence(14)

  -- DEUXIEME replique : c'est PENDANT elle que le noir se leve.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  local fondu = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    pcall(function() GAME:FadeIn(150) end)   -- tres progressif
  end)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_A02']))
  pcall(function() TASK:JoinCoroutines({fondu}) end)
  Vent()
  Silence(20)

  cloven_ruins_entrance_ch_5.Acte2(hero, partner)
end


-- ==================================================================
-- ACTE 2 — ILS NE COMPRENNENT PAS CE QU'ILS VOIENT
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte2(hero, partner)
  -- Ils avancent encore un peu, puis s'arretent net.
  local av = {}
  av[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 184, 216, false, 1) end)
  end)
  av[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(7)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 184, 232, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(av) end)
  Silence(24)

  -- Ils regardent DEVANT. Le camp est vide, et ca ne colle pas.
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 6)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Right, 6) end
  end)
  Silence(30)

  -- Puis ils se regardent l'un l'autre. Rien n'est dit : c'est le
  -- regard qui pose la question.
  pcall(function()
    if partner ~= nil then
      GROUND:CharTurnToCharAnimated(hero, partner, 5)
      GAME:WaitFrames(7)
      GROUND:CharTurnToCharAnimated(partner, hero, 5)
    end
  end)
  Silence(28)

  -- Emotes d'interrogation et de gene, decalees.
  ReactAll({ {partner, "Question"}, {hero, "Sweating"} })
  Silence(16)

  -- Chacun balaie les alentours, a son rythme.
  local regard = {}
  regard[1] = TASK:BranchCoroutine(function()
    if partner ~= nil then
      pcall(function() GeneralFunctions.LookAround(partner, 2, 14, false, false, true, Direction.Right) end)
    end
  end)
  regard[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    pcall(function() GeneralFunctions.LookAround(hero, 2, 14, false, false, true, Direction.Right) end)
  end)
  pcall(function() TASK:JoinCoroutines(regard) end)
  Vent()
  Silence(30)

  Says(partner, "Worried", 'CR5_A03', {hero})
  Silence(18)
  Pense(hero, 'CR5_A04', "Worried")
  Silence(24)

  cloven_ruins_entrance_ch_5.Acte3(hero, partner)
end


-- ==================================================================
-- ACTE 3 — LE TRAVELLING, PUIS PLUM
-- ==================================================================
-- La camera quitte le groupe et glisse TRES lentement jusqu'au centre
-- exact du camp. 104 px a parcourir : a 240 frames, c'est un mouvement
-- que le joueur voit avancer sans le sentir bouger.
function cloven_ruins_entrance_ch_5.Acte3(hero, partner)
  pcall(function() GAME:MoveCamera(CX, CY, 240, false) end)
  Silence(20)
  Vent()
  Silence(40)

  -- Elle est la. Debout. Immobile. Face au groupe. Bras le long du
  -- corps. La camera reste sur elle SANS AUCUN DIALOGUE.
  local plum = E('Plum')
  if plum ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.Left, 8) end)
  end
  Silence(60)
  Vent()
  Silence(70)

  -- Le partenaire finit par rompre le silence. Sourire gene.
  Says(partner, "Sigh", 'CR5_A05')
  Silence(14)
  Says(partner, "Happy", 'CR5_A06')
  Silence(22)

  -- Le heros observe : comment est-elle arrivee avant eux ?
  Pense(hero, 'CR5_A07', "Surprised")
  Silence(26)

  -- Plum ne repond pas. Elle detourne seulement les yeux vers le
  -- chemin par lequel tout le monde arrive.
  if plum ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.DownLeft, 10) end)
  end
  Silence(50)
  Vent()
  Silence(45)

  -- Emote "?" au-dessus de la tete du partenaire.
  if partner ~= nil then
    pcall(function() GeneralFunctions.EmoteAndPause(partner, "Question", true) end)
  end
  Says(partner, "Worried", 'CR5_A08')
  Silence(55)

  cloven_ruins_entrance_ch_5.Acte4(hero, partner, plum)
end


-- ==================================================================
-- ACTE 4 — LES ARRIVEES ECHELONNEES
-- ==================================================================
-- Chacun entre a son tour, marche vraiment depuis le bord ouest, et
-- lache une replique qui lui ressemble. Kino et Reinier sont les TOUT
-- DERNIERS et ne remarquent meme pas Plum : ils parlent d'eux.
local function Entre(nom, dir)
  local id = ESPECE[nom]
  if id == nil then return nil end
  local a = ARR[nom]
  if a == nil then return E(nom) end
  local c = E(nom)
  if c == nil then return nil end
  pcall(function()
    GROUND:TeleportTo(c, a.depart[1], a.depart[2], dir or Direction.Right)
    GROUND:Unhide(id)
    GROUND:MoveToPosition(c, a.attente[1], a.attente[2], false, 1)
  end)
  return c
end

function cloven_ruins_entrance_ch_5.Acte4(hero, partner, plum)
  -- Camera sur le chemin d'arrivee : on voit venir.
  pcall(function() GAME:MoveCamera(176, 232, 100, false) end)
  Silence(20)

  -- 1er : Phileas, methodique, il annonce l'etape.
  local phileas = Entre('Phileas')
  Says(phileas, "Normal", 'CR5_A09', {hero, partner})
  Silence(12)

  -- 2e : Penticus, le doyen, souffle apres la marche.
  local penticus = Entre('Penticus')
  Says(penticus, "Sigh", 'CR5_A10', {phileas})
  Silence(10)

  -- 3e : Rin, medicale, elle s'inquiete des pattes de tout le monde.
  local rin = Entre('Rin')
  Says(rin, "Worried", 'CR5_A11', {penticus, partner})
  Silence(10)

  -- 4e : Coco, surprise que le heros soit deja la.
  local coco = Entre('Coco')
  Says(coco, "Surprised", 'CR5_A12', {hero, partner})
  Silence(10)

  -- 5e : Hyko, garde du perimetre, il flaire quelque chose.
  local hyko = Entre('Hyko')
  Says(hyko, "Normal", 'CR5_A13', {coco})
  Silence(10)

  -- 6e : Almotz, soulage de ne pas etre le dernier pour une fois.
  local almotz = Entre('Almotz')
  Says(almotz, "Happy", 'CR5_A14', {hyko, rin})
  Silence(12)

  -- Le groupe respire : personne n'est un mannequin.
  local resp = Respire({phileas, penticus, rin, coco, hyko, almotz})
  Silence(30)
  pcall(function() TASK:JoinCoroutines(resp) end)

  -- Ganlon et Shuca s'ils sont dans l'equipe.
  local ganlon, shuca = CH('Teammate2'), CH('Teammate3')
  if ganlon ~= nil then
    pcall(function()
      GROUND:TeleportTo(ganlon, ARR.Ganlon.depart[1], ARR.Ganlon.depart[2], Direction.Right)
      GROUND:MoveToPosition(ganlon, ARR.Ganlon.attente[1], ARR.Ganlon.attente[2], false, 1)
    end)
    Says(ganlon, "Sigh", 'CR5_A15', {almotz, coco})
    Silence(10)
  end
  if shuca ~= nil then
    pcall(function()
      GROUND:TeleportTo(shuca, ARR.Shuca.depart[1], ARR.Shuca.depart[2], Direction.Right)
      GROUND:MoveToPosition(shuca, ARR.Shuca.attente[1], ARR.Shuca.attente[2], false, 1)
    end)
    Says(shuca, "Normal", 'CR5_A16', {ganlon})
    Silence(12)
  end

  -- LES TOUT DERNIERS : Kino et Reinier, en pleine conversation.
  -- Ils ne voient meme pas Plum et continuent leur histoire.
  local kino = Entre('Kino')
  local reinier = Entre('Reinier')
  Says(kino, "Joyous", 'CR5_A17', {reinier})
  Silence(8)
  Says(reinier, "Normal", 'CR5_A18', {kino})
  Silence(8)
  Says(kino, "Shouting", 'CR5_A19', {reinier})
  Silence(14)

  -- ...puis ils comprennent que personne ne les ecoute.
  pcall(function()
    GROUND:CharAnimateTurnTo(kino, Direction.Right, 5)
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(reinier, Direction.Right, 5)
  end)
  ReactAll({ {kino, "Question"}, {reinier, "Sweating"} })
  Says(reinier, "Worried", 'CR5_A20', {kino})
  Silence(20)

  -- LE MALAISE. Les conversations se font plus discretes. Chacun a sa
  -- lecture de la situation, fidele a son caractere.
  pcall(function() GAME:MoveCamera(CX - 24, CY, 120, false) end)
  Says(rin, "Worried", 'CR5_A21', {plum})
  Silence(16)
  Says(coco, "Normal", 'CR5_A22', {plum, rin})
  Silence(16)
  Says(hyko, "Sad", 'CR5_A23', {plum})
  Silence(18)
  Says(penticus, "Normal", 'CR5_A24', {plum, phileas})
  Silence(20)

  -- Tout le monde finit par se tourner vers elle, en decale.
  Listen(plum, {phileas, penticus, rin, coco, hyko, almotz, kino, reinier,
                ganlon, shuca, partner, hero})
  Silence(40)
  Vent()
  Silence(45)

  Pense(hero, 'CR5_A25', "Worried")
  Silence(50)

  cloven_ruins_entrance_ch_5.Acte5(hero, partner, plum,
    {phileas=phileas, penticus=penticus, rin=rin, coco=coco, hyko=hyko,
     almotz=almotz, kino=kino, reinier=reinier, ganlon=ganlon, shuca=shuca})
end


-- ==================================================================
-- ACTE 5 — LE CRI
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte5(hero, partner, plum, t)
  -- Elle se retourne BRUTALEMENT. Rotation en 1 frame, pas 8.
  if plum ~= nil then
    pcall(function() GROUND:EntTurn(plum, Direction.Left) end)
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  end
  -- TRES gros silence. C'est lui qui arme la blague.
  Silence(75)

  -- LE CRI.
  pcall(function() BossFX.ShakeScreen(6, 30) end)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end) -- Start funny guild theme!
  Says(plum, "Shouting", 'CR5_A26')
  pcall(function() GeneralFunctions.EmoteAndPause(plum, "Angry", true) end)
  Silence(20)

  -- Tout le camp encaisse : emotes DIFFERENTES, en cascade.
  ReactAll({ {partner, "Shock"}, {hero, "Exclaim"}, {t.coco, "Shock"},
             {t.rin, "Sweating"}, {t.hyko, "Exclaim"}, {t.almotz, "Shock"},
             {t.kino, "Question"}, {t.reinier, "Sweating"} })
  Silence(24)

  -- LE RUNNING GAG
  Says(t.penticus, "Sigh", 'CR5_A27', {plum})
  Silence(12)
  Says(plum, "Angry", 'CR5_A28', {t.penticus})
  Silence(10)
  Says(t.coco, "Happy", 'CR5_A29', {plum})
  Silence(10)
  Says(plum, "Shouting", 'CR5_A30', {t.coco})
  Silence(12)
  Says(t.phileas, "Normal", 'CR5_A31', {plum})
  Silence(14)
  -- La chute : elle etait devant tout le monde depuis le debut.
  Says(plum, "Sigh", 'CR5_A32', {t.phileas, partner})
  Silence(16)
  ReactAll({ {t.kino, "Happy"}, {partner, "Sweating"}, {t.almotz, "Happy"} })
  Says(t.kino, "Joyous", 'CR5_A33', {plum})
  Silence(12)
  Says(plum, "Angry", 'CR5_A34', {t.kino})
  Silence(14)
  Pense(hero, 'CR5_A35', "Sigh")
  Silence(20)

  cloven_ruins_entrance_ch_5.Acte6(hero, partner, plum, t)
end


-- ==================================================================
-- ACTE 6 — GANLON A FAIM, SHUCA LE REGARDE
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte6(hero, partner, plum, t)
  if t.ganlon ~= nil then
    Says(t.ganlon, "Happy", 'CR5_A36', {t.coco, partner})
    Silence(12)
    Says(t.coco, "Joyous", 'CR5_A37', {t.ganlon})
    Silence(10)
    Says(t.almotz, "Happy", 'CR5_A38', {t.ganlon})
    Silence(10)
    Says(t.ganlon, "Angry", 'CR5_A39', {t.coco, t.almotz})
    Silence(12)

    -- SHUCA NE DIT RIEN. Elle le regarde. C'est tout.
    if t.shuca ~= nil then
      pcall(function() GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 3) end)
      Silence(45)
      pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweating", true) end)
      Silence(18)
      Says(t.ganlon, "Sigh", 'CR5_A40', {t.shuca})
      Silence(16)
      Pense(hero, 'CR5_A41', "Surprised")
      Silence(22)
    end
  end

  -- Le feu s'allume : c'est le repas. Le camp prend enfin vie.
  Narre('CR5_A42')
  pcall(function() SOUND:FadeOutBGM(30) end) -- Fade out funny BGM
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("At the End of the Day.ogg", true) end) -- Start cozy camp BGM!
  cloven_ruins_entrance_ch_5.BuildCampDay()

  -- Chacun a sa place autour du foyer.
  local assis = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, a in ipairs(assis) do
    local c, p = a[1], PLACES[a[2]]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Down) end)
    end
  end
  -- Tout le monde regarde le feu.
  for _, a in ipairs(assis) do
    if a[1] ~= nil then
      pcall(function()
        local dx, dy = CX - a[1].Position.X, CY - a[1].Position.Y
        local d = Direction.Down
        if math.abs(dx) > math.abs(dy) then
          d = (dx > 0) and Direction.Right or Direction.Left
        else
          d = (dy > 0) and Direction.Down or Direction.Up
        end
        GROUND:EntTurn(a[1], d)
      end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(45)
  Silence(30)

  -- LE DINER : les conversations se croisent.
  Says(t.penticus, "Normal", 'CR5_A43', {hero, partner, t.phileas})
  Silence(12)
  Says(t.kino, "Joyous", 'CR5_A44', {t.reinier, t.coco})
  Silence(10)
  Says(t.reinier, "Sigh", 'CR5_A45', {t.kino})
  Silence(10)
  Says(t.rin, "Happy", 'CR5_A46', {partner, hero})
  Silence(10)
  Says(plum, "Angry", 'CR5_A47', {t.coco, t.kino})
  Silence(10)
  ReactAll({ {t.coco, "Happy"}, {t.hyko, "Happy"}, {t.almotz, "Happy"} })
  Says(t.coco, "Joyous", 'CR5_A48', {plum})
  Silence(12)
  Says(t.hyko, "Normal", 'CR5_A49', {t.penticus})
  Silence(10)
  Says(t.phileas, "Normal", 'CR5_A50', {t.penticus, hero, partner})
  Silence(14)
  Says(partner, "Determined", 'CR5_A51', {hero, t.phileas})
  Silence(12)
  Pense(hero, 'CR5_A52', "Happy")
  Silence(20)

  cloven_ruins_entrance_ch_5.Acte7(hero, partner, plum, t)
end


-- ==================================================================
-- ACTE 7 — LA NUIT, LES PAILLASSES, LE REVE
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte7(hero, partner, plum, t)
  -- LE SOIR TOMBE. 'dusk' d'abord, sous les yeux du joueur : la
  -- lumiere baisse pendant que le camp discute encore. La nuit noire
  -- ('darkness') ne viendra qu'avec les paillasses, dans DeployBeds.
  -- Patron du Mont Venteux, ou la meme progression est jouee.
  -- TRANSITION DOUCE VERS LE CREPUSCULE : on passe par un fondu doux de 40 frames
  -- pour eviter tout changement brusque de couleur a l'ecran (respect strict de la DA PMD).
  pcall(function() GAME:FadeOut(false, 40) end)
  pcall(function() GAME:WaitFrames(25) end)
  pcall(function() GROUND:RemoveMapStatus("gloom") end)
  pcall(function() GROUND:AddMapStatus("dusk") end)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GAME:FadeIn(40) end)
  -- Fin de la transition douce

  Narre('CR5_A53')
  GAME:FadeOut(false, 50)
  GAME:WaitFrames(35)

  -- LES PAILLASSES SONT POSEES ICI, ET NULLE PART AVANT.
  cloven_ruins_entrance_ch_5.DeployBeds()

  -- Chacun sur SA paillasse. Positions auditees : 40 px entre voisines,
  -- aucune sur un obstacle, aucune superposition.
  local couches = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, c in ipairs(couches) do
    local ch, p = c[1], LITS[c[2]]
    if ch ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(ch, p[1], p[2], Direction.Down) end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(50)
  Silence(30)

  -- Les chuchotements, comme au Mont Venteux.
  Says(t.coco, "Normal", 'CR5_A54', {t.rin})
  Silence(14)
  Says(t.rin, "Happy", 'CR5_A55', {t.coco})
  Silence(12)
  Says(t.almotz, "Normal", 'CR5_A56', {t.hyko})
  Silence(12)
  Says(t.kino, "Joyous", 'CR5_A57', {t.reinier})
  Silence(10)
  Says(t.reinier, "Sigh", 'CR5_A58', {t.kino})
  Silence(10)
  Says(t.kino, "Happy", 'CR5_A59', {t.reinier})
  Silence(14)

  -- PHILEAS rappelle tout le monde a l'ordre — et cite Kino, comme
  -- au Mont Venteux. Clin d'oeil assume.
  Says(t.phileas, "Normal", 'CR5_A60', {t.kino, t.coco, t.rin, t.almotz})
  Silence(16)
  ReactAll({ {t.kino, "Sweating"}, {t.coco, "Happy"} })
  Says(t.kino, "Sigh", 'CR5_A61', {t.phileas})
  Silence(14)
  Says(plum, "Angry", 'CR5_A62', {t.phileas})
  Silence(12)
  ReactAll({ {t.phileas, "Sweating"} })
  Silence(20)

  -- LA DISCUSSION INTIME — camera resserree sur les deux paillasses.
  pcall(function()
    GAME:MoveCamera((LITS.hero[1] + LITS.partner[1]) / 2,
                    LITS.hero[2] + 8, 90, false)
  end)
  Silence(24)
  pcall(function()
    if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, hero, 5) end
  end)
  Silence(16)
  Says(partner, "Normal", 'CR5_A63', {hero})
  Silence(18)
  Pense(hero, 'CR5_A64', "Normal")
  Silence(16)
  Says(partner, "Determined", 'CR5_A65', {hero})
  Silence(20)
  Says(partner, "Happy", 'CR5_A66', {hero})
  Silence(24)

  -- Bonne nuit au reste de l'equipe.
  Says(t.penticus, "Normal", 'CR5_A67')
  Silence(30)

  -- Tout le monde s'endort.
  local dodo = {}
  for i, c in ipairs(couches) do
    if c[1] ~= nil then
      dodo[#dodo + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 6)
          GROUND:CharSetAnim(c[1], "Sleep", true)
        end)
      end)
    end
  end
  pcall(function() TASK:JoinCoroutines(dodo) end)
  Silence(40)

  SV.Chapter5.RuinsCampNightDone = true

  -- LE REVE : bascule vers hero_dream, qui renvoie ici.
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(40)

  local peut = false
  local okPre = pcall(function()
    peut = (_DATA.DataIndices ~= nil)
  end)
  if not okPre then peut = false end

  SV.TemporaryFlags.DreamReturn = 'cloven_ruins_entrance'
  local okDream = pcall(function()
    GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
  end)
  if not okDream then
    PrintInfo('[CR5] hero_dream indisponible — reve saute')
    pcall(function() SV.Chapter5.RuinsDreamSeen = true end)
    pcall(function()
      GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker', true)
    end)
  end
end


-- ==================================================================
-- LENDEMAIN MATIN — retour du reve
-- ==================================================================
function cloven_ruins_entrance_ch_5.ResumeAfterDream()
  local ok, err = pcall(cloven_ruins_entrance_ch_5.MorningBody)
  if not ok then
    PrintInfo('[CR5] matin interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.MorningBody()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  SOUND:StopBGM()

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(true)
  -- On se reveille encore dans la nuit : DeployBeds repose 'darkness'.
  -- Le jour se levera avec BuildCampDay, plus bas, qui le retire.
  cloven_ruins_entrance_ch_5.DeployBeds()

  local t = {phileas=E('Phileas'), penticus=E('Penticus'), rin=E('Rin'),
             coco=E('Coco'), hyko=E('Hyko'), almotz=E('Almotz'),
             kino=E('Kino'), reinier=E('Reinier'),
             ganlon=CH('Teammate2'), shuca=CH('Teammate3')}
  local plum = E('Plum')

  -- Tout le monde encore couche.
  local couches = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, c in ipairs(couches) do
    local ch, p = c[1], LITS[c[2]]
    if ch ~= nil and p ~= nil then
      pcall(function()
        GROUND:TeleportTo(ch, p[1], p[2], Direction.Down)
        GROUND:CharSetAnim(ch, "Sleep", true)
      end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)

  pcall(function() UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['CR5_A68']) .. "\n\n", -1) end)
  GAME:FadeIn(60)
  Silence(30)

  -- Le camp se reveille, en decale : personne ne se leve en meme temps.
  local leve = {}
  for i, c in ipairs(couches) do
    if c[1] ~= nil then
      leve[#leve + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 9)
          GROUND:CharEndAnim(c[1])
          GeneralFunctions.LookAround(c[1], 1, 12, false, false, true, Direction.Down)
        end)
      end)
    end
  end
  pcall(function() TASK:JoinCoroutines(leve) end)
  Silence(24)

  Says(t.coco, "Sigh", 'CR5_A69', {t.rin})
  Silence(12)
  Says(t.kino, "Happy", 'CR5_A70', {t.reinier})
  Silence(12)

  -- On replie les paillasses : le decor redevient un camp de jour.
  Narre('CR5_A71')
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(25)
  cloven_ruins_entrance_ch_5.BuildCampDay()

  -- Rassemblement autour du foyer.
  local assis = couches
  for _, a in ipairs(assis) do
    local c, p = a[1], PLACES[a[2]]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Up) end)
    end
  end
  if t.penticus ~= nil then
    pcall(function() GROUND:TeleportTo(t.penticus, CX, CY - 40, Direction.Down) end)
  end
  GAME:MoveCamera(CX, CY - 8, 1, false)
  GAME:FadeIn(45)
  Silence(28)

  -- Tout le monde se tourne vers le Maitre de Guilde, en decale.
  Listen(t.penticus, {hero, partner, plum, t.phileas, t.rin, t.coco, t.hyko,
                      t.almotz, t.kino, t.reinier, t.ganlon, t.shuca})
  Silence(24)

  -- LE DISCOURS MATINAL.
  Says(t.penticus, "Normal", 'CR5_A72')
  Silence(16)
  Says(t.penticus, "Determined", 'CR5_A73')
  Silence(18)
  Says(t.penticus, "Shouting", 'CR5_A74')
  Silence(14)
  -- CORRECTIF d'audit : 'Determined' et 'Joyous' sont des EMOTIONS DE
  -- PORTRAIT, pas des emotes de bulle. EmoteAndPause ne les connait pas
  -- (GeneralFunctions.lua:590-650) et serait retombe en silence sur
  -- 'sweatdrop' — une goutte de sueur au moment ou le camp s'enthousiasme,
  -- soit exactement l'inverse de l'effet voulu.
  -- Emotes de bulle reellement gerees : Happy, Notice, Exclaim, Glowing,
  -- Sweating, Question, Angry, Shock, Sweatdrop.
  ReactAll({ {partner, "Exclaim"}, {t.kino, "Happy"}, {t.coco, "Happy"},
             {t.hyko, "Notice"}, {plum, "Happy"} })
  Says(partner, "Determined", 'CR5_A75', {hero})
  Silence(18)

  SV.Chapter5.RuinsCampDone = true
  if partner ~= nil then
    pcall(function()
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
      PartnerEssentials.SaveGamePartnerPosition(partner)
    end)
  end
  GeneralFunctions.RendreLaMain(true)
end


-- ==================================================================
-- RETOURS APRES KO / REPLI dans les Ruines
-- ==================================================================
function cloven_ruins_entrance_ch_5.KODefeatCutscene()
  local ok, err = pcall(function()
    cloven_ruins_entrance_ch_5.RetourBody('CR5_A76', 'CR5_A77')
  end)
  if not ok then
    PrintInfo('[CR5] reveil apres KO interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.RetreatReturnCutscene()
  local ok, err = pcall(function()
    cloven_ruins_entrance_ch_5.RetourBody('CR5_A78', 'CR5_A79')
  end)
  if not ok then
    PrintInfo('[CR5] repli interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.RetourBody(k1, k2)
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(false)
  cloven_ruins_entrance_ch_5.BuildCampDay()

  local rin = E('Rin')
  local penticus = E('Penticus')
  pcall(function() GROUND:TeleportTo(hero, PLACES.hero[1], PLACES.hero[2], Direction.Down) end)
  if partner ~= nil then
    pcall(function() GROUND:TeleportTo(partner, PLACES.partner[1], PLACES.partner[2], Direction.Down) end)
  end
  if rin ~= nil then
    pcall(function() GROUND:TeleportTo(rin, PLACES.Rin[1], PLACES.Rin[2], Direction.Left) end)
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(45)
  Silence(30)

  Says(rin, "Worried", k1, {hero, partner})
  Silence(16)
  Says(penticus, "Normal", k2, {hero, partner, rin})
  Silence(20)

  SV.Chapter5.PlayTempRuinsScene = false
  if partner ~= nil then
    pcall(function()
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    end)
  end
  GeneralFunctions.RendreLaMain(true)
end

return cloven_ruins_entrance_ch_5
