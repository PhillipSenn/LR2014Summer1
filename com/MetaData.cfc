component {
Variables.MetaData = GetMetaData()

function myMeta() {
	include "getMetaData.cfm"
	dump(Variables.MetaData)
	dump(local.MetaData)
}
}
