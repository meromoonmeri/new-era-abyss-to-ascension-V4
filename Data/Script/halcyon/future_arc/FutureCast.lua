--[[
    FutureCast.lua — SPAWNER DU CAST NEW ERA (arc du futur).

    Chorégraphie 1:1 (directive utilisateur) : les personnages sont placés aux
    positions canoniques (SSB/SSA), seuls les ACTEURS sont New Era :
      Dusknoir / Grovyle (alliés du futur), Sableye (sbires de Necrozma),
      Celebi, héros/partenaire ; dans les scènes où l'acteur original joue le
      rôle d'ANTAGONISTE -> Necrozma (ANTAGONIST_SCENES).
    HeroFuture copie l'espèce du héros (le héros du futur, 30 ans plus tard).
]]
require 'origin.common'

FutureCast = {}

FutureCast.ANTAGONIST = {
  ['P05P03A_m17a0302'] = true,
  ['P05P03A_m26a06d3'] = true,
  ['P09P01A_m19b1001'] = true,
  ['P09P01A_m19b1007'] = true,
  ['P09P01A_m19b1009'] = true,
  ['P09P01A_m19d1072'] = true,
}

FutureCast.SPAWNS = require 'halcyon.future_arc.spawns'.FutureCast_SPAWNS

-- Crée un personnage au sol (nom explicite -> CH(name) fonctionne).
function FutureCast.Create(species, gender, name, x, y, dir)
  local g = RogueEssence.Data.Gender
  local monster = RogueEssence.Dungeon.MonsterID(species, 0, 'normal', g[gender])
  local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), dir, name, name)
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  AI:DisableCharacterAI(chara)
  return chara
end

-- Place le cast de la scène. Retourne la table nom -> chara.
function FutureCast.Spawn(sceneKey)
  local sp = FutureCast.SPAWNS[sceneKey]
  if sp == nil then return {} end
  local out = {}
  local hero = CH('PLAYER')
  local heroSpecies = 'bulbasaur'
  if hero ~= nil then heroSpecies = hero.CurrentForm.Species end
  local antagoniste = FutureCast.ANTAGONIST[sceneKey] == true
  for ent, info in pairs(sp) do
    -- PLAYER/ATTENDANT1 = l'équipe du joueur : téléportés plus bas, pas créés
    if ent == 'PLAYER' or ent == 'ATTENDANT1' then
      goto continue
    end
    local species = info.species
    local gender = info.gender
    local name = info.name
    if species == '__HERO__' then
      species = heroSpecies
    end
    if antagoniste and (ent == 'NPC_YONOWAARU' or ent == 'NPC_YONOWAARU_N8') then
      species, gender, name = 'necrozma', 'Genderless', 'Necrozma'
    end
    local c = FutureCast.Create(species, gender, name, info.x, info.y, info.dir)
    out[name] = c
    ::continue::
  end
  -- héros + partenaire : téléportés à leur position canonique
  local heroPos = sp['PLAYER']
  local partPos = sp['ATTENDANT1']
  if heroPos ~= nil and hero ~= nil then
    GROUND:TeleportTo(hero, heroPos.x, heroPos.y)
  end
  local partner = CH('Teammate1')
  if partPos ~= nil and partner ~= nil then
    GROUND:TeleportTo(partner, partPos.x, partPos.y)
  end
  return out
end

return FutureCast
