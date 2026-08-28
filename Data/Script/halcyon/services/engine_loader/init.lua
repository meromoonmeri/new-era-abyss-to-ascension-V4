--[[ engine_loader — NewEra.Engine : compile (Roslyn in-process, cache par
     hash) et charge dev/engine/src/NewEraEngine.cs en assembly
     'NewEra.Engine' AU BOOT (EngineServiceEvents.Init), AVANT toute
     désérialisation de zone. Les JSON peuvent alors référencer
     $type NewEra.LevelGen.X (assembly NewEra.Engine).
     Toujours actif (pas opt-in) : les zones qui utilisent ces types en
     dépendent. Échec de compilation = log fort, jamais silencieux. ]]
require 'origin.common'
require 'origin.services.baseservice'

local S = Class('NewEraEngineLoader', BaseService)

function S:initialize()
  BaseService.initialize(self)
end

local function repo_root()
  -- PathMod.Quest.Path est RELATIF à APP_PATH (le dossier -appdata).
  -- MODS/New-Era y est un symlink vers la racine du repo.
  local Path = luanet.import_type('System.IO.Path')
  local PathMod = luanet.import_type('RogueEssence.PathMod')
  local quest = tostring(PathMod.Quest.Path)
  local app = tostring(PathMod.APP_PATH)
  if quest ~= nil and quest ~= '' then
    return Path.GetFullPath(Path.Combine(app, quest))
  end
  return Path.GetFullPath(app)
end

function S:LoadEngine()
  local ok, err = xpcall(function()
    local File = luanet.import_type('System.IO.File')
    local Directory = luanet.import_type('System.IO.Directory')
    local Path = luanet.import_type('System.IO.Path')
    local root = repo_root()
    local srcPath = Path.Combine(root, 'dev/engine/src/NewEraEngine.cs')
    if not File.Exists(srcPath) then
      PrintInfo('[NewEraEngine] source absente: ' .. tostring(srcPath) .. ' (skip)')
      return
    end
    local src = File.ReadAllText(srcPath)
    -- hash du source -> cache
    local SHA256 = luanet.import_type('System.Security.Cryptography.SHA256')
    local Encoding = luanet.import_type('System.Text.Encoding')
    local Convert = luanet.import_type('System.Convert')
    local sha = SHA256.Create()
    local hash = Convert.ToHexString(sha:ComputeHash(Encoding.UTF8:GetBytes(src))):sub(1, 16)
    local cacheDir = Path.Combine(root, '.runtime-cache/enginelab')
    Directory.CreateDirectory(cacheDir)
    local dllPath = Path.Combine(cacheDir, 'NewEra.Engine.' .. hash .. '.dll')
    if not File.Exists(dllPath) then
      PrintInfo('[NewEraEngine] compilation ' .. hash .. '...')
      luanet.load_assembly('Microsoft.CodeAnalysis')
      luanet.load_assembly('Microsoft.CodeAnalysis.CSharp')
      local CSharpSyntaxTree = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree')
      local CSharpCompilation = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilation')
      local CSharpCompilationOptions = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions')
      local OutputKind = luanet.import_type('Microsoft.CodeAnalysis.OutputKind')
      local MetadataReference = luanet.import_type('Microsoft.CodeAnalysis.MetadataReference')
      local AppDomain = luanet.import_type('System.AppDomain')
      local tree = CSharpSyntaxTree.ParseText(src)
      local opts = CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary)
      local comp = CSharpCompilation.Create('NewEra.Engine', nil, nil, opts)
      comp = comp:AddSyntaxTrees(tree)
      local asms = AppDomain.CurrentDomain:GetAssemblies()
      for i = 0, asms.Length - 1 do
        local a = asms[i]
        local okl, loc = pcall(function() return a.Location end)
        if okl and loc ~= nil and loc ~= '' then
          comp = comp:AddReferences(MetadataReference.CreateFromFile(loc))
        end
      end
      local FileStream = luanet.import_type('System.IO.FileStream')
      local FileMode = luanet.import_type('System.IO.FileMode')
      local tmpPath = dllPath .. '.tmp'
      local fs = FileStream(tmpPath, FileMode.Create)
      local result = comp:Emit(fs)
      fs:Dispose()
      if not result.Success then
        local ds = result.Diagnostics
        local msg = ''
        local shown = 0
        for i = 0, ds.Length - 1 do
          local d = ds[i]
          local sev = tostring(d.Severity)
          if sev == 'Error' or sev == '3' then
            if shown < 12 then msg = msg .. tostring(d) .. '\n' end
            shown = shown + 1
          end
        end
        if msg == '' then
          for i = 0, math.min(ds.Length - 1, 11) do msg = msg .. tostring(ds[i]) .. '\n' end
        end
        File.Delete(tmpPath)
        error('[NewEraEngine] COMPILE FAIL (' .. tostring(shown) .. ' erreurs):\n' .. msg)
      end
      File.Move(tmpPath, dllPath)
      PrintInfo('[NewEraEngine] compilé -> ' .. dllPath)
    end
    local Assembly = luanet.import_type('System.Reflection.Assembly')
    local asm = Assembly.LoadFrom(dllPath)
    local probe = asm:GetType('NewEra.LevelGen.EngineProbe')
    local ver = probe:GetMethod('Version'):Invoke(nil, nil)
    PrintInfo('[NewEraEngine] chargé: ' .. tostring(ver) .. ' (' .. hash .. ')')
    _G.NEWERA_ENGINE_LOADED = tostring(ver)
  end, debug.traceback)
  if not ok then
    PrintError('[NewEraEngine] ÉCHEC: ' .. tostring(err))
  end
end

function S:Subscribe(med)
  med:Subscribe('NewEraEngineLoader', EngineServiceEvents.Init,
    function() self:LoadEngine() end)
end

function S:UnSubscribe(med) end

SCRIPT:AddService("NewEraEngineLoader", S:new())
return S
