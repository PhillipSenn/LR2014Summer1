<cfscript>
local.arr = local.svc.getParams()
if (IsDefined('local.lfw.DataSource')) {
	local.svc.setDataSource(local.lfw.DataSource)
}
local.svc.setSQL(local.sql)
if (local.lfw.try.catch) {
	try {
		local.obj = local.svc.execute()
		local.result.qry = local.obj.getResult()
		local.result.Prefix = local.obj.getPrefix()
	} catch(any Exception) {
		request.rfw.msg = 'An Exception.Error has occured'
		request.rfw.modifier = local.lfw.try.class
		request.rfw.Detail = Exception.Detail
		if (local.lfw.try.email != '') {
			local.svc = new mail()
			local.svc.setSubject(Application.afw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
			local.svc.setBody('Database Error: #request.rfw.msg#<p>#request.rfw.Detail#</p>')
			
			local.port=465
			local.server='smtp.gmail.com'
			local.type='html'
			local.UserName='PhillipSenn@gmail.com'
			local.useSSL=true
		
			local.svc.setPort(local.Port)
			local.svc.setServer(local.Server)
			local.svc.setType(local.Type)
			local.svc.setUserName(local.UserName)
			local.svc.setUseSSL(local.UseSSL)
			local.UserName = 'admin@NeighborHopeMinistries.com'
			local.svc.setFrom(local.UserName)


			var Password = ''
			include '/Inc/Passwords/Email.cfm'
			local.svc.setPassword(Password)


			local.svc.setTo(local.lfw.try.email)
			// local.svc.Send()
		}
		if (local.lfw.log.dbErr) { // If we are logging database errors
			session.sfw.log.DBErrCounter += 1 // See onRequestStart
			local.result.Exception = Exception
			if (IsDefined('request.rfw.LogCFID')) {
				local.LogCFID = request.rfw.LogCFID
			} else {
				local.LogCFID = 0 // Trying to track down a bug. new com.LogCF().Save()
			}
			local.lfw.MetaData = GetMetaData()
			new com.LogDBErr().Save(local)
		}
	} finally {
	}
} else {
	local.obj = local.svc.execute()
	local.result.qry = local.obj.getResult()
	local.result.Prefix = local.obj.getPrefix()
}
if (local.lfw.log.db) { // If we are logging this database call. This gives me the chance to turn it off at the local scope.
	if (IsDefined('local.result.Prefix')) {
		local.lfw.MetaData = GetMetaData()
		new com.LogDB().Save(local)
	}
}
</cfscript>
