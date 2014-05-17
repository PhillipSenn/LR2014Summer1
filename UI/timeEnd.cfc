component {

function Save(TimeEndID,TimeEndDateTime) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @TimeEndID Int
	DECLARE @TimeEndDateTime DateTime2 = ?
	UPDATE TimeEnd SET TimeEnd=?
	WHERE TimeEndID = @TimeEndID
	";
	local.svc.addParam(cfsqltype="CF_SQL_TIMESTAMP",value=arguments.TimeEndDateTime);
	include "/Inc/execute.cfm";
	return local.result;
}
}
