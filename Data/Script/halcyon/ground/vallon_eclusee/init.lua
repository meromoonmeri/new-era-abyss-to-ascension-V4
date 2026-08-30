-- M1 RAW_TOWN_ENVIRONMENT — vallon_eclusee (environnement brut, zéro
-- bâtiment). Généré par materialize_ground.py.
require 'origin.common'
local M = {}
function M.Init(map) end
function M.Enter(map) GAME:FadeIn(20) end
function M.Exit(map) end
function M.Update(map, time) end
function M.GameSave(map) end
function M.GameLoad(map) GAME:FadeIn(20) end
return M
