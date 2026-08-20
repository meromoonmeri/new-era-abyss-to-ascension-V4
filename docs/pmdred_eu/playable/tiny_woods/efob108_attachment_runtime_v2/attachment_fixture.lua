-- Bounded native proof for the EU Caterpie efob108 actor attachment.
-- Loaded only by pmdred_efob108_attachment_validator.lua in a create-only fixture.
local M = {}
local FrameTickType = luanet.import_type('RogueEssence.FrameTick')
local GraphicsManagerType = luanet.import_type('RogueEssence.Content.GraphicsManager')
local ActionPointType = luanet.import_type('RogueEssence.Content.ActionPointType')
local IdleAnimGroundActionType = luanet.import_type('RogueEssence.Ground.IdleAnimGroundAction')
local AnimDataType = luanet.import_type('RogueEssence.Content.AnimData')
local EmoteType = luanet.import_type('RogueEssence.Content.Emote')

local EXPECTED_EFFECT_FRAMES = {0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12}

local function fail(message)
  error('PMDRED_EFOB108_ATTACHMENT_FAIL: '..tostring(message), 2)
end

local function expect(value, message)
  if not value then fail(message) end
end

local function same_point(point, x, y)
  return point.X == x and point.Y == y
end

local function action_name(action)
  local ok, value = pcall(function() return action:GetType().FullName end)
  if ok then return tostring(value) end
  return tostring(action)
end

local function stage_terminal(caterpie, x, y, expected_head_x, expected_head_y, emit, candidate)
  GROUND:TeleportTo(caterpie, x, y, Direction.Down)
  expect(caterpie.Position.X == x and caterpie.Position.Y == y, candidate..' placement differs')
  local walk_id = GraphicsManagerType.GetAnimIndex('Walk')
  expect(walk_id == GraphicsManagerType.WalkAction, 'Walk action index differs from engine WalkAction')
  local action = IdleAnimGroundActionType(caterpie.Position, caterpie.LocHeight, Direction.Down, walk_id, false)
  caterpie:StartAction(action)
  expect(action.AnimFrameType == walk_id, candidate..' action is not Walk')
  expect(action.CharDir == Direction.Down, candidate..' action is not Down-facing')
  expect(action.AnimTotalTime >= 2, candidate..' Walk duration cannot expose a bounded terminal sample')

  -- Keep one native frame in reserve.  The action therefore selects its final
  -- non-looping frame but does not schedule the automatic idle transition.
  local pin_frame = action.AnimTotalTime - 2
  action.ActionTime = FrameTickType.FromFrames(pin_frame)
  caterpie:UpdateFrame()
  local head = GROUND:CharGetAnimPoint(caterpie, ActionPointType.Head)
  expect(same_point(head, expected_head_x, expected_head_y), candidate..' terminal Head point differs')
  expect(action.Complete == false, candidate..' terminal pre-boundary action completed early')
  expect(caterpie:GetCurrentAction() == action, candidate..' terminal Walk identity was replaced')
  emit('terminal_walk_sample', {
    candidate=candidate, placement_x=x, placement_y=y,
    direction=tostring(action.CharDir), native_type=action_name(action),
    anim_id=action.AnimFrameType, walk_anim_id=walk_id,
    action_time_frames=action.ActionTime:ToFrames(), anim_total_time_frames=action.AnimTotalTime,
    terminal_head_x=head.X, terminal_head_y=head.Y,
    complete=action.Complete, current_action_identity=true,
  })
  return action, pin_frame, head
end

local function certify_completion(caterpie, action, expected_head_x, expected_head_y, emit, candidate)
  action.ActionTime = FrameTickType.FromFrames(action.AnimTotalTime)
  caterpie:UpdateFrame()
  local head = GROUND:CharGetAnimPoint(caterpie, ActionPointType.Head)
  expect(action.Complete == true, candidate..' Walk did not complete at AnimTotalTime')
  expect(caterpie:GetCurrentAction() == action, candidate..' completion frame was not sampled before idle transition')
  expect(same_point(head, expected_head_x, expected_head_y), candidate..' completion Head point differs')
  emit('terminal_walk_completion', {
    candidate=candidate, native_type=action_name(action), anim_id=action.AnimFrameType,
    action_time_frames=action.ActionTime:ToFrames(), anim_total_time_frames=action.AnimTotalTime,
    terminal_head_x=head.X, terminal_head_y=head.Y,
    complete=action.Complete, current_action_identity=true,
  })
end

function M.Run(caterpie, emit)
  expect(caterpie ~= nil, 'CATERPIE actor is absent')
  expect(type(emit) == 'function', 'trace emitter is absent')
  emit('fixture_begin', {
    actor='CATERPIE', species=tostring(caterpie.CurrentForm.Species),
    initial_x=caterpie.Position.X, initial_y=caterpie.Position.Y,
    initial_direction=tostring(caterpie.CharDir),
  })

  local direct_action = stage_terminal(caterpie, 180, 148, 187, 161, emit, 'eu_center_literal')
  certify_completion(caterpie, direct_action, 187, 161, emit, 'eu_center_literal')

  -- Replacing the completed direct candidate occurs without yielding.  This is
  -- the exact completion-frame observation before GroundChar's next input
  -- update can schedule IdleGroundAction.
  local normalized_action, pin_frame, normalized_head =
    stage_terminal(caterpie, 172, 140, 179, 153, emit, 'pmdo_top_left_normalized')

  local anim = AnimDataType('PMDRed_Efob108', 2)
  local sheet = GraphicsManagerType.GetAttackSheet('PMDRed_Efob108')
  expect(sheet.TotalFrames == 13, 'efob108 native strip frame count differs')
  expect(anim:GetTotalFrames(sheet.TotalFrames) == 13, 'efob108 selected frame count differs')
  local emote = EmoteType(anim, 4, 1)
  expect(emote.LocHeight == 4, 'efob108 LocHeight differs')
  local draw_size = emote:GetDrawSize()
  expect(draw_size.X == 128 and draw_size.Y == 128, 'efob108 native draw size differs')
  local effect_center_x = normalized_head.X
  local effect_center_y = normalized_head.Y - emote.LocHeight - caterpie.LocHeight
  expect(effect_center_x == 179 and effect_center_y == 149, 'normalized effect center differs from authenticated AX attachment')
  emit('attachment_started', {
    actor='CATERPIE', native_type=action_name(emote), anim_index='PMDRed_Efob108',
    frame_time=2, selected_frames=anim:GetTotalFrames(sheet.TotalFrames), cycles=1,
    duration_frames=26, loc_height=emote.LocHeight,
    draw_width=draw_size.X, draw_height=draw_size.Y,
    head_x=normalized_head.X, head_y=normalized_head.Y,
    actor_loc_height=caterpie.LocHeight,
    effect_center_x=effect_center_x, effect_center_y=effect_center_y,
  })
  caterpie:StartEmote(emote)

  for elapsed=0,25 do
    expect(caterpie:GetCurrentAction() == normalized_action, 'normalized terminal Walk changed during attachment')
    expect(emote.Finished == false, 'efob108 finished before the 26-frame boundary')
    local selected = anim:GetCurrentFrame(FrameTickType.FromFrames(elapsed), sheet.TotalFrames)
    expect(selected == EXPECTED_EFFECT_FRAMES[elapsed + 1], 'efob108 native frame selection differs at elapsed frame '..elapsed)
    local head = GROUND:CharGetAnimPoint(caterpie, ActionPointType.Head)
    expect(same_point(head, 179, 153), 'attached Head point moved during the bounded effect')
    emit('attachment_frame', {
      elapsed_frames=elapsed, selected_frame=selected, finished=emote.Finished,
      head_x=head.X, head_y=head.Y,
      effect_center_x=head.X,
      effect_center_y=head.Y - emote.LocHeight - caterpie.LocHeight,
      terminal_walk_current=true,
    })
    if elapsed < 25 then
      GAME:WaitFrames(1)
      -- GroundChar natively updated both its action and attached emote.  Pinning
      -- back one frame from completion retains the same terminal non-looping
      -- action for the next native attached-emote update.
      expect(caterpie:GetCurrentAction() == normalized_action, 'normalized Walk transitioned before terminal pin')
      normalized_action.ActionTime = FrameTickType.FromFrames(pin_frame)
      caterpie:UpdateFrame()
    end
  end

  emit('attachment_pre_boundary', {elapsed_frames=25, selected_frame=12, finished=emote.Finished})
  GAME:WaitFrames(1)
  expect(caterpie:GetCurrentAction() == normalized_action, 'normalized Walk transitioned at effect boundary')
  normalized_action.ActionTime = FrameTickType.FromFrames(pin_frame)
  caterpie:UpdateFrame()
  expect(emote.Finished == true, 'efob108 did not finish at the 26-frame boundary')
  emit('attachment_boundary', {elapsed_frames=26, finished=emote.Finished})

  certify_completion(caterpie, normalized_action, 179, 153, emit, 'pmdo_top_left_normalized')
  emit('coordinate_convention_selected', {
    convention='eu_center_to_pmdo_top_left_minus_8_minus_8',
    source_center_x=180, source_center_y=148,
    pmdo_position_x=172, pmdo_position_y=140,
    terminal_head_x=179, terminal_head_y=153,
    effect_center_x=179, effect_center_y=149,
    authenticated_ax_x=179, authenticated_ax_y=149,
    verdict='PASS',
  })
  emit('fixture_complete', {verdict='PASS', effect_frames=26, selected_coordinate_convention='normalized_minus_8_minus_8'})
end

return M
