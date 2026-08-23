--[[
    mapgen_validator — validation runtime de la génération des donjons.

    Ce service rejoue, DANS LE MOTEUR, exactement la boucle de
    MapGenTest.Example.StressTestAll :

        ReNoise(zoneSeed) -> GetTwoUInt64(segment)
        ZoneGenContext { CurrentZone, CurrentSegment, ZoneSteps instanciés }
        pour chaque étage : Seed = ReNoise(seed2):GetUInt64((id << 32) | maps)
        structure:GetMap(context)     <= génération réelle par RogueElements

    Il n'imite rien : c'est l'appel du moteur qui construit l'étage. Toute
    exception est capturée et journalisée telle quelle, sans masquage.

    Activation (jamais en jeu normal) :
        PMDO_MAPGEN_VALIDATOR=all            toutes les zones du mod
        PMDO_MAPGEN_VALIDATOR=zone1,zone2    liste explicite
        PMDO_MAPGEN_ITER=3                   itérations par étage (défaut 1)
        PMDO_MAPGEN_OUT=/tmp/mapgen.jsonl    fichier de sortie

    Sortie : une ligne JSON par étage généré (ou en échec), puis une ligne
    {"event":"end"} avec le récapitulatif.
]]
require 'origin.common'
require 'origin.services.baseservice'

local MapGenValidator = Class('MapGenValidator', BaseService)

local OUT = os.getenv('PMDO_MAPGEN_OUT') or '/tmp/mapgen_validator.jsonl'

local function emit(line)
  PrintInfo('[MAPGEN] ' .. line)
  local f = io.open(OUT, 'a')
  if f then f:write(line .. '\n'); f:flush(); f:close() end
end

local function esc(s)
  s = tostring(s)
  s = s:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', ' | '):gsub('\r', '')
  return s
end

function MapGenValidator:initialize()
  BaseService.initialize(self)
  self.spec = os.getenv('PMDO_MAPGEN_VALIDATOR')
  self.enabled = (self.spec ~= nil and self.spec ~= '')
  self.iterations = tonumber(os.getenv('PMDO_MAPGEN_ITER') or '1') or 1
  self.done = false
  if self.enabled then
    PrintInfo('[MAPGEN] service actif, spec=' .. tostring(self.spec)
              .. ' itérations=' .. tostring(self.iterations))
  end
end

--------------------------------------------------------------------
-- Types CLR utilisés (mêmes que MapGenTest).
--------------------------------------------------------------------
local function clr()
  luanet.load_assembly('RogueElements')
  luanet.load_assembly('RogueEssence')
  return {
    ReNoise = luanet.import_type('RogueElements.ReNoise'),
    MathUtils = luanet.import_type('RogueElements.MathUtils'),
    ZoneGenContext = luanet.import_type('RogueEssence.LevelGen.ZoneGenContext'),
    MainProgress = luanet.import_type('RogueEssence.Data.MainProgress'),
    DataManager = luanet.import_type('RogueEssence.Data.DataManager'),
    Guid = luanet.import_type('System.Guid'),
  }
end

--------------------------------------------------------------------
-- Liste des zones à tester.
--------------------------------------------------------------------
function MapGenValidator:zone_list()
  if self.spec ~= 'all' then
    local list = {}
    for id in string.gmatch(self.spec, '[^,%s]+') do list[#list + 1] = id end
    return list
  end
  local list = {}
  local indices = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]
  local keys = indices:GetOrderedKeys(false)
  for i = 0, keys.Count - 1 do list[#list + 1] = keys[i] end
  return list
end

--------------------------------------------------------------------
-- Génération réelle d'un étage.
--------------------------------------------------------------------
function MapGenValidator:run()
  if not self.enabled or self.done then return end
  self.done = true

  local f = io.open(OUT, 'w'); if f then f:close() end
  local T = clr()
  local zones = self:zone_list()
  emit(string.format('{"event":"begin","zones":%d,"iterations":%d}', #zones, self.iterations))

  local total, failures, floors = 0, 0, 0
  for _, zoneId in ipairs(zones) do
    local okZone, zone = pcall(function() return _DATA:GetZone(zoneId) end)
    if not okZone or zone == nil then
      failures = failures + 1
      emit(string.format('{"event":"zone_error","zone":"%s","error":"%s"}', esc(zoneId), esc(zone)))
    else
      local segCount = zone.Segments.Count
      for iter = 1, self.iterations do
        local zoneSeed = T.MathUtils.Rand:NextUInt64()
        local totalNoise = T.ReNoise(zoneSeed)
        for seg = 0, segCount - 1 do
          local structure = zone.Segments[seg]
          local doubleSeed = totalNoise:GetTwoUInt64(seg)
          local ctx = T.ZoneGenContext()
          ctx.CurrentZone = zoneId
          ctx.CurrentSegment = seg
          local structNoise = T.ReNoise(doubleSeed[0])
          for ii = 0, structure.ZoneSteps.Count - 1 do
            ctx.ZoneSteps:Add(structure.ZoneSteps[ii]:Instantiate(structNoise:GetUInt64(ii)))
          end
          local idNoise = T.ReNoise(doubleSeed[1])
          local save = T.MainProgress(T.MathUtils.Rand:NextUInt64(), T.Guid.NewGuid():ToString())
          T.DataManager.Instance:SetProgress(save)
          -- FloorCount == nombre d'étages du segment ; les identifiants vont
          -- de 0 à FloorCount-1 (RogueEssence.LevelGen.ZoneSegmentBase).
          for floorId = 0, structure.FloorCount - 1 do
            ctx.CurrentID = floorId
            ctx.Seed = idNoise:GetUInt64((floorId << 32) | 0)
            total = total + 1
            local t0 = os.clock()
            local ok, result = pcall(function() return structure:GetMap(ctx) end)
            local ms = math.floor((os.clock() - t0) * 1000)
            if ok and result ~= nil then
              floors = floors + 1
              local w, h, rooms = -1, -1, -1
              pcall(function()
                w = result.Map.Width; h = result.Map.Height
                rooms = result.RoomPlan.RoomCount
              end)
              emit(string.format(
                '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"status":"OK",'
                .. '"width":%d,"height":%d,"rooms":%d,"ms":%d,"seed":"%s"}',
                esc(zoneId), seg, floorId, iter, w, h, rooms, ms, tostring(ctx.Seed)))
            else
              failures = failures + 1
              -- NLua remonte l'objet exception : on extrait le vrai type,
              -- le message interne et la pile, sans rien masquer.
              local etype, emsg, estack = 'unknown', tostring(result), ''
              pcall(function()
                local inner = result.InnerException or result
                etype = inner:GetType():ToString()
                emsg = inner.Message
                estack = inner.StackTrace or ''
              end)
              emit(string.format(
                '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"status":"FAIL",'
                .. '"type":"%s","message":"%s","stack":"%s","raw":"%s","seed":"%s"}',
                esc(zoneId), seg, floorId, iter, esc(etype), esc(emsg), esc(estack),
                esc(result), tostring(ctx.Seed)))
            end
          end
          T.DataManager.Instance:SetProgress(nil)
        end
      end
    end
  end

  emit(string.format('{"event":"end","attempted":%d,"generated":%d,"failures":%d}',
                     total, floors, failures))
end

function MapGenValidator:OnInit()
  if not self.enabled then return end
  local ok, err = pcall(function() self:run() end)
  if not ok then emit(string.format('{"event":"fatal","error":"%s"}', esc(err))) end
end

function MapGenValidator:Subscribe(med)
  med:Subscribe('MapGenValidator', EngineServiceEvents.Init, function() self.OnInit(self) end)
end

function MapGenValidator:UnSubscribe(med)
  med:UnsubscribeAll('MapGenValidator')
end

SCRIPT:AddService('MapGenValidator', MapGenValidator:new())
return MapGenValidator
