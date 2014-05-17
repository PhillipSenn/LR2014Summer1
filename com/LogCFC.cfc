component {
Variables.fw.DataSource = 'fw'

function Save(arg) {
	include '/Inc/newQuery.cfm'
	request.rfw.log.Sort += 1; // I use the same counter for LogDB, LogDBErr, LogCF, LogCFErr, LogCFC
	// local.LogCFCName = ReplaceNoCase(arg.LogCFCName,Application.afw.Path,'');
	if (IsDefined("request.rfw.LogCFID")) {
		local.LogCFID = request.rfw.LogCFID;
	} else {
		local.LogCFID = 0; // todo: Shouldn't I create a LogCFID if it doesn't exist?  Maybe this scenario never occurs.
	}

	local.sql = "
	DECLARE @LogCFCID BigInt = NEXT VALUE FOR LogCFCID
	DECLARE @DomainID Int = #Val(Application.afw.DomainID)#
	DECLARE @LogDBSort Int = #Val(request.rfw.log.Sort)#;
	DECLARE @LogCFCElapsed Int = #GetTickCount() - request.rfw.TickCount#;
	DECLARE @LogCFID BigInt = #Val(local.LogCFID)#;
	
	UPDATE LogCFC SET
	 LogCFC_DomainID  = @DomainID
	,LogCFC_CFID	= @LogCFID
	,LogCFCSort			= @LogDBSort
	,LogCFCElapsed		= @LogCFCElapsed
	,LogCFCDateTime	= getdate()
	,LogCFCName 		= ?
	,LogCFCDesc 		= ?
	WHERE LogCFCID 	= @LogCFCID;
	";
	local.svc = new query();
	local.svc.setSQL(local.sql);
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=arg.LogCFCName);
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=arg.LogCFCDesc);
	local.lfw.log.db = false
	include '/Inc/execute.cfm'
}
}
