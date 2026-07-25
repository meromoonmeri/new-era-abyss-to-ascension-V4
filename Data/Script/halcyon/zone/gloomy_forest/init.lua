require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}

function gloomy_forest.Init(zone)
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> Init_gloomy_forest")
	SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
	-- Rescues allowed in segments 0 and 1, disallowed in the boss fight (segment 2).
	if segmentID == 2 then
		GAME:SetRescueAllowed(false)
	else
		GeneralFunctions.CheckAllowSetRescue(zone.ID)
	end
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function gloomy_forest.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

------------------------------------------------------------------
-- ExitSegment
------------------------------------------------------------------
-- Gloomy Forest has 3 segments:
--   0 = normal floors (procedural, "eighteen floors")
--   1 = depth floors  (procedural, "three floors") + Chenipent rescue objective
--   2 = boss (Zarude, LoadGen gloomy_forest_boss.rsmap)
--
-- A mid-dungeon relay "gloomy_forest_midpoint" (master_zone mapID 61) sits between
-- segment 0 and segment 1. Dying in segment 1 or 2 respawns at the relay instead
-- of Metano Town. Faithful mirror of zone/searing_tunnel + zone/crooked_cavern.
-- See docs/audit_checkpoint_crooked_cavern.md (reusable pattern).
------------------------------------------------------------------
function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> ExitSegment_gloomy_forest result " .. tostring(result) .. " segment " .. tostring(segmentID))

	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
	SV.adventure.Thief = false
	if exited == true then return end

	if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : stop at the relay instead of flowing directly
		-- into the depth floors. The relay's North exit starts segment 1.
		-- (Original was: GAME:ContinueDungeon("gloomy_forest", 1, 0, 0, ...).)
		SV.Chapter6.GloomyMidpointState = 'FirstArrival'
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 61, 0, false, false) --gloomy_forest_midpoint (mapID 61)
		return
	end

	if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		if SV.Chapter6.ChenipentFound then
			GAME:EnterGroundMap('gloomy_forest_boss', 'Main_Entrance_Marker')
		else
			-- The rescue objective is required before the heart of the forest opens.
			SV.Chapter6.MissionAccepted = false
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		end
		return
	end

	if segmentID == 1 and result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : died/escaped in the depth floors.
		if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
			-- Escaped: leave to the entrance, NOT the relay (mirrors Searing Tunnel).
			GAME:WaitFrames(20)
			SV.Chapter6.MissionAccepted = false
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 51, 0, true, true) --gloomy_forest_entrance (mapID 51)
		else
			-- Died: respawn at the relay.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			GAME:WaitFrames(20)
			GAME:EndDungeonRun(result, "master_zone", -1, 61, 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, 61, 0)
		end
		return
	end

	if segmentID == 2 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.GloomyBossEncountered = true
			SV.Chapter6.DefeatedGloomyBoss = true
			SV.Chapter6.MissionComplete = true
			SV.Chapter6.MissionAccepted = false
			-- Beat the boss: return to town (UNCHANGED).
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		else
			-- *** CHECKPOINT (NEW) *** : died/escaped to the boss (Zarude) -> respawn at
			-- the relay (previously returned to town, mapID 1). GloomyBossEncountered
			-- stays true so the next gloomy_forest_boss visit plays the retry scene.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			SV.Chapter6.MissionAccepted = false
			GAME:EndDungeonRun(result, "master_zone", -1, 61, 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, 61, 0)
		end
		return
	end

	-- Segment 0 loss/escape (and any other unhandled loss): return safely to Metano Town (UNCHANGED).
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		GAME:WaitFrames(20)
	end
	SV.Chapter6.MissionAccepted = false
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
end

return gloomy_forest
