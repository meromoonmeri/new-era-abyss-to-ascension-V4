--[[
    RedCanonScene — lecture d'une cinématique canonique PMD Red.

    Les scènes de la ROM sont décrites par leur structure (musique, suite de
    répliques). Ce module les joue sans jamais inventer de texte : une réplique
    dont la clé n'est pas présente dans les Strings du mod est sautée, et
    signalée une fois dans le journal.

    Importer le texte canonique : `tools/audit_pmdred_eu_rom.py` avec votre ROM
    EU, puis `tools/import_red_scene_strings.py`.
]]
require 'origin.common'

RedCanonScene = {}

local warned = {}

--- Renvoie le texte canonique de la clé, ou nil s'il n'est pas importé.
function RedCanonScene.Text(key)
  local ok, value = pcall(function() return STRINGS:FormatKey(key) end)
  if not ok or value == nil then return nil end
  value = tostring(value)
  -- RogueEssence renvoie la clé elle-même lorsqu'elle est absente.
  if value == '' or value == key then return nil end
  return value
end

--- Joue la scène : musique canonique puis répliques canoniques disponibles.
function RedCanonScene.Play(scene, lines, music)
  GAME:CutsceneMode(true)
  if music ~= nil and music ~= '' then
    pcall(function() GAME:PlayBGM(music, true) end)
  end
  local shown, missing = 0, 0
  for _, key in ipairs(lines or {}) do
    local text = RedCanonScene.Text(key)
    if text ~= nil then
      UI:ResetSpeaker(false)
      UI:WaitShowDialogue(text)
      shown = shown + 1
    else
      missing = missing + 1
    end
  end
  if missing > 0 and not warned[scene] then
    warned[scene] = true
    PrintInfo(string.format(
      '[RedCanonScene] %s : %d réplique(s) canonique(s) sans texte importé (ROM absente) '
      .. '— elles sont sautées, aucune ligne inventée.', tostring(scene), missing))
  end
  return shown, missing
end

return RedCanonScene
