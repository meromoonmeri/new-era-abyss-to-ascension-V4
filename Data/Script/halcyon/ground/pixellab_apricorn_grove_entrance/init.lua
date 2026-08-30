-- Ground Script for Apricorn Grove Entrance (Bosquet Noigrumes) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_apricorn_grove_entrance = {}

function pixellab_apricorn_grove_entrance.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_apricorn_grove_entrance.Enter(map)
  SOUND:PlayBGM("Apricorn Grove.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_apricorn_grove_entrance.Update(map, time)
  -- Ambient animation updates
end

function pixellab_apricorn_grove_entrance.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_apricorn_grove_entrance
