<cfscript>
new Reset().Guess()
new Reset().LogCFC()
new Reset().LogCFErr()
new Reset().LogDBErr()
new Reset().LogJS()
new Reset().LogUI()
new Reset().Wrk()
new Reset().LogCF()
new Reset().LogDB()
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
Yay.
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>