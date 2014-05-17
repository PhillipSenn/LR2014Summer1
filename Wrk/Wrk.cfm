<cfscript>
Wrk = new com.Wrk().Where("UsrID",session.Usr.qry.UsrID)
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<table class="no-striped">
	<thead>
		<tr>
			<th>Question</th>
			<th>Answer</th>
			<th class="date">Date</th>
			<th class="time">Time</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="Wrk.qry">
			<tr>
				<td>#QuestionName#</td>
				<cfif Wrk_Correct>
					<cfset myClass = "label-success">
				<cfelse>
					<cfset myClass = "label-danger">
				</cfif>
				<td class="#myClass#">#Wrk_AnswerName#</td>
				<td class="date" data-date="#DateFormat(WrkDateTime,'yyyymmdd')##TimeFormat(WrkDateTime,'HHmmss.l')#">#DateFormat(WrkDateTime,'mm/dd')#</td>
				<td class="time" data-time="#TimeFormat(WrkDateTime,'HHmmss.l')#">#TimeFormat(WrkDateTime,'h:mm:ss.llltt')#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>