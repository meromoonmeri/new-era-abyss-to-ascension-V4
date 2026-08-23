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
  -- analyse de traversabilité active par défaut ; PMDO_MAPGEN_TRAVERSAL=0 la coupe
  self.traversal = (os.getenv('PMDO_MAPGEN_TRAVERSAL') ~= '0')
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
-- Analyse de traversabilité, sur la carte RÉELLEMENT générée.
--
-- On n'estime rien : on interroge le moteur (`Map:TileBlocked`) pour
-- chaque case, on repart du point d'entrée (`Map.EntryPoints[0]`) et on
-- vérifie que les escaliers posés sur la carte sont atteignables.
--------------------------------------------------------------------
local Loc = nil
local STAIR_IDS = { stairs_go_up = true, stairs_go_down = true }

local function analyse(map)
  if Loc == nil then
    luanet.load_assembly('RogueElements')
    Loc = luanet.import_type('RogueElements.Loc')
  end
  local w, h = map.Width, map.Height
  local blocked = {}
  local walkable = 0
  for x = 0, w - 1 do
    blocked[x] = {}
    for y = 0, h - 1 do
      local b = map:TileBlocked(Loc(x, y))
      blocked[x][y] = b
      if not b then walkable = walkable + 1 end
    end
  end

  local stairs = {}
  for x = 0, w - 1 do
    for y = 0, h - 1 do
      local tile = map.Tiles[x][y]
      local eff = tile.Effect
      if eff ~= nil and eff.ID ~= nil and STAIR_IDS[tostring(eff.ID)] then
        stairs[#stairs + 1] = { x = x, y = y }
      end
    end
  end

  local entry = nil
  if map.EntryPoints ~= nil and map.EntryPoints.Count > 0 then
    local pt = map.EntryPoints[0].Loc
    entry = { x = pt.X, y = pt.Y }
  end
  if entry == nil then
    return { walkable = walkable, stairs = #stairs, reached = -1,
             entry_ok = false, stairs_reachable = false }
  end
  local entry_ok = (entry.x >= 0 and entry.y >= 0 and entry.x < w and entry.y < h
                    and not blocked[entry.x][entry.y])

  -- parcours en largeur, 8 directions ; une diagonale n'est franchissable
  -- que si les deux orthogonales adjacentes le sont (règle du moteur).
  local seen = {}
  for x = 0, w - 1 do seen[x] = {} end
  local queue = { entry }
  seen[entry.x][entry.y] = true
  local reached = 1
  local head = 1
  local DIRS = { {1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1} }
  while head <= #queue do
    local cur = queue[head]; head = head + 1
    for _, d in ipairs(DIRS) do
      local nx, ny = cur.x + d[1], cur.y + d[2]
      if nx >= 0 and ny >= 0 and nx < w and ny < h and not seen[nx][ny]
         and not blocked[nx][ny] then
        local ok = true
        if d[1] ~= 0 and d[2] ~= 0 then
          ok = (not blocked[cur.x + d[1]][cur.y]) and (not blocked[cur.x][cur.y + d[2]])
        end
        if ok then
          seen[nx][ny] = true
          reached = reached + 1
          queue[#queue + 1] = { x = nx, y = ny }
        end
      end
    end
  end

  local reachable_stairs = 0
  for _, st in ipairs(stairs) do
    if seen[st.x][st.y] then reachable_stairs = reachable_stairs + 1 end
  end

  return {
    walkable = walkable, reached = reached, stairs = #stairs,
    reachable_stairs = reachable_stairs, entry_ok = entry_ok,
    stairs_reachable = (#stairs > 0 and reachable_stairs == #stairs),
  }
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

  local total, failures, floors, unreachable = 0, 0, 0, 0
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
              local trav, terr = nil, ''
              if self.traversal then
                local okt, res = pcall(function() return analyse(result.Map) end)
                if okt then trav = res else terr = tostring(res) end
              end
              if trav ~= nil then
                if not (trav.entry_ok and trav.stairs_reachable) then
                  unreachable = unreachable + 1
                end
                emit(string.format(
                  '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"status":"OK",'
                  .. '"width":%d,"height":%d,"rooms":%d,"ms":%d,"walkable":%d,"reached":%d,'
                  .. '"stairs":%d,"stairs_reachable":%d,"entry_ok":%s,"traversable":%s,"seed":"%s"}',
                  esc(zoneId), seg, floorId, iter, w, h, rooms, ms,
                  trav.walkable, trav.reached, trav.stairs, trav.reachable_stairs,
                  tostring(trav.entry_ok), tostring(trav.entry_ok and trav.stairs_reachable),
                  tostring(ctx.Seed)))
              else
                emit(string.format(
                  '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"status":"OK",'
                  .. '"width":%d,"height":%d,"rooms":%d,"ms":%d,"traversal_error":"%s","seed":"%s"}',
                  esc(zoneId), seg, floorId, iter, w, h, rooms, ms, esc(terr), tostring(ctx.Seed)))
              end
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

  emit(string.format('{"event":"end","attempted":%d,"generated":%d,"failures":%d,'
                     .. '"non_traversable":%d}', total, floors, failures, unreachable))
end


--------------------------------------------------------------------
-- Contrôle moteur des Grounds de scène.
--
-- Le moteur charge et désérialise réellement chaque Ground cité par le
-- câblage (entrée, relais, scène finale), puis on vérifie que le marqueur
-- d'entrée utilisé par les scripts existe bien sur la carte. Un Ground
-- illisible ou sans marqueur = téléportation ratée en jeu.
--------------------------------------------------------------------
function MapGenValidator:check_grounds(entries)
  local checked, failed = 0, 0
  for _, entry in ipairs(entries) do
    -- entrée = "zone|ground|marqueur" ; marqueur vide = entrée par index
    local zoneId, name, marker = string.match(entry, '([^|]*)|([^|]*)|([^|]*)')
    checked = checked + 1
    local ok, res = pcall(function()
      local ground = _DATA:GetGround(name)
      if ground == nil then error('GetGround a renvoyé nil') end
      local markers = {}
      local count = 0
      for ii = 0, ground.Entities.Count - 1 do
        local layer = ground.Entities[ii]
        for jj = 0, layer.Markers.Count - 1 do
          markers[tostring(layer.Markers[jj].EntName)] = true
          count = count + 1
        end
      end
      -- le Ground doit être déclaré par la zone, sinon MoveToGround refuse
      local declared = false
      local zdata = _DATA:GetZone(zoneId)
      if zdata ~= nil then
        for ii = 0, zdata.GroundMaps.Count - 1 do
          if zdata.GroundMaps[ii] == name then declared = true end
        end
      end
      local entry_ok
      if marker ~= '' then entry_ok = (markers[marker] == true)
      else entry_ok = true end   -- entrée par index : GetEntryPoint(int) ne lève pas
      return { w = ground.Width, h = ground.Height, count = count,
               declared = declared, entry_ok = entry_ok,
               mode = (marker ~= '' and 'marker' or 'index') }
    end)
    if ok then
      local problem = (not res.entry_ok) or (not res.declared)
      if problem then failed = failed + 1 end
      emit(string.format('{"event":"ground","zone":"%s","ground":"%s","status":"%s",'
        .. '"width":%d,"height":%d,"markers":%d,"entry_mode":"%s","entry":"%s",'
        .. '"entry_ok":%s,"declared_in_zone":%s}',
        esc(zoneId), esc(name), problem and 'PROBLEM' or 'OK', res.w, res.h, res.count,
        res.mode, esc(marker), tostring(res.entry_ok), tostring(res.declared)))
    else
      failed = failed + 1
      local etype, emsg = 'unknown', tostring(res)
      pcall(function()
        local inner = res.InnerException or res
        etype = inner:GetType():ToString(); emsg = inner.Message
      end)
      emit(string.format('{"event":"ground","zone":"%s","ground":"%s","status":"FAIL",'
        .. '"type":"%s","message":"%s"}', esc(zoneId), esc(name), esc(etype), esc(emsg)))
    end
  end
  emit(string.format('{"event":"grounds_end","checked":%d,"problems":%d}', checked, failed))
end

function MapGenValidator:OnInit()
  if not self.enabled then return end
  local ok, err = pcall(function() self:run() end)
  if not ok then emit(string.format('{"event":"fatal","error":"%s"}', esc(err))) end
  local grounds = os.getenv('PMDO_GROUND_CHECK')
  if grounds ~= nil and grounds ~= '' then
    local list = {}
    for id in string.gmatch(grounds, '[^,%s]+') do list[#list + 1] = id end
    local okg, errg = pcall(function() self:check_grounds(list) end)
    if not okg then emit(string.format('{"event":"fatal","error":"%s"}', esc(errg))) end
  end
end

function MapGenValidator:Subscribe(med)
  med:Subscribe('MapGenValidator', EngineServiceEvents.Init, function() self.OnInit(self) end)
end

function MapGenValidator:UnSubscribe(med)
  med:UnsubscribeAll('MapGenValidator')
end

SCRIPT:AddService('MapGenValidator', MapGenValidator:new())
return MapGenValidator
