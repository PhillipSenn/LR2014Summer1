<cfscript>
if (StructKeyExists(url,"LogJSID")) {
	LogJS = new com.LogJS().Read(url)
} else {
	LogJS = new com.LogJS().Where()
}
SaveDate = ''
Variables.fw.container = false
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<table>
	<thead>
		<tr>
			<th class="num">LogJS</th>
			<th class="num">User</th>
			<th class="num">Sort</th>
			<th class="num">Elapsed</th>
			<th>PathName</th>
			<th>LogJSName</th>
			<th class="date">Date</th>
			<th class="date">Time</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="LogJS.qry">
			<tr>
				<td class="num">#LogJSID#</td>
				<td class="num">#LogCF_UsrID#</td>
				<td class="num">
					<cfif LogJSSort>
						#LogJSSort#
					</cfif>
				</td>
				<td class="num">
					<cfif LogJSElapsed>
						#NumberFormat(LogJSElapsed)#
					</cfif>
				</td>
				<td>#LogJSPathName#</td>
				<td><a href="Desc.cfm?LogJSID=#LogJSID#">#LogJSName#</a></td>
				<td class="date" data-date="#DateFormat(LogJSDateTime,'yyyymmdd')##TimeFormat(LogJSDateTime,'HHmmss.l')#">
					<cfif SaveDate NEQ DateFormat(LogJSDateTime,"mm/dd")>
						<cfset SaveDate = DateFormat(LogJSDateTime,"mm/dd")>
						#SaveDate#
					</cfif>
				</td>
				<td class="time" data-time="#TimeFormat(LogJSDateTime,'HHmmss.l')#">#TimeFormat(LogJSDateTime,'h:mm:ss.llltt')#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>