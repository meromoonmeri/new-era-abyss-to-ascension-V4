--[[
    RuinesArenes.lua — LES QUATRE GARDIENS, JOUES EN DONJON

    ==================================================================
    CE QUI CHANGE PAR RAPPORT A RuinesGardiens.lua
    ==================================================================
    RuinesGardiens.lua jouait l'eveil sur des GROUNDS dedies
    (cloven_ruins_regice/regirock/registeel), qui enchainaient ensuite sur le
    segment de combat. Ces grounds sont supprimes : chaque Regi a desormais
    son ETAGE-ARENE dans la zone, avec le biome de son labyrinthe.

    La cinematique se joue donc DANS l'etage, sur OnMapStarts, avant que le
    joueur ne reprenne la main. Le gardien est deja pose sur la carte par
    MapTeams : on ne le fait pas apparaitre, on le REVEILLE.

    Consequences techniques, toutes assumees ici :
      * plus de GROUND:*, tout passe par DonjonFX (API DUNGEON:) ;
      * plus de STRINGS.MapStrings (vide hors ground) : STRINGS:FormatKey
        sur les cles RUINES_* portees dans Strings/stringsEx*.resx ;
      * plus de CH('PLAYER') : GAME:GetPlayerPartyMember(0) ;
      * plus de transition vers un segment de combat : le combat, c'est
        l'etage lui-meme. La scene rend la main, le joueur joue.

    ==================================================================
    CE QUI NE CHANGE PAS
    ==================================================================
    Le texte, integralement. Les onze repliques par gardien, leurs
    signatures distinctes, l'apres-combat individualise ou chacun livre son
    morceau de la question de Regigigas. Le decoupage en actes. Le silence
    avant le reveal. Le heros qui ne parle jamais a voix haute.

    ==================================================================
    REGLES APPLIQUEES
    ==================================================================
    * Corps de scene sous pcall ; la reprise de main est HORS pcall — une
      cinematique qui casse ne doit jamais laisser le joueur bloque en
      CutsceneMode.
    * Chaque personnage se reoriente selon SA position (DonjonFX.RegarderVers
      applique CharTurnToChar individuellement, avec decalage) : jamais une
      rotation de groupe d'un bloc.
    * Un flag par gardien empeche la scene de rejouer si le joueur ressort et
      revient sur le meme etage.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.DonjonFX'
require 'halcyon.RuinesTitan'
require 'halcyon.EngineKit'

RuinesArenes = {}

--------------------------------------------------------------------
-- FICHES
--------------------------------------------------------------------
-- 'cles' : les 11 repliques, dans l'ordre du plan de beats.
--   1  la salle              2  le detail qui cloche   3  pensee du heros
--   4  le gardien parle      5  reaction du partenaire 6-7 il pose l'enjeu
--   8  reponse du duo        9  ce qu'il dit en partant (VICTOIRE)
--  10  la lecon du partenaire                        11 sa derniere phrase (DEFAITE)
-- 'eveil' : la signature visuelle, jamais partagee entre deux gardiens.
--------------------------------------------------------------------
RuinesArenes.FICHES = {
  [1] = {
    nom = 'Regice', flag = 'Regice',
    eveil = function(g) DonjonFX.EveilGlace(g) end,
    cles = { '@Le froid se concentre autour de la statue.','@La glace ne vient pas des murs… elle vient de lui.','@(Le sceau réagit à notre présence.)',
             '@VOUS AVEZ OUVERT LE SCEAU DE GLACE.','@Il nous observe.','@SI VOUS VOULEZ POURSUIVRE, MONTREZ VOTRE PUISSANCE.',
             '@AUCUN PAS NE SERA ACCORDÉ AUX INDIGNES.','@Nous irons jusqu’au bout, ensemble.','@JE RECONNAIS VOTRE FORCE.',
             '@Regice ne tombe pas. Il reprend sa garde.','@LE SCEAU VOUS ATTENDRA ENCORE.' },
  },
  [3] = {
    nom = 'Regirock', flag = 'Regirock',
    eveil = function(g) DonjonFX.EveilRoche(g) end,
    cles = { '@La chambre résonne comme une montagne creuse.','@Chaque pierre semble tournée vers la statue.','@(Quelque chose mesure chacun de nos pas.)',
             '@VOUS AVEZ OUVERT LE SCEAU DE ROCHE.','@Le sol vient de bouger !','@SI VOUS VOULEZ POURSUIVRE, RÉSISTEZ À MON POIDS.',
             '@LA ROCHE NE CÈDE PAS AUX HÉSITANTS.','@Alors nous ne céderons pas non plus.','@JE RECONNAIS VOTRE FORCE.',
             '@Regirock se redresse et le silence revient.','@LA ROCHE ÉPROUVERA ENCORE VOTRE VOLONTÉ.' },
  },
  [5] = {
    nom = 'Registeel', flag = 'Registeel',
    eveil = function(g) DonjonFX.EveilAcier(g) end,
    cles = { '@Un reflet froid court sur toute la chambre.','@La statue était déjà éveillée avant notre arrivée.','@(Le métal écoute. Le métal attend.)',
             '@VOUS AVEZ OUVERT LE SCEAU D’ACIER.','@Il n’a pas bougé… pourtant il nous regarde.','@SI VOUS VOULEZ POURSUIVRE, PROUVEZ VOTRE RÉSOLUTION.',
             '@L’ACIER NE SE PLIE PAS DEVANT LES PROMESSES.','@Alors juge nos actes, pas nos paroles.','@JE RECONNAIS VOTRE FORCE.',
             '@Registeel se fige, plus droit qu’avant.','@L’ACIER N’OUBLIE AUCUNE DÉFAITE.' },
  },
}

local function etat()
  SV.Ruines = SV.Ruines or {}
  return SV.Ruines
end

--------------------------------------------------------------------
-- AVANT LE COMBAT — l'eveil
--------------------------------------------------------------------
-- Quatre actes :
--   I   la salle, et ce qui cloche dedans (recit + partenaire + pensee)
--   II  le gardien se manifeste — signature propre a chacun
--   III il pose son enjeu (trois repliques)
--   IV  le duo repond, la main est rendue
--------------------------------------------------------------------
function RuinesArenes.Eveil(segmentID)
  -- Regigigas a sa propre scene, d'une tout autre ampleur (huit gardes,
  -- renforts de la guilde, renversement d'apres-combat) : elle vit dans
  -- RuinesTitan.lua.
  if RuinesTitan.EstTitan(segmentID) then
    return RuinesTitan.Eveil()
  end

  local f = RuinesArenes.FICHES[segmentID]
  if f == nil then return end

  local s = etat()

  -- RESPAWN CHECKPOINT (2026-08-04) : on arrive dans l'arene du Regi
  -- vaincu (il l'a quittee, il est redevenu statue / n'y est plus). On
  -- joue une courte scene de reveil dans la chambre videe — c'est la
  -- cinematique de respawn demandee — puis on rend la main : le gardien
  -- n'est plus la, l'equipe repart de ce checkpoint vers le labyrinthe
  -- suivant.
  local cp = nil
  pcall(function()
    if SV.Chapter5 ~= nil and SV.Chapter5.RuinsRespawnArena == segmentID then
      cp = SV.Chapter5.RuinsRespawnArena
      SV.Chapter5.RuinsRespawnArena = nil
    end
  end)
  if cp ~= nil then
    pcall(function()
      GAME:CutsceneMode(true)
      GAME:WaitFrames(45)
      DonjonFX.Recit('RUINES_RESPAWN_' .. f.flag)
      GAME:WaitFrames(35)
      GAME:CutsceneMode(false)
    end)
    return
  end

  -- Deja joue sur cet etage : on ne rejoue pas l'eveil complet, mais le
  -- gardien reste hostile. Le joueur revient pour se battre, pas pour
  -- reecouter.
  if s['Eveille' .. f.flag] == true then return end
  s['Eveille' .. f.flag] = true

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gardien = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(30)

    ---------------------------------------------------------------- ACTE I
    -- La salle parle avant les personnages.
    DonjonFX.Recit(f.cles[1])
    GAME:WaitFrames(20)
    DonjonFX.Dire(partner, f.cles[2], "Worried")
    GAME:WaitFrames(16)
    DonjonFX.Penser(f.cles[3], "Worried")
    GAME:WaitFrames(24)

    --------------------------------------------------------------- ACTE II
    -- Le gardien se manifeste. Chaque signature est ecrite dans DonjonFX
    -- et n'est utilisee que par lui.
    f.eveil(gardien)
    -- CADRAGE : le gardien trone en haut de l'arene, a des centaines de
    -- pixels de l'entree. La camera suit le heros (en bas) : sans ce
    -- recadrage, le gardien se manifeste et parle HORS CHAMP.
    pcall(function() EngineKit.CamOn(gardien, 0, -8, 45) end)
    GAME:WaitFrames(30)

    -- L'equipe se tourne vers lui, chacun selon sa propre position.
    DonjonFX.RegarderVers(gardien, 7)
    GAME:WaitFrames(18)

    -------------------------------------------------------------- ACTE III
    -- Il parle. Nom masque, portrait bien a lui : quelqu'un de reel,
    -- pas un oracle desincarne.
    DonjonFX.VoixGardien(gardien, f.cles[4])
    GAME:WaitFrames(20)
    DonjonFX.Dire(partner, f.cles[5], "Surprised")
    GAME:WaitFrames(16)
    DonjonFX.VoixGardien(gardien, f.cles[6])
    GAME:WaitFrames(14)
    DonjonFX.VoixGardien(gardien, f.cles[7])
    GAME:WaitFrames(22)

    --------------------------------------------------------------- ACTE IV
    -- Le duo repond, puis la musique de combat prend le relais.
    DonjonFX.Dire(partner, f.cles[8], "Determined")
    GAME:WaitFrames(24)
    DonjonFX.Emote(gardien, "angry", 1)
    DonjonFX.Secousse(4, 20)
    GAME:WaitFrames(20)
  end)

  if not ok then
    PrintInfo('[RuinesArenes.Eveil] scene ecourtee : ' .. tostring(err))
  end

  -- HORS pcall : quoi qu'il arrive, le joueur reprend la main.
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
end

--------------------------------------------------------------------
-- APRES LE COMBAT — le gardien redevient statue
--------------------------------------------------------------------
-- Demande explicite de l'utilisateur : les Regi disparaissent apres leur
-- defaite (ils seront recrutables plus tard), idealement en redevenant des
-- statues. C'est fait ici, et c'est VU : le gardien se fige, la lueur se
-- retire, la pierre reprend. Puis il quitte la carte.
--
-- Il ne meurt pas. Son tour de garde s'acheve. La nuance porte toute la
-- scene : le texte RUINES_RG_VICTOIRE dit explicitement qu'il ne s'effondre
-- pas, qu'il se tient simplement plus droit qu'avant.
--------------------------------------------------------------------
function RuinesArenes.Victoire(segmentID)
  if RuinesTitan.EstTitan(segmentID) then
    return RuinesTitan.Victoire()
  end

  local f = RuinesArenes.FICHES[segmentID]
  if f == nil then return end

  local s = etat()
  s['Vaincu' .. f.flag] = true
  s['Scelle' .. f.flag .. 'Brise'] = true

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gardien = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(40)

    -- On le remontre AVANT de faire parler qui que ce soit : le joueur doit
    -- comprendre qu'il ne s'est pas effondre.
    DonjonFX.Recit('RUINES_RG_VICTOIRE')
    GAME:WaitFrames(22)

    -- Ce qu'il dit en partant. Chacun livre ici SON morceau de la question
    -- que Regigigas posera plus bas : pourquoi les a-t-on postes FACE a ce
    -- qu'ils gardaient ? Aucun des trois n'a la reponse entiere.
    -- CADRAGE : apres le combat la camera est revenue sur le heros (en bas) ;
    -- re-centre sur le gardien avant sa derniere prise de parole.
    pcall(function() EngineKit.CamOn(gardien, 0, -8, 45) end)
    GAME:WaitFrames(30)
    DonjonFX.VoixGardien(gardien, f.cles[9])
    GAME:WaitFrames(28)

    -- Il se range. La pierre reprend, puis il n'est plus la.
    DonjonFX.RedevenirStatue(gardien)
    GAME:WaitFrames(20)

    -- La scene se referme sur le duo, pas sur la statue.
    DonjonFX.RegarderVers(partner or hero, 9)
    DonjonFX.Dire(partner, f.cles[10], "Worried")
    GAME:WaitFrames(22)

    -- La musique s'eteint avant la derniere ligne : le silence referme l'acte.
    pcall(function() SOUND:FadeOutBGM(60) end)
    GAME:WaitFrames(20)
    DonjonFX.Recit('RUINES_RG_VICTOIRE_P')
    GAME:WaitFrames(24)
  end)

  if not ok then
    PrintInfo('[RuinesArenes.Victoire] scene ecourtee : ' .. tostring(err))
  end

  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
end

--------------------------------------------------------------------
-- DEFAITE — il ne poursuit pas, il reprend son poste
--------------------------------------------------------------------
-- Appelee depuis la zone quand le joueur sort battu d'un etage-arene.
-- On ne joue rien sur la carte (le joueur n'y est plus) : le texte
-- accompagne la sortie, cote zone.
--------------------------------------------------------------------
function RuinesArenes.CleDefaite(segmentID)
  local f = RuinesArenes.FICHES[segmentID]
  if f == nil then return nil end
  return f.cles[11]
end

--------------------------------------------------------------------
-- POINTS D'ENTREE MOTEUR
--------------------------------------------------------------------
-- Branches sur OnMapStarts des etages-arenes via Data/Zone/cloven_ruins.json
-- (patron beginner_lesson.json : SingleCharScriptEvent + ArgTable).
-- La signature (owner, ownerChar, context, args) est celle de tous les
-- SINGLE_CHAR_SCRIPT du depot.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.RuinesArenesEveil(owner, ownerChar, context, args)
  -- OnMapStarts est appele une fois sans utilisateur : c'est notre signal.
  if context ~= nil and context.User ~= nil then return end
  local seg = (args ~= nil and args.Segment) or nil
  if seg == nil then
    pcall(function() seg = _ZONE.CurrentMapID.Segment end)
  end
  RuinesArenes.Eveil(seg)
end

return RuinesArenes
