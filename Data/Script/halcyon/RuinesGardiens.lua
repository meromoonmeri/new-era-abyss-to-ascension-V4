--[[
    RuinesGardiens.lua — LES TROIS SCELLES DES RUINES

    ==================================================================
    CE QU'ON PORTE D'AEGIS CAVE
    ==================================================================
    Dans Explorers of Sky, chaque Regi attend au bout de son labyrinthe,
    dans une salle qui lui est propre. On ne le rencontre pas : on le
    REVEILLE. La dalle s'ouvre, on descend, et la chose qui dormait la
    depuis des siecles se met en marche.

    Structure identique pour les trois — c'est un rituel, il doit se
    reconnaitre — mais chaque gardien a sa SIGNATURE. Jamais le meme
    effet recopie trois fois :

      REGICE     le froid arrive AVANT lui. L'air se givre, le souffle
                 se voit, puis la glace se fend. Effet : brume + gel.
      REGIROCK   la pierre s'ebroue. Une secousse d'abord, des eclats
                 qui tombent, puis la masse se redresse. Effet : impact.
      REGISTEEL  il ne s'eveille pas : il etait deja debout, immobile,
                 depuis le debut. C'est la LUMIERE qui le revele. Pas de
                 secousse, pas de bruit — juste un ecran qui s'eclaire
                 sur une silhouette qui n'a jamais bouge. Le plus
                 inquietant des trois, par soustraction.

    ==================================================================
    REGLES DU PROJET APPLIQUEES
    ==================================================================
    * Apparition JAMAIS instantanee : signes annonciateurs, camera qui
      met en valeur, puis reveal.
    * Le heros ne parle pas a voix haute : pensee entre parentheses.
    * Le partenaire reagit selon SA position, pas une rotation de groupe.
    * Silence avant le reveal : la BGM est coupee, c'est le vide sonore
      qui rend la chose imminente.
    * La Voix (\uE040) N'APPARAIT PAS ici. Ce sont des gardiens, pas des
      legendaires du recit principal ; ils parlent en leur nom, patron
      du clan Limagma (BossFX.GuardianVoice).
    * Corps de scene sous pcall, sortie vers le combat HORS du pcall :
      une cinematique qui casse ne doit jamais bloquer la progression.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.BossMusic'

RuinesGardiens = {}

-- Geometrie de la salle (gabarit 456x456, identique aux arenes validees).
local ENTREE   = { 228, 348 }   -- Main_Entrance_Marker
local SOCLE    = { 228, 150 }   -- le gardien, au fond
local CAM_SALLE= { 228, 240 }
local CAM_SOCLE= { 228, 176 }

-- Fiche de chaque gardien : segment d'arene, espece, cles de texte.
-- 11 cles par gardien (plan de beats, docs/PLAN_cinematiques_ruines_lot5.md) :
--   1  la salle           2  le detail qui cloche   3  pensee du heros
--   4  le gardien parle   5  reaction du partenaire 6-7 il pose l'enjeu
--   8  reponse du duo     9  ce qu'il dit en partant (VICTOIRE, propre a lui)
--  10  la lecon du partenaire                      11 sa derniere phrase (DEFAITE)
RuinesGardiens.FICHES = {
  Regice = {
    seg = 1, espece = 'Regice', asset = 'cloven_ruins_regice',
    cles = { 'RG_ICE_01','RG_ICE_02','RG_ICE_03','RG_ICE_04','RG_ICE_05',
             'RG_ICE_06','RG_ICE_07','RG_ICE_08','RG_ICE_09','RG_ICE_10','RG_ICE_11' },
  },
  Regirock = {
    seg = 3, espece = 'Regirock', asset = 'cloven_ruins_regirock',
    cles = { 'RG_ROCK_01','RG_ROCK_02','RG_ROCK_03','RG_ROCK_04','RG_ROCK_05',
             'RG_ROCK_06','RG_ROCK_07','RG_ROCK_08','RG_ROCK_09','RG_ROCK_10','RG_ROCK_11' },
  },
  Registeel = {
    seg = 5, espece = 'Registeel', asset = 'cloven_ruins_registeel',
    cles = { 'RG_STEEL_01','RG_STEEL_02','RG_STEEL_03','RG_STEEL_04','RG_STEEL_05',
             'RG_STEEL_06','RG_STEEL_07','RG_STEEL_08','RG_STEEL_09','RG_STEEL_10','RG_STEEL_11' },
  },
}

--------------------------------------------------------------------
-- Helpers de mise en scene
--------------------------------------------------------------------
local function centre(cle)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

local function pense(hero, cle)
  if hero == nil then return end
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings[cle]), "Worried")
end

local function dit(chara, cle, emo)
  if chara == nil then return end
  UI:SetSpeaker(chara)
  GeneralFunctions.SetEmotion(emo or "Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:ResetSpeaker()
end

-- Le duo se retourne vers le fond de la salle, chacun a son rythme :
-- un groupe qui pivote d'un bloc a l'air mecanique.
local function regarderLeFond(hero, partner)
  local c1 = TASK:BranchCoroutine(function()
    if hero ~= nil then GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(9)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end
  end)
  TASK:JoinCoroutines({ c1, c2 })
end

--------------------------------------------------------------------
-- SIGNATURES — un eveil different par gardien
--------------------------------------------------------------------
local function eveilRegice(chara, hero, partner)
  -- Le froid precede la creature.
  pcall(function() BossFX.Particle("Wave_Circle_Blue", SOCLE[1], SOCLE[2] + 16, 5) end)
  GAME:WaitFrames(40)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(25)
  pcall(function() SOUND:PlayBattleSE('EVT_Battle_Flash') end)
  BossFX.Flash(SOCLE[1], SOCLE[2], 4, 6, 22)
  GAME:WaitFrames(10)
  GROUND:Unhide('Regice')
  pcall(function() BossFX.Particle("Moonlight_Sparkles_2", SOCLE[1], SOCLE[2], 4) end)
  BossFX.Impact(6)
end

local function eveilRegirock(chara, hero, partner)
  -- La secousse d'abord : quelque chose de lourd se met en mouvement.
  BossFX.ShakeScreen(3, 30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE('_UNK_EVT_102') end)
  pcall(function() BossFX.RockFall(SOCLE[1], SOCLE[2]) end)
  GAME:WaitFrames(20)
  BossFX.Flash(SOCLE[1], SOCLE[2], 3, 5, 18)
  GAME:WaitFrames(8)
  GROUND:Unhide('Regirock')
  pcall(function() BossFX.Particle("Rock_Pieces", SOCLE[1], SOCLE[2] + 8, 4) end)
  BossFX.Impact(10)
end

local function eveilRegisteel(chara, hero, partner)
  -- Aucun bruit, aucune secousse. Il etait deja la.
  -- On ECLAIRE, simplement. Le silence fait tout le travail.
  GAME:WaitFrames(50)
  GROUND:Unhide('Registeel')
  pcall(function() GAME:FadeOut(true, 8) end)
  GAME:WaitFrames(6)
  pcall(function() GAME:FadeIn(30) end)
  GAME:WaitFrames(40)
  pcall(function() SOUND:PlayBattleSE('EVT_Battle_Transition') end)
  BossFX.Impact(4)
end

local EVEIL = {
  Regice    = eveilRegice,
  Regirock  = eveilRegirock,
  Registeel = eveilRegisteel,
}

--------------------------------------------------------------------
-- Corps de la scene. Isole pour que la SORTIE soit garantie.
--------------------------------------------------------------------
local function corpsScene(nom, court)
  local f = RuinesGardiens.FICHES[nom]
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, ENTREE[1], ENTREE[2], Direction.Up)
  if partner ~= nil then
    GROUND:TeleportTo(partner, ENTREE[1] - 32, ENTREE[2] + 8, Direction.Up)
  end

  -- Le gardien existe des maintenant, mais cache : c'est lui qui parlera
  -- avant d'etre vu (patron du clan Limagma au Creuset).
  local garde = CharacterEssentials.MakeCharactersFromList({
    { f.espece, SOCLE[1], SOCLE[2], Direction.Down }
  })
  GROUND:Hide(f.espece)

  GAME:MoveCamera(CAM_SALLE[1], CAM_SALLE[2], 1, false)
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeIn(50)
  GAME:WaitFrames(30)

  -- ================================================================
  -- RETOUR APRES DEFAITE — version courte.
  -- ================================================================
  -- Patron de la reference (mount_windswept_miniboss : FirstPreBossScene
  -- / SecondPreBossScene). Le gardien est deja eveille, le duo sait ce
  -- qui l'attend : rejouer la decouverte serait une redite. On garde
  -- UNIQUEMENT la reprise et l'entree au combat.
  if court then
    GROUND:Unhide(f.espece)
    pcall(function() GROUND:CharSetAnim(garde, "Idle", true) end)
    GAME:MoveCamera(CAM_SOCLE[1], CAM_SOCLE[2], 1, false)
    GAME:FadeIn(30)
    GAME:WaitFrames(25)
    pcall(function() BossMusic.Play(f.asset) end)
    if garde ~= nil then
      UI:SetSpeaker(garde)
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[f.cles[7]]))
      UI:ResetSpeaker()
    end
    GAME:WaitFrames(22)
    GAME:MoveCamera(CAM_SALLE[1], CAM_SALLE[2] + 20, 40, false)
    if partner ~= nil then
      pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
    end
    dit(partner, f.cles[8], "Determined")
    GAME:WaitFrames(20)
    pcall(function() COMMON.BossTransition() end)
    return
  end

  -- ================================================================
  -- ACTE 1 — LA DESCENTE. On laisse VOIR avant de faire parler.
  -- ================================================================
  centre(f.cles[1])
  GAME:WaitFrames(22)

  -- Le duo avance de quelques pas dans la salle, decale : le partenaire
  -- part devant (il ouvre toujours la marche), le heros suit.
  local a1 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      pcall(function()
        GROUND:MoveToPosition(partner, ENTREE[1] - 32, ENTREE[2] - 40, false, 1)
      end)
    end
  end)
  local a2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if hero ~= nil then
      pcall(function()
        GROUND:MoveToPosition(hero, ENTREE[1], ENTREE[2] - 32, false, 1)
      end)
    end
  end)
  TASK:JoinCoroutines({ a1, a2 })
  GAME:WaitFrames(12)

  -- Le detail qui cloche — propre a chaque gardien. Le partenaire le
  -- remarque et se tourne vers lui : il reagit a un SIGNE precis, pas a
  -- une inquietude generique.
  if partner ~= nil then
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  end
  dit(partner, f.cles[2], "Worried")
  GAME:WaitFrames(16)

  -- Le heros pense. Un seul apparte, jamais un resume de l'image.
  pense(hero, f.cles[3])
  GAME:WaitFrames(20)

  -- ================================================================
  -- ACTE 2 — LE SILENCE, PUIS LA VOIX. On comprend avant de voir.
  -- ================================================================
  GAME:WaitFrames(40)
  GAME:MoveCamera(CAM_SOCLE[1], CAM_SOCLE[2], 90, false)
  GAME:WaitFrames(45)

  -- Il parle AVANT d'apparaitre : portrait a lui, nom masque.
  pcall(function() BossFX.GuardianVoice(garde, f.cles[4]) end)
  GAME:WaitFrames(22)

  -- Le duo se retourne, chacun a son tempo.
  regarderLeFond(hero, partner)
  GAME:WaitFrames(14)

  -- Le partenaire reagit a la voix elle-meme, avant tout reveal.
  if partner ~= nil then
    pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  end
  dit(partner, f.cles[5], "Surprised")
  GAME:WaitFrames(18)

  -- ================================================================
  -- ACTE 3 — L'EVEIL. La musique entre ICI, pas avant.
  -- ================================================================
  pcall(function() BossMusic.Play(f.asset) end)
  local eveil = EVEIL[nom]
  if eveil ~= nil then eveil(garde, hero, partner) end
  GROUND:CharSetAnim(garde, "Idle", true)
  GAME:WaitFrames(28)

  -- Le duo recule d'un pas : la masse est plus grande que prevu.
  local r1 = TASK:BranchCoroutine(function()
    if hero ~= nil then pcall(function() GROUND:MoveInDirection(hero, Direction.Down, 12, false, 1) end) end
  end)
  local r2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(7)
    if partner ~= nil then pcall(function() GROUND:MoveInDirection(partner, Direction.Down, 12, false, 1) end) end
  end)
  TASK:JoinCoroutines({ r1, r2 })
  pcall(function() BossFX.Rumble({ hero, partner }, 2) end)
  GAME:WaitFrames(16)

  -- Le gardien pose l'enjeu : deux repliques, son registre propre.
  GAME:MoveCamera(CAM_SOCLE[1], CAM_SOCLE[2] + 8, 40, false)
  if garde ~= nil then
    UI:SetSpeaker(garde)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[f.cles[6]]))
    GAME:WaitFrames(24)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[f.cles[7]]))
    UI:ResetSpeaker()
  end
  GAME:WaitFrames(26)

  -- ================================================================
  -- ACTE 4 — LA REPONSE. Determination, jamais bravade.
  -- ================================================================
  GAME:MoveCamera(CAM_SALLE[1], CAM_SALLE[2] + 20, 40, false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
  end
  dit(partner, f.cles[8], "Determined")
  GAME:WaitFrames(22)

  pcall(function() COMMON.BossTransition() end)
end

--------------------------------------------------------------------
-- Entree publique : scene puis combat. La sortie est GARANTIE.
--------------------------------------------------------------------
function RuinesGardiens.Affronter(nom, court)
  local f = RuinesGardiens.FICHES[nom]
  if f == nil then return end

  local ok, err = pcall(function() corpsScene(nom, court) end)
  if not ok then
    PrintInfo('[Ruines] cinematique ' .. nom .. ' ERREUR : ' .. tostring(err))
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  -- HORS du pcall : quoi qu'il arrive au-dessus, le joueur entre au combat.
  GAME:CutsceneMode(false)
  PrintInfo('[Ruines] -> arene ' .. nom .. ' (segment ' .. tostring(f.seg) .. ')')
  GAME:ContinueDungeon("cloven_ruins", f.seg, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

--------------------------------------------------------------------
-- Retour apres combat : le scelle est brise, ou l'equipe a echoue.
--------------------------------------------------------------------
function RuinesGardiens.Apres(nom, vaincu)
  local f = RuinesGardiens.FICHES[nom]
  if f == nil then return end
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok = pcall(function()
    GAME:CutsceneMode(true)
    GAME:MoveCamera(CAM_SALLE[1], CAM_SALLE[2], 1, false)
    GAME:FadeIn(40)
    GAME:WaitFrames(30)

    if vaincu then
      -- ============================================================
      -- VICTOIRE — il ne meurt pas : son tour de garde s'acheve.
      -- ============================================================
      -- Le gardien est encore la, immobile. On le remontre AVANT de
      -- faire parler qui que ce soit : le joueur doit comprendre qu'il
      -- ne s'est pas effondre.
      local garde = nil
      pcall(function()
        garde = CharacterEssentials.MakeCharactersFromList({
          { f.espece, SOCLE[1], SOCLE[2], Direction.Down }
        })
        GROUND:CharSetAnim(garde, "Idle", true)
      end)
      GAME:MoveCamera(CAM_SOCLE[1], CAM_SOCLE[2], 60, false)
      GAME:WaitFrames(40)
      centre('RG_VICTOIRE')
      GAME:WaitFrames(22)

      -- CE QU'IL DIT EN PARTANT — propre a chaque scelle. C'est ici que
      -- chacun livre SON morceau de la question que Regigigas posera
      -- plus tard : pourquoi les a-t-on postes FACE a ce qu'ils
      -- gardaient ? Aucun des trois n'a la reponse entiere.
      if garde ~= nil then
        UI:SetSpeaker(garde)
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[f.cles[9]]))
        UI:ResetSpeaker()
      end
      GAME:WaitFrames(28)

      -- Il se retire. Pas un effondrement : il se range.
      pcall(function()
        GROUND:CharSetAnim(garde, "EventSleep", true)
        BossFX.Impact(4)
      end)
      GAME:WaitFrames(30)

      -- Le duo encaisse. Le partenaire tire la lecon, chacun se tourne
      -- vers l'autre : la scene se referme sur eux, pas sur la statue.
      GAME:MoveCamera(CAM_SALLE[1], CAM_SALLE[2] + 20, 50, false)
      GAME:WaitFrames(15)
      local t1 = TASK:BranchCoroutine(function()
        if partner ~= nil then pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end) end
      end)
      local t2 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(9)
        if hero ~= nil then pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end) end
      end)
      TASK:JoinCoroutines({ t1, t2 })
      dit(partner, f.cles[10], "Worried")
      GAME:WaitFrames(22)

      -- La salle redevient une salle : la musique s'eteint avant la
      -- derniere ligne. Le silence referme l'acte.
      pcall(function() SOUND:FadeOutBGM(60) end)
      GAME:WaitFrames(20)
      centre('RG_VICTOIRE_P')
      GAME:WaitFrames(24)

    else
      -- ============================================================
      -- DEFAITE — il ne poursuit pas. Il reprend son poste.
      -- ============================================================
      pcall(function() SOUND:FadeOutBGM(40) end)
      centre('RG_DEFAITE')
      GAME:WaitFrames(24)

      -- Le duo est au sol. Le partenaire se releve le premier.
      pcall(function()
        if hero ~= nil then GROUND:CharSetAnim(hero, "EventSleep", true) end
        if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
      end)
      GAME:WaitFrames(35)
      pcall(function()
        if partner ~= nil then GROUND:CharSetAnim(partner, "Idle", true) end
      end)
      GAME:WaitFrames(18)

      -- Sa derniere phrase avant qu'ils repartent — propre a lui.
      centre(f.cles[11])
      GAME:WaitFrames(26)

      pcall(function()
        if hero ~= nil then GROUND:CharSetAnim(hero, "Idle", true) end
      end)
      GAME:WaitFrames(14)
      dit(partner, 'RG_DEFAITE_P', "Pain")
      GAME:WaitFrames(22)
    end
  end)
  if not ok then
    PrintInfo('[Ruines] Apres(' .. tostring(nom) .. ') : echec, sortie forcee.')
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  -- HORS du pcall : le retour au camp a TOUJOURS lieu.
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker')
end

return RuinesGardiens
