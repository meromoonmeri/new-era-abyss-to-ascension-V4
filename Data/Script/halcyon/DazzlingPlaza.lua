--[[
    DazzlingPlaza.lua

    PREMIERE CONFRONTATION AVEC LA TEAM DAZZLING — Metano Town
    ==================================================================
    Trois actes, joues SUR LA PLACE, sans jamais quitter la ville.

      ACTE I   Rencontre. La mere Papilusion supplie ; Aria repond a
               cote ; Sonata enfonce ; Adagio doit tout rattraper.
               L'entree theatrale des rivales est SABOTEE DE L'INTERIEUR.
      ACTE II  Combat sur la place. Aucun changement de decor visible.
      ACTE III Deux branches : defaite (le passage en force, l'evanouis-
               sement, le chevet a la guilde) ou victoire (Adagio
               reconnait, sans jamais s'abaisser).

    ------------------------------------------------------------------
    POURQUOI LE COMBAT A LIEU « SUR LA PLACE » ALORS QUE LE MOTEUR
    INTERDIT DE SE BATTRE SUR UN GROUND
    ------------------------------------------------------------------
    Verifie dans RogueEssence : un combat exige une carte de donjon
    (GameManager.cs:626 — Segment == -1 SIGNIFIE ground ; GroundChar n'a
    ni PV ni capacites). On ne peut donc pas se battre sur
    metano_town.rsground. Mais rien n'oblige la carte de combat a
    RESSEMBLER a un donjon.

    Data/Map/metano_town_duel.rsmap est la PLACE ELLE-MEME, transplantee
    depuis metano_town.rsground par tools/make_metano_arene.py : mêmes
    planches de tuiles, mêmes animations (riviere, etals), mêmes murs.
    Controle automatique : rendu de la carte de combat compare au rendu
    de la ville sur la meme fenetre -> 0 pixel de difference sur 142272.
    Le joueur ne voit aucun changement de decor. Le fondu de
    COMMON.BossTransition() couvre la bascule technique.

    ------------------------------------------------------------------
    LES SPECTATEURS NE PEUVENT PAS ETRE BLESSES — GARANTI PAR LE MOTEUR
    ------------------------------------------------------------------
    Les 11 habitants sont dans AllyTeams, pas dans MapTeams.
    Map.ReconnectMapReference() (Maps/Map.cs:1082) leur impose
    Faction.Friend a chaque chargement, et DSceneAction.GetMatchup()
    (DSceneAction.cs:697-706) renvoie alors Alignment.Friend pour TOUTE
    paire impliquant un Friend — y compris Dazzling -> habitant, via
    foeTruce. C'est le mecanisme des PNJ neutres des donjons PMDO.
    Verrous supplementaires poses dans le .rsmap : aucune attaque
    (Skills vide), EnemyOfFriend/AttackFriend a false, CantInteract,
    CantWalk, Tactic 'wait_only' (WaitPlan seul, gabarit copie de
    terrakion_fight.rsmap). Ils regardent, ils ne font que ca.

    ------------------------------------------------------------------
    LE COMBAT EST DESEQUILIBRE, MAIS LA DEFAITE N'EST PAS IMPOSEE
    ------------------------------------------------------------------
    3 contre 2, niveaux 25/26 contre une equipe de chapitre 6, chacune
    equipee. Le joueur perdra presque toujours. Les DEUX issues sont
    ecrites, et aucune ne rend l'autre incoherente : la defaite envoie
    au chevet de la guilde, la victoire rend la main sur la place.

    ------------------------------------------------------------------
    CONTINUITE
    ------------------------------------------------------------------
    SV.Chapter6.PlazaMet      : la rencontre a eu lieu (verrou unique)
    SV.Chapter6.PlazaOutcome  : 'win' ou 'loss' — lu par les habitants
    Aucune rejouabilite : le declencheur se retire de lui-meme.

    ------------------------------------------------------------------
    REGLES DE PROJET RESPECTEES
    ------------------------------------------------------------------
    * Aucune API inventee : chaque appel est atteste ailleurs dans le
      depot (comptages faits avant ecriture).
    * 1 a 2 phrases par boite, texte francais litteral.
    * Tout sous pcall : une scene qui casse ne laisse jamais le joueur
      immobile.
    * RIEN N'A ETE TESTE EN JEU.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

DazzlingPlaza = {}

--------------------------------------------------------------------
-- HELPERS (memes patrons que DazzlingArc.lua)
--------------------------------------------------------------------
local function say(who, emo, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--Regard : celui qui ecoute se tourne vers celui qui parle.
local function look(who, target, frames)
  if who == nil or target == nil then return end
  pcall(function() GROUND:CharTurnToCharAnimated(who, target, frames or 4) end)
end

--Le duo se tourne ensemble, mais pas au meme instant : sans ce
--decalage les deux pivotent comme un seul objet.
local function duoLook(hero, partner, target)
  local a = TASK:BranchCoroutine(function() look(partner, target, 4) end)
  local b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(7); look(hero, target, 4)
  end)
  TASK:JoinCoroutines({a, b})
end

--Reaction de foule : quelques habitants seulement, decales. Une foule
--qui reagit d'un bloc est une foule fausse.
local function foule(gens, emote, sound)
  local jobs = {}
  for i, g in ipairs(gens) do
    if g ~= nil then
      table.insert(jobs, TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 9)
        pcall(function() GROUND:CharSetEmote(g, emote, 1) end)
      end))
    end
  end
  if sound ~= nil then pcall(function() SOUND:PlayBattleSE(sound) end) end
  if #jobs > 0 then TASK:JoinCoroutines(jobs) end
end

--------------------------------------------------------------------
-- LES HABITANTS DU CERCLE
--------------------------------------------------------------------
-- Positions en pixels sur metano_town.rsground, toutes verifiees en
-- Tags == 0. Le cercle se REFERME progressivement : ils commencent
-- disperses (SetupGround les a places ailleurs), et viennent.
-- L'ordre de la liste est l'ordre d'arrivee.
-- PREMIER TEMPS : la foule occupe le CENTRE de la place, y compris la
-- bouche du defile nord. C'est ce qui rend l'entree des rivales
-- physique : il faudra que la place s'ouvre pour les laisser passer.
-- Toutes les positions sont validees par tools/plan_place_marchande.py
-- (marchable 20x20, hors riviere, >= 40 px de tout collider de boutique).
-- COMPOSITION DE LA SCENE — trois niveaux de profondeur.
--
-- Elle suit le schema fourni par l'utilisateur (cercles bleus / rouges /
-- jaunes), transpose sur la grille reelle de la place. L'axe vertical du
-- schema tombe exactement sur x = 1152, c'est-a-dire le defile nord :
-- la composition et le decor sont donc alignes sans rien forcer.
--
--   ARRIERE-PLAN  spectateurs (jaune)  y 904..928, en arc symetrique
--   CENTRE        Team Dazzling (rouge) y 912..936, en triangle
--   PREMIER PLAN  heros (bleu)          y 984, sous le leader
--
-- REGLES TENUES, toutes verifiees par tools/plan_place_marchande.py :
--   * une case (24 px) d'ecart MINIMUM entre deux personnages ;
--   * >= 40 px de tout collider de commerce (aucun effleurement) ;
--   * aucune entite sur la riviere ;
--   * spectateurs strictement AU NORD du leader : ils n'entrent jamais
--     dans l'axe de vision heros -> Dazzling ;
--   * repartition symetrique, 4 a gauche / 4 a droite ;
--   * apres ecartement, la colonne du defile (|x-1152| < 28) est vide.

-- PREMIER TEMPS : la foule occupe le centre ET la bouche du defile.
-- C'est ce qui rend l'entree des rivales physique : il faudra que la
-- place s'ouvre pour les laisser passer.
-- PREMIER TEMPS : la foule occupe le centre ET la bouche du defile.
-- C'est ce qui rend l'entree des rivales physique : il faudra que la
-- place s'ouvre pour les laisser passer.
local CERCLE = {
  --{ instance, x, y, direction }
  { 'Mawile',    1128, 904, Direction.Down },
  { 'Floatzel',  1176, 904, Direction.Down },
  { 'Quagsire',  1104, 912, Direction.Right },
  { 'Marill',    1200, 920, Direction.Left  },
  { 'Azumarill', 1152, 888, Direction.Down },   -- en plein dans le defile
  { 'Venipede',  1224, 920, Direction.Left  },
  { 'Nidorina',  1080, 920, Direction.Right },
  { 'Electrike', 1248, 920, Direction.Left  },
}

-- SECOND TEMPS : ils refluent sur les COTES en ARC symetrique.
-- 4 a gauche, 4 a droite, tous au NORD du leader : le centre reste
-- entierement degage et la vue heros -> Dazzling n'est jamais coupee.
-- La colonne du defile (|x-1152| < 28) redevient vide.
local CERCLE_ECARTE = {
  { 'Mawile',    1104, 920, Direction.Right },
  { 'Floatzel',  1200, 920, Direction.Left  },
  { 'Quagsire',  1080, 920, Direction.Right },
  { 'Marill',    1224, 920, Direction.Left  },
  { 'Azumarill', 1056, 912, Direction.Right },
  { 'Venipede',  1248, 920, Direction.Left  },
  { 'Nidorina',  1032, 912, Direction.Right },
  { 'Electrike', 1272, 920, Direction.Left  },
}

--------------------------------------------------------------------
-- ACTE I — LA RENCONTRE
--------------------------------------------------------------------
-- Rythme : la mere arrive EN COURANT (elle ne marche pas, c'est une
-- urgence) ; Aria repond AVANT la fin de la phrase ; le silence dure
-- assez longtemps pour etre inconfortable ; Adagio explose, puis se
-- recompose en une seule boite.
function DazzlingPlaza.ActeI()
  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')
  local adagio  = CH('Adagio')
  local aria    = CH('Aria')
  local sonata  = CH('Sonata')
  local mere    = CH('Butterfree')   --la mere Papilusion

  local voisins = {}
  for _, e in ipairs(CERCLE) do
    local c = CH(e[1])
    if c ~= nil then table.insert(voisins, c) end
  end

  GAME:CutsceneMode(true)
  for _, c in ipairs({ partner, adagio, aria, sonata, mere }) do
    if c ~= nil then pcall(function() AI:DisableCharacterAI(c) end) end
  end
  for _, c in ipairs(voisins) do
    pcall(function() AI:DisableCharacterAI(c) end)
  end

  ------------------------------------------------------------------
  -- 1. LA PLACE MARCHANDE, ANIMEE. Le duo arrive par le sud.
  --
  -- Toute la scene se joue sur la GRANDE PLACE, l'esplanade de terre
  -- battue entourée des commerces : le Kec Shop et le comptoir TM au
  -- nord-ouest, l'Entrepot au nord-est, la Banque au sud. Le duo
  -- s'arrete au bord sud de l'esplanade, face au nord.
  ------------------------------------------------------------------
  GAME:MoveCamera(1152, 936, 1, false)
  GAME:WaitFrames(30)

  local e1 = TASK:BranchCoroutine(function()
    GeneralFunctions.EightWayMove(hero, 1128, 944, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  local e2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    GeneralFunctions.EightWayMove(partner, 1104, 944, false, 1)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({ e1, e2 })
  GAME:WaitFrames(15)

  ------------------------------------------------------------------
  -- 2. ELLES ARRIVENT PAR LE NORD, ENTRE LES MAGASINS.
  --
  -- Le defile nord (x = 1152) passe entre le comptoir TM a l'ouest et
  -- l'Entrepot a l'est, et se resserre a UNE SEULE case de large en
  -- y = 860 : elles ne peuvent donc descendre qu'EN FILE INDIENNE.
  -- C'est le decor lui-meme qui impose l'entree en cortege.
  --
  -- Elles descendent d'abord hors champ (y = 688 / 720 / 760), la
  -- camera remonte vers la bouche du defile, et on les decouvre en
  -- train d'arriver — on ne les voit pas apparaitre.
  ------------------------------------------------------------------
  GROUND:TeleportTo(adagio, 1152, 760, Direction.Down)
  GROUND:TeleportTo(aria,   1152, 720, Direction.Down)
  GROUND:TeleportTo(sonata, 1152, 688, Direction.Down)

  SOUND:PlayBGM('Team_Dazzling.ogg', true)
  GAME:MoveCamera(1152, 872, 60, false)
  GAME:WaitFrames(20)

  --LA FOULE S'ECARTE POUR LES LAISSER PASSER. Elle bouchait le centre
  --et la bouche du defile ; elle reflue sur les cotes, chacun du cote
  --dont il est le plus proche. Personne ne traverse devant elles.
  local ec = {}
  for i, e in ipairs(CERCLE_ECARTE) do
    local c = CH(e[1])
    if c ~= nil then
      ec[#ec + 1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 8)
        pcall(function()
          GROUND:CharSetEmote(c, "exclaim", 1)
          GeneralFunctions.EightWayMove(c, e[2], e[3], false, 1)
          GROUND:CharAnimateTurnTo(c, e[4], 4)
        end)
      end)
    end
  end
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  TASK:JoinCoroutines(ec)
  GAME:WaitFrames(12)

  --LA DESCENTE EN FILE. Adagio en tete, les deux autres dans son dos.
  --Elles franchissent le goulet une par une, puis se deploient en
  --triangle sur l'esplanade : Adagio devant, Aria arriere-gauche,
  --Sonata arriere-droite. Cette geometrie ne changera plus.
  local f1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(adagio, 1152, 864, false, 1)
    GROUND:MoveToPosition(adagio, 1152, 928, false, 1)
    GROUND:CharAnimateTurnTo(adagio, Direction.Down, 4)
  end)
  local f2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GROUND:MoveToPosition(aria, 1152, 864, false, 1)
    GeneralFunctions.EightWayMove(aria, 1128, 912, false, 1)
    GROUND:CharAnimateTurnTo(aria, Direction.Down, 4)
  end)
  local f3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(52)
    GROUND:MoveToPosition(sonata, 1152, 864, false, 1)
    GeneralFunctions.EightWayMove(sonata, 1176, 912, false, 1)
    GROUND:CharAnimateTurnTo(sonata, Direction.Down, 4)
  end)
  local f4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    GAME:MoveCamera(1152, 904, 60, false)
  end)
  TASK:JoinCoroutines({ f1, f2, f3, f4 })
  GAME:WaitFrames(18)

  duoLook(hero, partner, adagio)
  GAME:WaitFrames(12)
  say(partner, 'Surprised', STRINGS:Format(STRINGS.MapStrings['MTP_001']))
  GAME:WaitFrames(10)

  --Adagio prend la pose. Elle va parler. Elle ne parlera pas.
  pcall(function() GROUND:CharSetEmote(adagio, "glowing", 1) end)
  GAME:WaitFrames(20)

  ------------------------------------------------------------------
  -- 3. LA MERE PAPILUSION COUPE TOUT. Elle court : run = true.
  --    Elle deboule du cote est de la place, entre les etals.
  ------------------------------------------------------------------
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  local m1 = TASK:BranchCoroutine(function()
    GeneralFunctions.EightWayMove(mere, 1232, 920, true, 2)
    GROUND:CharTurnToCharAnimated(mere, adagio, 4)
  end)
  local m2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GAME:MoveCamera(1184, 912, 30, false)
  end)
  TASK:JoinCoroutines({ m1, m2 })

  local t1 = TASK:BranchCoroutine(function() look(adagio, mere, 4) end)
  local t2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6); look(aria, mere, 4)
  end)
  local t3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(11); look(sonata, mere, 4)
  end)
  TASK:JoinCoroutines({ t1, t2, t3 })
  GAME:WaitFrames(10)

  pcall(function() GROUND:CharSetEmote(mere, "sweating", 1) end)
  say(mere, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_002']))
  say(mere, 'Pain',    STRINGS:Format(STRINGS.MapStrings['MTP_003']))

  ------------------------------------------------------------------
  -- 4. ARIA REPOND. Immediatement. Sans mechancete — c'est pire.
  ------------------------------------------------------------------
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(aria, "happy", 1) end)
  say(aria, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_004']))

  --LE SILENCE. Personne ne bouge. C'est la respiration de la scene.
  GAME:WaitFrames(50)
  foule(voisins, "sweatdrop", nil)
  GAME:WaitFrames(30)

  --Adagio ferme les yeux. Sa mise en scene vient de mourir.
  pcall(function() GROUND:CharSetEmote(adagio, "sweating", 1) end)
  GAME:WaitFrames(25)

  ------------------------------------------------------------------
  -- 5. SONATA. Lentement. La lenteur EST la reaction.
  ------------------------------------------------------------------
  GROUND:CharTurnToCharAnimated(sonata, aria, 14)
  GAME:WaitFrames(20)
  say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_005']))
  GAME:WaitFrames(12)

  GROUND:CharTurnToCharAnimated(sonata, mere, 8)
  GAME:WaitFrames(10)
  say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_006']))

  --Le partenaire encaisse. Le heros aussi, en silence.
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  say(partner, 'Shocked', STRINGS:Format(STRINGS.MapStrings['MTP_007']))
  GAME:WaitFrames(10)

  --La mere baisse la tete. Aucun mot : l'animation suffit.
  pcall(function() GROUND:CharAnimateTurnTo(mere, Direction.Down, 6) end)
  GAME:WaitFrames(30)
  foule(voisins, "sweatdrop", nil)
  GAME:WaitFrames(20)

  ------------------------------------------------------------------
  -- 6. ADAGIO EXPLOSE — puis se recompose en une seule boite.
  ------------------------------------------------------------------
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  pcall(function() GROUND:CharSetEmote(adagio, "angry", 1) end)
  BossFX.ShakeScreen(4, 16)
  say(adagio, 'Angry', STRINGS:Format(STRINGS.MapStrings['MTP_008']))
  GAME:WaitFrames(8)
  say(adagio, 'Angry', STRINGS:Format(STRINGS.MapStrings['MTP_009']))
  GAME:WaitFrames(22)

  --Elle se reprend : elle lisse, elle respire, elle redevient Adagio.
  pcall(function() GROUND:CharSetAnim(adagio, "Idle", true) end)
  GAME:WaitFrames(25)
  GROUND:CharTurnToCharAnimated(adagio, hero, 6)
  GAME:WaitFrames(12)
  say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_010']))
  say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_011']))
  GAME:WaitFrames(15)

  ------------------------------------------------------------------
  -- 7. LE CERCLE SE REFERME. Ils viennent a pied, decales.
  ------------------------------------------------------------------
  local venues = {}
  for i, e in ipairs(CERCLE) do
    local c = CH(e[1])
    if c ~= nil then
      table.insert(venues, TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 11)
        GeneralFunctions.EightWayMove(c, e[2], e[3], false, 1)
        GROUND:CharAnimateTurnTo(c, e[4], 4)
      end))
    end
  end
  table.insert(venues, TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(912, 864, 60, false)
  end))
  TASK:JoinCoroutines(venues)
  GAME:WaitFrames(15)
  foule(voisins, "notice", nil)
  GAME:WaitFrames(15)

  ------------------------------------------------------------------
  -- 8. LE PARTENAIRE TENTE D'EVITER. Adagio refuse.
  ------------------------------------------------------------------
  duoLook(hero, partner, adagio)
  GAME:WaitFrames(10)
  say(partner, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_012']))
  look(adagio, partner, 4)
  say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_013']))
  GAME:WaitFrames(10)

  say(partner, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_014']))
  GAME:WaitFrames(8)

  --Aria retombe a cote. Sonata la reprend. Le duo comique tourne
  --pendant que la tension monte : c'est ce contraste qui tient l'acte.
  look(aria, partner, 4)
  pcall(function() GROUND:CharSetEmote(aria, "question", 1) end)
  say(aria, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_015']))
  GAME:WaitFrames(6)
  GROUND:CharTurnToCharAnimated(sonata, aria, 10)
  say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_016']))
  GAME:WaitFrames(10)
  foule(voisins, "sweatdrop", nil)
  GAME:WaitFrames(12)

  --Adagio recentre, comme toujours.
  look(adagio, hero, 4)
  say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_017']))
  GAME:WaitFrames(12)
  think(hero, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_018']))
  GAME:WaitFrames(10)

  say(adagio, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_019']))
  GAME:WaitFrames(10)

  --Le partenaire se place DEVANT le heros. Deplacement reel.
  local g1 = TASK:BranchCoroutine(function()
    GeneralFunctions.EightWayMove(partner, 1128, 968, false, 1)
    GROUND:CharTurnToCharAnimated(partner, adagio, 4)
  end)
  local g2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    GAME:MoveCamera(928, 856, 40, false)
  end)
  TASK:JoinCoroutines({ g1, g2 })
  GAME:WaitFrames(12)
  say(partner, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_020']))
  GAME:WaitFrames(15)

  --Les trois se mettent en garde, en decale.
  local h1 = TASK:BranchCoroutine(function()
    pcall(function() GROUND:CharSetEmote(adagio, "determined", 1) end)
  end)
  local h2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    pcall(function() GROUND:CharSetEmote(aria, "determined", 1) end)
  end)
  local h3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    pcall(function() GROUND:CharSetEmote(sonata, "determined", 1) end)
  end)
  TASK:JoinCoroutines({ h1, h2, h3 })

  say(adagio, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_021']))
  BossFX.ShakeScreen(5, 22)
  GAME:WaitFrames(20)

  --La foule recule d'un pas : elle a compris. Deplacement visible.
  local recul = {}
  for i, e in ipairs(CERCLE) do
    local c = CH(e[1])
    if c ~= nil then
      table.insert(recul, TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 7)
        local dy = 16
        GROUND:MoveToPosition(c, e[2], e[3] + dy, false, 1)
        GROUND:CharAnimateTurnTo(c, e[4], 4)
      end))
    end
  end
  TASK:JoinCoroutines(recul)
  foule(voisins, "sweating", nil)
  GAME:WaitFrames(20)
end

--------------------------------------------------------------------
-- ACTE II — LE COMBAT, SUR LA PLACE
--------------------------------------------------------------------
-- Segment 7 de gloomy_forest -> Data/Map/metano_town_duel.rsmap, qui
-- EST la place (0 pixel d'ecart mesure). Aucun autre segment n'est
-- touche. Le fondu de BossTransition couvre la bascule.
function DazzlingPlaza.ActeII()
  SV.Chapter6.PlazaMet = true
  pcall(function()
    UI:ResetSpeaker()
    COMMON.BossTransition()
    GAME:ContinueDungeon("gloomy_forest", 7, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
end

--------------------------------------------------------------------
-- ACTE III — DEFAITE
--------------------------------------------------------------------
-- Le passage en force. Adagio ne ralentit pas ; Aria imite sans
-- comprendre ; Sonata conclut. Puis l'evanouissement, et le chevet.
function DazzlingPlaza.Defaite()
  SV.Chapter6.PlazaOutcome = 'loss'

  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')
  local adagio  = CH('Adagio')
  local aria    = CH('Aria')
  local sonata  = CH('Sonata')

  local voisins = {}
  for _, e in ipairs(CERCLE) do
    local c = CH(e[1])
    if c ~= nil then table.insert(voisins, c) end
  end

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then pcall(function() AI:DisableCharacterAI(partner) end) end

    GAME:MoveCamera(896, 872, 1, false)
    GAME:FadeIn(50)
    GAME:WaitFrames(30)

    --Les corps d'abord. Ils essaient de se relever, ils n'y arrivent pas.
    pcall(function() GROUND:CharSetAnim(hero, "Hurt", true) end)
    pcall(function() GROUND:CharSetAnim(partner, "Hurt", true) end)
    GAME:WaitFrames(35)
    narrate(STRINGS:Format(STRINGS.MapStrings['MTP_030']))
    GAME:WaitFrames(15)

    say(partner, 'Pain', STRINGS:Format(STRINGS.MapStrings['MTP_031']))
    GAME:WaitFrames(12)

    ----------------------------------------------------------------
    -- ADAGIO PASSE. Elle ne contourne pas. Elle ne ralentit pas.
    ----------------------------------------------------------------
    local p1 = TASK:BranchCoroutine(function()
      GROUND:MoveToPosition(adagio, 1152, 928, false, 1)
    end)
    local p2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(20)
      GAME:MoveCamera(880, 872, 40, false)
    end)
    TASK:JoinCoroutines({ p1, p2 })

    SOUND:PlayBattleSE("EVT_Battle_Flash")
    BossFX.ShakeScreen(4, 14)
    pcall(function() GROUND:CharSetAnim(hero, "Hurt", true) end)
    GAME:WaitFrames(22)
    GROUND:MoveToPosition(adagio, 1128, 960, false, 1)
    GAME:WaitFrames(10)
    say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_032']))
    GAME:WaitFrames(14)

    ----------------------------------------------------------------
    -- ARIA IMITE. Sans malice : elle a vu faire, donc elle fait.
    ----------------------------------------------------------------
    GROUND:MoveToPosition(aria, 1168, 936, false, 1)
    GAME:WaitFrames(8)
    pcall(function() GROUND:CharSetEmote(aria, "happy", 1) end)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
    BossFX.ShakeScreen(3, 12)
    pcall(function() GROUND:CharSetAnim(partner, "Hurt", true) end)
    GAME:WaitFrames(20)
    GROUND:MoveToPosition(aria, 1120, 968, false, 1)
    say(aria, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_033']))
    GAME:WaitFrames(14)

    ----------------------------------------------------------------
    -- SONATA EN DERNIER. Elle pousse les deux, et elle commente.
    ----------------------------------------------------------------
    GROUND:MoveToPosition(sonata, 1136, 944, false, 1)
    GAME:WaitFrames(8)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
    BossFX.ShakeScreen(4, 14)
    GAME:WaitFrames(18)
    GROUND:MoveToPosition(sonata, 1104, 976, false, 1)
    GAME:WaitFrames(8)
    GROUND:CharTurnToCharAnimated(sonata, hero, 8)
    say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_034']))
    GAME:WaitFrames(15)

    ----------------------------------------------------------------
    -- ELLES S'EN VONT A PIED. La camera les accompagne jusqu'au bout.
    ----------------------------------------------------------------
    local s1 = TASK:BranchCoroutine(function()
      GeneralFunctions.EightWayMove(adagio, 1112, 1048, false, 1)
      GROUND:Hide('Adagio')
    end)
    local s2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(12)
      GeneralFunctions.EightWayMove(aria, 1128, 1048, false, 1)
      GROUND:Hide('Aria')
    end)
    local s3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(24)
      GeneralFunctions.EightWayMove(sonata, 1096, 1048, false, 1)
      GROUND:Hide('Sonata')
    end)
    local s4 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(15)
      GAME:MoveCamera(776, 876, 90, false)
    end)
    local s5 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(30)
      SOUND:FadeOutBGM(70)
    end)
    TASK:JoinCoroutines({ s1, s2, s3, s4, s5 })
    GAME:WaitFrames(25)

    ----------------------------------------------------------------
    -- LES HABITANTS ACCOURENT. Ils courent : run = true.
    ----------------------------------------------------------------
    GAME:MoveCamera(880, 880, 50, false)
    local secours = {}
    --Cases de secours, toutes verifiees en Tags == 0 sur le ground.
    --Ils accourent autour du duo tombe. Cases validees par
    --tools/plan_place_marchande.py (marchable, hors riviere,
    --a distance des etals).
    local dest = {
      { 1104, 912 }, { 1192, 928 }, { 1112, 960 },
      { 1184, 904 }, { 1120, 984 },
    }
    for i, e in ipairs(CERCLE) do
      local c = CH(e[1])
      if c ~= nil and dest[i] ~= nil then
        table.insert(secours, TASK:BranchCoroutine(function()
          GAME:WaitFrames((i - 1) * 8)
          GeneralFunctions.EightWayMove(c, dest[i][1], dest[i][2], true, 2)
          GROUND:CharTurnToCharAnimated(c, hero, 4)
        end))
      end
    end
    TASK:JoinCoroutines(secours)
    foule(voisins, "exclaim", "EVT_Emote_Exclaim_2")
    GAME:WaitFrames(18)

    narrate(STRINGS:Format(STRINGS.MapStrings['MTP_035']))
    GAME:WaitFrames(12)

    ----------------------------------------------------------------
    -- LA VUE SE BROUILLE. Trois battements de plus en plus lents.
    ----------------------------------------------------------------
    think(hero, 'Pain', STRINGS:Format(STRINGS.MapStrings['MTP_036']))
    GAME:WaitFrames(20)

    for i = 1, 3 do
      pcall(function() GAME:FadeOut(false, 22) end)
      GAME:WaitFrames(6)
      pcall(function() GAME:FadeIn(20 + i * 8) end)
      GAME:WaitFrames(14 + i * 10)
    end
    pcall(function() GROUND:CharSetAnim(hero, "Sleep", true) end)
    pcall(function() GROUND:CharSetAnim(partner, "Sleep", true) end)
    GAME:WaitFrames(20)
    pcall(function() GAME:FadeOut(false, 90) end)
    GAME:WaitFrames(60)
  end)

  if not ok then PrintInfo('[DazzlingPlaza.Defaite] ecourtee : ' .. tostring(err)) end

  --La transition temporelle, presentee comme les cartons du jeu.
  pcall(function()
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['MTP_037']), 110)
    UI:SetCenter(false)
  end)
  GAME:WaitFrames(20)
end

--------------------------------------------------------------------
-- ACTE III (suite) — LE CHEVET, A LA GUILDE
--------------------------------------------------------------------
-- Jouee dans guild_heros_room. Positions verifiees dans le .rsground :
-- Hero_Bed 172,148 / Partner_Bed 228,148 ; les cadres se placent devant.
-- CASTING — un ecart assume par rapport a la demande, et pourquoi.
-- Demande : Maitre de Guilde, Zigzaton, Chucrin, Phileas.
--   * Maitre de Guilde -> PENTICUS (Tropius). Atteste : c'est lui qui
--     ouvre l'adresse du matin et donne la parole a Phileas
--     (guild_third_floor_lobby_ch_7.lua). OK.
--   * Zigzaton -> ALMOTZ (Zigzagoon). Atteste : CharacterEssentials
--     l.48-55, et nomme « Almotz (Zigzaton) » dans les scenes du ch5. OK.
--   * Phileas -> Noctowl, le savant de la guilde. OK.
--   * CHUCRIN (Bidoof) N'EXISTE PAS DANS CE MOD. Verifie : aucune entree
--     'Bidoof' dans CharacterEssentials, aucune occurrence de 'Chucrin'
--     dans tout le depot. L'invoquer produirait un CH() nil et une scene
--     amputee. Remplace par RIN (Audino), qui tient l'infirmerie et
--     l'assemblee : au chevet de deux blesses, c'est le personnage
--     legitime, et c'est deja son role dans RaidScenes.Bedside().
local CHEVET = {
  { 'Tropius',   200, 190, Direction.Up   },  --Penticus, maitre de guilde
  { 'Noctowl',   148, 182, Direction.Right},  --Phileas, le savant
  { 'Zigzagoon', 176, 196, Direction.Up   },  --Almotz (Zigzaton)
  { 'Audino',    244, 190, Direction.Left },  --Rin, l'infirmiere
}

function DazzlingPlaza.Chevet()
  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then pcall(function() AI:DisableCharacterAI(partner) end) end

    pcall(function() CharacterEssentials.MakeCharactersFromList(CHEVET) end)
    local penticus = CH('Tropius')
    local phileas  = CH('Noctowl')
    local almotz   = CH('Zigzagoon')
    local rin      = CH('Audino')

    --Le duo est couche.
    local bed1 = MRKR('Hero_Bed')
    local bed2 = MRKR('Partner_Bed')
    if bed1 ~= nil then
      GROUND:TeleportTo(hero, bed1.Position.X, bed1.Position.Y, Direction.Right)
    end
    if bed2 ~= nil and partner ~= nil then
      GROUND:TeleportTo(partner, bed2.Position.X, bed2.Position.Y, Direction.Left)
    end
    pcall(function() GROUND:CharSetAnim(hero, "Sleep", true) end)
    pcall(function() GROUND:CharSetAnim(partner, "Sleep", true) end)

    --LA PIECE D'ABORD. La camera presente, puis se recentre sur eux.
    GAME:MoveCamera(200, 120, 1, false)
    SOUND:PlayBGM('Goodnight.ogg', true)
    GAME:FadeIn(70)
    GAME:WaitFrames(40)
    GAME:MoveCamera(200, 160, 70, false)
    GAME:WaitFrames(25)

    narrate(STRINGS:Format(STRINGS.MapStrings['MTP_040']))
    GAME:WaitFrames(18)

    --LE HEROS SE REVEILLE. Progressivement.
    pcall(function() GROUND:CharSetAnim(hero, "Idle", true) end)
    GAME:WaitFrames(30)
    think(hero, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_041']))
    GAME:WaitFrames(15)

    look(almotz, hero, 4)
    pcall(function() GROUND:CharSetEmote(almotz, "exclaim", 1) end)
    SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
    say(almotz, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_042']))
    GAME:WaitFrames(12)

    --LE PARTENAIRE, quelques instants plus tard.
    pcall(function() GROUND:CharSetAnim(partner, "Idle", true) end)
    GAME:WaitFrames(28)
    say(partner, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_043']))
    GAME:WaitFrames(12)

    --RIN explique le retour. Elle parle du CORPS, jamais de la faute.
    look(rin, partner, 4)
    say(rin, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_044']))
    GAME:WaitFrames(10)
    say(rin, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_045']))
    GAME:WaitFrames(12)

    --PHILEAS veut le FAIT, pas la faute. C'est sa maniere.
    look(phileas, hero, 4)
    say(phileas, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_046']))
    GAME:WaitFrames(10)
    think(hero, 'Sad', STRINGS:Format(STRINGS.MapStrings['MTP_047']))
    GAME:WaitFrames(12)

    --PENTICUS conclut, et protege. Il avance d'un pas avant de parler.
    GROUND:MoveToPosition(penticus, 200, 176, false, 1)
    GROUND:CharTurnToCharAnimated(penticus, hero, 6)
    GAME:WaitFrames(14)
    say(penticus, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_048']))
    GAME:WaitFrames(10)
    say(penticus, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_049']))
    GAME:WaitFrames(12)
    say(partner, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_050']))
    GAME:WaitFrames(10)
    say(penticus, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_051']))
    GAME:WaitFrames(15)

    --Ils repartent en file. La piece redevient calme.
    local d1 = TASK:BranchCoroutine(function()
      GeneralFunctions.EightWayMove(phileas, 40, 184, false, 1)
      GROUND:Hide('Noctowl')
    end)
    local d2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(12)
      GeneralFunctions.EightWayMove(almotz, 40, 184, false, 1)
      GROUND:Hide('Zigzagoon')
    end)
    local d3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(24)
      GeneralFunctions.EightWayMove(rin, 40, 184, false, 1)
      GROUND:Hide('Audino')
    end)
    local d4 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(36)
      GeneralFunctions.EightWayMove(penticus, 40, 184, false, 1)
      GROUND:Hide('Tropius')
    end)
    TASK:JoinCoroutines({ d1, d2, d3, d4 })
    GAME:WaitFrames(25)
  end)

  if not ok then PrintInfo('[DazzlingPlaza.Chevet] ecourtee : ' .. tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- ACTE III — VICTOIRE
--------------------------------------------------------------------
-- Exceptionnelle, jamais humiliante pour les rivales. Adagio ne se
-- renie pas : elle REEVALUE. C'est plus inquietant qu'une rancune.
function DazzlingPlaza.Victoire()
  SV.Chapter6.PlazaOutcome = 'win'

  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')
  local adagio  = CH('Adagio')
  local aria    = CH('Aria')
  local sonata  = CH('Sonata')

  local voisins = {}
  for _, e in ipairs(CERCLE) do
    local c = CH(e[1])
    if c ~= nil then table.insert(voisins, c) end
  end

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then pcall(function() AI:DisableCharacterAI(partner) end) end

    GAME:MoveCamera(912, 856, 1, false)
    GAME:FadeIn(50)
    GAME:WaitFrames(30)

    narrate(STRINGS:Format(STRINGS.MapStrings['MTP_060']))
    GAME:WaitFrames(15)
    foule(voisins, "exclaim", "EVT_Emote_Exclaim_2")
    GAME:WaitFrames(20)

    --Aria cherche une excuse. Maladroitement, comme toujours.
    pcall(function() GROUND:CharSetEmote(aria, "question", 1) end)
    say(aria, 'Worried', STRINGS:Format(STRINGS.MapStrings['MTP_061']))
    GAME:WaitFrames(8)
    GROUND:CharTurnToCharAnimated(sonata, aria, 10)
    say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_062']))
    GAME:WaitFrames(10)

    --Sonata minimise. Elle ne concede rien.
    GROUND:CharTurnToCharAnimated(sonata, hero, 8)
    say(sonata, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_063']))
    GAME:WaitFrames(12)

    --Adagio s'avance. Elle regarde. Elle reevalue.
    GROUND:MoveToPosition(adagio, 1152, 928, false, 1)
    GROUND:CharTurnToCharAnimated(adagio, hero, 6)
    GAME:WaitFrames(20)
    duoLook(hero, partner, adagio)
    GAME:WaitFrames(12)

    say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_064']))
    GAME:WaitFrames(12)
    say(adagio, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_065']))
    GAME:WaitFrames(15)
    think(hero, 'Normal', STRINGS:Format(STRINGS.MapStrings['MTP_066']))
    GAME:WaitFrames(12)
    say(adagio, 'Determined', STRINGS:Format(STRINGS.MapStrings['MTP_067']))
    GAME:WaitFrames(18)

    --Elles repartent calmement, en formation. Camera jusqu'au bout.
    local s1 = TASK:BranchCoroutine(function()
      GeneralFunctions.EightWayMove(adagio, 1152, 688, false, 1)
      GROUND:Hide('Adagio')
    end)
    local s2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(14)
      GeneralFunctions.EightWayMove(aria, 1152, 688, false, 1)
      GROUND:Hide('Aria')
    end)
    local s3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(28)
      GeneralFunctions.EightWayMove(sonata, 1152, 688, false, 1)
      GROUND:Hide('Sonata')
    end)
    local s4 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(18)
      GAME:MoveCamera(1040, 840, 95, false)
    end)
    local s5 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(40)
      SOUND:FadeOutBGM(70)
    end)
    TASK:JoinCoroutines({ s1, s2, s3, s4, s5 })
    GAME:WaitFrames(25)

    say(partner, 'Happy', STRINGS:Format(STRINGS.MapStrings['MTP_068']))
    GAME:WaitFrames(15)
    pcall(function() GAME:FadeOut(false, 60) end)
    GAME:WaitFrames(40)
  end)

  if not ok then PrintInfo('[DazzlingPlaza.Victoire] ecourtee : ' .. tostring(err)) end

  --Les habitants se dispersent dans la ville : c'est TownLife qui les
  --replace, on ne fait que rendre la main proprement.
  pcall(function()
    UI:ResetSpeaker()
    DazzlingPlaza.Disperser()
    GAME:FadeIn(50)
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- APRES LA CONFRONTATION — la ville se disperse
--------------------------------------------------------------------
-- Les temoins ne restent pas plantes en cercle : ils repartent, seuls
-- ou par deux. Positions verifiees en Tags == 0 sur le ground.
local DISPERSION = {
  { 'Mawile',    1032,  896, Direction.Right },
  { 'Floatzel',  1240, 1048, Direction.Left  },
  { 'Quagsire',  1032, 1056, Direction.Right },
  { 'Marill',    1264,  912, Direction.Left  },
  { 'Azumarill', 1096, 1040, Direction.Up    },
}

function DazzlingPlaza.Disperser()
  local jobs = {}
  for i, e in ipairs(DISPERSION) do
    local c = CH(e[1])
    if c ~= nil then
      table.insert(jobs, TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 9)
        pcall(function()
          GeneralFunctions.EightWayMove(c, e[2], e[3], false, 1)
          GROUND:CharAnimateTurnTo(c, e[4], 4)
        end)
      end))
    end
  end
  if #jobs > 0 then TASK:JoinCoroutines(jobs) end
end

--------------------------------------------------------------------
-- LES TEMOINS PARLENT — dialogues exclusifs, variables selon l'issue
--------------------------------------------------------------------
-- Chaque habitant a SA replique, differente selon defaite ou victoire.
-- Aucune n'est generique : chacune renvoie a un detail precis de la
-- scene (la question d'Aria, le silence, la mere Papilusion...).
local TEMOINS = {
  Mawile    = { loss = 'MTP_T01', win = 'MTP_T02' },
  Floatzel  = { loss = 'MTP_T03', win = 'MTP_T04' },
  Quagsire  = { loss = 'MTP_T05', win = 'MTP_T06' },
  Marill    = { loss = 'MTP_T09', win = 'MTP_T10' },
  Azumarill = { loss = 'MTP_T11', win = 'MTP_T12' },
  Butterfree= { loss = 'MTP_T13', win = 'MTP_T14' },
  --Venipede a assiste a la scene depuis le bord de la place.
  Venipede  = { loss = 'MTP_T07', win = 'MTP_T08' },
}

--Renvoie true si une replique de temoin a ete jouee.
function DazzlingPlaza.Temoin(instance)
  if not SV.Chapter6 or not SV.Chapter6.PlazaMet then return false end
  local e = TEMOINS[instance]
  if e == nil then return false end
  local issue = SV.Chapter6.PlazaOutcome
  local key = (issue == 'win') and e.win or e.loss
  if key == nil then return false end

  local c = CH(instance)
  if c == nil then return false end
  local done = false
  pcall(function()
    GeneralFunctions.StartConversation(c)
    UI:SetSpeaker(c)
    GeneralFunctions.SetEmotion('Normal')
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
    GeneralFunctions.EndConversation(c)
    done = true
  end)
  return done
end
