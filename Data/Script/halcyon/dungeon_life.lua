--[[
    dungeon_life.lua — rencontres non hostiles + zones secretes
    Utilise les systemes existants : MapEffectStep, ActiveEffect, ScriptGenStep
]]
require 'origin.common'
DungeonLife = {}

-- 1. Marchand itinerant (Musharna) — 8% par etage non-boss
function DungeonLife.SpawnWanderingMerchant(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 8 then return end
    if zoneContext.CurrentID == 0 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_MerchantAppears"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 2. Groupe de danseurs (Spinda+Ludicolo) — 5% par etage
function DungeonLife.SpawnDancingGroup(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 5 then return end
    if zoneContext.CurrentID < 3 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_DancersAppear"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 3. Habitants pacifiques — 4% par etage
function DungeonLife.SpawnFriendlyResident(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 4 then return end
    if zoneContext.CurrentID < 2 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_ResidentAppears"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 4. Zone secrete par type Plante — 3% si type Plante equipe
function DungeonLife.CheckTeamForSecretZone(zoneContext, context, queue, seed, args)
    local hasType = false
    for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
        local m = GAME:GetPlayerPartyMember(i)
        if m.Element1 == "grass" or m.Element2 == "grass" then hasType = true; break end
    end
    if not hasType then return end
    if seed:Next(100) >= 3 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_SecretZone"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- ====================================================================
-- HANDLERS D'ENTREE (OnMapStarts) — référencés par les Spawn* ci-dessus.
-- DungeonLife_* est appelé au démarrage d'un étage qui a reçu le
-- MapEffectStep. Le module d'origine ne les définissait pas : sans eux,
-- tout étage porteur d'un de ces spawns levait « attempt to call a nil
-- value » (DungeonLife_MerchantAppears etc. inexistants) -> crash à la
-- génération. Définis ici en sécurité : les apparitions bonus sont
-- volontairement inertes pour l'instant, mais le jeu ne crashe plus.
-- ====================================================================
function SINGLE_CHAR_SCRIPT.DungeonLife_MerchantAppears(owner, ownerChar, context, args)
  -- Réservé : apparition d'un marchand itinérant.
end

function SINGLE_CHAR_SCRIPT.DungeonLife_DancersAppear(owner, ownerChar, context, args)
  -- Réservé : groupe de danseurs Spinda+Ludicolo.
end

function SINGLE_CHAR_SCRIPT.DungeonLife_ResidentAppears(owner, ownerChar, context, args)
  -- Réservé : habitant pacifique.
end

function SINGLE_CHAR_SCRIPT.DungeonLife_SecretZone(owner, ownerChar, context, args)
  -- Réservé : zone secrète par type Plante.
end

return DungeonLife
