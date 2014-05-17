component {
Variables.fw.DataSource = 'fw'

remote function Save() {
	include '/Inc/newQuery.cfm'
	local.LogUIName = ReplaceNoCase(cgi.HTTP_REFERER,'http://summer.lenoir-rhyne.com','')
	if (FindNoCase(Application.afw.Path,local.LogUIName) == 1) {
		local.LogUIName = Mid(local.LogUIName,Len(Application.afw.Path),128)
	}
	local.LogUIName = Replace(local.LogUIName,'=','= ','all')
	
	if (Len(arguments.LogUIClass)) {
		local.LogUIClass = '.' & Replace(arguments.LogUIClass,' ','.','all')
	} else {
		local.LogUIClass = ''
	}
	if (IsDefined('session.sfw.TickCount')) {
		local.TickCount = session.sfw.TickCount
	} else {
		local.TickCount = GetTickCount()
	}
	if (isDefined('session.sfw.LogCFID')) {
		local.LogCFID = session.sfw.LogCFID
	} else {
		local.LogCFID = 0
	}
	local.sql = "
	DECLARE @LogUIID BigInt = NEXT VALUE FOR LogUIID
	DECLARE @LogCFID BigInt = #Val(local.LogCFID)#
	DECLARE @LogJSSort Int = #Val(arguments.LogJSSort)#
	DECLARE @LogUIElapsed Int = #GetTickCount() - local.TickCount#
	UPDATE LogUI SET
	 LogUI_CFID = @LogCFID
	,LogUISort=@LogJSSort
	,LogUIElapsed=@LogUIElapsed
	,LogUIDateTime = getdate()
	,LogUIName=?
	,LogUITag=?
	,LogUITagName=?
	,LogUIIdentifier=?
	,LogUIClass=?
	,LogUIDestination=?
	,LogUIValue=?
	WHERE LogUIID = @LogUIID
	"
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogUIName)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUITag,MaxLength=6) // anchor, button, check
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUITagName)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIIdentifier)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=local.LogUIClass)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIDestination)
	local.svc.addParam(cfsqltype='cf_sql_varchar',value=arguments.LogUIValue)
	local.lfw.log.db = false
	include '/Inc/execute.cfm'
	// Don't forget to put local.dataType = 'text' in the JavaScript!
}
}