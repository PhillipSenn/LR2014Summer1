<cfscript>
LogJS = new com.LogJS().Read(url);
LogJSDesc = Replace(LogJS.qry.LogJSDesc,chr(9),'   ','all');
</cfscript>

<cfoutput query="LogJS.qry">
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<h1>#LogJSName#</h1>
<pre>#Variables.LogJSDesc#</pre>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>