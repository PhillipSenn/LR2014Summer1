component {

remote function PostAttendance(PaperID) { // The assignment you are working on
	include "/Inc/newQuery.cfm";
	local.sql = "
	DECLARE @PaperID Int = #Val(arguments.PaperID)#;
	DECLARE @UsrID Int = #Val(session.Usr.qry.UsrID)#;
	DECLARE @CourseID Int;
	DECLARE @QuestionSort Int;
	DECLARE @GuessID Int = 0;
	DECLARE @Attendance_PaperID Int = 0;
	DECLARE @AnswerID Int;
	DECLARE @ActID Int = 0;
	DECLARE @AssignmentID Int;
	DECLARE @AssignmentStop DateTime2
	
	SELECT @QuestionSort = ActSort
	,@CourseID = CourseID
	FROM PaperView
	WHERE PaperID = @PaperID
	
	SELECT @ActID = ActID
	FROM QuestionView
	WHERE QuestionSort = @QuestionSort
	AND ActName like '%attendance%'
	
	IF @ActID <> 0 BEGIN
		SELECT @AssignmentID = AssignmentID
		FROM AssignmentView
		WHERE ActID = @ActID
		AND CourseID = @CourseID
	
		SELECT @Attendance_PaperID = PaperID
		FROM PaperView
		WHERE UsrID = @UsrID
		AND AssignmentID = @AssignmentID
		IF @Attendance_PaperID = 0 BEGIN
			INSERT INTO Paper(Paper_UsrID,Paper_AssignmentID) VALUES(@UsrID,@AssignmentID);
			SELECT @Attendance_PaperID = Scope_Identity();
		END
		SELECT @ActID=ActID,@AssignmentStop = AssignmentStop
		FROM PaperView
		WHERE PaperID = @Attendance_PaperID
		
		SELECT @GuessID = GuessID
		FROM GuessView
		WHERE PaperID = @Attendance_PaperID
		IF @GuessID = 0 BEGIN
			-- Get the late answer
			SELECT @AnswerID = AnswerID
			FROM AnswerView
			WHERE ActName like '%attendance%'
			AND QuestionSort = @QuestionSort
			AND Correct=0
			INSERT INTO Guess(Guess_PaperID,Guess_AnswerID,GradeDateTime) VALUES(@Attendance_PaperID,@AnswerID,getdate())
		END
		-- Get the on time answer
		SELECT @AnswerID = AnswerID
		FROM AnswerView
		WHERE ActName like '%attendance%'
		AND QuestionSort = @QuestionSort
		AND Correct=1
		UPDATE Guess SET Earned=100
		,Guess_AnswerID = @AnswerID
		WHERE GuessID IN(
			SELECT GuessID
			FROM GuessView
			WHERE ActName like '%attendance%'
			AND UsrID = @UsrID
			AND QuestionSort = @QuestionSort
			AND getdate() < DateAdd(day,1,@AssignmentStop)
		)
	END
	";
	include "/Inc/execute.cfm";
}
}