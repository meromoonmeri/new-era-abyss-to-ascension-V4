--[[
    RuinesRenforts.lua — LA REVELATION DE LA TOUR

    Ce module ne contient plus qu'une scene : celle qui se joue DEHORS, au
    camp, quand l'equipe ressort des Ruines.

    HISTORIQUE. Il portait aussi les huit gardes de Regigigas, l'arrivee des
    renforts de la guilde, l'effondrement et la fuite. Tout cela vivait sur le
    ground cloven_ruins_boss. Ce ground est supprime : les gardes sont
    desormais des combattants poses dans MapTeams de l'etage-arene
    (sanctuaire_titans, segment 7), et l'effondrement comme la fuite se
    jouent en donjon dans RuinesTitan.lua.

    Ce qui reste ici est le seul morceau qui se passe reellement a la surface,
    et qui doit donc rester une scene de ground : le camp voit la falaise se
    refermer, et une tour apparaitre au-dessus des ruines.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'

RuinesRenforts = {}

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
-- DEHORS — ce que la pierre a laisse derriere elle.
--------------------------------------------------------------------
-- Equivalent du monument d'EoS qui ouvre les Ruines Cachees. Joue au
-- camp, apres le retour : la scene de fuite s'arrete sur un noir, et
-- c'est ici que le noir se leve.
function RuinesRenforts.Revelation()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok = pcall(function()
    GAME:CutsceneMode(true)
    GAME:FadeIn(60)
    GAME:WaitFrames(40)
    centre('CRB_REVEL_01')
    GAME:WaitFrames(22)
    if partner ~= nil then
      GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
      dit(partner, 'CRB_REVEL_02', "Surprised")
    end
    GAME:WaitFrames(18)
    if hero ~= nil then
      GeneralFunctions.HeroDialogue(hero,
        STRINGS:Format(STRINGS.MapStrings['CRB_REVEL_03']), "Worried")
    end
    GAME:WaitFrames(20)
    centre('CRB_REVEL_04')
    GAME:WaitFrames(25)
  end)
  if not ok then
    PrintInfo('[Ruines] Revelation : echec, la progression continue.')
  end

  -- HORS du pcall : le deverrouillage a lieu quoi qu'il arrive.
  GAME:CutsceneMode(false)
  SV.Ruines = SV.Ruines or {}
  SV.Ruines.TourRevelee = true
  pcall(function()
    if not GAME:DungeonUnlocked("tour_reliques") then
      GAME:UnlockDungeon("tour_reliques")
    end
  end)
  PrintInfo('[Ruines] Tour des Reliques deverrouillee')
end

return RuinesRenforts
