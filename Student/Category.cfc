component {

function WhereCatID(form) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @CatID Int = #Val(form.CatID)#;
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	SELECT AssignmentView.*
	,GuessID
	,isNull(Earned,0) AS Earned
	,CASE WHEN GETDATE() < AssignmentStop THEN isNull(Earned,0) ELSE 100 END AS Perfect
	,CASE WHEN Guess_AssignmentID is null THEN 'Yes' ELSE 'Not Yet' END AS Graded
	FROM AssignmentView
	LEFT JOIN (
		SELECT Paper_AssignmentID
		,Max(GuessID) AS GuessID
		,Sum(Earned) AS Earned
		FROM GuessView
		WHERE UsrID = @UsrID
		GROUP BY Paper_AssignmentID
	) Guess
	ON Paper_AssignmentID = AssignmentID
	LEFT JOIN (
		SELECT AssignmentID AS Guess_AssignmentID
		FROM GuessView
		WHERE UsrID = @UsrID
		AND GradeDateTime is null
		GROUP BY AssignmentID
	) NonGraded
	ON Guess_AssignmentID = AssignmentID
	WHERE CatID = @CatID
	ORDER BY AssignmentStop,AssignmentStart,ActSort
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function WhereAssignmentID(form) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	DECLARE @AssignmentID Int = #Val(form.AssignmentID)#;
	SELECT *
	FROM GuessView
	WHERE UsrID = @UsrID
	AND AssignmentID = @AssignmentID
	AND GuessName <> ''
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function Research(form) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	DECLARE @AssignmentID Int = #Val(form.AssignmentID)#;
	SELECT *
	FROM GuessView
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	AND AssignmentID = @AssignmentID
	AND GuessName <> ''
	ORDER BY AnswerID,GuessDateTime DESC
	";
	include "/Inc/execute.cfm";
	return local.result;
}
}
