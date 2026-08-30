--[[
    init.lua — MILESTONE 1: town_hollow RAW ENVIRONMENT

    Volontairement minimal : ce map est un environnement brut (grammaire Metano,
    layout neuf, zéro structure). Aucune intrigue, aucun PNJ, aucun événement
    ne vit ici tant que les jalons « structures » ne sont pas livrés.

    Le routage standard du projet (PlotScripting par chapitre) est absent PAR
    CONSTRUCTION : aucun drapeau SV n'est lu ni écrit ici, donc aucun risque de
    routage fantôme. La seule obligation moteur : libérer le fondu à l'entrée
    (sinon EnterGroundMap reste en cutscene et fige la scène — cause exacte du
    gel observé avant l'existence de ce fichier).
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local town_hollow = {}

-------------------------------
-- Map Callbacks
-------------------------------
---town_hollow.Init
--Engine callback function
function town_hollow.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_town_hollow <<=')
end

---town_hollow.Enter
--Engine callback function
function town_hollow.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  GAME:FadeIn(20)
end

---town_hollow.Update
--Engine callback function
function town_hollow.Update(map, time)

end

---town_hollow.GameSave
--Engine callback function
function town_hollow.GameSave(map)

end

---town_hollow.GameLoad
--Engine callback function
function town_hollow.GameLoad(map)
  GAME:FadeIn(20)
end

return town_hollow
