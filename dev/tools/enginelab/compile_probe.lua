-- Probe : compiler une assembly C# IN-PROCESS via Roslyn embarqué (bundle PMDO).
-- Usage : appelé par le validateur (mode enginelab) au démarrage.
local M={}
function M.run(outdir)
  local ok,err=xpcall(function()
    luanet.load_assembly('Microsoft.CodeAnalysis')
    luanet.load_assembly('Microsoft.CodeAnalysis.CSharp')
    luanet.load_assembly('System.Runtime')
    local CSharpSyntaxTree=luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree')
    local CSharpCompilation=luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilation')
    local CSharpCompilationOptions=luanet.import_type('Microsoft.CodeAnalysis.CSharp.CSharpCompilationOptions')
    local OutputKind=luanet.import_type('Microsoft.CodeAnalysis.OutputKind')
    local MetadataReference=luanet.import_type('Microsoft.CodeAnalysis.MetadataReference')
    local AppDomain=luanet.import_type('System.AppDomain')
    local File=luanet.import_type('System.IO.File')
    local src=File.ReadAllText(outdir..'/NewEraGen.cs')
    local tree=CSharpSyntaxTree.ParseText(src)
    local opts=CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary)
    local comp=CSharpCompilation.Create('NewEraGen',nil,nil,opts)
    comp=comp:AddSyntaxTrees(tree)
    -- références = toutes les assemblies déjà chargées dans le process
    local asms=AppDomain.CurrentDomain:GetAssemblies()
    local nrefs=0
    for i=0,asms.Length-1 do
      local a=asms[i]
      local okl,loc=pcall(function() return a.Location end)
      if okl and loc~=nil and loc~='' then
        comp=comp:AddReferences(MetadataReference.CreateFromFile(loc))
        nrefs=nrefs+1
      end
    end
    local FileStream=luanet.import_type('System.IO.FileStream')
    local FileMode=luanet.import_type('System.IO.FileMode')
    local fs=FileStream(outdir..'/NewEraGen.dll',FileMode.Create)
    local result=comp:Emit(fs)
    fs:Dispose()
    local diag=''
    if not result.Success then
      local ds=result.Diagnostics
      for i=0,math.min(ds.Length-1,9) do diag=diag..tostring(ds[i])..' | ' end
    end
    local f=io.open(outdir..'/compile_result.txt','w')
    f:write('success='..tostring(result.Success)..' refs='..nrefs..'\n'..diag)
    f:close()
  end,debug.traceback)
  if not ok then
    local f=io.open(outdir..'/compile_result.txt','w')
    f:write('LUA_ERROR: '..tostring(err))
    f:close()
  end
end
return M
