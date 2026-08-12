-- PMD Red EU s01, station group 1 / sector 0.
-- Canonical scope: new-game portal prelude leading into the personality quiz.
-- This file is replay-only and has no New Era route registration.
local ScenePlayer = require 'halcyon.pmdred_eu.ScenePlayer'
local FrenchText = require 'halcyon.pmdred_eu.FrenchText'

local s01 = {}

s01.AUTHORITY = {
  rom_sha256 = '0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd',
  regional_ground_id = 228,
  source_asset = 's01',
  source_script = 's_gs223_g1_s0_station_sref_script',
  source_command_count = 16,
  exact_eu_graph = true,
}

local PRELUDE = {
  {op = 'BGM_STOP'},
  {op = 'SELECT_MAP', asset = 's01', regional_ground_id = 228},
  {op = 'MSG_ON_BG', source_index = 2, key = 'PMDRED_EU_S01_001', pages = {'PMDRED_EU_S01_001'}},
  {op = 'MSG_ON_BG', source_index = 3, key = 'PMDRED_EU_S01_002', pages = {'PMDRED_EU_S01_002'}},
  {op = 'MSG_ON_BG', source_index = 4, key = 'PMDRED_EU_S01_003', pages = {'PMDRED_EU_S01_003'}},
  {op = 'MSG_ON_BG', source_index = 5, key = 'PMDRED_EU_S01_004', pages = {'PMDRED_EU_S01_004'}},
  {op = 'MSG_ON_BG', source_index = 6, key = 'PMDRED_EU_S01_005', pages = {'PMDRED_EU_S01_005'}},
  -- The source block contains #W between these pages. Two PMDO voice-over
  -- pages preserve that explicit player acknowledgement rather than deleting
  -- the cue or replacing it with an arbitrary timed pause.
  {op = 'MSG_ON_BG', source_index = 7, key = 'PMDRED_EU_S01_006', pages = {'PMDRED_EU_S01_006_A', 'PMDRED_EU_S01_006_B'}},
  {op = 'TEXTBOX_CLEAR'},
  {op = 'SELECT_ENTITIES', group = -1, sector = 0},
  {op = 'BGM_SWITCH', cue = 'Welcome to the World of Pokémon!.ogg', source_music = 'MUS_WELCOME_TO_THE_WORLD_OF_POKEMON'},
}

function s01.ReplayPrelude(options)
  options = options or {}
  GAME:CutsceneMode(true)
  if options.on_action ~= nil then
    options.on_action('SCENE_BEGIN', {scene = 's01', scope = 'prelude_before_personality_quiz'})
  end

  for _, action in ipairs(PRELUDE) do
    if action.op == 'BGM_STOP' then
      ScenePlayer.StopBGM(options)
    elseif action.op == 'SELECT_MAP' then
      ScenePlayer.AssertGround(action.asset, options)
      ScenePlayer.HideActiveTeamForPresentation(options)
    elseif action.op == 'MSG_ON_BG' then
      ScenePlayer.CenteredBackgroundText(action.key, action.pages, FrenchText, options)
    elseif action.op == 'TEXTBOX_CLEAR' then
      ScenePlayer.ClearText(options)
    elseif action.op == 'SELECT_ENTITIES' then
      ScenePlayer.SelectCertifiedGroundEntities(action.group, action.sector, options)
    elseif action.op == 'BGM_SWITCH' then
      ScenePlayer.PlayBGM(action.cue, options)
    else
      error('unmapped PMD Red EU s01 prelude opcode: ' .. tostring(action.op))
    end
  end

  -- The next source command is raw opcode 0x22 (blocking, 30 frames), followed
  -- by SPECIAL_TEXT_PERSONALITY_QUIZ. Neither may be guessed or silently
  -- skipped. Keep cutscene mode active for a future exact continuation, while
  -- the isolated validator is allowed to clean up after recording the gate.
  local result = ScenePlayer.Dependency(
    'SPECIAL_TEXT_PERSONALITY_QUIZ_AND_PALETTE_0x22',
    'RAW_OPCODE_0x22(wait=1,frames=30) -> SPECIAL_TEXT_PERSONALITY_QUIZ',
    options
  )
  if options.on_action ~= nil then
    options.on_action('SCENE_PRELUDE_END', result)
  end
  if options.validation_cleanup then
    GAME:CutsceneMode(false)
  end
  return result
end

function s01.Cutscene()
  error('PMD Red EU s01 is not promotable yet: personality quiz dependency remains open')
end

return s01
