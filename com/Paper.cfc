component extends="ReadWhereDelete" {
Variables.TableName = "Paper"
Variables.TableSort = "PaperID"

function Save(arg) { // Assumes session.Usr.qry.UsrID
	include "/Inc/newQuery.cfm"
	local.sql = "
	DECLARE @UsrID 	Int = #Val(session.Usr.qry.UsrID)#
	DECLARE @ActSort 	Int = #Val(arg.ActSort)#
	DECLARE @CourseID	Int = #Val(session.Usr.qry.CourseID)#
	DECLARE @AssignmentID Int=0
	SELECT @AssignmentID = AssignmentID
	FROM AssignmentView
	WHERE ActSort=@ActSort
	AND CourseID = @CourseID
	IF @AssignmentID <> 0 BEGIN
		DECLARE @PaperID Int=(
			SELECT PaperID
			FROM PaperView
			WHERE UsrID=@UsrID
			AND ActSort=@ActSort
		)
		IF @PaperID IS NULL BEGIN
			INSERT INTO Paper(Paper_UsrID,Paper_AssignmentID) VALUES(@UsrID,@AssignmentID)
			SELECT @PaperID = Scope_Identity()
		END
		SELECT *
		FROM PaperView
		WHERE PaperID=@PaperID
	END
	"
	include "/Inc/execute.cfm"
	return local.result
}

}
