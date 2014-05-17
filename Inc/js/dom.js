var dom = {}
dom.msg = $('.msg')
dom.main = $('#main')

dom.failure = function(svc, SQLError) {
	dom.msg.text(SQLError.message).addClass('label-danger')
	debugger
}
dom.fail = function (xhr, status, response) {
	dom.msg.text(status + ': ' + response).addClass('label-danger')
	dom.main.html(xhr.responseText)
	debugger
}

window.onerror = function(myError) {
	console.log('window.onerror')
}

window.log = function(arg) {
	console.log(arg)
}