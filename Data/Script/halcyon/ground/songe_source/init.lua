--[[
    init.lua
    Songe de la Source — cinematique du rêve du héros (chapitre 5).
    Carte purement narrative (pas de gameplay), patron genesis_vision :
    on y entre par EnterGroundMap, la scène se joue, on en revient pareil.
]]
require 'origin.common'
require 'halcyon.ground.songe_source.songe_source_ch_5'

local songe_source = {}

function songe_source.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_songe_source <<=')
end

function songe_source.Enter(map)
  songe_source.PlotScripting()
end

function songe_source.Exit(map)
end

function songe_source.Update(map)
end

function songe_source.GameSave(map)
end

function songe_source.GameLoad(map)
  songe_source.PlotScripting()
end

function songe_source.PlotScripting()
  if SV.Chapter5.MountDreamPending and not SV.Chapter5.MountDreamDone then
    --La nuit de la veillee du Mont Venteux : le heros dort, le songe se joue.
    songe_source_ch_5.PlayDream()
  else
    --FILET (patron du failsafe de personality_test/init.lua) : jamais de
    --carte sans issue. Retour au camp du Mont — si le songe est termine,
    --son PlotScripting enchainera sur le réveil et le matin.
    GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')
  end
end

return songe_source
