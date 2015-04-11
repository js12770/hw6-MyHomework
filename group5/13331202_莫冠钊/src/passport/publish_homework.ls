require! {Homework:'../models/homework'}

module.exports = (req, res, next)->
	new-homework = new Homework {
		title: req.param 'title'
		content: req.param 'content'
		deadline: req.param 'deadline'
	}
	new-homework.save (error)->
		if error
			console.log "Error in saving user: ", error
			throw error
		else
			console.log "User registration success"
			next?!

