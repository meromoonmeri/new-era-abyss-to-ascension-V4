--[[
  Sommet du Mont Grondant — import 1:1 de la carte D06P03 de pret/pmd-red.
  Patron de scène repris de src/dungeon_cutscene_zapdos.c : regards -> trois
  flashes -> descente d'Électhor -> recul -> nouveau cycle de flashes.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.Weather'

local mont_grondant_sommet = {}

function mont_grondant_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mont_grondant_sommet.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GAME:FadeOut(false, 1)

  -- Coordonnées lues dans ground_data_d06p03_station.h et conservées.
  GROUND:TeleportTo(hero, 192, 168, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 168, Direction.Up) end
  local zapdos = CharacterEssentials.MakeCharactersFromList({{'Electhor', 224, 144, Direction.Down}})
  GROUND:Hide('Electhor')
  GAME:MoveCamera(224, 144, 1, false)

  -- Les couches moteur reproduisent le ciel chargé et les éclairs de la scène GBA.
  Weather.ClearAll()
  GROUND:AddMapStatus('thunderclouds')
  GROUND:AddMapStatus('blowing_wind_fast')
  GROUND:AddMapStatus('fog')
  GAME:FadeIn(30)
  GAME:WaitFrames(10)

  -- Patron exact Rescue Team : le duo cherche la source, puis triple flash.
  if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end
  GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  GAME:WaitFrames(10)
  if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  GAME:WaitFrames(10)
  BossFX.Flash(224, 88, 2, 5, 18)
  GAME:WaitFrames(8)

  -- ZapdosDropInEffect : descente depuis les nuages, puis pause avant le combat.
  GROUND:TeleportTo(zapdos, 224, 32, Direction.Down)
  GROUND:Unhide('Electhor')
  SOUND:PlayBattleSE('DUN_Shock_Wave')
  GROUND:MoveToPosition(zapdos, 224, 144, false, 1.5)
  GAME:WaitFrames(30)
  if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end
  BossFX.Flash(224, 88, 2, 5, 18)
  GAME:WaitFrames(10)
  BossFX.Flash(224, 88, 2, 5, 18)
  GAME:WaitFrames(10)
  BossFX.Flash(224, 88, 2, 5, 18)
  GAME:WaitFrames(10)

  -- Carte de référence prête à être jouée / dev-travel sans lancer un combat imposé.
  GAME:CutsceneMode(false)
end

function mont_grondant_sommet.Update(map, time) end
function mont_grondant_sommet.GameSave(map) end
function mont_grondant_sommet.GameLoad(map) end
return mont_grondant_sommet
