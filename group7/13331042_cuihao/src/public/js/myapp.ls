$ !->
	$ '#datetimepicker' .datetimepicker({
		format: 'yyyy-mm-dd hh:ii'
	})

	

	$ '#changetitle' .click !~>
		title = $ '#title' .text!
		$ '#message-text' .val title
		$ '#dochange' .attr 'temp', 'title'
	$ '#changebrief' .click !~>
		brief = $ '#briefIntroduction' .text!
		$ '#message-text' .val brief
		$ '#dochange' .attr 'temp', 'briefIntroduction'
	$ '#changedetails' .click !~>
		details = $ '#details' .text!
		$ '#message-text' .val details
		$ '#dochange' .attr 'temp', 'details'

	$ '#dochange' .click !~>
		tar-id = $ '#getid' .attr 'temp'
		tar-pro = $ '#dochange' .attr 'temp'
		new-content = $ '#message-text' .val!
		$.post '/change', {id: tar-id, pro: tar-pro, content: new-content}, (flag, state) !~> 
			if (flag == 'true')
				$ '#'+tar-pro .text new-content

	$ '#changedeadline' .click !~>
		tar-id = $ '#getid' .attr 'temp'
		new-content = $ '#datetimepicker' .val!
		$.post '/change', {id: tar-id, pro: 'deadline', content: new-content}, (flag, state) !~> 
			if (flag == 'true')
				$ '#datetimepicker' .val new-content
				$ '#deadline' .text new-content

	$ '#changescore' .click !~>
		tar-id = $ '#getid' .attr 'temp'
		new-content = $ '#score' .val!
		$.post '/remark', {id: tar-id, score: new-content}, (flag, state) !~> 
			if (flag == 'true')
				$ '#score1' .text new-content
