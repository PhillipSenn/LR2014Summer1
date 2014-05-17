<cfscript>
local.result = {}
local.result.msg = ''
local.svc = new query()
local.lfw = Duplicate(request.rfw)
if (IsDefined('Variables.fw.DataSource')) {
	local.lfw.DataSource = Variables.fw.DataSource
}
local.lfw.FunctionCalledName = GetFunctionCalledName() & '()'
</cfscript>