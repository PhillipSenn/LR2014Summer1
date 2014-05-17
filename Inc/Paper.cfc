component {

function Save(arg) { // Assumes session.Usr.qry.UsrID
	include "/Inc/newQuery.cfm"
	local.sql = "
	DECLARE @UsrID 	Int = #Val(session.Usr.qry.UsrID)#
	DECLARE @ActSort 	Int = #Val(arg.ActSort)#
	SELECT *
	FROM PaperView
	WHERE UsrID=@UsrID
	AND ActSort=@ActSort
	"
	include "/Inc/execute.cfm"
	if (!local.result.Prefix.Recordcount) {
		include "/Inc/newQuery.cfm"
		local.sql = "
		DECLARE @UsrID 	Int = #Val(session.Usr.qry.UsrID)#
		DECLARE @ActSort 	Int = #Val(arg.ActSort)#
		DECLARE @CourseID	Int = #Val(session.Usr.qry.CourseID)#
		INSERT INTO Paper(Paper_UsrID,Paper_AssignmentID) VALUES(
			@UsrID,(
				SELECT AssignmentID
				FROM AssignmentView
				WHERE ActSort=@ActSort
				AND CourseID = @CourseID
			)
		)
		"
		include "/Inc/execute.cfm"
		// I can't do an insert followed by a select Scope_Identity() in the same sql stmt.
		// https://issues.jboss.org/browse/RAILO-2911
		include "/Inc/newQuery.cfm"
		local.sql = "
		DECLARE @UsrID 	Int = #Val(session.Usr.qry.UsrID)#
		DECLARE @ActSort 	Int = #Val(arg.ActSort)#
		SELECT *
		FROM PaperView
		WHERE UsrID=@UsrID
		AND ActSort=@ActSort
		"
		include "/Inc/execute.cfm"
	}
	return local.result
}

}