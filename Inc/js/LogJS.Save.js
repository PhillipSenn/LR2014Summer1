(function() {
	var local = {}
	local.type 			= 'POST'
	local.dataType		= 'text'
	local.url			= '/Inc/js/LogJS.cfc'
	local.data			= {}
	local.data.method	= 'Save'
	local.data.LogJSName = 'LogJS.Save'
	local.data.LogJSDesc = ''
	local.data.LogJSSort = 1000
	local.data.LogJSPathName = window.location.pathname
	local.Promise = $.ajax(local)
})()