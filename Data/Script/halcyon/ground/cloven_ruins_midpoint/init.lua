--[[
    init.lua — Cloven Ruins Midpoint (Relais des Ruines Tordues)
    Chapitre 7 — relais mi-donjon type Statue Kangourex.
    Modèle : searing_tunnel_midpoint / vast_steppe_midpoint (patron validé).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.MidpointTemplate'

local cloven_ruins_midpoint = {}

--------------------------------------------------------------------
-- HABILLAGE DU POINT MEDIAN — Ruines Tordues (336x240)
--
-- STRUCTURE : halcyon.MidpointTemplate, commune a tous les relais.
-- HABILLAGE : propre a ce biome, jamais recopie ailleurs.
--
--   Biome     : CLAIRIERE A CIEL OUVERT, cernee par les murailles des
--               ruines. Une trouee de verdure au milieu de la pierre :
--               les batisseurs ont laisse ce creux respirer, et la
--               nature l'a repris. Le calme ne vient ni du vent coupe
--               (Mont) ni du couvert vegetal dense (Foret) : il vient
--               de l'OUVERTURE, d'un morceau de ciel au milieu des
--               murs. On y voit le portail du nord depuis le sentier.
--   Ambiance  : aucune. Le relais est un repit A CIEL OUVERT : y poser
--               une distorsion contredirait le calme de la clairiere.
--   Musique   : 'In the Depths of the Pit.ogg', theme de la carte.
--   Lumiere   : plein jour.
--
-- GEOMETRIE MESUREE sur la grille d'obstacles (55,0 % bloquant,
-- 517 cases atteignables, une seule composante) :
--   sentier d'arrivee au SUD (South_Exit 136,232 sur 72 px),
--   clairiere ovale ouverte au centre (jusqu'a 208 px de large),
--   portail du donjon au NORD (North_Exit 152,56 sur 32 px),
--   rocher de Kangourex a l'ouest (112,200).
-- ATTENTION : l'ancienne carte faisait 384x480 ; les 6 positions de
-- cette scene tombaient TOUTES hors carte. Recalculees et verifiees.
--------------------------------------------------------------------
local RUINS_SKIN = {
  music     = 'In the Depths of the Pit.ogg',
  wakeMusic = 'Heartwarming.ogg',
  status    = nil,
  hero      = {176, 224},
  partner   = {152, 224},
  camera    = {168, 200},
  walk      = 56,
  wake = {
    hero        = {96, 176},  heroFace    = Direction.Right,
    partner     = {144, 176}, partnerFace = Direction.Left,
    camera      = {120, 176},
  },
}

function cloven_ruins_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_midpoint.Enter(map)
  if SV.Chapter7.RuinsMidState == 'DeathArrival' then
    SV.Chapter7.RuinsMidState = nil
    cloven_ruins_midpoint.WipedCutscene()
    return
  end
  if SV.Chapter7.RuinsMidpointState == nil then SV.Chapter7.RuinsMidpointState = 'FirstArrival' end
  if SV.Chapter7.RuinsMidpointState == 'FirstArrival' then
    SV.Chapter7.RuinsMidpointState = 'RepeatArrival'
    if SV.ChapterProgression.Chapter == 7 then
      -- Première halte pendant l'expédition du chapitre 7 : arrivée jouée.
      RelayScenes.DuoArrival({
        hero = {176, 224}, partner = {152, 224}, camera = {168, 200},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Surprised', txt="Attends...[pause=10] de l'herbe ?[pause=15] En plein milieu des ruines ?", wait=10 },
          { spk='partner', emo='Normal', txt="Les murs s'ouvrent, ici.[pause=0] Il y a du CIEL au-dessus de nous.[pause=10] Ça faisait des heures." },
          { spk='hero', emo='Worried', txt="(Les bâtisseurs ont laissé ce creux respirer.[pause=0] Pourquoi celui-ci, et pas le reste ?)", wait=10 },
          { spk='partner', emo='Normal', txt="Et là, regarde ![pause=0] Un rocher de Kangourex.[pause=10] Pas une fissure, alors que tout s'effondre autour." },
          { spk='partner', emo='Determined', txt="Déposons ce qui nous encombre.[pause=0] Passé ce portail, au nord,[pause=10] je doute qu'on nous laisse faire demi-tour." },
        },
      })
    else
      -- Visite libre (rejouabilité) : découverte plus contemplative.
      RelayScenes.DuoArrival({
        hero = {176, 224}, partner = {152, 224}, camera = {168, 200},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Cette clairière au milieu des murailles...[pause=0] On respire mieux, ici." },
          { spk='partner', emo='Normal', txt="Le rocher de Kangourex n'a pas bougé.[pause=0] Profitons-en avant de passer le portail." },
        },
      })
    end
  elseif SV.Chapter7.RuinsMidReturn then
    --ETAT « RepeatArrival » DU TEMPLATE — retour a l'amiable
    --(repli volontaire par la sortie sud, ou reprise d'une sauvegarde
    --faite ici). Le relais ne connaissait que FirstArrival et le reveil
    --apres KO : revenir sur ses pas ne donnait qu'un fondu muet.
    SV.Chapter7.RuinsMidReturn = false
    local partner = CH('Teammate1')
    MidpointTemplate.RepeatArrival({
      skin = RUINS_SKIN,
      lines = {
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "La clairière est intacte.[pause=0] Dans ces ruines,[pause=10] c'est presque rassurant.", wait = 10 },
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "Sauvegardons avant de repasser le portail.[pause=0] Le Cœur n'attend que nous." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function cloven_ruins_midpoint.Update(map)
end

function cloven_ruins_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Reprise d'une sauvegarde faite AU relais : sortie a l'amiable, on
-- arme le retour sobre du template plutot qu'un fondu muet.
function cloven_ruins_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if SV.Chapter7.RuinsMidpointState ~= 'FirstArrival'
     and SV.Chapter7.RuinsMidState ~= 'DeathArrival' then
    SV.Chapter7.RuinsMidReturn = true
  end
  cloven_ruins_midpoint.Enter(map)
end

-- Sortie nord : franchir le portail vers les profondeurs (segment 2)
function cloven_ruins_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Franchir le portail et s'enfoncer dans les ruines ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("cloven_ruins", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Sortie sud : retour à l'entrée des ruines
function cloven_ruins_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("cloven_ruins")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    --Repli VOLONTAIRE : sortie a l'amiable, on arme le retour sobre.
    SV.Chapter7.RuinsMidReturn = true
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Rocher Kangourex : sauvegarde + stockage
function cloven_ruins_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function cloven_ruins_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui dans la clairière, ranimé par ses réserves.
--------------------------------------------------------------------
function cloven_ruins_midpoint.WipedCutscene()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

    -- Fix audit 2026-07-27 : l'ancienne position du partenaire chevauchait le
  -- collider du rocher Kangourex. Positions libres verifiees (flood-check).
  GROUND:TeleportTo(hero, 96, 176, Direction.Right)
  if partner ~= nil then GROUND:TeleportTo(partner, 144, 176, Direction.Left) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(120, 176, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Ces ruines...[pause=20] même les murs semblaient vouloir qu'on parte.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("On a réussi à revenir jusqu'à la clairière.[pause=20] L'herbe, le ciel...[pause=10] ça m'a réveillé.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Le Cœur des ruines est tout près, je le sens.[pause=20] Reposons-nous — puis finissons ce qu'on a commencé.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return cloven_ruins_midpoint
