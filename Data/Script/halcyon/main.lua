--[[
  main.lua
  
  This file is loaded persistently.
  Its main purpose is to include anything that needs to stay persistently in the lua state.
  Things like services and campaign managers.
]]--

function PrintInfo(msg)
  print(tostring(msg))
end

--------------------------------------------------------------------------------------------------------------
-- Service Packages & Campaign Managers
--------------------------------------------------------------------------------------------------------------
require 'halcyon.services.debug_tools'
require 'halcyon.services.menu_tools'
require 'halcyon.services.upgrade_tools'
require 'halcyon.services.config_tools'
require 'halcyon.services.nre_probe'
require 'halcyon.services.ground_gameplay_validator'
require 'halcyon.SceneDebug'
require 'halcyon.DonjonFX'
require 'halcyon.HoopaGateway'
require 'halcyon.RescueTeamCampaign'
require 'halcyon.SkyCampaign'

PrintInfo('[NREPROBE] build 2026-08-10 charge (main.lua) — Portages Rescue Team & Sky actifs')

math.randomseed(os.time())
