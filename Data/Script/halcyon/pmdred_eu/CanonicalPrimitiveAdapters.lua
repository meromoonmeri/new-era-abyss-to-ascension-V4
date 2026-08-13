-- Proven PMD Red primitive adapters for exact PMDO 0.8.12.
--
-- This module is dormant: it registers no route, mutates no Ground, and never
-- skips an unsupported source command.  Only the three equivalences certified
-- in PMD_RED_OPCODE_REGISTRY.json are executable here.
local Adapters = {}

Adapters.AUTHORITY = {
  pret_commit = 'bf0092d0e34fd8e49b859a0b5f96f00740faa42d',
  pmdo_runtime_commit = '61c005e1dc9fd4eee6e6e7fcde77364de33d291e',
  rogue_essence_commit = '4961b2271bb0cace74f40f6a85e799e8e4848ace',
}

Adapters.PROVEN = {
  WAIT = true,
  BGM_FADEOUT = true,
  SET_DIR_WAIT = true,
}

-- PMD Red and RogueElements enumerate east/west in opposite numeric order.
-- Source direction numbers must therefore never be cast directly to PMDO.
local DIRECTIONS = {
  DIRECTION_SOUTH = Direction.Down,
  DIRECTION_SOUTHEAST = Direction.DownRight,
  DIRECTION_EAST = Direction.Right,
  DIRECTION_NORTHEAST = Direction.UpRight,
  DIRECTION_NORTH = Direction.Up,
  DIRECTION_NORTHWEST = Direction.UpLeft,
  DIRECTION_WEST = Direction.Left,
  DIRECTION_SOUTHWEST = Direction.DownLeft,
}

local function nonnegative_integer(name, value)
  if type(value) ~= 'number' or value < 0 or value ~= math.floor(value) then
    error('PMD Red adapter expected non-negative integer ' .. name)
  end
  return value
end

function Adapters.ResolveDirection(source_direction)
  if source_direction == -1 then
    return nil
  end
  if type(source_direction) ~= 'string' then
    error('PMD Red directions must be mapped by symbol, never by numeric cast')
  end
  local mapped = DIRECTIONS[source_direction]
  if mapped == nil then
    error('unsupported PMD Red direction symbol: ' .. source_direction)
  end
  return mapped
end

function Adapters.WAIT(frames)
  GAME:WaitFrames(nonnegative_integer('frames', frames))
end

function Adapters.BGM_FADEOUT(frames)
  SOUND:FadeOutBGM(nonnegative_integer('frames', frames))
end

function Adapters.SET_DIR_WAIT(actor, source_direction, frames)
  if actor == nil then
    error('SET_DIR_WAIT requires the source parent actor')
  end
  local mapped = Adapters.ResolveDirection(source_direction)
  if mapped ~= nil then
    GROUND:EntTurn(actor, mapped)
  end
  frames = nonnegative_integer('frames', frames)
  if frames > 0 then
    GAME:WaitFrames(frames)
  end
end

function Adapters.Execute(kind, operands, context)
  operands = operands or {}
  context = context or {}
  if kind == 'WAIT' then
    return Adapters.WAIT(operands.frames)
  elseif kind == 'BGM_FADEOUT' then
    return Adapters.BGM_FADEOUT(operands.frames)
  elseif kind == 'SET_DIR_WAIT' then
    return Adapters.SET_DIR_WAIT(context.actor, operands.direction, operands.frames)
  end
  error('unmapped PMD Red primitive (fail-closed): ' .. tostring(kind))
end

return Adapters
