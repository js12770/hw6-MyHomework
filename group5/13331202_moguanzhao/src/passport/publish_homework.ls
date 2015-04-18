require! {Homework:'../models/homework'}

module.exports = (req, res, next)->
	(error, homeworks) <- Homework.find {}

	new-homework = new Homework {
		id: homeworks.length
		title: req.param 'title'
		content: req.param 'content'
		deadline: req.param 'deadline'
	}
	new-homework.save (error)->
		if error
			console.log "Error in saving homework: ", error
			throw error
		else
			console.log "Homework publish success"
			next?!

