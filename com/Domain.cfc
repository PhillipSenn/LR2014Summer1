component extends="ReadWhereDelete" {
Variables.fw.DataSource = 'fw'
Variables.fw.TableName = 'Domain'
Variables.fw.TableSort = 'DomainID'

function WhereDomainName() {
	include '/Inc/newQuery.cfm'
	local.sql = "SELECT * FROM fw.dbo.Domain WHERE DomainName='summer.Lenoir-Rhyne.com'"
	include '/Inc/execute.cfm'
	return local.result.qry.DomainID
}
}
