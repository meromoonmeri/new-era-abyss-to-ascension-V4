-- Source-pinned adapter for the 15 authenticated PMD Red EU palette commands.
local GraphicsManagerType=luanet.import_type('RogueEssence.Content.GraphicsManager')
local COMMANDS={
  ["0x084CB130"]={address="0x084CB130",array="tiny_woods_scene:s_gs178_g1_s0_station_sref_script",index=2,opcode=35,opcode_hex="0x23",frames=0,channel="main",target="black",api="GAME:FadeOut(false, frames)"},
  ["0x084CB148"]={address="0x084CB148",array="tiny_woods_scene:s_gs178_g1_s0_station_sref_script",index=3,opcode=38,opcode_hex="0x26",frames=0,channel="front",target="black",api="GAME:FadeOutFront(false, frames)"},
  ["0x084CB2E0"]={address="0x084CB2E0",array="tiny_woods_scene:s_gs178_g1_s0_station_sref_script",index=20,opcode=37,opcode_hex="0x25",frames=0,channel="front",target="visible",api="GAME:FadeInFront(frames)"},
  ["0x084CB400"]={address="0x084CB400",array="tiny_woods_scene:s_gs178_g1_s0_station_sref_script",index=32,opcode=34,opcode_hex="0x22",frames=60,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x084CFFE8"]={address="0x084CFFE8",array="tiny_woods_scene:s_gs178_g2_s0_station_sref_script",index=9,opcode=34,opcode_hex="0x22",frames=60,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x084D1C54"]={address="0x084D1C54",array="tiny_woods_scene:s_gs178_g3_s0_station_sref_script",index=4,opcode=34,opcode_hex="0x22",frames=30,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x084D1C9C"]={address="0x084D1C9C",array="tiny_woods_scene:s_gs178_g3_s0_station_sref_script",index=7,opcode=35,opcode_hex="0x23",frames=30,channel="main",target="black",api="GAME:FadeOut(false, frames)"},
  ["0x084D4C90"]={address="0x084D4C90",array="tiny_woods_scene:s_gs179_g1_s0_station_sref_script",index=3,opcode=34,opcode_hex="0x22",frames=30,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x084D4CC0"]={address="0x084D4CC0",array="tiny_woods_scene:s_gs179_g1_s0_station_sref_script",index=5,opcode=35,opcode_hex="0x23",frames=30,channel="main",target="black",api="GAME:FadeOut(false, frames)"},
  ["0x0838D21C"]={address="0x0838D21C",array="post_route:s_gs9_g17_s0_station_sref_script",index=4,opcode=34,opcode_hex="0x22",frames=30,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x0838D27C"]={address="0x0838D27C",array="post_route:s_gs9_g17_s0_station_sref_script",index=8,opcode=35,opcode_hex="0x23",frames=60,channel="main",target="black",api="GAME:FadeOut(false, frames)"},
  ["0x0838D294"]={address="0x0838D294",array="post_route:s_gs9_g17_s0_station_sref_script",index=9,opcode=38,opcode_hex="0x26",frames=0,channel="front",target="black",api="GAME:FadeOutFront(false, frames)"},
  ["0x0838D36C"]={address="0x0838D36C",array="post_route:s_gs9_g17_s0_station_sref_script",index=18,opcode=37,opcode_hex="0x25",frames=0,channel="front",target="visible",api="GAME:FadeInFront(frames)"},
  ["0x0856280C"]={address="0x0856280C",array="post_route:title_group/script",index=5,opcode=34,opcode_hex="0x22",frames=60,channel="main",target="visible",api="GAME:FadeIn(frames)"},
  ["0x08562854"]={address="0x08562854",array="post_route:title_group/script",index=8,opcode=35,opcode_hex="0x23",frames=30,channel="main",target="black",api="GAME:FadeOut(false, frames)"}
}
local ORDER={"0x084CB130","0x084CB148","0x084CB2E0","0x084CB400","0x084CFFE8","0x084D1C54","0x084D1C9C","0x084D4C90","0x084D4CC0","0x0838D21C","0x0838D27C","0x0838D294","0x0838D36C","0x0856280C","0x08562854"}
local Palette={}
local function trace(kind,command,scene,detail)
  if PMDRED_TINY_WOODS_SCENE_TRACE then
    PMDRED_TINY_WOODS_SCENE_TRACE(kind,scene,command.index,command.address,command.channel,command.target,detail)
  end
end
local function ticks() return tonumber(GraphicsManagerType.TotalFrameTick) or 0 end
function Palette.Execute(address,scene)
  local command=COMMANDS[address]
  if command==nil then error('palette adapter rejected unauthenticated address '..tostring(address)) end
  local runtimeFrames=command.frames==0 and 1 or command.frames
  local before=ticks()
  local common=string.format('array=%s;opcode=%s;source_frames=%d;runtime_frames=%d;blocking=true;api=%s',command.array,command.opcode_hex,command.frames,runtimeFrames,command.api)
  trace('palette_transition_start',command,scene,common..';before_tick='..tostring(before))
  if command.opcode==0x22 then GAME:FadeIn(runtimeFrames)
  elseif command.opcode==0x23 then GAME:FadeOut(false,runtimeFrames)
  elseif command.opcode==0x25 then GAME:FadeInFront(runtimeFrames)
  elseif command.opcode==0x26 then GAME:FadeOutFront(false,runtimeFrames)
  else error('palette adapter opcode gate failed') end
  local after=ticks();local elapsed=math.floor((after-before)/120)
  trace('palette_transition_complete',command,scene,common..';before_tick='..tostring(before)..';after_tick='..tostring(after)..';elapsed_frames='..tostring(elapsed))
end
function Palette.ExecuteAll(scene)
  for _,address in ipairs(ORDER) do Palette.Execute(address,scene) end
end
function Palette.Count() return #ORDER end
return Palette
