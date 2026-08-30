-- Ground Script for Weeping Woods (Bois des Plaintes) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_bois_des_plaintes = {}

function pixellab_bois_des_plaintes.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_bois_des_plaintes.Enter(map)
  SOUND:PlayBGM("Weeping Woods.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_bois_des_plaintes.Update(map, time)
  -- Ambient animation updates
end

function pixellab_bois_des_plaintes.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_bois_des_plaintes
