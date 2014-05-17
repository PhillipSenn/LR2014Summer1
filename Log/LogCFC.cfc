component {
Variables.fw.MetaData = GetMetaData()
Variables.fw.DataSource = 'fw'

function Save2() {
	include '/Inc/newQuery.cfm'
	local.sql = "
	DECLARE @LogCFCID BigInt = NEXT VALUE FOR LogCFCID;
	UPDATE LogCFC SET LogCFCDateTime = getdate() WHERE LogCFCID=@LogCFCID;
	SELECT *
	FROM LogCFC
	WHERE LogCFCID=@LogCFCID
	"
	include '/Inc/execute.cfm'
}
}
