init-for-teacher = ->
	$ '.publish_homework' .click !->
		$ '.form-publish-homework' .fadeIn 200
	$ '.cancle' .click !->
		$ '.form-publish-homework' .fadeOut 200
		$ '.form-control' .val ''
		$ '#deadline' .val ''
		return false;

$ ->
	$ '.form-publish-homework' .fadeOut 0
	init-for-teacher!