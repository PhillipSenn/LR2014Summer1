// head = local for the head function
// col  = local scope for the column
// row  = local scope for the row
// tr   = Table Row element
if (typeof fw == 'undefined') fw={};
$(window).load(Sortable)

function Sortable() {
	fw.sortable = function(index, element) { // This is called from draggable.js
		element.find('th .fwUnicode').remove()
		processHead(0,element)
	}
	$('body table').not('.no-sort').find('thead').each(processHead)
	function processHead(index, element) {  // body thead because of ColdFusion info
		var head = {}
		
		//head.index = index
		//log('head.index: ' + head.index)
		head.thead = $(element)
		head.table = head.thead.closest('table')
		head.firstRow = head.table.find('tbody > tr:first-child')

		head.thead.find('th').not('.no-sort').addClass('fwSortable').each(processColumn)
		function processColumn(index, element) {
			var col = {}
			col.index = index // Trying to scope every variable.
			col.th = $(element)
			//log('col.index: ' + col.index)
			col.firstCell = head.firstRow.children('td:eq(' + col.index + ')')
			col.diff = col.firstCell.text() // The text of the first cell.
			col.ascending = true // The entire column is in ascending order.
			col.hasClassDate = col.th.hasClass('date') // <td class="date" data-date="#DateFormat(DateTime,'yyyymmdd')##TimeFormat(DateTime,'HHmmss.l')#">#DateFormat(DateTime,'mm/dd')#</td>
			col.hasClassTime = col.th.hasClass('time') // <td class="time" data-time="#TimeFormat(DateTime,'HHmmss.l')#">#TimeFormat(DateTime,'h:mm:ss.llltt')#</td>
			col.hasClassNum = col.th.hasClass('num')
			col.differences = false // If every single value is the same, then don't show a ascending arrow
			col.tr = head.table.find('tbody > tr')
			col.tr.each(processAscending)
			col.descending= false // The entire column is in descening order.
			if (!col.ascending && col.differences) {
				col.descending = true
				col.tr.each(processDescending)
			}
			if (col.differences) {
				if (col.ascending) {
					col.th.addClass('fwAscending').append('<span class="fwUnicode">&#9650;</span>') // http://www.charbase.com/25b3-unicode-white-up-pointing-triangle
				} else if (col.descending) {
					col.th.addClass('fwDescending').append('<span class="fwUnicode">&#9660;</span>') // http://www.charbase.com/25bc-unicode-black-down-pointing-triangle
				} else {
					col.th.append('<span class="fwUnicode">&nbsp;</span>') // So that they can click on the th element.
				}
			}
			function processAscending(index, element) {
				var row = {}
				
				row.index = index
				row.tr = $(element)
				row.text = row.tr.children('td:eq(' + col.index + ')').text()
				if (col.hasClassNum) {
					row.text = row.text.replace(/,/g ,'')
					row.text = parseFloat(row.text)
				} else {
					row.text = $.trim(row.text)
				}
				if (col.hasClassDate) {
					row.text = row.tr.children('td:eq(' + col.index + ')').data('date') || row.text
				} else if (col.hasClassTime) {
					row.text = row.tr.children('td:eq(' + col.index + ')').data('time') || row.text
					row.text = parseFloat(row.text)
				}
				if (row.index) {
					if (row.text < col.text) {
						col.ascending = false
						col.differences = true
						return false
					}
					if (row.text > col.text) {
						col.text = row.text
						col.differences = true
					}
				} else {
					col.text = row.text
				}
			}

			function processDescending(index, element) {
				var row = {}
				
				row.index = index
				row.tr = $(element)
				row.text = row.tr.children('td:eq(' + col.index + ')').text()
				if (col.hasClassNum) {
					row.text = row.text.replace(/,/g ,'')
					row.text = parseFloat(row.text)
				} else {
					row.text = $.trim(row.text)
				}
				if (col.hasClassDate) {
					row.text = row.tr.children('td:eq(' + col.index + ')').data('date') || row.text
				} else if (col.hasClassTime) {
					row.text = row.tr.children('td:eq(' + col.index + ')').data('time') || row.text
					row.text = parseFloat(row.text)
				}
				if (row.index) { // if we're not on row 1
					if (row.text > col.text) {
						col.descending = false
						return false
					}
				} else {
					col.text = row.text
				}
			}
		}
	}
}

;(function() {
	$(document).on('click','th a',hyperlinkClicked)// if they put a hyperlink inside a th element
	function hyperlinkClicked(myEvent) {
		myEvent.stopPropagation() // you don't want to sort the column when they choose the hyperlink.
	}
})()

;(function() {
	$(document).on('click','th.fwSortable',thSortable) // Whenever any th.fwSortable is clicked
	function thSortable() {
		var col = {}
	
		col.th = $(this)
		col.table = col.th.closest('table')
		col.column = col.th.index()
		col.hasClassNum  = col.th.hasClass('num')
		col.hasClassDate = col.th.hasClass('date')
		col.rows = col.table.find('tbody > tr')
		
		col.hadClassAscending = col.th.hasClass('fwAscending')
	
		col.th.closest('tr').find('th').removeClass('fwDescending fwAscending ').find('.fwUnicode').removeClass('fwSubSort').html('&nbsp;')
		if (col.hadClassAscending) {
			col.th.addClass('fwDescending').find('.fwUnicode').html('&#9660;')
			col.rows.sort(function(rowA, rowB) {
				return -sortAsc(rowA,rowB)
			})
		} else {
			col.th.addClass('fwAscending').find('.fwUnicode').html('&#9650;')
			col.rows.sort(sortAsc)
		}
		$.each(col.rows,function(index, element){
			col.table.children('tbody').append(element)
		})
		function sortAsc(rowA,rowB) {
			var row = {}
			
			row.a = $(rowA).children('td:eq(' + col.column + ')').text()
			row.b = $(rowB).children('td:eq(' + col.column + ')').text()
			row.a = $.trim(row.a) // probably not necessary
			row.b = $.trim(row.b) // probably not necessary
			if (col.hasClassDate) {
				row.a = $(rowA).children('td:eq(' + col.column + ')').data('date') || row.a
				row.b = $(rowB).children('td:eq(' + col.column + ')').data('date') || row.b
				return row.a - row.b
			}
			if (col.hasClassNum) {
				row.a = row.a.replace(/,/g ,'') // strip commas
				row.b = row.b.replace(/,/g ,'') // strip commas
				return row.a - row.b
			}
			if (row.a < row.b) return -1
			if (row.a > row.b) return 1
			return 0
		}
	}
})()
