component extends='ReadWhereDelete' {
Variables.fw.TableName = 'LogDBErr'
Variables.fw.TableSort = 'LogDBErrDateTime DESC, LogDBErrID DESC'
Variables.fw.DataSource = 'fw'

function Save(arg) { // arg was the local scope when passed.  So arg.result was local.result.
	request.rfw.log.Sort += 1

	local.result.Prefix = {}
	if (StructKeyExists(arg.result.Exception,"sql")) {
		local.result.Prefix.sql = arg.result.Exception.sql
	}
	local.result.Prefix.RecordCount = 0
	local.result.Prefix.ExecutionTime = 0
	local.lfw = Duplicate(arg.lfw)
	local.LogDBID = new com.LogDB().Save(local)

	// ErrorCode and SQLState are Integers
	if (StructKeyExists(arg.result.Exception,"NativeErrorCode")) {
		local.LogDBErrCode = arg.result.Exception.NativeErrorCode
	} else {
		local.LogDBErrCode = 0
	}
	if (StructKeyExists(arg.result.Exception,"SQLState")) {
		local.LogDBErrSQLState = arg.result.Exception.SQLState
	} else {
		local.LogDBErrSQLState = 0
	}

	// Type, Name, Desc are varchar
	if (StructKeyExists(arg.result.Exception,"Type")) {
		local.LogDBErrType = arg.result.Exception.Type
	} else {
		local.LogDBErrType = "arg.result.Exception.Type"
	}
	if (StructKeyExists(arg.result.Exception,"Message")) {
		local.LogDBErrName = arg.result.Exception.Message
	} else {
		local.LogDBErrName = "arg.result.Exception.Message"
	}
	if (StructKeyExists(arg.result.Exception,"Detail")) {
		local.LogDBErrDesc = arg.result.Exception.Detail
	} else {
		local.LogDBErrDesc = "arg.result.Exception.Detail"
	}

	if (StructKeyExists(arg.result.Exception,"queryError")) {
		local.LogDBErrQuery = arg.result.Exception.QueryError
		if (local.LogDBErrQuery != local.LogDBErrDesc) {
			local.LogDBErrDesc &= '<br>' & local.LogDBErrQuery
		}
	}
//	if (StructKeyExists(arg.result.Exception,"where")) {
//		local.LogDBErrWhere = arg.result.Exception.where
//	} else {
//		local.LogDBErrWhere = "arg.result.Exception.where"
//	}
	local.sql = "
	DECLARE @DomainID Int = #Val(Application.afw.DomainID)#
	DECLARE @LogDBErrID BigInt = NEXT VALUE FOR LogDBErrID
	DECLARE @LogDBID BigInt = #Val(local.LogDBID)#
	DECLARE @LogDBErrSort Int = #Val(request.rfw.log.Sort)#
	DECLARE @LogDBErrElapsed Int = #GetTickCount() - request.rfw.TickCount#
	DECLARE @LogDBErrCode Int = #Val(local.LogDBErrCode)#
	DECLARE @LogDBErrSQLState Int = #Val(local.LogDBErrSQLState)#
	UPDATE LogDBErr SET
	 LogDBErr_DomainID = @DomainID
	,LogDBErr_DBID=@LogDBID
	,LogDBErrSort=@LogDBErrSort
	,LogDBErrElapsed=@LogDBErrElapsed
	,LogDBErrCode=@LogDBErrCode
	,LogDBErrSQLState=@LogDBErrSQLState
	,LogDBErrDateTime = getdate()
	,LogDBErrType=?
	,LogDBErrName=?
	,LogDBErrDesc=?
	WHERE LogDBErrID=@LogDBErrID
	"
	include '/Inc/newQuery.cfm'
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrType)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrName)
	local.svc.addParam(cfsqltype="cf_sql_varchar",value=local.LogDBErrDesc)
	local.lfw.log.db = false
	include '/Inc/execute.cfm'

	if (arg.lfw.try.abort) {
		WriteOutput('<html>' & Chr(10))
		WriteOutput('<head>' & Chr(10))
		WriteOutput('<link rel="stylesheet" href="/Inc/css/fw.css">' & Chr(10))
		WriteOutput('</head>' & Chr(10))
		WriteOutput('<body>' & Chr(10))
		WriteOutput('<nav class="navbar-default navbar-fixed-top">' & Chr(10))
		WriteOutput('	<div class="navbar-inverse">' & Chr(10))
		WriteOutput('		<div class="container">' & Chr(10))
		WriteOutput('			<div class="navbar-header">' & Chr(10))
		WriteOutput('				<a class="navbar-brand" href="//lr.edu">LR.edu</a>' & Chr(10))
		WriteOutput('			</div>' & Chr(10))
		WriteOutput('		</div>' & Chr(10))
		WriteOutput('	</div>' & Chr(10))
		WriteOutput('	<div class="msg container label-danger">' & arg.result.Exception.Detail & Chr(10))
		WriteOutput('	</div>' & Chr(10))
		WriteOutput('</nav>' & Chr(10))
		WriteOutput('<section id="main" class="container">' & Chr(10))
		if (arg.lfw.try.email != '') {
			local.svc = new mail()
			local.svc.setSubject(Application.afw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
			local.emailBody  = ''
			if (StructKeyExists(arg.result.Exception,"Datasource")) {
				local.emailBody &= 'Datasource: ' & arg.result.Exception.datasource & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Detail")) {
				local.emailBody &= 'Detail: ' & arg.result.Exception.Detail & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Detail")) {
				local.emailBody &= 'ErrorCode: ' & arg.result.Exception.ErrorCode & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"Message")) {
				local.emailBody &= 'Message: ' & arg.result.Exception.message & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"NativeErrorCode")) {
				local.emailBody &= 'NativeErrorCode: ' & arg.result.Exception.NativeErrorCode & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"SQLState")) {
				local.emailBody &= 'SQLState: ' & arg.result.Exception.SQLState & '<br>'
			}
			// local.emailBody &= 'StackTrace: ' & arg.result.Exception.StackTrace & '<br>'
			if (StructKeyExists(arg.result.Exception,"Type")) {
				local.emailBody &= 'Type: ' & arg.result.Exception.Type & '<br>'
			}
			if (StructKeyExists(arg.result.Exception,"QueryError")) {
				local.emailBody &= 'QueryError: ' & arg.result.Exception.QueryError & '<br>'
			}
			/*
			if (StructKeyExists(arg.result.Exception,"Where") && arg.result.Exception != '') {
				local.emailBody &= 'Where: ' & arg.result.Exception.Where & '<br>'
			}
			*/
			local.emailBody &= '<p>'
			local.emailBody &= 'Application: ' & Application.afw.Name & '<br>'
			local.emailBody &= 'SCRIPT_NAME: ' & cgi.SCRIPT_NAME & '<br>'
			local.emailBody &= 'CurrentTmpl: ' & GetCurrentTemplatePath() & '<br>'
			local.emailBody &= '</p>'
			if (StructKeyExists(arg.result.Exception,"sql")) {
				local.emailBody &= '<pre>' & arg.result.Exception.sql & '</pre>'
			} else {
				local.emailBody &= '<pre>arg.result.Exception.sql is empty.</pre>'
			}
			local.svc.setBody(local.emailBody)

			local.port=465
			local.server='smtp.gmail.com'
			local.type='html'
			local.useSSL=true
			local.svc.setServer(local.Server)
			local.svc.setType(local.Type)
			local.svc.setUseSSL(local.UseSSL)
			local.svc.setPort(local.Port)

			var UserName='PhillipSenn@gmail.com'
			var Password = ''
			include "/Inc/Passwords/Email.cfm"
			local.svc.setFrom(UserName)
			local.svc.setTo('Administrator<#UserName#>')
			local.svc.setUserName(UserName)
			local.svc.setPassword(Password)
			local.svc.Send()
			WriteOutput("<p>I've sent an email to the administrator to let them know.</p>" & Chr(10))
		}
		WriteOutput('</div>' & Chr(10))
		WriteOutput('<script src="//code.jquery.com/jquery-2.1.1.js"></script>' & Chr(10))
		WriteOutput('<script src="/Inc/js/fw.js"></script>' & Chr(10))
		WriteOutput('<script src="//cdn.PhillipSenn.com/bootstrap-3.1.1-dist/js/bootstrap.js"></script>' & Chr(10))
		WriteOutput('</body>' & Chr(10))
		WriteOutput('</html>')
		abort;
	} else {
		request.rfw.msg = arg.result.Exception.Detail
		request.rfw.modifier = arg.fw.try.class
	}
}
}