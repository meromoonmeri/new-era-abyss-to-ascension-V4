-- Ground Script for Sinister Woods Verge (Orée des Bois Sombres) (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_bois_sombres_oree = {}

function pixellab_bois_sombres_oree.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_bois_sombres_oree.Enter(map)
  SOUND:PlayBGM("Sinister Woods.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_bois_sombres_oree.Update(map, time)
  -- Ambient animation updates
end

function pixellab_bois_sombres_oree.Exit(map)
  GAME:FadeOut(20)
end

return pixellab_bois_sombres_oree
