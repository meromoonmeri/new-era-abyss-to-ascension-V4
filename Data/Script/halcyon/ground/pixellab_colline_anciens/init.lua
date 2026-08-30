-- Ground Script for Hill of Ancients (Colline des Anciens) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_colline_anciens = {}

function pixellab_colline_anciens.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_colline_anciens.Enter(map)
  SOUND:PlayBGM("Hill of the Ancients.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_colline_anciens.Update(map, time)
  -- Ambient animation updates
end

function pixellab_colline_anciens.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_colline_anciens
