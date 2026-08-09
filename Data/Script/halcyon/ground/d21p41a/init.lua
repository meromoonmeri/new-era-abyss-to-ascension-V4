--[[
    d21p41a — SALLE DU BOSS SPIRITOMB (Sealed Ruin Pit, arc du futur).

    ENCOUNTER CANONIQUE EoS (reconstruit depuis les données NDS) :
      * Map fixe D21P41A, arène 22x17 (fixed floor 7), Spiritomb placé à
        (8,2) tuiles = (324,196) px, direction Down (position SSA m18b1201).
      * Ordre canonique des scènes (LSD d21p41a) :
          m18b1101 — « Urggh... You two... » (entrée dans la salle)
          m18b1201 — SPIRITOMB attaque : « HEE-hee...HEE-hee...! Back again? »
                     « None shall be forgiven for TRESPASSING here! »
                     « PREPARE to take your punishment! »
          m18b1301 — SPIRITOMB s'effraie et s'enfuit : « UGGGH...OOOOH...ARRGH! »
                     « Eeep! » ; Grovyle révèle qu'il est normalement timide
                     (« It's normally a timid Pokémon. ») — scène de confiance.
      * Après la rencontre : progression vers Dusk Forest (dungeon 32, D22P11A).

    Cast New Era : SPIRITOMB (ミカルゲ) est CONSERVÉ tel quel — jamais remplacé
    par Dusknoir, Mismagius ou un autre Pokémon.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d21p41a = {}

function d21p41a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d21p41a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    -- 1. m18b1101 : entrée dans la salle du boss
    local s1 = require('halcyon.future_arc.scene.d21p41a_m18b1101')
    if s1 ~= nil and s1.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1101')
      s1.Cutscene()
    end
    -- 2. m18b1201 : SPIRITOMB attaque (position canonique 324,196)
    local s2 = require('halcyon.future_arc.scene.d21p41a_m18b1201')
    if s2 ~= nil and s2.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1201')
      s2.Cutscene()
    end
    -- 3. m18b1301 : SPIRITOMB s'effraie et s'enfuit ; Grovyle explique
    local s3 = require('halcyon.future_arc.scene.d21p41a_m18b1301')
    if s3 ~= nil and s3.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1301')
      s3.Cutscene()
    end
    GAME:CutsceneMode(false)
    -- Progression : après Spiritomb, le trio poursuit vers Dusk Forest (d32)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d22p11a', 'Main_Entrance_Marker')
  end)
  if not ok then
    PrintInfo('[d21p41a] scène Spiritomb interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

function d21p41a.Update(map) end
function d21p41a.GameSave(map) end
function d21p41a.GameLoad(map)
  GAME:FadeIn(20)
end

return d21p41a
