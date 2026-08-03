--[[
    RuinesRenforts.lua — LE PUITS ET LES GARDES DE REGIGIGAS

    ==================================================================
    CE QU'ON PORTE D'AEGIS CAVE
    ==================================================================
    Dans Explorers of Sky, le combat final n'est pas un duel : Regigigas
    est entoure de QUATRE Hitmonlee et QUATRE Bronzong, statues qui
    s'animent quand on approche. Et surtout, on ne l'affronte pas seul —
    la Team Charm, retrouvee a terre apres Registeel, se releve et
    combat aux cotes du joueur.

    ==================================================================
    L'ADAPTATION A NEW ERA — pourquoi PAS la Team Charm
    ==================================================================
    Recopier la Team Charm serait un corps etranger : le projet a deja
    ses personnages, et ils sont DEJA SUR PLACE, au camp devant les
    ruines. Les faire descendre est plus juste narrativement que
    d'inventer un trio venu d'ailleurs.

    Qui descend, et pourquoi — chacun justifie par ce qui est deja ecrit
    de lui au camp (cloven_ruins_entrance) :

      GANLON (Cranidos, Teammate2)
        Deja dans l'equipe. Type Roche/Combat : le Combat est LA
        faiblesse commune des Regi. Son registre etabli est le
        bravache qui frappe (« j'ai juste tape plus fort », relais du
        Mont). Il n'a pas besoin d'etre convaincu de descendre.

      SHUCA (Mareep, Teammate3)
        Deja dans l'equipe. La prudente du duo, celle qui compte les
        provisions. C'est elle qui mesure le danger a voix haute — son
        role n'est pas de frapper, c'est de dire ce que les autres
        preferent taire.

      KINO (Breloom) et REINIER (Girafarig)
        Les deux eclaireurs du camp, deja envoyes en reconnaissance dans
        la trame (ARR.Kino / ARR.Reinier). Kino est Plante/COMBAT : la
        meilleure arme possible contre les Regi, et c'est coherent avec
        son role, pas un choix d'opportunite. Reinier est le methodique
        qui remarque avant les autres.

    PENTICUS, PHILEAS, RIN, COCO, HYKO, ALMOTZ, PLUM restent au camp :
    ils ont tous une raison etablie d'y rester (le maitre de guilde tient
    le camp, Rin soigne, Coco cuisine...). On ne vide pas le campement
    pour peupler une salle.

    ==================================================================
    LES HUIT GARDES
    ==================================================================
    Fideles a EoS : 4 Hitmonlee + 4 Bronzong. Adaptation narrative — ce
    ne sont pas des monstres errants, ce sont les STATUES du sanctuaire.
    Elles bordent la salle depuis le debut, decrites comme du decor, et
    s'animent d'un coup. Le joueur les a vues sans les voir.

    ==================================================================
    API — verifiee, jamais supposee
    ==================================================================
    CharacterEssentials.MakeCharactersFromList, GROUND:Hide/Unhide,
    BossFX.Flash/Impact/ShakeScreen/Rumble, GeneralFunctions.SetEmotion,
    TASK:BranchCoroutine/JoinCoroutines : tous largement attestes.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

RuinesRenforts = {}

-- Salle 240x320 px, entree par le sud (geometrie de cloven_ruins_boss,
-- reprise telle quelle de la scene ch7 deja validee).
local ENTREE = { 152, 240 }

-- Les huit statues, en bordure de salle. Deux rangees qui encadrent
-- l'allee centrale : le joueur passe ENTRE elles pour atteindre le fond.
RuinesRenforts.STATUES = {
  { 'Hitmonlee', 'Hitmonlee_1',  88, 200 },
  { 'Hitmonlee', 'Hitmonlee_2', 200, 200 },
  { 'Hitmonlee', 'Hitmonlee_3',  88, 152 },
  { 'Hitmonlee', 'Hitmonlee_4', 200, 152 },
  { 'Bronzong',  'Bronzong_1',   72, 176 },
  { 'Bronzong',  'Bronzong_2',  216, 176 },
  { 'Bronzong',  'Bronzong_3',   72, 128 },
  { 'Bronzong',  'Bronzong_4',  216, 128 },
}

-- Les renforts de la guilde, a leur arrivee : ils entrent par le sud,
-- derriere le duo, et se placent sans jamais se superposer.
RuinesRenforts.ALLIES = {
  { 'Cranidos',  'Ganlon',  120, 264 },
  { 'Mareep',    'Shuca',   184, 264 },
  { 'Breloom',   'Kino',     96, 272 },
  { 'Girafarig', 'Reinier', 208, 272 },
}

--------------------------------------------------------------------
local function centre(cle)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

local function dit(chara, cle, emo)
  if chara == nil then return end
  UI:SetSpeaker(chara)
  GeneralFunctions.SetEmotion(emo or "Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
  UI:ResetSpeaker()
end

--------------------------------------------------------------------
-- Pose les huit statues, immobiles. Appele AVANT tout dialogue : elles
-- doivent etre a l'ecran, prises pour du decor, bien avant de bouger.
--------------------------------------------------------------------
function RuinesRenforts.PoserStatues()
  local out = {}
  for _, s in ipairs(RuinesRenforts.STATUES) do
    local ok, c = pcall(function()
      return CharacterEssentials.MakeCharactersFromList({
        { s[2], s[3], s[4], Direction.Down }
      })
    end)
    if ok and c ~= nil then
      out[#out + 1] = c
      -- Immobiles : une statue ne respire pas.
      pcall(function() GROUND:CharSetAnim(c, "None", true) end)
    end
  end
  return out
end

--------------------------------------------------------------------
-- L'EVEIL DES GARDES. Elles ne se levent pas ensemble : le regard du
-- joueur doit avoir le temps de faire le tour de la salle et de
-- comprendre qu'il est encercle.
--------------------------------------------------------------------
function RuinesRenforts.EveillerStatues(statues, hero, partner)
  centre('CRB_GARDES_01')
  GAME:WaitFrames(25)

  -- Premier signe : une seule bouge, au fond. Presque rien.
  pcall(function() SOUND:PlayBattleSE('_UNK_EVT_102') end)
  BossFX.ShakeScreen(2, 20)
  GAME:WaitFrames(30)

  dit(partner, 'CRB_GARDES_02', "Surprised")
  GAME:WaitFrames(15)

  -- Puis toutes, en cascade — jamais d'un bloc.
  for i, c in ipairs(statues) do
    local delai = 6 + (i % 3) * 4
    local co = TASK:BranchCoroutine(function()
      GAME:WaitFrames(delai)
      pcall(function()
        BossFX.Flash(RuinesRenforts.STATUES[i][3], RuinesRenforts.STATUES[i][4], 2, 3, 12)
        GROUND:CharSetAnim(c, "Idle", true)
      end)
    end)
    TASK:JoinCoroutines({ co })
  end
  BossFX.Impact(9)
  GAME:WaitFrames(20)
  pcall(function() BossFX.Rumble({ hero, partner }, 2) end)
  centre('CRB_GARDES_03')
  GAME:WaitFrames(20)
end

--------------------------------------------------------------------
-- L'ARRIVEE DES RENFORTS. Ils ne tombent pas du ciel : on les ENTEND
-- descendre le puits avant de les voir, et ils entrent par la meme
-- porte que le duo. Aucune teleportation d'etat.
--------------------------------------------------------------------
function RuinesRenforts.FaireEntrerAllies(hero, partner)
  local crees = {}

  -- 1. Le bruit d'abord. Le duo se retourne vers l'entree.
  pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim') end)
  local c1 = TASK:BranchCoroutine(function()
    if hero ~= nil then GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end
  end)
  TASK:JoinCoroutines({ c1, c2 })
  GAME:WaitFrames(20)

  -- 2. Ils apparaissent au seuil, caches, puis remontent l'allee.
  for _, a in ipairs(RuinesRenforts.ALLIES) do
    local ok, c = pcall(function()
      return CharacterEssentials.MakeCharactersFromList({
        { a[1], a[3], ENTREE[2] + 64, Direction.Up }
      })  -- a[1] = cle CharacterEssentials (Cranidos/Mareep/Breloom/Girafarig)
    end)
    if ok and c ~= nil then crees[a[2]] = c end
  end

  -- 3. Marche echelonnee : Ganlon devant (il ne sait pas attendre),
  --    Shuca derriere lui, les deux eclaireurs en dernier.
  local ordre = { 'Ganlon', 'Shuca', 'Kino', 'Reinier' }
  local coros = {}
  for i, nom in ipairs(ordre) do
    local c = crees[nom]
    local cible = nil
    for _, a in ipairs(RuinesRenforts.ALLIES) do
      if a[2] == nom then cible = a end
    end
    if c ~= nil and cible ~= nil then
      coros[#coros + 1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames((i - 1) * 12)
        pcall(function()
          GROUND:MoveToPosition(c, cible[3], cible[4], false, 1)
        end)
      end)
    end
  end
  if #coros > 0 then TASK:JoinCoroutines(coros) end
  GAME:WaitFrames(15)

  return crees
end

--------------------------------------------------------------------
-- L'ECHANGE. Chacun parle selon ce qui est deja etabli de lui.
--------------------------------------------------------------------
function RuinesRenforts.DialogueRenforts(crees, hero, partner)
  dit(crees['Ganlon'],  'CRB_RENFORT_01', "Determined")
  GAME:WaitFrames(12)
  dit(crees['Shuca'],   'CRB_RENFORT_02', "Worried")
  GAME:WaitFrames(12)

  -- Le heros ne parle pas : il pense.
  if hero ~= nil then
    GeneralFunctions.HeroDialogue(hero,
      STRINGS:Format(STRINGS.MapStrings['CRB_RENFORT_03']), "Surprised")
  end
  GAME:WaitFrames(12)

  dit(crees['Reinier'], 'CRB_RENFORT_04', "Normal")
  GAME:WaitFrames(12)
  dit(crees['Kino'],    'CRB_RENFORT_05', "Determined")
  GAME:WaitFrames(15)
  dit(partner,          'CRB_RENFORT_06', "Determined")
  GAME:WaitFrames(18)
end

return RuinesRenforts
