component {
function Read() {
	include '/Inc/newQuery.cfm'
	local.sql="SELECT * FROM X"
	include '/Inc/execute.cfm'
}
}