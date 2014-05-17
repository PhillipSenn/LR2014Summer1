<cfscript>
if (StructKeyExists(url,"LogCFErrID")) {
	LogCFErr = new com.LogCFErr().Read(url)
} else {
	LogCFErr = new com.LogCFErr().Where()
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
			<th class="num">CFErr</th>
			<th class="num">User</th>
			<th class="num">Sort</th>
			<th class="num">Elapsed</th>
			<th class="num">ColdFusion<br>Page</th>
			<th class="num">Number</th>
			<th class="num">Line</th>
			<th>Message</th>
			<th>ErrName</th>
			<th>Detail</th>
			<th>Type</th>
			<th>Event<br>Name</th>
			<th class="date">Date</th>
			<th class="time">Time</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="LogCFErr.qry">
			<tr>
				<td class="num">#LogCFErrID#</td>
				<td class="num">#LogCF_UsrID#</td>
				<td class="num">
					<cfif LogCFErrSort>
						#LogCFErrSort#
					</cfif>
				</td>
				<td class="num">
					<cfif LogCFErrElapsed>
						#LogCFErrElapsed#
					</cfif>
				</td>
				<td class="num"><a href="../LogCF/LogCF.cfm?LogCFID=#LogCFID#">#LogCFID#</a></td>
				<td class="num">
					<cfif LogCFErrNumber>
						#LogCFErrNumber#
					</cfif>
				</td>
				<td class="num">
					<cfif LogCFErrLine>
						#LogCFErrLine#
					</cfif>
				</td>
				<td>#LogCFErrMessage#</td>
				<td>#LogCFErrName#</td>
				<td>#LogCFErrDetail#</td>
				<td>#LogCFErrType#</td>
				<td>#LogCFErrEventName#</td>
				<td class="date" data-date="#DateFormat(LogCFErrDateTime,'yyyymmdd')##TimeFormat(LogCFErrDateTime,'HHmmss.l')#">
					<cfif SaveDate NEQ DateFormat(LogCFErrDateTime,"mm/dd")>
						<cfset SaveDate = DateFormat(LogCFErrDateTime,"mm/dd")>
						#SaveDate#
					</cfif>
				</td>
				<td class="time" data-time="#TimeFormat(LogCFErrDateTime,'HHmmss.l')#">#TimeFormat(LogCFErrDateTime,'h:mm:ss.llltt')#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>