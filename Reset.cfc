component {
function Guess() {
	include "/Inc/newQuery.cfm"
	local.sql = "
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#
	DELETE Guess
	FROM Guess
	JOIN GuessView
	ON Guess.GuessID = GuessView.GuessID
	WHERE UsrID=@UsrID
	"
	include "/Inc/execute.cfm"
}

function LogCF() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogCF SET
	 LogCF_DomainID = 0
	,LogCFSort = 0
	,LogCFElapsed=0
	,LogCF_UsrID =0
	,LogCFDateTime = null
	,LogCFOutString=''
	,LogCFQueryString=''
	,LogCFName=''
	,LogCFUserAgent=''
	,LogCFURL=''
	,LogCFForm=''
	,LogCFSession=''
	,RemoteAddr=''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogCFC() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogCFC SET
	 LogCFC_DomainID  = 0
	,LogCFC_CFID		= 0
	,LogCFCSort			= 0
	,LogCFCElapsed		= 0
	,LogCFCDateTime	= null
	,LogCFCName 		= ''
	,LogCFCDesc 		= ''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogCFErr() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogCFErr SET
	 LogCFErr_DomainID	= 0
	,LogCFErr_CFID			= 0
	,LogCFErrSort			= 0
	,LogCFErrNumber		= 0
	,LogCFErrElapsed		= 0
	,LogCFErrLine			= 0
	,LogCFErrDatetime		= null
	,LogCFErrName			= ''
	,LogCFErrDetail		= ''
	,LogCFErrMessage		= ''
	,LogCFErrType			= ''
	,LogCFErrEventName	= ''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogDB() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogDB SET
	 LogDB_DomainID      = 0
	,LogDB_CFID				= 0
	,LogDBSort				= 0
	,LogDBElapsed			= 0
	,LogDBRecordcount		= 0
	,LogDBExecutionTime	= 0
	,LogDBDateTime			= null
	,LogDBComponentName	= ''
	,LogDBFunctionName	= ''
	,LogDBName				= ''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogDBErr() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogDBErr SET
	 LogDBErr_DomainID = 0
	,LogDBErr_DBID		= 0
	,LogDBErrSort		= 0
	,LogDBErrElapsed	= 0
	,LogDBErrCode		= 0
	,LogDBErrSQLState	= 0
	,LogDBErrDateTime = null
	,LogDBErrType=''
	,LogDBErrName=''
	,LogDBErrDesc=''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogJS() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogJS SET
	 LogJS_CFID = 0
	,LogJSSort = 0
	,LogJSElapsed = 0
	,LogJSDateTime = null
	,LogJSName=''
	,LogJSDesc=''
	,LogJSPathName = ''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function LogUI() {
	include "/Inc/newQuery.cfm"
	local.sql = "UPDATE LogUI SET
	 LogUI_CFID = 0
	,LogUISort=0
	,LogUIElapsed=0
	,LogUIDateTime = null
	,LogUIName=''
	,LogUITag=''
	,LogUITagName=''
	,LogUIIdentifier=''
	,LogUIClass=''
	,LogUIDestination=''
	,LogUIValue=''
	"
	local.fw.DataSource = 'fw'
	include "/Inc/execute.cfm"
}

function Wrk() {
	include "/Inc/newQuery.cfm"
	local.sql = "TRUNCATE TABLE Wrk
	"
	include "/Inc/execute.cfm"
}

}