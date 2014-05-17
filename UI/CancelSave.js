(function() {
	$(document).on('keydown','*',changed)
	function changed() {
		$('button[name=Save]').removeClass('hidden')
		$('#Cancel').hide()
	}
})()