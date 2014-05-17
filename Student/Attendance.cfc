component {

function WhereQuestionSort(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @ActID Int = #Val(arg.ActID)#;
	SELECT *
	FROM QuestionView
	WHERE QuestionSort=@ActID
	AND ActName like '%attendance%'
	";
	include "/Inc/execute.cfm";
	return local.result;
}
}