<cfscript>
Usr = new com.Usr().Read(url)
</cfscript>

<cfoutput query="Usr.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
#PersonName#
<p>And other info when I get around to it</p>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>