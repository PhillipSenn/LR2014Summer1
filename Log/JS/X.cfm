<cfscript>

</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<s>Every page logs a timeEnd after the window has loaded.</s>
<p>
But this page also does a console.log as well as posting it to the logjs table.
</p>
<cfinclude template="/Inc/foot.cfm">
<script>
function ConjunctionJunction(arg) {
	// Hooking up words and phrases and clauses
	logjs(arg)
}
ConjunctionJunction("What's your function?")
</script>
<cfinclude template="/Inc/End.cfm">
</cfoutput>