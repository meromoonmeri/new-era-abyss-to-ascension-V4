--[[
    dungeon55_events.lua — ÉVÉNEMENTS D'ÉTAGE DU DONJON D55 (Passage du Temps).

    Les 26 SSB de D55 (D55P11A/D55P21A/D55P41A) sont convertis en modules dans
    scene/. Ce module les EXPOSE avec leurs conditions NDS, et fournit les
    hooks d'entrée/sortie du donjon pour l'arc du futur.

    IMPORTANT (données NDS) :
      * D55 est un donjon PARTAGÉ. L'arc du futur y entre par
        main_EnterDungeon(140) depuis P08P01A (l'embuscade des Sableye).
      * Les scènes n06a* (acteurs CHAAREMU/SAANAITO/Team Charm + PLAYER_CHARMS)
        appartiennent à l'ÉPISODE SPÉCIAL « Here Comes Team Charm! »
        (Boulder Quarry) — elles ne sont PAS déclenchées dans le run du héros
        du futur. Elles sont exposées ici pour complétude, avec leurs flags.
      * Les portails n06a0801/1101/1701 (« Would you like to go on? ») mènent
        vers D58/D59/D60 (donjons bonus), conditionnés par SCENARIO_SIDE >=
        [45,4]/[45,6] — hors parcours principal de l'arc.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

Dungeon55Events = {}

-- Scènes par étage (noms de modules générés)
Dungeon55Events.FLOOR1 = { 'd55p11a_enter00', 'd55p11a_enter03', 'd55p11a_enter04',
  'd55p11a_enter05', 'd55p11a_enter06', 'd55p11a_enter08', 'd55p11a_n06a0701',
  'd55p11a_n06a0801', 'd55p11a_n06a0901', 'd55p11a_n06a1601', 'd55p11a_n06a3903',
  'd55p11a_n06a3908' }
Dungeon55Events.FLOOR2 = { 'd55p21a_enter00', 'd55p21a_enter01', 'd55p21a_enter02',
  'd55p21a_enter05', 'd55p21a_enter06', 'd55p21a_enter07', 'd55p21a_n06a1001',
  'd55p21a_n06a1101', 'd55p21a_n06a1201', 'd55p21a_n06a1401', 'd55p21a_n06a1501' }
Dungeon55Events.FLOOR3 = { 'd55p41a_n06a1301', 'd55p41a_n06a1701', 'd55p41a_n06a1801' }

-- Joue une scène D55 par son nom de module (si le module existe).
function Dungeon55Events.Play(name)
  local ok, mod = pcall(function() return require('halcyon.future_arc.scene.' .. name) end)
  if ok and mod ~= nil and mod.Cutscene ~= nil then
    mod.Cutscene()
  end
end

-- Sortie du donjon D55 -> P09P01A (climax de l'arc).
-- Appelé par le hook natif ExitSegment de la zone passage_temps.
-- Le résultat du donjon est celui fourni par le moteur (RogueEssence).
function Dungeon55Events.ExitToClimax(result)
  DEBUG.EnableDbgCoro()
  result = result or RogueEssence.Data.GameProgress.Result.Success
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  -- Sortie NATIVE de donjon : EndDungeonRun -> master_zone, ground p09p01a.
  -- GROUND_IDX résout l'index du ground dans la zone master_zone.
  GAME:EndDungeonRun(result, 'master_zone', -1, GROUND_IDX('p09p01a'), 0, false, false)
  GAME:WaitFrames(10)
  GAME:FadeIn(20)
  PrintInfo('[Dungeon55] sortie vers p09p01a (climax)')
end

return Dungeon55Events
