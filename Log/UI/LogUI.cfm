<cfscript>
if (StructKeyExists(url,"LogUIID")) {
	LogUI = new com.LogUI().Read(url)
} else {
	LogUI = new com.LogUI().Where()
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
			<th class="num">LogUI</th>
			<th class="num">User</th>
			<th class="num">Sort</th>
			<th>LogUIName</th>
			<th>Tag</th>
			<th>TagName</th>
			<th>ID</th>
			<th>Class</th>
			<th>Destination</th>
			<th>Value</th>
			<th class="num">Date</th>
			<th class="num">Time</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="LogUI.qry">
			<tr>
				<td class="num">#LogUIID#</td>
				<td class="num">#LogCF_UsrID#</td>
				<td class="num">
					<cfif LogUISort>
						#LogUISort#
					</cfif>
				</td>
				<td>
					<cfif FindNoCase('UniqueID',LogUIName)>
						UniqueID=?
					<cfelse>
						#LogUIName#
					</cfif>
				</td>
				<td>#LogUITag#</td>
				<td>#LogUITagName#</td>
				<td>#LogUIIdentifier#</td>
				<td>#LogUIClass#</td>
				<td>#LogUIDestination#</td>
				<td>#LogUIValue#</td>
				<td class="date" data-date="#DateFormat(LogUIDateTime,'yyyymmdd')##TimeFormat(LogUIDateTime,'HHmmss.l')#">
					<cfif SaveDate NEQ DateFormat(LogUIDateTime,"mm/dd")>
						<cfset SaveDate = DateFormat(LogUIDateTime,"mm/dd")>
						#SaveDate#
					</cfif>
				</td>
				<td class="time" data-time="#TimeFormat(LogUIDateTime,'HHmmss.l')#">#TimeFormat(LogUIDateTime,'h:mm:ss.llltt')#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>