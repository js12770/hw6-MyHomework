init-for-teacher = ->
	$ '.publish_homework' .click !->
		$ '.form-publish-homework' .fadeIn 200
	$ '.cancle' .click !->
		$ '.form-publish-homework' .fadeOut 200
		$ '.form-control' .val ''
		$ '#deadline' .val ''
		return false;
	for let button, i in $ '.homework'
		$ '.homework'+i .fadeOut 0
		button .onclick = ->
			$ '.homework'+i .fadeIn 200

	for let cancle, i in $ '.homework-cancle'
		cancle .onclick = ->
			$ '.homework'+i .fadeOut 200
			return false
			

$ ->
	$ '.form-publish-homework' .fadeOut 0
	init-for-teacher!