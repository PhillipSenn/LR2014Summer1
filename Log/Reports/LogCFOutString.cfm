<cfscript>
LogCF = new com.LogCF().Read(url);
StructDelete(request,"Bootstrap");
</cfscript>

<cfoutput query="LogCF.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<pre>
#Replace(LogCFOutString,'<','&lt;','all')#
</pre>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>