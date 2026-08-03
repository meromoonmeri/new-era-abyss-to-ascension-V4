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
RuinesGardiens.FICHES = {
  Regice = {
    seg = 1, espece = 'Regice', asset = 'cloven_ruins_regice',
    cles = { 'RG_ICE_01','RG_ICE_02','RG_ICE_03','RG_ICE_04','RG_ICE_05' },
  },
  Regirock = {
    seg = 3, espece = 'Regirock', asset = 'cloven_ruins_regirock',
    cles = { 'RG_ROCK_01','RG_ROCK_02','RG_ROCK_03','RG_ROCK_04','RG_ROCK_05' },
  },
  Registeel = {
    seg = 5, espece = 'Registeel', asset = 'cloven_ruins_registeel',
    cles = { 'RG_STEEL_01','RG_STEEL_02','RG_STEEL_03','RG_STEEL_04','RG_STEEL_05' },
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
local function corpsScene(nom)
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

  -- 1. La salle. On la laisse respirer avant tout dialogue.
  centre(f.cles[1])
  GAME:WaitFrames(20)

  -- 2. Le partenaire remarque le fond de la salle et s'avance d'un pas.
  dit(partner, f.cles[2], "Worried")
  local c = TASK:BranchCoroutine(function()
    if partner ~= nil then
      pcall(function()
        GROUND:MoveToPosition(partner, ENTREE[1] - 32, ENTREE[2] - 40, false, 1)
      end)
    end
  end)
  GAME:WaitFrames(14)
  TASK:JoinCoroutines({ c })

  -- 3. Le silence, puis la camera glisse vers le socle : on comprend
  --    avant de voir. Mouvement justifie — il revele.
  GAME:WaitFrames(35)
  GAME:MoveCamera(CAM_SOCLE[1], CAM_SOCLE[2], 90, false)
  GAME:WaitFrames(40)

  -- 4. Le gardien parle AVANT d'apparaitre. Portrait a lui, nom masque.
  pcall(function() BossFX.GuardianVoice(garde, f.cles[3]) end)
  GAME:WaitFrames(20)

  -- 5. Le duo se retourne, chacun a son tempo.
  regarderLeFond(hero, partner)
  GAME:WaitFrames(12)

  -- 6. L'EVEIL — signature propre au gardien.
  -- La musique n'entre qu'ICI : tout ce qui precede se joue dans le
  -- silence laisse par le FadeOutBGM d'ouverture. C'est le contraste
  -- qui rend l'eveil brutal, pas une nappe posee des le debut.
  pcall(function() BossMusic.Play(f.asset) end)
  local eveil = EVEIL[nom]
  if eveil ~= nil then eveil(garde, hero, partner) end
  GROUND:CharSetAnim(garde, "Idle", true)
  GAME:WaitFrames(25)

  -- 7. Reaction : le heros pense, le partenaire encaisse.
  pense(hero, f.cles[4])
  GAME:WaitFrames(15)
  pcall(function() BossFX.Rumble({ hero, partner }, 2) end)
  dit(partner, f.cles[5], "Determined")
  GAME:WaitFrames(20)

  pcall(function() COMMON.BossTransition() end)
end

--------------------------------------------------------------------
-- Entree publique : scene puis combat. La sortie est GARANTIE.
--------------------------------------------------------------------
function RuinesGardiens.Affronter(nom)
  local f = RuinesGardiens.FICHES[nom]
  if f == nil then return end

  local ok, err = pcall(function() corpsScene(nom) end)
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
    GAME:WaitFrames(25)
    if vaincu then
      centre('RG_VICTOIRE')
      GAME:WaitFrames(15)
      dit(partner, 'RG_VICTOIRE_P', "Happy")
    else
      centre('RG_DEFAITE')
      GAME:WaitFrames(15)
      dit(partner, 'RG_DEFAITE_P', "Pain")
    end
    GAME:WaitFrames(20)
  end)
  if not ok then
    pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
  end

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker')
end

return RuinesGardiens
