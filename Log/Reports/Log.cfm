<cfscript>
Log = new Log().GrandUnification()
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
			<th>Type</th>
			<th class="num">Primary<br>Key</th>
			<th class="num">Date/Time</th>
			<th class="num">User</th>
			<th class="num">CF</th>
			<th class="num">DB</th>
			<th class="num">DBSort</th>
			<th class="num">JSSort</th>
			<th class="num">Elapsed</th>
			<th>Name</th>
			<th>Description</th>
			<th>More Info</th>
			<th>IP Address</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="Log.qry">
			<tr>
				<td>#Type#</td>
				<td class="num">#PrimaryKey#</td>
				<td class="num monospace">
					<cfif SaveDate NEQ DateFormat(LogDateTime,"mm/dd/yyyy")>
						<cfset SaveDate = DateFormat(LogDateTime,"mm/dd/yyyy")>
						#SaveDate# <br>
					</cfif>
					#TimeFormat(LogDateTime,"H:mm:ss.lll")#
				</td>
				<td class="num">
					<cfif PersonID>
						<a href="../Person/Person.cfm?PersonID=#PersonID#">#PersonID#</a>
					</cfif>
				</td>
				<td class="num">
					<cfif LogCFID>
						<a href="LogCF.cfm?LogCFID=#LogCFID#">#LogCFID#</a>
					</cfif>
				</td>
				<td class="num">
					<cfif LogDBID>
						<a href="../LogDB/LogDB.cfm?LogDBID=#LogDBID#">#LogDBID#</a>
					</cfif>
				</td>
				<td class="num">
					<cfif DBSort>
						#DBSort#
					</cfif>
				</td>
				<td class="num">
					<cfif JSSort>
						#JSSort#
					</cfif>
				</td>
				<td class="num">
					#Elapsed#
				</td>
				<td>
					<cfset Variables.LogName = Replace(LogName,'814F7845-1C3F-4F42-BD1C-4A3301AF89BF','(snip)','all')>
					#Variables.LogName#
				</td>
				<td>#Description#</td>
				<td>
					<cfset Break = ''>
					<cfif Varchar1 NEQ "">
						<cfif Type EQ "CF">
							<a href="LogCFOutString.cfm?LogCFID=#PrimaryKey#">Output:&nbsp;#Len(Varchar1)#</a>
							<cfset Break = '<br>'>
						<cfelseif Type EQ "UI">
							#Varchar1#
							<cfset Break = '<br>'>
						</cfif>
					</cfif>
					<cfif Varchar2 NEQ "">
						<cfif Type EQ "CF">
							#Break#<a href="LogCFUserAgent.cfm?LogCFID=#PrimaryKey#">UserAgent:&nbsp;#Len(Varchar2)#</a>
							<cfset Break = '<br>'>
						<cfelseif Type EQ "UI">
							#Break#<a href="LogUIDestination.cfm?LogUIID=#PrimaryKey#">#Varchar2#</a>
							<cfset Break = '<br>'>
						</cfif>
					</cfif>
					<cfif Varchar4 NEQ "">
						<cfif Type EQ "CF">
							#Break#<a href="LogCFURL.cfm?LogCFID=#PrimaryKey#">URL:&nbsp;#Len(Varchar4)#</a>
							<cfset Break = '<br>'>
						</cfif>
					</cfif>
					<cfif Varchar5 NEQ "">
						<cfif Type EQ "CF">
							#Break#<a href="LogCFForm.cfm?LogCFID=#PrimaryKey#">Form:&nbsp;#Len(Varchar5)#</a>
							<cfset Break = '<br>'>
						</cfif>
					</cfif>
					<cfif Varchar6 NEQ "">
						<cfif Type EQ "CF">
							#Break#<a href="LogCFSession.cfm?LogCFID=#PrimaryKey#">Session:&nbsp;#Len(Varchar6)#</a>
							<cfset Break = '<br>'>
						</cfif>
					</cfif>
					<cfif Int1>
						<cfif Type EQ "DBErr">
							#Break#DB Code: #Int1#
						<cfelseif Type EQ "CFerr">
							#Break#CF Err: #Int1#
						<cfelseif Type EQ "DB">
							#Break#Exec Time: #Int1#
						</cfif>
						<cfset Break = '<br>'>
					</cfif>
					<cfif Int2>
						<cfif Type EQ "DBErr">
							#Break#SQL State: #Int2#
						<cfelseif Type EQ "CFErr">
							#Break#CF Line: #Int2#
						<cfelseif Type EQ "DB">
							#Break#Rows: #Int2#
						</cfif>
						<cfset Break = '<br>'>
					</cfif>
				</td>
				<!---
				<cfif Int1 AND Type EQ "DBErr">
					<td class="num" title="DB Code">#Int1#</td>
				<cfelseif Int1 AND Type EQ "CFerr">
					<td class="num" title="CF Err Number">#Int1#</td>
				<cfelseif Int1 AND Type EQ "DB">
					<td class="num" title="DB Execution Time">#Int1#</td>
				<cfelse>
					<td></td>
				</cfif>
				<cfif Int2 AND Type EQ "DBErr">
					<td class="num" title="SQL State">#Int2#</td>
				<cfelseif Int2 AND Type EQ "CFErr">
					<td class="num" title="CF Err Line">#Int2#</td>
				<cfelseif Int2 AND Type EQ "DB">
					<td class="num" title="Rows">#Int2#</td>
				<cfelse>
					<td></td>
				</cfif>
				--->
				<cfif RemoteAddr EQ '68.115.122.162'>
					<td title="#RemoteAddr#">
						Atlas
					</td>
				<cfelseif RemoteAddr EQ "204.12.49.139">
					<td title="#RemoteAddr#">VPS</td>
				<cfelseif RemoteAddr EQ US>
					<td title="#us#">
						us
					</td>
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