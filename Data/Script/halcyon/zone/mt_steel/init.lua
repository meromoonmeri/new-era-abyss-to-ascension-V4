-- Mt Acier (D03) : huit étages procéduraux et l'arène authentifiée du 9e.
local Route = require 'halcyon.RedEarlyDungeonRoute'
local mt_steel = {}

function mt_steel.Init(zone) Route.Init(zone, 'mt_steel') end
function mt_steel.EnterSegment(zone, rescuing, segment_id, map_id)
  Route.EnterSegment(zone, rescuing, segment_id, map_id, false)
end
function mt_steel.Rescued(zone, name, mail) Route.Rescued(zone, name, mail) end
function mt_steel.ExitSegment(zone, result, rescue, segment_id, map_id)
  Route.ExitSegment(zone, result, rescue, segment_id, {
    pending = 'mt_steel_exit', ending_ground = 'd03p02',
    ending_map = 1, ending_entry = 0,
    completion_display = false, completion_fanfare = false,
    failure_zone = 'master_zone', failure_segment = -1,
    failure_map = 1, failure_entry = 0,
    failure_display = true, failure_fanfare = true,
  })
end
return mt_steel
