(function() {
	var local = {};
	
	$('body table').not('.no-drag').find('thead').each(processHead);
	function processHead(index, element) {
		var head = {};
		head.thead = $(element);
		head.table = head.thead.closest('table');
		head.firstRow = head.table.find('tbody > tr:first-child');
		head.thead.find('th').not('.no-drag').addClass('fwDraggable');
	}
	if ($('body thead th').length) {
		local.containment = 'parent';
		local.revert = true;
		$('body thead th').draggable(local);
		$('body thead th').droppable({
			drop: dropZone
		});
	}
	function dropZone(myEvent, myUI ) {
		var head = {};
		
		head.dragIndex = myUI.draggable.index();
		head.dropIndex = $(this).index();
		//log('dragIndex: ' + head.dragIndex);
		//log('dropIndex: ' + head.dropIndex);
		head.rows = $(this).closest('thead').find('tr:first');
		head.cellIndex = head.rows.find('th').length-1;
		//log('head.cellIndex: ' + head.cellIndex);
		head.rows.each(processTableHeaderRows);
		// Same thing here for td instead of th
		head.table = $(this).closest('table');
		head.table.find('tbody > tr').each(processRows);
		fw.sortable(0,head.table); // Modeled after .each(function(index, element) {}

		function processTableHeaderRows(index, element) {
			var row = {}
			
			row.tr = $(element);
			row.drag = row.tr.find('th:eq(' + head.dragIndex + ')');
			row.drop = row.tr.find('th:eq(' + head.dropIndex + ')');
			if (head.dropIndex === head.cellIndex) {
				row.drag.detach().insertAfter(row.drop);
			} else {
				row.drag.detach().insertBefore(row.drop);
			}
		}
		function processRows(index, element) {
			var row = {};
			
			row.tr = $(element);
			row.drag = row.tr.find('td:eq(' + head.dragIndex + ')');
			row.drop = row.tr.find('td:eq(' + head.dropIndex + ')');
			if (head.dropIndex === head.cellIndex) {
				row.drag.detach().insertAfter(row.drop);
			} else {
				row.drag.detach().insertBefore(row.drop);
			}
		}
	}
})();
