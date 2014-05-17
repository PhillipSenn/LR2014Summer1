;(function() {
	var local = {}

	local.type = 'POST'
	local.url = 'LogJS.cfc'
	local.dataType = 'text'
	local.data = {}
	local.data.method = 'Save'
	local.data.LogJSName = 'timeEnd'
	local.data.LogJSDateTime = new Date()
	local.Promise = $.ajax(local)
	local.Promise.done(done)
	local.Promise.fail(fail)

	function done(response,status,xhr) {
	}
	function fail(xhr,status,response) {
		dom.fail(xhr,status,response)
		debugger
	}
})()