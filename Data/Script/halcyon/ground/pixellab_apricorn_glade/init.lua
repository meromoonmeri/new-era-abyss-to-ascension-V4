-- Ground Script for Apricorn Glade (Clairière Noigrumes) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_apricorn_glade = {}

function pixellab_apricorn_glade.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_apricorn_glade.Enter(map)
  SOUND:PlayBGM("Apricorn Grove.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_apricorn_glade.Update(map, time)
  -- Ambient animation updates
end

function pixellab_apricorn_glade.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_apricorn_glade
