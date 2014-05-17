<cfscript>
include "/Inc/Paper.cfm"
new com.Guess().Create(Paper.qry)
</cfscript>

<cfoutput query="Paper.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
Drag the answer from the left-hand side to the right-hand side.

<p>I've found that it's easiest to read what's in the the right-hand column and
then go down the list of words on the left to find the answer.</p>
<cfif Now() GT AssignmentStart OR session.Usr.qry.isAdmin>
	<p>Ready?</p>
	<a class="btn-primary" href="Matching.cfm?ActSort=#url.ActSort#">Ready!</a>
</cfif>
<!---
<a class="btn" href="/jqm/Matching/Matching.cfm?ActSort=#url.ActSort#">jQuery Mobile</a>
--->
<div class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header label-primary">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Pedagogy for this assignment</h4>
			</div>
			<div class="modal-body">
				<p>Don't give up if you get the wrong answer!  Just keep working on it until you've made a 100! Yay!</p>
			</div>
			<div class="modal-footer">
				<button type="button" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<footer>
	<button class="btn-info" type="button" data-toggle="modal" data-target=".modal">Pedagogy</button>
</footer>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>