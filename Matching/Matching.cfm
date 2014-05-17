<cfscript>
if (IsDefined('form.jQueryUI')) {
	session.form.jQueryUI = form.jQueryUI
} else {
	param name="session.form.jQueryUI" default='cupertino';
}
include "/Inc/Paper.cfm"
new com.Guess().Create(Paper.qry)
Answer = new Matching().Answer(Paper.qry)
Question = new Matching().Question(Paper.qry)
Variables.fw.jQueryUI=session.form.jQueryUI
Variables.showProgress = true
Themes = "black-tie,blitzer,cupertino,dark-hive,dot-luv,eggplant,excite-bike,flick,hot-sneaks,humanity,le-frog,mint-choc,overcast,pepper-grinder,redmond,smoothness,south-street,start,sunny,swanky-purse,trontastic,ui-darkness,ui-lightness,vader"
</cfscript>

<cfoutput query="Paper.qry">
<cfinclude template="/Inc/html.cfm">
<link rel="stylesheet" href="Matching.css">
<cfinclude template="/Inc/body.cfm">
<div class="row">
	<div class="col-md-5">
		<h1>#ActName#</h1>
	</div>
	<div class="col-md-7">
		<button type="button" class="btn-primary pull-right" id="Earned" disabled>Earned: #Score.qry.Earned#</button>
	</div>
</div>
<div class="row">
	<div class="col-md-10">
		<label class="checkbox-inline">
			<input type="checkbox" id="hideCorrectAnswers">Hide the ones that are matched already
		</label>
	</div>
	<div class="col-md-2 pull-right">
		<form method="post" action="Matching.cfm?ActSort=#url.ActSort#">
			<select name="jQueryUI">
				<cfloop list="#Themes#" index="theme">
					<option value="#theme#"<cfif theme EQ session.form.jQueryUI> selected</cfif>>#theme#</option>
				</cfloop>
			</select>
		</form>
	</div>
</div>

<div class="row">
	<div id="AnswerIDs" class="col-md-4">
		<cfloop query="Answer.qry">
			<cfif Val(Earned)>
				<div class="ui-widget-content ui-state-focus" title="#QuestionName#">
					&##10004;
					#AnswerName#
				</div>
			<cfelse>
				<div class="ui-widget-content AnswerID" draggable="true" id="Answer#AnswerID#">
					#AnswerName#
				</div>
			</cfif>
		</cfloop>
	</div>
	<div id="GuessIDs" class="col-md-7 col-md-offset-1">
		<cfloop query="Question.qry">
			<cfif Val(Earned)>
				<div class="ui-state-focus ui-widget-content" title="#AnswerName#">
					#QuestionName#
					&##10004;
				</div>
			<cfelseif GradeDateTime NEQ "">
				<div class="ui-state-error GuessID ui-widget-content" id="Guess#GuessID#">
					#QuestionName#
				</div>
			<cfelse>
				<div class="GuessID ui-widget-content" id="Guess#GuessID#">
					#QuestionName# 
				</div>
			</cfif>
		</cfloop>
	</div>
</div>
<input type="hidden" id="PaperID" value="#Paper.qry.PaperID#">

<div class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
		<div class="modal-header label-primary">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h4 class="modal-title">Pedagogy for this assignment</h4>
		</div>
		<div class="modal-body">
		<p>The Instructor's Companion Site has 20 matching questions per chapter.<br>
		If you login to <a target="_blank" href="http://www.cengagebrain.com/">cengagebrain.com</a>, 
		and search for 
<blockquote>Discovering Computers: Essentials<br>
Misty E. Vermaat<br>
ISBN-10: 1-285-16178-5<br>
ISBN-13: 978-1-285-16178-5<br>
</blockquote>
		you will see a link to a Student Companion Site where there is a glossary for each of the 5 chapters.
		</p>
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
<script src="Matching.js"></script>
<cfinclude template="/Inc/End.cfm">
</cfoutput>
