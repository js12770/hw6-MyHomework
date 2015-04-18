$ ->
	forbid-uploading-homework-after-deadline!

forbid-uploading-homework-after-deadline = !->
	date = new Date!
	year = date.get-full-year! + ''
	if date.get-month! < 10 then month = '0' + (date.get-month! + 1) else month = (date.get-month! + 1) + ''
	if date.get-date! < 10 then day = '0' + date.get-date! else day = date.get-date! + ''
	if date.get-hours! < 10 then hours = '0' + date.get-hours! else hours = date.get-hours! + ''
	if date.get-minutes! < 10 then minutes = '0' + date.get-minutes! else minutes = date.get-minutes! + ''
	now = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes
	homeworks = $ 'table tbody tr'
	homeworks.add-class 'success'
	for homework in homeworks
		homework = $ homework
		deadline = homework.find '.before-deadline'
		upload-btn = homework.find '.upload-hw'
		if deadline.text! <= now
			homework.add-class 'warning'
			deadline.add-class 'after-deadline' .remove-class 'before-deadline' 
			upload-btn.add-class 'disabled'
