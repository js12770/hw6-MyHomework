require! {'express', Course: '../models/courses', Content:'../models/homeworkContent', Homework:'../models/homework'}

router = express.Router!

is-student = (req, res, next)->
	if req.user.character == 'student'
		next! 
	else 
		res.write "You're not student!"

is-teacher = (req, res, next)->
	if req.user.character == 'teacher'
		next! 
	else 
		res.write "you're not teacher!"

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

module.exports = router

router.get '/', is-authenticated, (req, res)!->
	course_id = req.query.course
	console.log course_id
	console.log 'homework home'
	Course.find-one {_id: course_id}, (err, course)!->
		console.log course
		homeworks = Homework.find {course-id: course._id}, (err, homeworks)!->
			console.log homeworks
			res.render 'homeworkList', homeworks: homeworks, user: req.user, course: course


router.get '/detail/:homeworkId', is-authenticated, (req, res)!->
	user = req.user
	console.log user
	Homework.find-one {_id: req.params.homeworkId}, (err, homework)!->
		if err
			console.log('Failed to find the homework')
		if user.character is 'teacher'
			Content.find {homework-id: homework._id}, (err, contents)!->
				if err then console.log('No contents')
				res.render 'homeworkDetail', contents: contents, user: user, homework: homework
		else
			console.log 'homework is'
			console.log homework._id
			console.log user._id
			Content.find-one {homework-id: homework._id, writer-id: user._id}, (err, content)!->
				res.render 'homeworkDetail', content: content, user: user, homework: homework

router.get '/create', is-authenticated, is-teacher, (req, res)->
	course-id = req.query.course-id
	console.log course-id
	res.render 'createHomework', courseId: course-id

router.post '/create/:courseId', is-authenticated, is-teacher, (req, res)->
	course-id = req.param.course-id
	Homework.find-one {name: req.params.name} (err, homework)!->
		console.log req.params.course-id + "..."
		if homework then res.write("This homework has existed!")
		else
			new-homework = new Homework {
				name: req.param 'name'
				deadline: req.param 'deadline'
				content: req.param 'content'
				course-id: req.params.course-id
			}
			new-homework.save!
			res.redirect '/courses'

router.get '/content/:contentId', is-authenticated, is-teacher, (req, res)->
	Content.find-one {_id: req.params.content-id}, (err, content)!->
		if not content
			res.write 'The homework doesn\'t exist!'
			res.end!
		else
			res.render 'homeworkContent', content:content, user:req.user

router.post "/enscore/:contentId", is-authenticated, is-teacher, (req, res)->
	Content.find-one {_id: req.params.content-id}, (err, content)!->
		if not content
			res.write 'The homework doesn\'t exist!'
			res.end!
		else
			Homework.find-one {_id: content.homework-id}, (err, homework)!->
				if (nowDate = new Date()) < homework.deadline
					res.write 'It\' s not time to enscore!'
					res.end!
					return
				content.score = req.param 'score'
				content.save!
				res.redirect '/home'

router.get "/edit/:homeworkId", is-authenticated, is-teacher, (req, res)->
	Homework.find-one {_id: req.params.homeworkId}, (err, homework)!->
		if not homework
			res.write 'The homework doesn\'t exist!'
			res.end!
		else
			nowDate = new Date()
			if (nowDate >= homework.deadline)
				res.write 'The deadline has passed!'
				res.end!
			else
				res.render 'editHomework', user: req.user, homework: homework

router.post "/edit/:homeworkId", is-authenticated, is-teacher, (req, res)->
	Homework.find-one {_id: req.params.homeworkId}, (err, homework)!->
		if not homework
			res.write 'The homework doesn\'t exist!'
			res.end!
		else
			if (nowDate >= homework.deadline)
				res.write 'The deadline has passed!'
				res.end!
			else
				homework.deadline = req.param 'deadline'
				homework.instruction = req.param 'instruction'
				homework.name = req.param 'name'
				homework.save!
				res.redirect '/home'

router.get "/write/:contentId", is-authenticated, is-student, (req, res)->
	console.log req.user
	Content.find-one {writer-id: req.user._id, _id: req.params.content-id}, (err, content)!->
		if not content
			content = new Content {
				homework-id: req.query.homework,
				content: '',
				writer-id: req.user._id,
				score: 'unscored'
			}
			console.log 'A new content'
			content.save!

		Homework.find-one {_id: content.homework-id}, (err, homework)!->
			if (nowDate = new Date()) >= homework.deadline
				res.write 'The deadline has passed!'
				res.end!
				return
			Course.find-one {_id: homework.course-id}, (err, course)!->
				res.render 'writeHomework', user:req.user, course-name:course.name, content:content

router.post '/write/:contentId', is-authenticated, is-student, (req, res)->
	console.log req.user
	console.log 'no'
	user = req.user
	Content.find-one {writer-id: req.user._id, _id: req.params.content-id}, (err, content)!->
		if not content
			res.write 'Error'
			res.end!
		else
			Homework.find-one {_id: content.homework-id} (err, homework)!->
				if (nowDate = new Date()) >= homework.deadline
					res.write 'The deadline has passed!'
					res.end!
					return
				content.content = req.param 'content'
				content.save!
				res.redirect('/home')

