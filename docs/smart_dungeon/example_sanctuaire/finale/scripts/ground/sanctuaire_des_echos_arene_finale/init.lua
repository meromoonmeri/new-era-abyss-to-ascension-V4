-- Smart Dungeon final arena controller.
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.sanctuaire_des_echos_arene_finale.sanctuaire_des_echos_arene_finale_scene'

local sanctuaire_des_echos_arene_finale = {}

function sanctuaire_des_echos_arene_finale.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sanctuaire_des_echos_arene_finale.Enter(map)
  SV.smart_dungeon = SV.smart_dungeon or {}
  SV.smart_dungeon['sanctuaire_des_echos'] = SV.smart_dungeon['sanctuaire_des_echos'] or {}
  local state = SV.smart_dungeon['sanctuaire_des_echos']
  if state.won then
    state.won = false
    sanctuaire_des_echos_arene_finale_scene.Victory()
  elseif state.lost then
    state.lost = false
    sanctuaire_des_echos_arene_finale_scene.Defeat()
  else
    sanctuaire_des_echos_arene_finale_scene.Introduction()
  end
end

function sanctuaire_des_echos_arene_finale.Update(map) end
return sanctuaire_des_echos_arene_finale
