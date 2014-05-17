component extends="ReadWhereDelete" {
Variables.fw.TableName = "Guess";
Variables.fw.TableSort = "GuessID DESC";

function Score(arg) { // /Inc/Paper.cfm
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	WITH CTE1 AS(
		SELECT ActID,Questions,KeepWorkingOnIt
		FROM PaperView
		WHERE PaperID = @PaperID
	)
	,CTE2 AS(
		select Question_ActID
		,count(*) AS Answered
		FROM (
			SELECT Question_ActID,QuestionID
			FROM WrkView
			WHERE PaperID = @PaperID
			GROUP BY Question_ActID,QuestionID
		) X
		GROUP BY Question_ActID
	)
	,CTE3 AS(
		select ActID AS Guess_ActID
		,Sum(Earned) AS Earned
		from guessView
		WHERE PaperID = @PaperID
		GROUP BY ActID
	)
	SELECT Earned
	,CASE WHEN KeepWorkingOnIt=1 THEN 
		isNull(Earned,0)
	ELSE
		isNull(100.0*Answered/Questions,0)
	END AS PctComplete 
	,isNull(Answered,0) AS Answered
	,Questions
	FROM CTE1
	LEFT JOIN CTE2
	ON Question_ActID = ActID
	LEFT JOIN CTE3
	ON Guess_ActID = ActID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function Create(arg) { // where correct=1
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	SELECT COUNT(*) AS CreatedQuestions
	FROM (
		SELECT QuestionID
		FROM GuessView
		WHERE PaperID = @PaperID
		GROUP BY QuestionID
	) Guess
	";
	local.svc.setSQL(local.sql);
	local.obj = local.svc.execute();
	local.Guess = {};
	local.Guess.qry = local.obj.getResult();

	if (local.Guess.qry.CreatedQuestions < arg.Questions) {
		include "/Inc/newQuery.cfm";
		local.sql = "
		DECLARE @PaperID Int = #Val(arg.PaperID)#;
		DECLARE @ActID Int = #Val(arg.ActID)#;
		INSERT INTO Guess(Guess_PaperID,Guess_AnswerID,GradeDateTime)
		SELECT TOP #arg.Questions-Val(local.Guess.qry.CreatedQuestions)#
		@PaperID
		,AnswerID
		,getdate()
		FROM AnswerView
		WHERE ActID = @ActID
		AND Correct=1
		AND AnswerID NOT IN(
			SELECT AnswerID
			FROM GuessView
			WHERE PaperID = @PaperID
		)
		ORDER BY NewID()
		";
		include "/Inc/execute.cfm";
	}
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	SELECT *
	FROM GuessView
	WHERE GuessID IN(
		SELECT Max(GuessID)
		FROM GuessView
		WHERE PaperID=@PaperID
		GROUP BY QuestionID
	)
	ORDER BY QuestionSort,QuestionID
	";
	// if ORDER BY GUESSID, THEN THE LAST ONE ANSWERED (INSERTED) WILL MOVE TO THE BOTTOM.
	include "/Inc/execute.cfm";
	return local.result;
}

function TheirAnswer(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @QuestionID Int = #Val(arg.QuestionID)#;
	DECLARE @AnswerID Int = #Val(arg.AnswerID)#;
	SELECT *
	FROM AnswerView
	WHERE AnswerName=(
		SELECT AnswerName
		FROM Answer
		WHERE AnswerID = @AnswerID
	)
	AND QuestionID = @QuestionID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function SaveGraded(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	DECLARE @AnswerID Int = #Val(arg.AnswerID)#;
	DECLARE @Earned Int = 0;
	SELECT @Earned=Points
	FROM AnswerView
	WHERE AnswerID=@AnswerID
	AND Correct=1;
	INSERT INTO Guess(Guess_PaperID,Guess_AnswerID,Earned,GradeDateTime) VALUES
	(@PaperID
	,@AnswerID
	,@Earned
	,getdate()
	)
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function WherePaperID(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	SELECT *
	FROM GuessView
	WHERE PaperID=@PaperID
	ORDER BY QuestionSort,QuestionID,AnswerSort,AnswerID,GuessID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function ResetWherePaperID(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	UPDATE Guess SET
	 Earned = 0
	WHERE Guess_PaperID = @PaperID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function UpdateGradedWherePaperID(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE Guess SET Earned=(
				SELECT Points
				FROM AnswerView
				WHERE AnswerID=Guess_AnswerID
			)
			,GuessDateTime = getdate()
			,GradeDateTime = getdate()
			WHERE GuessID IN(
				SELECT GuessID
				FROM GuessView
				WHERE PaperID = @PaperID
				
			);
			UPDATE Guess SET Earned=0
			WHERE GuessID IN(
				SELECT GuessID
				FROM GuessView
				WHERE PaperID = @PaperID
				AND QuestionName like '%on time%'
				AND getdate() > DateAdd(Day,1,AssignmentStop)
			)
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
	";
	include "/Inc/execute.cfm";
	return local.result;
}

/*
function SaveGuessName(arg) { // SaveOriginalFileName
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	UPDATE Guess SET
	GuessName = ?
	WHERE GuessID =(
		SELECT TOP 1 GuessID
		FROM GuessView
		WHERE PaperID = @PaperID
		AND AnswerName = 'attachment'
		ORDER BY GuessID DESC
	)
	";
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arg.GuessName);
	include "/Inc/execute.cfm";
}
*/

function Attachment(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	SELECT *
	FROM GuessView
	WHERE Attachment like '%" & arg.Name & "'
	AND AnswerName = 'attachment'
	";
	// local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arg.Name);
	include "/Inc/execute.cfm";
	return result;
}

function UpdateEarned(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @GuessID Int = #Val(arg.GuessID)#;
	DECLARE @Earned Int = 0;
	";
	if (StructKeyExists(arg,"AnswerIDs") 
		&& StructKeyExists(arg,"AnswerID")
		&& ListFind(arg.AnswerIDs,arg.AnswerID)) {
		local.sql = local.sql & "
		SELECT @Earned = Points
		FROM GuessView
		WHERE GuessID = @GuessID
		";
	}
	local.sql = local.sql & "
	UPDATE Guess SET
	 Earned = @Earned
	,GradeDateTime = getdate()
	,GuessComment = ?
	WHERE GuessID = @GuessID
	";
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arg.GuessComment);
	include "/Inc/execute.cfm";
}

function SaveTextArea(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	UPDATE Guess SET
	GuessName = ?
	WHERE GuessID =(
		SELECT TOP 1 GuessID
		FROM GuessView
		WHERE PaperID = @PaperID
		AND (
			QuestionName like '%textarea%' OR
			AnswerName like '%textarea%'
		)
		ORDER BY GuessID DESC
	)
	";
	local.svc.addParam(cfsqltype="CF_SQL_VARCHAR",value=arg.GuessName);
	include "/Inc/execute.cfm";
	return local.result;
}

function Next(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	SELECT TOP 1 *
	FROM GuessView
	WHERE GuessID IN(
		SELECT Max(GuessID)
		FROM GuessView
		WHERE PaperID = @PaperID
		GROUP BY QuestionID
	)
	ORDER BY GuessID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function UpdateGuess(arg) { // I could probably use some other function for this.
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @GuessID Int = #Val(arg.GuessID)#;
	UPDATE Guess SET Earned=(
		SELECT Points
		FROM GuessView
		WHERE GuessID = @GuessID
	)
	,GuessDateTime=getDate()
	,GradeDateTime=getdate()
	WHERE GuessID=@GuessID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function InsertByQuestionSort(arg) {
	local.result = Where("PaperID",arg.PaperID);
	if (!local.result.Prefix.Recordcount) {
		include "/Inc/newQuery.cfm";
		local.sql = "
		DECLARE @PaperID Int = #Val(arg.PaperID)#;
		DECLARE @ActID Int = #Val(arg.ActID)#;
		INSERT INTO Guess(Guess_PaperID,Guess_AnswerID)
		SELECT @PaperID,AnswerID
		FROM AnswerView
		WHERE ActID = @ActID
		AND Correct=1
		ORDER BY QuestionSort
		";
		include "/Inc/execute.cfm";
	}
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	SELECT *
	FROM GuessView
	WHERE PaperID=@PaperID
	ORDER BY GuessID
	";
	include "/Inc/execute.cfm";
	return local.result;
}

function UpdateUngradedWherePaperID(arg) {
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arg.PaperID)#;
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE Guess SET Earned=(
				SELECT Points
				FROM AnswerView
				WHERE AnswerID=Guess_AnswerID
			)
			,GuessDateTime = getdate()
			,GradeDateTime = null
			WHERE GuessID IN(
				SELECT GuessID
				FROM GuessView
				WHERE PaperID = @PaperID
				
			);
			UPDATE Guess SET Earned=0
			WHERE GuessID IN(
				SELECT GuessID
				FROM GuessView
				WHERE PaperID = @PaperID
				AND QuestionName like '%on time%'
				AND getdate() > DateAdd(Day,1,AssignmentStop)
			)
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
	";
	include "/Inc/execute.cfm";
	return local.result;
}
}
