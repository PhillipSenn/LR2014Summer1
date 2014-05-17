<cfscript>
include "/Inc/Paper.cfm";
Guess = new com.Guess().Where("PaperID",Paper.qry.PaperID);
if (Guess.Prefix.Recordcount) {
	Act = new com.Act().Where("ActSort",Guess.qry.QuestionSort);
} else {
	Question = new com.Question().Where("ActID",Paper.qry.ActID);
	Act = new com.Act().Where("ActSort",Question.qry.QuestionSort);
	location('/' & Act.qry.ActLink & '?ActSort=' & Act.qry.ActSort,false);
}
</cfscript>

<cfoutput query="Act.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<!---
<h1>#ActName#</h1>
<p>#ActDesc#</p>
--->
<p>
<cfif Guess.Prefix.Recordcount>
	It looks like you finished #ActName# on #DayOfWeekAsString(DayOfWeek(Guess.qry.GuessDateTime))#,
	#DateFormat(Guess.qry.GuessDateTime,'mm/dd')# at #TimeFormat(Guess.qry.GuessDateTime,'h:mm:ss.ltt')#.
<cfelse>
	It doesn't look like you've finished #ActName# yet.
</cfif>
</p>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>