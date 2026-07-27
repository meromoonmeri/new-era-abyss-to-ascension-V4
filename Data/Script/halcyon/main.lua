--[[
  main.lua
  
  This file is loaded persistently.
  Its main purpose is to include anything that needs to stay persistently in the lua state.
  Things like services.
]]--

--------------------------------------------------------------------------------------------------------------
-- Service Packages
--------------------------------------------------------------------------------------------------------------
require 'halcyon.services.debug_tools'
require 'halcyon.services.menu_tools'
require 'halcyon.services.upgrade_tools'
require 'halcyon.services.config_tools'
require 'halcyon.services.nre_probe'--sonde runtime NRE IsGameOver (audit 2026-07-27, retirable)
PrintInfo('[NREPROBE] build 2026-07-27-B charge — si cette ligne est ABSENTE du log, la copie du mod installee dans MODS est PERIMEE.')

math.randomseed(os.time())