component {

function Answer(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @ActID Int = #Val(arg.ActID)#;
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	SELECT *
	FROM AnswerView
	LEFT JOIN (
		SELECT AnswerID AS Guess_AnswerID
		,Earned
		FROM GuessView
		WHERE UsrID = @UsrID
	) Guess
	ON Guess_AnswerID = AnswerID
	WHERE ActID=@ActID
	AND Correct=1
	ORDER BY AnswerName
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function Question(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @ActID Int = #Val(arg.ActID)#;
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	SELECT *
	FROM AnswerView
	LEFT JOIN (
		SELECT GuessID
		,QuestionID AS Guess_QuestionID
		,Earned,GradeDateTime
		FROM GuessView
		WHERE UsrID = @UsrID
	) Guess
	ON Guess_QuestionID = QuestionID
	LEFT JOIN (
		SELECT Wrk_GuessID
		FROM Wrk
		GROUP BY Wrk_GuessID
	) Wrk
	ON Wrk_GuessID = GuessID
	WHERE ActID=@ActID
	AND Correct=1
	ORDER BY GuessID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

remote function Save() returnformat="json" {
	include "/Inc/newQuery.cfm";
	// He chose an AnswerName, but we've got to find the AnswerName that has an Answer_QuestionID=
	local.sql = "
	DECLARE @GuessID Int = #Val(arguments.GuessID)#;
	DECLARE @AnswerID Int = #Val(arguments.AnswerID)#;
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	DECLARE @Earned Int = 0;
	SELECT @AnswerID = AnswerID -- This is his true answer to the question
	FROM AnswerView
	WHERE QuestionID = (
		SELECT QuestionID
		FROM GuessView
		WHERE GuessID = @GuessID
	)
	AND AnswerName = (
		SELECT AnswerName
		FROM Answer
		WHERE AnswerID = @AnswerID
	);
	SELECT @Earned = Points -- Now find out what he's won.
	FROM AnswerView
	WHERE AnswerID = @AnswerID
	AND Correct=1;
	INSERT INTO Wrk(Wrk_GuessID,Wrk_AnswerID) VALUES(@GuessID,@AnswerID)
	UPDATE Guess SET
	 Guess_AnswerID = @AnswerID
	,Earned = @Earned
	,GuessDateTime = getdate()
	,GradeDateTime = getdate()
	WHERE GuessID = @GuessID
	";
	include "/Inc/execute.cfm";

	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @GuessID Int = #Val(arguments.GuessID)#;
	SELECT Earned
	,isNull(SumEarned,0) AS SumEarned
	FROM GuessView
	JOIN (
		SELECT PaperID
		,Sum(Earned) AS SumEarned
		FROM GuessView
		GROUP BY PaperID
	) Total
	ON GuessView.PaperID = Total.PaperID
	WHERE GuessID = @GuessID
	";
	include "/Inc/execute.cfm";
	url.queryFormat = "column";
	return local.result; // I'm returning a response so that JavaScript can know how to treat the drop.
}

}