<cfscript>
//Assignment = new com.Assignment().WhereActSort(url)
//form.AssignmentID = Assignment.qry.AssignmentID // Paper.cfc, WhereAssignmentID
Paper = new com.Paper().Save(form)
if (Now() < Paper.qry.AssignmentStart) {
//	request.rfw.msg = 'This assignment begins on ' & DateFormat(Paper.qry.AssignmentStart,'mm/dd')
}
//form.PaperID = Paper.qry.PaperID
//form.Questions = Paper.qry.Questions // Guess.cfc, Create
Score = new com.Guess().Score(Paper.qry)
//form.ActID = Assignment.qry.ActID
//form.CourseID = Paper.qry.CourseID // UsrList
</cfscript>
