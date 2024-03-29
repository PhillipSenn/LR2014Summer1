component {
Variables.fw.DataSource = 'fw'

function Save(arg) {
	include '/Inc/newQuery.cfm'
	request.fw.log.Sort += 1; // I use the same counter for LogDB, LogDBErr, LogCF, LogCFErr, LogCFC
	// local.LogCFCName = ReplaceNoCase(arg.LogCFCName,Application.fw.Path,'');
	if (IsDefined("request.fw.LogCFID")) {
		local.LogCFID = request.fw.LogCFID;
	} else {
		local.LogCFID = 0; // todo: Shouldn't I create a LogCFID if it doesn't exist?  Maybe this scenario never occurs.
	}

	local.sql = "
	DECLARE @LogCFCID BigInt = NEXT VALUE FOR LogCFCID
	DECLARE @DomainID Int = #Val(Application.fw.DomainID)#
	DECLARE @LogDBSort Int = #Val(request.fw.log.Sort)#;
	DECLARE @LogCFCElapsed Int = #GetTickCount() - request.fw.TickCount#;
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
	local.fw.log.db = false
	include '/Inc/execute.cfm'
}
}
