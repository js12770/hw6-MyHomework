$ ->
	revising-homework-after-deadline!
revising-homework-after-deadline = !->
	date = new Date!
	year = date.get-full-year! + ''
	if date.get-month! < 10 then month = '0' + (date.get-month! + 1) else month = (date.get-month! + 1) + ''
	if date.get-date! < 10 then day = '0' + date.get-date! else day = date.get-date! + ''
	if date.get-hours! < 10 then hours = '0' + date.get-hours! else hours = date.get-hours! + ''
	if date.get-minutes! < 10 then minutes = '0' + date.get-minutes! else minutes = date.get-minutes! + ''
	now = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes
	homeworks = $ 'table tbody tr'
	if homeworks.length is 0 then $ 'button'.add-class 'disabled'
	for homework in homeworks
		homework = $ homework
		homeworks.add-class 'success'
		deadline = homework.find '.before-deadline'
		revise-btn = homework.find '.hidden'
		edit-btn = homework.find '.edit'
		if deadline.text! <= now
			homework.add-class 'warning' .remove-class 'success'
			deadline.add-class 'after-deadline' .remove-class 'before-deadline' 
			revise-btn.remove-class 'hidden'
			edit-btn.remove!
