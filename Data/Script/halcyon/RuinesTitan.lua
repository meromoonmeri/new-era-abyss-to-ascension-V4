--[[
    RuinesTitan.lua — REGIGIGAS, JOUE EN DONJON

    ==================================================================
    CE QUE CE FICHIER REMPLACE
    ==================================================================
    cloven_ruins_boss_ch_7.lua faisait tout sur le ground cloven_ruins_boss :
    pre-cinematique, transition vers le segment de combat, retour sur le
    ground pour l'apres-combat, la fuite et la revelation.

    Demande explicite : plus aucun ground dans le donjon. Le Sanctuaire des
    Titans est desormais l'etage-arene du segment 7, avec Regigigas et ses
    huit gardes deja poses dessus. Tout se joue la.

    ==================================================================
    DECOUPAGE
    ==================================================================
    AVANT LE COMBAT (OnMapStarts, RuinesTitan.Eveil) :
      Acte I    l'allee des huit statues — elles bougent
      Acte II   Regigigas se leve, pose sa consigne
      Acte III  les renforts de la guilde arrivent par le puits
      Acte IV   la garde se referme, le combat commence

    APRES LE COMBAT (RuinesTitan.Victoire) :
      Acte V    le Titan n'est pas vaincu : il est RELEVE
      Acte VI   la question qui derange (CRB_056/057) — le coeur du donjon
      Acte VII  il redevient statue
      Acte VIII l'effondrement et la fuite

    Le renversement de l'acte V est ce qui donne son sens au donjon entier :
    le duo croit avoir gagne, il vient en realite de liberer un veilleur de sa
    consigne. Puis Regigigas demande pourquoi on l'avait poste FACE a ce qu'il
    gardait. Personne ne repond. C'est voulu.

    ==================================================================
    NOTES TECHNIQUES
    ==================================================================
    * API DUNGEON: exclusivement, via DonjonFX. Aucun GROUND:.
    * Textes par STRINGS:FormatKey sur les cles RUINES_CRB_* portees dans
      Strings/stringsEx*.resx (MapStrings est vide hors ground).
    * Les huit gardes ne sont pas crees par script : ils sont dans MapTeams.
      On les recupere avec DonjonFX.Ennemis() et on les fait trembler sur
      place — ils etaient deja la, c'est tout le propos de CRB_GARDES_01.
    * Les renforts de la guilde n'existent pas comme combattants sur cet
      etage : leur arrivee est racontee (repliques CRB_RENFORT_*), pas
      simulee. Faire spawner quatre allies jouables en plein combat de boss
      changerait l'equilibre du combat, ce qui n'est pas demande.
    * Sortie et progression HORS pcall.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.DonjonFX'
require 'halcyon.EngineKit'

RuinesTitan = {}

local SEGMENT = 7

local TEXT={
 CRB_GARDES_01='Les statues disposées autour du colosse frémissent en même temps.',
 CRB_GARDES_02='Huit regards sans pupilles se tournent vers nous.',
 CRB_GARDES_03='Ce ne sont pas des ornements. Ce sont ses gardes.',
 CRB_RENFORT_01='Derrière nous, les renforts de la Guilde prennent position.',
 CRB_RENFORT_02='Nous avons suivi votre trace. Vous ne combattrez pas seuls.',
 CRB_RENFORT_03='Deux lignes. Protégez le duo et ne rompez pas la formation !',
 CRB_RENFORT_04='Même les divas savent respecter une entrée dramatique.',
 CRB_RENFORT_05='Le signal vient du colosse. Il donne le rythme aux huit statues.',
 CRB_RENFORT_06='Alors brisons ce rythme ensemble !',
 CRB_045='LE SCEAU DU FOND A ÉTÉ OUVERT.', CRB_046='VOUS VOUS TENEZ DEVANT CELUI QUI GARDE LA PORTE.',
 CRB_047='PROUVEZ QUE VOTRE VOLONTÉ SURVIVRA À MON ÉVEIL.', CRB_048='Le sol répond à chaque pulsation de Regigigas.',
 CRB_049='On reste ensemble. Personne ne quitte sa position.', CRB_050='QUE L’ÉPREUVE COMMENCE.',
 CRB_012='On l’a vaincu… cette fois, c’est terminé.', CRB_013='Pourquoi est-ce que la pierre réagit encore ?',
 CRB_014='(Ce n’était pas seulement un combat. Nous avons rompu sa consigne.)', CRB_015='Il faut sortir. Maintenant.',
 CRB_051='JE NE SUIS PAS TOMBÉ.', CRB_052='LE SCEAU QUI ME RETENAIT A CÉDÉ.',
 CRB_053='VOUS AVEZ LIBÉRÉ LE GARDIEN EN TRIOMPHANT DE LUI.', CRB_054='MAIS VOUS IGNOREZ ENCORE CE QUE JE GARDAIS.',
 CRB_055='POURQUOI M’AVAIT-ON PLACÉ FACE À CETTE PAROI ?', CRB_056='POURQUOI UN GARDIEN REGARDERAIT-IL CE QU’IL DEVRAIT PROTÉGER DES AUTRES ?',
 CRB_057='PARCE QUE MA CONSIGNE ÉTAIT D’EMPÊCHER CE QUI SE TROUVE DERRIÈRE DE S’ÉVEILLER.',
 CRB_058='PARTEZ. LA PIERRE REPREND DÉJÀ CE QUI LUI APPARTIENT.', CRB_059='Nous… nous avons ouvert quelque chose.',
 CRB_060='Le corps du colosse se fige. Sa présence, elle, demeure dans toute la chambre.',
 CRB_FUITE_01='Un grondement profond traverse le sanctuaire.', CRB_FUITE_02='La voûte se fend et les statues disparaissent sous la poussière.',
 CRB_FUITE_03='La sortie ! Ne vous séparez pas !', CRB_FUITE_04='Regigigas ne fuit pas. Il reste tourné vers la paroi.',
 CRB_FUITE_05='La pierre se referme sur lui tandis que le passage s’effondre.'
}
local function txt(cle) return '@'..(TEXT[cle] or cle) end

local function etat()
  SV.Ruines = SV.Ruines or {}
  return SV.Ruines
end

--Recit centre : ouverture et cloture d'acte uniquement.
local function recit(cle) DonjonFX.Recit(txt(cle)) end
local function penser(cle, emo) DonjonFX.Penser(txt(cle), emo) end
local function dire(c, cle, emo) DonjonFX.Dire(c, txt(cle), emo) end
local function titan(g, cle) DonjonFX.VoixGardien(g, txt(cle)) end

--La Voix de l'Abysse. Evenement narratif rare, reserve aux legendaires :
--Regigigas y a droit, ses gardes non. Equivalent donjon de BossFX.Voice —
--le heros est le seul a l'entendre, et l'entendre lui coute.
local function voix(cle)
  local hero = DonjonFX.Hero()
  pcall(function()
    DonjonFX.Emote(hero, "shock", 1)
    DonjonFX.Anim(hero, "Hurt", true)
    DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(0, 5, 26))
    GAME:WaitFrames(26)
  end)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "",
                RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(string.sub(txt(cle),2))
  UI:ResetSpeaker()
  pcall(function()
    DonjonFX.Emote(hero, "", 0)
    DonjonFX.FinAnim(hero)
  end)
end

--------------------------------------------------------------------
-- AVANT LE COMBAT
--------------------------------------------------------------------
function RuinesTitan.Eveil()
  local s = etat()
  if s.EveilleRegigigas == true then return end
  s.EveilleRegigigas = true

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local ennemis = DonjonFX.Ennemis()
  local gigas = DonjonFX.Gardien()   -- Regigigas : premier de MapTeams
  -- Les huit gardes : tous les ennemis sauf le premier.
  local gardes = {}
  for i = 2, #ennemis do table.insert(gardes, ennemis[i]) end

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(40)

    ---------------------------------------------------------------- ACTE I
    -- L'allee des huit statues. Elles sont deja la, sur la carte : le
    -- joueur les a vues en entrant sans y prendre garde.
    pcall(function() SOUND:FadeOutBGM(50) end)
    GAME:WaitFrames(50)
    recit('CRB_GARDES_01')
    GAME:WaitFrames(24)

    -- Elles bougent. Une seule d'abord, au fond — puis toutes.
    if #gardes > 0 then
      DonjonFX.Emote(gardes[#gardes], "notice", 1)
      DonjonFX.Secousse(2, 16)
      GAME:WaitFrames(26)
    end
    dire(partner, 'CRB_GARDES_02', "Surprised")
    GAME:WaitFrames(18)

    -- La poussiere tombe de huit paires d'epaules A LA FOIS.
    --
    -- Le commentaire disait « a la fois », le code faisait l'inverse :
    -- DonjonFX.Bond fait un TASK:WaitTask(StartAnim) donc BLOQUANT, et la
    -- boucle y ajoutait 6 frames. Les huit gardes se levaient chacun leur
    -- tour, la cascade s'etalait sur pres de deux secondes et se lisait
    -- comme huit evenements separes au lieu d'un seul reveil collectif.
    -- Chaque bond part maintenant dans sa propre coroutine ; le decalage
    -- de 6 frames est conserve — c'est lui qui fait la vague — mais il se
    -- joue DANS la branche. Patron atteste en donjon
    -- (event_single.lua:1392, chute des rochers du Terrakion).
    local bonds = {}
    for i, g in ipairs(gardes) do
      bonds[#bonds + 1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 6)
        DonjonFX.Bond(g)
      end)
    end
    if #bonds > 0 then pcall(function() TASK:JoinCoroutines(bonds) end) end
    SOUND:PlayBattleSE("DUN_Rock_Slide")
    DonjonFX.Secousse(6, 30)
    GAME:WaitFrames(30)
    recit('CRB_GARDES_03')
    GAME:WaitFrames(22)

    --------------------------------------------------------------- ACTE II
    -- Regigigas. La signature la plus lourde des quatre : c'est la seule
    -- scene ou l'on cumule secousse, froid et lumiere, parce que c'est lui
    -- que les trois autres gardaient.
    DonjonFX.EveilTitan(gigas)
    -- CADRAGE : le gardien trone en haut de l'arene, a des centaines de
    -- pixels de l'entree. La camera suit le heros (en bas) : sans ce
    -- recadrage, Regigigas se leve et parle HORS CHAMP. On centre sur lui
    -- avant qu'il ne prenne la parole (patron EngineKit.CamOn).
    pcall(function() EngineKit.CamOn(gigas, 0, -8, 45) end)
    GAME:WaitFrames(30)
    DonjonFX.RegarderVers(gigas, 7)
    GAME:WaitFrames(18)

    -- Sa consigne. Registre administratif, volontairement : ce n'est pas un
    -- monstre qui parle, c'est un poste de garde qu'on a oublie de relever.
    titan(gigas, 'CRB_045')
    GAME:WaitFrames(20)
    titan(gigas, 'CRB_046')
    GAME:WaitFrames(18)
    titan(gigas, 'CRB_047')
    GAME:WaitFrames(24)
    titan(gigas, 'CRB_048')
    GAME:WaitFrames(20)
    dire(partner, 'CRB_049', "Determined")
    GAME:WaitFrames(18)
    titan(gigas, 'CRB_050')
    GAME:WaitFrames(26)

    -------------------------------------------------------------- ACTE III
    -- Les renforts de la guilde. Ils ont descendu cinq etages dans le noir
    -- sans qu'on leur demande. Leur arrivee est racontee, pas simulee :
    -- quatre allies jouables de plus fausseraient le combat.
    SOUND:PlayBattleSE('EVT_Emote_Exclaim')
    GAME:WaitFrames(16)
    recit('CRB_RENFORT_01')
    GAME:WaitFrames(20)
    penser('CRB_RENFORT_03', "Surprised")
    GAME:WaitFrames(18)
    recit('CRB_RENFORT_02')
    GAME:WaitFrames(16)
    recit('CRB_RENFORT_04')
    GAME:WaitFrames(16)
    recit('CRB_RENFORT_05')
    GAME:WaitFrames(18)
    dire(partner, 'CRB_RENFORT_06', "Determined")
    GAME:WaitFrames(24)

    --------------------------------------------------------------- ACTE IV
    -- La garde se referme.
    for _, g in ipairs(gardes) do DonjonFX.Emote(g, "angry", 1) end
    DonjonFX.Emote(gigas, "angry", 1)
    DonjonFX.Impact(10)
    GAME:WaitFrames(24)
  end)

  if not ok then
    PrintInfo('[RuinesTitan.Eveil] scene ecourtee : ' .. tostring(err))
  end

  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
end

--------------------------------------------------------------------
-- APRES LE COMBAT
--------------------------------------------------------------------
function RuinesTitan.Victoire()
  local s = etat()
  s.VaincuRegigigas = true
  -- CORRECTIF (audit cloven_ruins) : SawAnimaCoreCorruption n'etait plus
  -- pose nulle part depuis la restructuration ch7 -> ch5. Sans lui, la
  -- revanche achetee chez Grodoudou (LegendZones colossus_quarry) et la
  -- branche sobre du segment 7 (zone/cloven_ruins/init.lua) ne se
  -- declenchaient jamais. Pose ici, garanti meme si la scene s'ecourte.
  if SV.Chapter5 ~= nil then SV.Chapter5.SawAnimaCoreCorruption = true end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gigas = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(45)

    ----------------------------------------------------------------- ACTE V
    -- Le duo croit avoir gagne.
    dire(partner, 'CRB_012', "Inspired")
    GAME:WaitFrames(20)
    dire(partner, 'CRB_013', "Normal")
    GAME:WaitFrames(22)

    -- Renversement : il n'est pas vaincu, il est RELEVE. Il se redresse a
    -- demi pour parler — jamais completement.
    SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
    DonjonFX.Secousse(6, 22)
    DonjonFX.Anim(gigas, "Hurt", true)
    GAME:WaitFrames(25)
    DonjonFX.FinAnim(gigas)
    -- CADRAGE : apres le combat la camera est revenue sur le heros (en bas) ;
    -- Regigigas releve (en haut) serait hors champ pour toute la scene.
    pcall(function() EngineKit.CamOn(gigas, 0, -8, 45) end)
    GAME:WaitFrames(30)

    titan(gigas, 'CRB_051')
    GAME:WaitFrames(20)
    titan(gigas, 'CRB_052')
    GAME:WaitFrames(25)
    titan(gigas, 'CRB_053')
    GAME:WaitFrames(22)
    titan(gigas, 'CRB_054')
    GAME:WaitFrames(25)

    ---------------------------------------------------------------- ACTE VI
    -- LA question du donjon. Le silence complet avant, pour qu'elle porte.
    pcall(function() SOUND:FadeOutBGM(40) end)
    GAME:WaitFrames(40)
    titan(gigas, 'CRB_055')
    GAME:WaitFrames(25)
    SOUND:PlayBattleSE('EVT_Emote_Shock_2')
    titan(gigas, 'CRB_056')
    GAME:WaitFrames(30)
    titan(gigas, 'CRB_057')
    GAME:WaitFrames(35)

    -- Le partenaire encaisse. Il n'a pas de reponse : c'est voulu.
    DonjonFX.RegarderVers(gigas, 9)
    dire(partner, 'CRB_059', "Worried")
    GAME:WaitFrames(25)
    titan(gigas, 'CRB_058')
    GAME:WaitFrames(30)

    --------------------------------------------------------------- ACTE VII
    -- Il redevient statue. Demande explicite de l'utilisateur : les Regi
    -- disparaissent apres leur defaite, idealement en reprenant la pierre.
    -- Ici on le VOIT se figer avant de quitter la carte.
    recit('CRB_060')
    GAME:WaitFrames(25)
    DonjonFX.RedevenirStatue(gigas)
    GAME:WaitFrames(20)

    penser('CRB_014', "Worried")
    GAME:WaitFrames(20)
    dire(partner, 'CRB_015', "Determined")
    GAME:WaitFrames(30)

    -------------------------------------------------------------- ACTE VIII
    -- L'effondrement. Ce n'est pas un effet spectaculaire : le sanctuaire se
    -- referme PARCE QUE le gardien a quitte son poste. La pierre reprend ce
    -- qui lui appartient. Consequence directe de CRB_057.
    RuinesTitan.Effondrement()
  end)

  if not ok then
    PrintInfo('[RuinesTitan.Victoire] scene ecourtee : ' .. tostring(err))
  end

  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
end

--------------------------------------------------------------------
-- L'EFFONDREMENT ET LA FUITE
--------------------------------------------------------------------
-- Reprise de la sortie d'Aegis Cave : la victoire ne se termine pas sur un
-- ecran de resultats, le sanctuaire se referme et tout le monde court.
function RuinesTitan.Effondrement()
  -- 1. Le premier signe est SONORE. Rien ne bouge encore.
  pcall(function() SOUND:FadeOutBGM(40) end)
  GAME:WaitFrames(45)
  SOUND:PlayBattleSE('EVT_Tower_Quake')
  DonjonFX.Secousse(3, 25)
  GAME:WaitFrames(30)
  recit('CRB_FUITE_01')
  GAME:WaitFrames(18)

  -- 2. La secousse s'installe.
  recit('CRB_FUITE_02')
  GAME:WaitFrames(14)
  DonjonFX.Secousse(7, 40)
  SOUND:PlayBattleSE('DUN_Rock_Slide')
  GAME:WaitFrames(20)
  recit('CRB_FUITE_03')
  GAME:WaitFrames(12)

  -- 3. Le regard en arriere. Le coeur de la scene : le colosse ne fuit pas.
  --    Il reste assis, tourne vers ce qu'il gardait, pendant que la pierre
  --    se referme sur lui.
  recit('CRB_FUITE_04')
  GAME:WaitFrames(22)
  recit('CRB_FUITE_05')
  GAME:WaitFrames(14)

  -- 4. La course. L'ecran encaisse jusqu'au noir.
  DonjonFX.Secousse(9, 60)
  for _, c in ipairs(DonjonFX.Equipe()) do DonjonFX.Emote(c, "sweating", 1) end
  GAME:WaitFrames(50)
  SOUND:PlayBattleSE('EVT_Battle_Transition')
  pcall(function() GAME:FadeOut(false, 50) end)
  GAME:WaitFrames(60)
  -- Câblage explicite NDS s04p1901 → s04p1902. La sortie de segment
  -- ramène ensuite au Ground extérieur, qui consomme ce drapeau.
  SV.Ruines = SV.Ruines or {}
  SV.Ruines.SceneS04P1901Complete = true
  SV.Ruines.SceneS04P1902Pending = true
  PrintInfo('[Cloven Ruin] s04p1901 complete; s04p1902 pending')
end

--------------------------------------------------------------------
-- POINT D'ENTREE MOTEUR
--------------------------------------------------------------------
-- Le meme crochet OnMapStarts sert les quatre arenes ; RuinesArenes route
-- vers ici pour le segment 7, dont la scene est d'une autre ampleur.
--------------------------------------------------------------------
function RuinesTitan.EstTitan(segmentID) return segmentID == SEGMENT end

return RuinesTitan
