<cfscript>
if (StructKeyExists(url,"LogDBID")) {
	LogDB = new com.LogDB().Read(url)
} else {
	LogDB = new com.LogDB().Where()
}
SaveDate = ''
US = getPageContext().getRequest().getRemoteAddr()
Variables.fw.container = false
</cfscript>

<cfoutput>
<cfinclude template="/Inc/html.cfm">
<cfinclude template="/Inc/body.cfm">
<table>
	<thead>
		<tr>
			<th class="num">User</th>
			<th class="num">LogDBID</th>
			<th class="num">Sort</th>
			<th class="num">Elapsed</th>
			<th>Function</th>
			<th>LogDBName</th>
			<th class="num">Record<br>Count</th>
			<th class="num">Exec<br>Time</th>
			<th class="num">Date/Time</th>
			<th>IP Address</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="LogDB.qry">
			<tr>
				<td class="num">
					<a href="../Usr/Usr.cfm?UsrID=#LogCF_UsrID#">#LogCF_UsrID#</a>
				</td>
				<td class="num">#LogDBID#</td>
				<td class="num">
					<cfif LogDBSort>
						#LogDBSort#
					</cfif>
				</td>
				<td class="num">
					<cfif LogDBElapsed>
						#LogDBElapsed#
					</cfif>
				</td>
				<td>
					<cfif LogDBComponentName NEQ "">
						#LogDBComponentName#()<br>
					</cfif>
					#LogDBFunctionName#
				</td>
				<cfset myClass = ''>
				<cfif LogDBFunctionName EQ "WhereUniqueID()">
					<cfset Variables.LogDBName = "SELECT * FROM UsrView WHERE UniqueID=?">
				<cfelseif FindNoCase('UniqueID',LogDBName)>
					<cfset Variables.LogDBName = "UniqueID found in cmd">
					<cfset myClass = 'label-danger'>
				<cfelse>
					<cfset Variables.LogDBName = LogDBName>
				</cfif>
				<td class="pre #myClass#">#Variables.LogDBName#</td>
				<td class="num">
					<cfif LogDBRecordCount>
						#LogDBRecordCount#
					</cfif>
				</td>
				<td class="num">
					<cfif LogDBExecutionTime>
						#LogDBExecutionTime#ms
					</cfif>
				</td>
				<td class="num monospace">
					<cfif SaveDate NEQ DateFormat(LogDBDateTime,"mm/dd/yyyy")>
						<cfset SaveDate = DateFormat(LogDBDateTime,"mm/dd/yyyy")>
						#SaveDate# <br>
					</cfif>
					#TimeFormat(LogDBDateTime,"h:mm:ss.llltt")#
				</td>
				<cfif RemoteAddr EQ US>
					<td title="#us#">
						us
					</td>
				<cfelseif RemoteAddr EQ "216.198.198.150">
					<td title="#RemoteAddr#">VPS</td>
				<cfelse>
					<td>#RemoteAddr#</td>
				</cfif>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/Inc/foot.cfm">
<cfinclude template="/Inc/End.cfm">
</cfoutput>