-- Ground Script for Treasure Town (Bourg Comptoir) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_bourg_comptoir = {}

function pixellab_bourg_comptoir.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_bourg_comptoir.Enter(map)
  SOUND:PlayBGM("Treasure Town.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_bourg_comptoir.Update(map, time)
  -- Ambient animation updates
end

function pixellab_bourg_comptoir.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_bourg_comptoir
