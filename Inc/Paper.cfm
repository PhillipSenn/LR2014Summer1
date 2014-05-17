<cfscript>
//Assignment = new com.Assignment().WhereActSort(url)
//form.AssignmentID = Assignment.qry.AssignmentID // Paper.cfc, WhereAssignmentID
Paper = new Inc.Paper().Save(form)
if (!Paper.Prefix.Recordcount) {
	echo("There's no assignment:<pre>#Paper.prefix.sql#</pre>")
	abort;
}
if (Now() < Paper.qry.AssignmentStart) {
//	request.fw.msg = 'This assignment begins on ' & DateFormat(Paper.qry.AssignmentStart,'mm/dd')
}
//form.PaperID = Paper.qry.PaperID
//form.Questions = Paper.qry.Questions // Guess.cfc, Create
Score = new com.Guess().Score(Paper.qry)
//form.ActID = Assignment.qry.ActID
//form.CourseID = Paper.qry.CourseID // UsrList
</cfscript>
