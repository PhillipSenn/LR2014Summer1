dom.hideCorrectAnswers = $('#hideCorrectAnswers')
Applause = new Audio('Applause.wav') // C:\Program Files\Microsoft Office 15\root\office15\MEDIA

;(function() {
	var Variables = {}
	Variables.start = function(myEvent, ui ) {
		$(this).addClass('btn-info')
	}
	Variables.stop = function(myEvent, ui ) {
		$(this).removeClass('btn-info')
	}
	Variables.revert = true
	$('.AnswerID').draggable(Variables)
})()

;(function() {
	var myDroppable = {}
	myDroppable.over = function(myEvent, ui ) {
		$(this).removeClass('ui-state-error').addClass('ui-state-highlight')
	}
	myDroppable.out = function(myEvent, ui ) {
		$(this).removeClass('ui-state-highlight')
	}
	myDroppable.drop = function(myEvent, ui ) {
		var local = {}

		// $('body').animate({scrollTop: 0})
		local.type = 'POST'
		local.url = 'Matching.cfc'
		local.dataType = 'json'
		local.data = {}
		local.data.method = 'Save'
		local.data.GuessID = myEvent.target.id
		local.data.GuessID = local.data.GuessID.substr(5) // Guess123
		local.data.AnswerID = ui.draggable[0].id
		local.data.AnswerID = local.data.AnswerID.substr(6) // Answer123
		local.context = local.data
		local.Promise = $.ajax(local)
		local.Promise.done(done)
		local.Promise.fail(fail)
	}
	$('.GuessID').droppable(myDroppable)

	function done(response,status,xhr) {
		var local = {}
		local.Earned = response.qry.DATA[0][0]
		local.SumEarned = response.qry.DATA[0][1]
		if (local.Earned) {
			$('#Answer' + this.AnswerID).removeClass('ui-state-error').addClass('ui-state-focus').prepend('&#10004;')
			$('#Guess' + this.GuessID).removeClass('ui-state-error ui-state-highlight ui-droppable').addClass('ui-state-focus').append('&#10004;')
			$('.progress-bar').css({width: local.SumEarned + '%'})
			$('#Earned').text('Earned: ' + local.SumEarned)
			if (local.SumEarned >= 100) {
				PostAttendance()
				dom.hideCorrectAnswers.removeAttr('checked') // showCorrectAnswers()!
				Applause.play()
			}
			hideCorrectAnswers()
			
		} else {
			$('#Answer' + this.AnswerID).addClass('ui-state-error')
			$('#Guess' + this.GuessID).addClass('ui-state-error')
		}
	}
	function fail(xhr,status,response) {
		dom.fail(xhr,status,response)
	}
	
	dom.hideCorrectAnswers.click(hideCorrectAnswers)
	function hideCorrectAnswers() {
		
		if (dom.hideCorrectAnswers.is(':checked')) {
			$('.ui-state-focus').slideUp('slow')
		} else {
			$('.ui-state-focus').slideDown('slow')
		}
	}
	
	function PostAttendance() {
		var local = {}

		local.type = 'POST'
		local.url = '/com/Attendance.cfc'
		local.dataType = 'text'
		local.data = {}
		local.data.method = 'PostAttendance'
		local.data.PaperID = $('#PaperID').val()
		local.Promise = $.ajax(local)
		local.Promise.done(PostAttendanceDone)
		local.Promise.fail(PostAttendanceFail)
	}
	function PostAttendanceDone(response,status,xhr) {
		$('.progress').addClass('progress-striped active')
	}
	function PostAttendanceFail(xhr, status, response) {
		dom.fail(xhr, status, response)
		debugger
	}
})()

;(function() {
	$(document).on('change','select',selectChanged)
	function selectChanged() {
		$(this).closest('form').submit()
	}
})()