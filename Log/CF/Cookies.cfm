<cfscript>
LogCF = new com.LogCF().Read(url);
</cfscript>

<cfoutput query="LogCF.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
#LogCFCookies#
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>