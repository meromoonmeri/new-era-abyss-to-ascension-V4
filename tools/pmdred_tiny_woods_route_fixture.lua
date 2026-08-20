-- Tiny Woods route state machine for the isolated PMD Red EU fixture.
--
-- This module deliberately owns only the observable routing/progression state
-- proven in this milestone.  Dialogue and choreography remain separate later
-- phases; no adapted New Era story state is consulted as canon.
require 'origin.common'

local Route = {}

local function state()
  SV.PmdRedTinyWoodsRoute = SV.PmdRedTinyWoodsRoute or {}
  return SV.PmdRedTinyWoodsRoute
end

function Route.Reset()
  SV.PmdRedTinyWoodsRoute = {
    Schema = 'pmdred-eu-tiny-woods-route-v1',
    Status = 'opening',
    Attempts = 0,
    Defeats = 0,
    FloorsEntered = {},
    FloorsCleared = {},
    RescueComplete = false,
    PendingGround = 'd01p01',
    LastGround = '',
    LastGroup = '',
    LastResult = '',
  }
  return SV.PmdRedTinyWoodsRoute
end

function Route.GetState()
  return state()
end

function Route.DispatchGround(ground)
  local s = state()
  local group = ''
  if ground == 'd01p01' then
    if s.RescueComplete then
      group = 'g3'
      s.Status = 'post_rescue'
    elseif s.Status == 'failed' then
      group = 'g2'
    else
      group = 'g1'
    end
  elseif ground == 'd01p02' and s.Status == 'cleared' and not s.RescueComplete then
    group = 'g1'
  end
  s.LastGround = ground
  s.LastGroup = group
  s.PendingGround = ground
  return group
end

function Route.BeginAttempt()
  local s = state()
  s.Attempts = (s.Attempts or 0) + 1
  s.Status = 'in_progress'
  s.PendingGround = 'tiny_woods'
  s.LastResult = ''
  return s.Attempts
end

function Route.RecordFloorEntered(floor)
  local s = state()
  floor = tonumber(floor) or -1
  table.insert(s.FloorsEntered, floor)
end

function Route.RecordFloorCleared(floor)
  local s = state()
  floor = tonumber(floor) or -1
  if s.FloorsCleared[#s.FloorsCleared] ~= floor then
    table.insert(s.FloorsCleared, floor)
  end
end

function Route.ExitSegment(result, segmentID, mapID)
  local s = state()
  local cleared = result == RogueEssence.Data.GameProgress.ResultType.Cleared
  s.LastResult = tostring(result)
  if cleared then
    s.Status = 'cleared'
    s.PendingGround = 'd01p02'
    return 'd01p02'
  end
  s.Defeats = (s.Defeats or 0) + 1
  s.Status = 'failed'
  s.PendingGround = 'd01p01'
  return 'd01p01'
end

function Route.CompleteRescue()
  local s = state()
  if s.Status ~= 'cleared' then
    error('Tiny Woods rescue cannot complete before a clear')
  end
  s.RescueComplete = true
  s.Status = 'post_rescue'
  s.PendingGround = 'd01p01'
end

return Route
