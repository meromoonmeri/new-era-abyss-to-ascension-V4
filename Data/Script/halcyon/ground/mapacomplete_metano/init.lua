-- Metano Outskirts (Treehouse) — mapacomplete_metano
-- BLOCKOUT généré par materialize_mapacomplete.py (langage Metano).
-- Reconstruction manuelle du fragment TOWN PLAZA (F1/F3) de
-- MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp.
-- Ressource de travail pour une construction manuelle dans l'éditeur PMDO.
require 'origin.common'

local mapacomplete_metano = {}

function mapacomplete_metano.Init(map)
end

function mapacomplete_metano.Enter(map)
  GAME:FadeIn(20)
end

function mapacomplete_metano.Exit(map)
end

function mapacomplete_metano.Update(map, time)
end

function mapacomplete_metano.GameSave(map)
end

function mapacomplete_metano.GameLoad(map)
  GAME:FadeIn(20)
end

return mapacomplete_metano
