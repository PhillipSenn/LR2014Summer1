component extends="ReadWhereDelete" {
Variables.fw.TableName = 'Usr'
Variables.fw.TableSort = 'UsrID'

function WhereUniqueID(arg) {
	if (Len(arg.UniqueID) != 36) return;
	if (Mid(arg.UniqueID,9,1) != '-') return;
	if (Mid(arg.UniqueID,14,1) != '-') return;
	if (Mid(arg.UniqueID,19,1) != '-') return;
	if (Mid(arg.UniqueID,24,1) != '-') return;

	for (local.i=1; local.i <= Min(36,Len(arg.UniqueID)); local.i++) {
		if (!Find(Mid(arg.UniqueID,local.i,1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-')) return;
	}
	if (Find('--',arg.UniqueID)) return;

	include "/Inc/newQuery.cfm";
	local.sql = "
		SELECT *
		FROM UsrView
		WHERE UniqueID = ?
	";
	local.svc.addParam(value=arg.UniqueID,cfsqltype="CF_SQL_VARCHAR");
	include "/Inc/execute.cfm";
	return local.result;
}
}
