component extends="ReadWhereDelete" {
Variables.TableName = "Assignment";
Variables.TableSort = "CourseSort,AssignmentStart,AssignmentStop,AssignmentID";

function WhereActSort(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @ActSort Int = #Val(arg.ActSort)#;
	DECLARE @CourseID Int = #Val(session.Usr.qry.CourseID)#;
	SELECT *
	FROM AssignmentView
	WHERE ActSort = @ActSort
	AND CourseID = @CourseID
	";
	include "/Inc/execute.cfm";
	return local.result;
}
}
