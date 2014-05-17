<cfscript>
Cat = new com.Cat().Read(form);
Assignment = new Category().WhereCatID(form);
tEarned = 0
tPerfect =0
for (qry in Assignment.qry) {
	tEarned += qry.Earned
	tPerfect += qry.Perfect
}
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<h1>#Cat.qry.CatName#</h1>
<table>
	<thead>
		<tr>
		<th>Start<br>Date</th>
		<th>Date<br>Due</th>
		<th>Assignment</th>
		<th class="num">Your Score</th>
		<th>Graded</th>
		<th class="num">Perfect</th>
		<th>Deadline</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="Assignment.qry">
			<tr>
			<td>#DateFormat(AssignmentStart,"mm/dd")#</td>
			<td>#DateFormat(AssignmentStop,"mm/dd")#</td>
			<td><a href="/#ActLink#?ActSort=#ActSort#">#ActName#</a></td>
			<td class="num">#Earned#</td>
			<cfif GuessID EQ "">
				<td>&nbsp;</td>
			<cfelse>
				<td>#Graded#</td>
			</cfif>
			<td class="num">#Perfect#</td>
			<td>
				<cfif Earned LT 100>
					<cfif AssignmentStop GT now()>
						#DateDiff('d',Now(),AssignmentStop)# days
					<cfelse>
						#DateFormat(AssignmentStop,"mm/dd")#
					</cfif>
				</cfif>
			</td>
			</tr>
		</cfloop>
	</tbody>
	<tfoot>
		<tr>
			<td>#DateFormat(session.Usr.qry.TermStart,"mm/dd")#</td>
			<td>#DateFormat(session.Usr.qry.LastDayOfClasses,"mm/dd")#</td>
			<td>Total</td>
			<td class="num">#tEarned#</td>
			<td>&nbsp;</td>
			<td class="num">#tPerfect#</td>
			<td></td>
		</tr>
	</tfoot>
</table>
<cfif tPerfect>
	<cfset Score = Int(tEarned / tPerfect * 100)>
	You scored #tEarned# out of #tPerfect#, giving you a #Score#%.
	<p>But "#Cat.qry.CatName#" is only #Cat.qry.CatPct#% of the grade.</p>
	<p>#Score# &times; #Cat.qry.CatPct# = #Int(tEarned / tPerfect * Cat.qry.CatPct)#.</p>
</cfif>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>
