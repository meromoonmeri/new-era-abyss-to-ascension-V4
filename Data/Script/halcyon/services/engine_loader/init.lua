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

    -- ---- TESTRUNNER in-process (équivalent `dotnet test` sans SDK) ----
    -- PMDO_NRETEST=1 : compile dev/engine/tests/*.cs AVEC référence à
    -- NewEra.Engine, exécute NewEra.Tests.Suite.Run(), écrit le JSONL,
    -- puis quitte le processus (tests rapides, pas de boot complet).
    if os.getenv('PMDO_NRETEST') == '1' then
      local testsDir = Path.Combine(root, 'dev/engine/tests')
      if Directory.Exists(testsDir) then
        PrintInfo('[NRETEST] compilation des tests...')
        luanet.load_assembly('Microsoft.CodeAnalysis')
        luanet.load_assembly('Microsoft.CodeAnalysis.CSharp')
        local CSharpSyntaxTree = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree')
        local CSharpCompilation = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilation')
        local CSharpCompilationOptions = luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions')
        local OutputKind = luanet.import_type('Microsoft.CodeAnalysis.OutputKind')
        local MetadataReference = luanet.import_type('Microsoft.CodeAnalysis.MetadataReference')
        local AppDomain = luanet.import_type('System.AppDomain')
        local comp = CSharpCompilation.Create('NewEra.Tests', nil, nil,
          CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary))
        local files = Directory.GetFiles(testsDir, '*.cs')
        for i = 0, files.Length - 1 do
          comp = comp:AddSyntaxTrees(CSharpSyntaxTree.ParseText(File.ReadAllText(files[i])))
        end
        local asms2 = AppDomain.CurrentDomain:GetAssemblies()
        for i = 0, asms2.Length - 1 do
          local okl2, loc2 = pcall(function() return asms2[i].Location end)
          if okl2 and loc2 ~= nil and loc2 ~= '' then
            comp = comp:AddReferences(MetadataReference.CreateFromFile(loc2))
          end
        end
        comp = comp:AddReferences(MetadataReference.CreateFromFile(dllPath))
        local FileStream2 = luanet.import_type('System.IO.FileStream')
        local FileMode2 = luanet.import_type('System.IO.FileMode')
        local testDll = Path.Combine(cacheDir, 'NewEra.Tests.dll')
        if File.Exists(testDll) then File.Delete(testDll) end
        local fs2 = FileStream2(testDll, FileMode2.Create)
        local res2 = comp:Emit(fs2)
        fs2:Dispose()
        if not res2.Success then
          local msg2 = ''
          local ds2 = res2.Diagnostics
          local shown2 = 0
          for i = 0, ds2.Length - 1 do
            local sv = tostring(ds2[i].Severity)
            if sv == 'Error' or sv == '3' then
              if shown2 < 15 then msg2 = msg2 .. tostring(ds2[i]) .. '\n' end
              shown2 = shown2 + 1
            end
          end
          if msg2 == '' then
            for i = 0, math.min(ds2.Length - 1, 14) do msg2 = msg2 .. tostring(ds2[i]) .. '\n' end
          end
          File.WriteAllText('/tmp/nretest.jsonl',
            '{"test":"COMPILE","verdict":"FAIL","detail":"' .. msg2:gsub('"', "'"):gsub('\n', ' | ') .. '"}')
          PrintError('[NRETEST] COMPILE FAIL:\n' .. msg2)
        else
          local tasm = Assembly.LoadFrom(testDll)
          local suite = tasm:GetType('NewEra.Tests.Suite')
          local outp = suite:GetMethod('Run'):Invoke(nil, nil)
          File.WriteAllText('/tmp/nretest.jsonl', tostring(outp))
          PrintInfo('[NRETEST] terminé:\n' .. tostring(outp))
        end
        local Environment = luanet.import_type('System.Environment')
        Environment.Exit(0)
      end
    end
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
