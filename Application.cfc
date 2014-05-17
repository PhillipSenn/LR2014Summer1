component {
this.Name = "Summer0516"
this.DataSource = "LR2014Summer1"
this.SessionManagement = true
this.ScriptProtect = "all"

function onApplicationStart() {
	Application.afw = {}
	Application.afw.name='Lenoir-Rhyne University'
	Application.afw.Path = '/'
	Application.afw.msg = ''
	Application.afw.modifier = 'label-info'

	Application.afw.log = {}
	Application.afw.log.CF  = true
	Application.afw.log.CFC = true
	Application.afw.log.CFErr = true
	Application.afw.log.DB = true 		// INSERT INTO LogDB
	Application.afw.log.DBErr = true 	// INSERT INTO LogDBErr
	Application.afw.log.JS  = true
	Application.afw.log.UI  = true
	Application.afw.log.CFErrCounter = 0
	Application.afw.log.DBErrCounter = 0
	Application.afw.log.MaxDB = 0		// Every session defaults to logging a maximum of n sequences

	Application.afw.try = {}
	Application.afw.try.catch = true
	Application.afw.try.abort = true // abort if there is a database exception
	Application.afw.try.class = 'label-danger'
	Application.afw.try.email = 'lrPhillipSenn@gmail.com'
	Application.afw.js = true // This get duplicated in the session scope
	Application.afw.css= true // This get duplicated in the session scope
	Application.afw.hidden = false // Hide #main until the page has loaded.

	Application.afw.DomainID = 0 // For logging the next command
	Application.afw.log.Sort = 0 // For logging the next command
	Application.afw.tickCount = GetTickCount() // For logging the next command
	Application.afw.LogCFID = 0 // For logging the next command
	session.sfw = Duplicate(Application.afw) // fw.try, fw.log
	request.rfw = Duplicate(Application.afw) // fw.try, fw.log
	Application.afw.DomainID = new com.Domain().WhereDomainName()
	local.LogCFCName = 'this.Name: ' & this.Name;
	local.LogCFCDesc = 'onApplicationStart';
	new com.LogCFC().Save(local);
	return true
}

function onSessionStart() {
	session.sfw = Duplicate(Application.afw)
	request.rfw = Duplicate(Application.afw)
	local.LogCFCName = 'this.Name: ' & this.Name;
	local.LogCFCDesc = 'onSessionStart';
	new com.LogCFC().Save(local);
}

function onRequestStart(LogCFCName) {
	StructAppend(form,url,false)
	if (StructKeyExists(form,"onApplicationStart")) {
		onApplicationStart()
	}
	if (StructKeyExists(form,"onSessionStart")) {
		onSessionStart()
	}
	request.rfw = Duplicate(session.sfw)
	request.rfw.tickCount = GetTickCount()
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onRequestStart';
	new com.LogCFC().Save(local)

	if (IsDefined('form.logout')) {
		StructDelete(session,"Usr")
	}
	if (IsDefined('form.UniqueID')) {
		local.Usr = new com.Usr().WhereUniqueID(form)
		if (IsDefined('local.Usr.Prefix')) {
			if (local.Usr.Prefix.Recordcount) {
				session.Usr = Duplicate(local.Usr)
			}
		}
	}
	request.rfw.LogCFID = new com.LogCF().Save() // This is for LogDB
	session.sfw.LogCFID = request.rfw.LogCFID // These are for LogUI and LogJS.
	session.sfw.TickCount = GetTickCount() // I put it these the session scope so that they can't be gamed.
	setting showDebugoutput = false;
	if (IsDefined('form.UniqueID')) {
		local.Usr = new com.Usr().WhereUniqueID(form)
		if (local.Usr.Prefix.Recordcount) {
			session.Usr = Duplicate(local.Usr)
		}
	}
	if (IsDefined('session.Usr.qry')) {
		//
	} else {
//		include '/Inc/LoggedOut.cfm'
		return false
	}
	return true
}

function OnRequestEnd(LogCFCName) {
	session.sfw.msg = ''
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onRequestEnd';
	new com.LogCFC().Save(local);
}

function onSessionEnd(mySession,myApplication) {
	if (IsDefined('mySession.Usr.qry.UsrID')) {
		local.LogCFCName = 'mySession.Usr.qry.UsrID: ' & mySession.Usr.qry.UsrID
	} else {
		local.LogCFCName = 'myApplication.name: ' & myApplication.name
	}
	local.LogCFCDesc = 'onSessionEnd';
	new com.LogCFC().Save(local);
}

function onMissingTemplate(LogCFCName) {
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onMissingTemplate';
	new com.LogCFC().Save(local);
	return false;
}

function onMissingMethod(LogCFCName,args) { // I don't think this is working
	local.LogCFCName = arguments.LogCFCName;
	local.LogCFCDesc = 'onMissingMethod';
	new com.LogCFC().Save(local);
	return false;
}

function onApplicationEnd(myApplication) {
	local.LogCFCName = 'myApplication.name: ' & myApplication.name
	local.LogCFCDesc = 'onApplicationEnd';
	new com.LogCFC().Save(local);
}

function onError(Exception,EventName) {
	if (!IsDefined('session.sfw.log.CFErr')) return;
	if (!session.sfw.log.CFErr) return;
	session.sfw.log.CFErrCounter += 1 // See onRequestStart

	if (IsDefined('arguments.Exception.Message')) {
		request.rfw.msg = Exception.Message
		request.rfw.modifier = 'label-danger'
		local.LogCFErrMessage = Exception.Message
	} else {
		local.LogCFErrMessage = 'No Exception.Message'
	}

	request.rfw.Detail = ''
	if (isDefined('arguments.Exception.Number')) {
		request.rfw.Detail &= 'Exception.Number: #arguments.Exception.Number#<br>'
		local.LogCFErrNumber = Exception.Number
	} else {
		local.LogCFErrNumber = 'No Exception.Number'
	}
	if (isDefined('arguments.Exception.TagContext') && IsArray(Exception.TagContext) && ArrayLen(Exception.TagContext)) {
		request.rfw.Detail &= 'Exception.TagContext[1].Line: #arguments.Exception.TagContext[1].Line#<br>'
		local.LogCFErrLine = Exception.TagContext[1].Line
	} else {
		local.LogCFErrLine = 0
	}

	if (isDefined('arguments.Exception.Name')) {
		request.rfw.Detail &= 'Exception.Name: #arguments.Exception.Name#<br>'
		local.LogCFErrName = Exception.Name
	} else {
		local.LogCFErrName = 'No Exception.Name'
	}
	if (isDefined('arguments.Exception.Detail') AND arguments.Exception.Detail != '') {
		request.rfw.Detail &= 'Exception.Detail: #arguments.Exception.Detail#<br>'
		local.LogCFErrDetail = Exception.Detail
	} else {
		local.LogCFErrDetail = 'No Exception.Detail'
	}
	if (isDefined('arguments.Exception.Type')) {
		request.rfw.Detail &= 'Exception.Type: #arguments.Exception.Type#<br>'
		local.LogCFErrType = Exception.Type
	} else {
		local.LogCFErrType = 'No Exception.Type'
	}
	if (IsDefined('arguments.EventName') AND arguments.EventName != '') {
		request.rfw.Detail &= 'EventName: #arguments.EventName#<br>'
		local.LogCFErrEventName = arguments.EventName
	} else {
		local.LogCFErrEventName = 'No arguments.EventName'
	}
	request.rfw.Detail &= '</pre>'

	local.svc = new mail()
	local.svc.setSubject(Application.afw.Name & ': ' & ListLast(GetBaseTemplatePath(),'\'))
	local.svc.setBody('Exception.Message: #request.rfw.msg#<p>#request.rfw.Detail#</p>')
	
	local.port=465
	local.server='smtp.gmail.com'
	local.type='html'
	local.UserName='lrPhillipSenn@gmail.com'
	local.useSSL=true

	local.svc.setPort(local.Port)
	local.svc.setServer(local.Server)
	local.svc.setType(local.Type)
	local.svc.setUserName(local.UserName)
	local.svc.setUseSSL(local.UseSSL)
	local.svc.setFrom(local.UserName)
	var Password = ''
	include "/Inc/Passwords/Email.cfm"
	local.svc.setPassword(Password)
	local.svc.setTo('Professor Senn<lrPhillipSenn@gmail.com>')
//	local.svc.Send()

	request.rfw.log.Sort += 1; // I use the same counter for LogDB, LogDBErr, LogCF, LogCFErr, LogCFC
	local.LogCFID = new com.LogCF().Save()
	local.sql = '
	DECLARE @DomainID Int = #Val(Application.afw.DomainID)#
	DECLARE @LogCFErrID BigInt = NEXT VALUE FOR LogCFErrID;
	DECLARE @LogCFID BigInt = #Val(local.LogCFID)#;
	DECLARE @LogCFErrSort Int = #Val(request.rfw.log.Sort)#;
	DECLARE @LogCFErrElapsed Int = #GetTickCount() - request.rfw.TickCount#;
	DECLARE @LogCFErrNumber Int = #Val(local.LogCFErrNumber)#;
	DECLARE @LogCFErrLine Int = #Val(local.LogCFErrLine)#;
	
	UPDATE fw.dbo.LogCFErr SET
	 LogCFErr_DomainID	= @DomainID
	,LogCFErr_CFID		= @LogCFID
	,LogCFErrSort			= @LogCFErrSort
	,LogCFErrNumber		= @LogCFErrNumber
	,LogCFErrElapsed		= @LogCFErrElapsed
	,LogCFErrLine			= @LogCFErrLine
	,LogCFErrDatetime		= getdate()
	,LogCFErrName			= ?
	,LogCFErrDetail		= ?
	,LogCFErrMessage		= ?
	,LogCFErrType			= ?
	,LogCFErrEventName	= ?
	WHERE LogCFErrID = @LogCFErrID
	';
	local.svc = new query();

	local.svc.setSQL(local.sql);
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrName,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrDetail,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrMessage,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrType,512));
	local.svc.addParam(cfsqltype='CF_SQL_VARCHAR',value=Left(local.LogCFErrEventName,512));
	local.svc.setDataSource('fw')
	local.svc.execute()

	request.rfw.Detail = '<pre>#request.rfw.Detail#</pre>'
	request.rfw.Detail &= "I've sent an email to the administrator."
	include "/Inc/onError.cfm"
}

}
