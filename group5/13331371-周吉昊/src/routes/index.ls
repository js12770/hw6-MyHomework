require! ['express']
require! {Homework:'../models/homework'}
router = express.Router! 

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = (passport)->
	router.get '/', (req, res)!-> res.render 'index', message: req.flash 'message'

	router.post '/login', passport.authenticate 'login', {
		success-redirect: '/home', failure-redirect: '/', failure-flash: true
	}

	router.get '/signup', (req, res)!-> res.render 'register', message: req.flash 'message'

	router.post '/signup', passport.authenticate 'signup', {
		success-redirect: '/home', failure-redirect: '/signup', failure-flash: true
	}

	router.get '/home', is-authenticated, (req, res)!->
		Homework.find {forList: true}, (err, homeworks)->
				if req.user.isTeacher
						Homework.find {forList: false}, (err, handedinhomeworks)->
								res.render 'home', user: req.user, homeworks: homeworks, handedinhomeworks: handedinhomeworks
				else
						Homework.find {author: req.user.username}, (err, handedinhomeworks)->
								res.render 'home', user: req.user, homeworks: homeworks, handedinhomeworks: handedinhomeworks

	router.get '/signout', (req, res)!-> 
		req.logout!
		res.redirect '/'

	router.get '/homework', (req, res)!->
		Homework.find {forList: true}, (err, homeworks)->
				if req.user.isTeacher
						Homework.find {forList: false}, (err, handedinhomeworks)->
								res.render 'homework', user: req.user, homeworks: homeworks, handedinhomeworks: handedinhomeworks
				else
						Homework.find {author: req.user.username}, (err, handedinhomeworks)->
								res.render 'homework', user: req.user, homeworks: homeworks, handedinhomeworks: handedinhomeworks
		message: req.flash 'message'

	router.post '/homework', (req, res)!->
		res.redirect '/homework'

	router.post '/createhomework', is-authenticated, (req, res)!->
		if !req.user.isTeacher
			console.log msg = "only teacher has permission to create homework"
			res.render 'homework', user: req.user, message: msg
		else
			Homework.count {}, (err, count)->
				new-homework = new Homework {
					id: count
					content: req.param 'content'
					author: req.user.username
					deadline: new Date(req.param('deadline'))
					forList: true
				}
				new-homework.save (error)->
					if error
						console.log "Error in saving homework: ", error
						throw error
					else
						console.log msg = "create successfully"
						res.redirect '/homework'

	router.post '/changedeadline', is-authenticated, (req, res)!->
		if !req.user.isTeacher
			console.log msg = "Only the teacher can change the deadline."
			res.render 'homework', user: req.user, message: msg
		else
				Homework.findOne {id: req.param('id')}, (err, homework)->
						if !homework
								console.log msg = "Invalid ID"
								res.render 'homework', user: req.user, message: msg
						else
								homework.deadline = new Date(req.param('deadline'))
								homework.save !->
										res.redirect '/homework'

	router.post '/handinhomework', is-authenticated, (req, res)->
		if req.user.isTeacher
			console.log msg = "Only student can hand in homework."
			res.render 'homework', user: req.user, message: msg
		else
				Homework.findOne {id: req.param('id')}, (err, homework)->
						if !homework
								console.log msg = "Invalid ID"
								res.render 'homework', user: req.user, message: msg
						else
								if homework.deadline > new Date()
										Homework.count {}, (err, count)->
												new-homework = new Homework {
														id: parseInt(req.param('id')) * -1
														content: req.param 'content'
														author: req.user.username
														forList: false
												}
												new-homework.save (error)->
														if error
																console.log "Error in saving homework: ", error
																throw error
														else
																console.log msg = "create successfully"
																res.redirect '/homework'
								else
										console.log msg = "Deadline passed"
										res.render 'homework', user: req.user, message: msg

	router.post '/givescore', is-authenticated, (req, res)!->
		if !req.user.isTeacher
			console.log msg = "Only the teacher has permission to give a score"
			res.render 'homework', user: req.user, message: msg
		else
				Homework.findOne {id: parseInt(req.param('id')) * -1}, (err, homework)->
						if homework.deadline < new Date()
								Homework.findOne {id: req.param('id'), author: req.param('studentname')}, (err, homework)->
										if !homework
												console.log msg = "Invalid id or student name"
												res.render 'homework', user: req.user, message: msg
										else
												homework.score = parseInt req.param('score')
												homework.save !->
														res.redirect '/homework'
						else
								console.log msg = "You can't give a score before the deadline."
								res.render 'homework', user: req.user, message: msg
