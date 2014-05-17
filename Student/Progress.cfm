<cfscript>
form.UsrID = session.Usr.qry.UsrID
Cat = new Progress().SumCat()

GrandPossible = 0
GrandEarned = 0
GrandCatPct = 0
// Have they turned in their final and has it been graded?
Final = new Progress().Final()
Usr = new Progress().Ranking()
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<table>
<thead>
	<tr>
		<th>Category</th>
		<cfif Now() LT session.Usr.qry.FinalStart>
			<!---	When finals week begins, the points possible becomes the weight because everything is due. --->
			<th class="num">Weight</th>
		</cfif>
		<th class="num">Earned</th>
		<th class="num">Possible</th>
		<th class="num">Grade</th>
	</tr>
</thead>
<tbody>
<cfloop query="Cat.qry">
	<cfif Perfect>
		<cfset TotalPossible = CatPct>
		<cfset TotalEarned = Int(10 * TotalPossible * Earned / Perfect) / 10>
		<cfset myGrade = Int(Earned / Perfect*1000)/10>
	<cfelse>
		<cfset TotalPossible = 0>
		<cfset TotalEarned = 0>
		<cfset myGrade = 0>
	</cfif>
	<tr>
		<td>
			<a href="Category.cfm?CatID=#CatID#">#CatName#</a>
		</td>
		<cfif Now() LT session.Usr.qry.FinalStart>
			<td class="num">#CatPct#</td>
		</cfif>
		<td class="num">#NumberFormat(TotalEarned,"999.9")#</td>
		<td class="num">#TotalPossible#</td>
		<td class="num">#NumberFormat(myGrade,"999.9")#%</td>
	</tr>
	<cfset GrandCatPct = GrandCatPct + CatPct>
	<cfset GrandEarned = GrandEarned + TotalEarned>
	<cfset GrandPossible = GrandPossible + TotalPossible>
</cfloop>
</tbody>
<tfoot>
	<cfif GrandPossible> <!--- Nothing is due the first day of class --->
		<cfset form.GradeSort = Int(1000 * GrandEarned/GrandPossible)/10>
	<cfelse>
		<cfset form.GradeSort = 0>
	</cfif>
	<cfset Grade = new Progress().WhereGradeSortLE(form)>
	<cfif NOW() LT session.Usr.qry.TermStart>
	<cfelseif !GrandEarned>
	<cfelseif Now() GT session.Usr.qry.FinalStop>
		<cfset Guess = new Progress().Graded()>
		<cfif Guess.qry.Recordcount>
			<tr>
				<th>Grade</th>
				<th class="num">#NumberFormat(GrandEarned,"999.9")#</th>
				<th class="num">#GrandPossible#</th>
				<th class="num">#form.GradeSort#%</th>
			</tr>
			<tr>
				<td colspan="4" class="right">I still have to grade papers.</td>
			</tr>
		<cfelse>
			<tr>
				<th>Grade</th>
				<th class="num">#NumberFormat(GrandEarned,"999.9")#</th>
				<th class="num">#GrandPossible#</th>
				<th class="num">#form.GradeSort#%</th>
			</tr>
			<tr>
				<th colspan="3">Final Grade</th>
				<th class="num">#Grade.qry.GradeName#</th>
			</tr>
			</tfoot>
		</cfif>
	<cfelseif NOW() LT session.Usr.qry.FinalStart>
		<!--- The Weight column only shows up before the final --->
		<tr>
			<th>Progress</th>
			<th class="num">#GrandCatPct#</th>
			<th class="num">#NumberFormat(GrandEarned,"999.9")#</th>
			<th class="num">#GrandPossible#</th>
			<th class="num">#form.GradeSort#%</th>
		</tr>
		<tr>
			<th colspan="4">As of #DateFormat(now(),"mm/dd")# at #TimeFormat(now(),"hh:mmtt")#</th>
			<th class="num">#Grade.qry.GradeName#</th>
		</tr>
	<cfelseif NOW() GE session.Usr.qry.FinalStart>
		<!--- It's finals week --->
		<cfif Final.qry.Recordcount>
			<!--- They've turned in their final --->
			<cfif Final.qry.GradeDateTime EQ "">
				<!--- I haven't graded their final. --->
				<tr>
					<th>Grade</th>
					<th class="num">#NumberFormat(GrandEarned,"999.9")#</th>
					<th class="num">#GrandPossible#</th>
					<th class="num">#form.GradeSort#%</th>
				</tr>
				<tr>
					<td colspan="3">Assuming you made a 100 on the final...</td>
					<!--- todo: Grade on the final required to make an A in the class: --->
					<th class="num">#Grade.qry.GradeName#</th>
				</tr>
			<cfelse>
				<!--- I've graded their final --->
				<tr>
					<th>Grade</th>
					<th class="num">#NumberFormat(GrandEarned,"999.9")#</th>
					<th class="num">#GrandPossible#</th>
					<th class="num">#form.GradeSort#%</th>
				</tr>
				<tr>
					<th colspan="3">Final Grade</th>
					<th class="num">#Grade.qry.GradeName#</th>
				</tr>
			</cfif>
		<cfelse>
			<!--- They haven't turned in their final yet --->
			<tr>
				<td colspan="4" class="num">Letter Grade withheld until the final has been turned in.</td>
			</tr>
		</cfif>
	<cfelse>
		<tr>
			<td colspan="4" class="num">Plugh</td>
		</tr>
	</cfif>
</tfoot>
</table>
<p>
	<a class="btn-primary" href="EmailMyGrade.cfm">Send Email</a>
</p>
<a id="ClassRanking" class="btn-info" href="JavaScript:;">See my class Ranking</a>
<table class="toggle hidden">
	<thead>
		<tr>
			<th class="num">Row</th>
			<th>Student Name</th>
			<th class="num">Earned</th>
			<th class="num">Textbook</th>
			<th class="num">Forums</th>
			<th class="num">Research</th>
			<th class="num">Programming</th>
			<th class="num">Presentation</th>
			<th class="num">Final</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="Usr.qry">
			<tr>
				<td class="num">#CurrentRow#</td>
				<td>
					<cfif UsrID EQ session.Usr.qry.UsrID OR session.Usr.qry.isAdmin OR StructKeyExists(url,"isAdmin")>
						#FirstName# #LastName#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td class="num">#Earned#</td>
				<td class="num">#Textbook_Earned#</td>
				<td class="num">#Forums_Earned#</td>
				<td class="num">#Research_Earned#</td>
				<td class="num">#Programming_Earned#</td>
				<td class="num">#Presentation_Earned#</td>
				<td class="num">#Final_Earned#</td>
			</tr>
		</cfloop>
	</tbody>
</table>

<cfinclude template="/Inc/foot.cfm">
<script src="Progress.js"></script>
<cfinclude template="/Inc/End.cfm">
</cfoutput>
