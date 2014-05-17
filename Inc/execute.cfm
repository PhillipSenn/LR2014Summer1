<cfscript>
local.arr = local.svc.getParams()
if (IsDefined('local.fw.DataSource')) {
	local.svc.setDataSource(local.fw.DataSource)
}
local.svc.setSQL(local.sql)
if (local.fw.try.catch) {
	try {
		local.obj = local.svc.execute()
		local.result.qry = local.obj.getResult()
		local.result.Prefix = local.obj.getPrefix()
	} catch(any Exception) {
		request.fw.msg = 'An Exception.Error has occured'
		request.fw.modifier = local.fw.try.class
		request.fw.Detail = Exception.Detail
		if (local.fw.try.email != '') {
			local.svc = new mail()
			local.svc.setSubject(Application.fw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
			local.svc.setBody('Database Error: #request.fw.msg#<p>#request.fw.Detail#</p>')
			
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


			local.svc.setTo(local.fw.try.email)
			// local.svc.Send()
		}
		if (local.fw.log.dbErr) { // If we are logging database errors
			session.fw.log.DBErrCounter += 1 // See onRequestStart
			local.result.Exception = Exception
			if (IsDefined('request.fw.LogCFID')) {
				local.LogCFID = request.fw.LogCFID
			} else {
				local.LogCFID = 0 // Trying to track down a bug. new com.LogCF().Save()
			}
			local.fw.MetaData = GetMetaData()
			new com.LogDBErr().Save(local)
		}
	} finally {
	}
} else {
	local.obj = local.svc.execute()
	local.result.qry = local.obj.getResult()
	local.result.Prefix = local.obj.getPrefix()
}
if (local.fw.log.db) { // If we are logging this database call. This gives me the chance to turn it off at the local scope.
	if (IsDefined('local.result.Prefix')) {
		local.fw.MetaData = GetMetaData()
		new com.LogDB().Save(local)
	}
}
</cfscript>
