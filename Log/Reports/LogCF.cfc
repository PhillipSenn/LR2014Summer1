component {
Variables.MetaData = GetMetaData();

function Top1000() {
	include "/Inc/newQuery.cfm";
	local.sql = "
	SELECT TOP 1000 *
	FROM LogCFView
	ORDER BY LogCFDateTime DESC
	";
	include "/Inc/execute.cfm";
	return local.result;
}

}
