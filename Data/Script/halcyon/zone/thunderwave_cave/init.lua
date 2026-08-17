-- Grotte Éclair (D02) : cinq étages authentifiés -> Ground final d02p02.
local Route = require 'halcyon.RedEarlyDungeonRoute'
local thunderwave_cave = {}

function thunderwave_cave.Init(zone)
  Route.Init(zone, 'thunderwave_cave')
end

function thunderwave_cave.EnterSegment(zone, rescuing, segment_id, map_id)
  Route.EnterSegment(zone, rescuing, segment_id, map_id, false)
end

function thunderwave_cave.Rescued(zone, name, mail)
  Route.Rescued(zone, name, mail)
end

function thunderwave_cave.ExitSegment(zone, result, rescue, segment_id, map_id)
  Route.ExitSegment(zone, result, rescue, segment_id, {
    pending = 'thunderwave_cave_exit',
    ending_ground = 'd02p02',
    ending_map = 1,
    ending_entry = 0,
    completion_display = false,
    completion_fanfare = false,
    failure_zone = 'master_zone',
    failure_segment = -1,
    failure_map = 1,
    failure_entry = 0,
    failure_display = true,
    failure_fanfare = true,
  })
end

return thunderwave_cave
