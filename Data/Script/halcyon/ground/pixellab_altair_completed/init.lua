-- Ground Script for Altair Transition (Completed by PixelLab)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_altair_completed = {}

function pixellab_altair_completed.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_altair_completed.Enter(map)
  SOUND:PlayBGM("Treasure Town.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_altair_completed.Update(map, time)
  -- Real-time updates (river ripples, breeze)
end

function pixellab_altair_completed.Exit(map)
  GAME:FadeOut(20)
end

function pixellab_altair_completed.Exit_Pier_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Boarding the raft at the Altair water pier...")
  GAME:EnterGroundMap("altere_pond", "Entry_South")
end

function pixellab_altair_completed.Exit_NorthOverlook_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Gazing across the sweeping mountain valleys...")
end

return pixellab_altair_completed
