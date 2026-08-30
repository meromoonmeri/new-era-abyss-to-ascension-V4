-- Ground Script for Altere Pond (Étang Altéré) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_altere_pond = {}

function pixellab_altere_pond.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_altere_pond.Enter(map)
  SOUND:PlayBGM("Altere Pond.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_altere_pond.Update(map, time)
  -- Ambient animation updates
end

function pixellab_altere_pond.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_altere_pond
