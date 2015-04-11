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
	course_id = req.param 'course'
	Course.find-one {_id: course_id}, (err, course)!->
		console.log course
		homeworks = Homework.find {} .where("_id") .in (course.homework-id) .exec (err, homeworks)!->
			console.log homeworks
			res.render 'homeworkList', homeworks: homeworks, user: req.user

router.get '/:homeworkId', is-authenticated, (req, res)!->
	user = req.user
	homework = Homework.find-one {id: homeworkId}
	res.render 'homeworkDetail', homework: homework, user: user

router.get '/create', is-authenticated, is-teacher, (req, res)->
	render 'createHomework'

router.get '/create', is-authenticated, is-teacher, (req, res)->
	Homework.find-one {name: req.params.name} (err, homework)!->
		if homework then res.write("This homework has existed!")
		else
			new-homework = new Homework {
				name: req.params.name
				content: req.params.content
			}

router.get '/:homeworkId/edit', is-authenticated, is-teacher, (req, res)->
	if not homework
		res.write 'The homework doesn't exist!'
		res.end!
	else
		res.render 'editHomework', homework:homework, user:user

router.get "/:homeworkId/check", is-authenticated, is-teacher, (req, res)->
	contents = Content.find {homework-id:req.params.homework-id}
	res.render 'homeworkContentList', contents:contents

router.get "/:homeworkId/enscore", is-authenticated, is-teacher, (req, res)->
	content = Content.find-one {id: req.params.content-id}
	res.render 'enscoreHomework', content:content

router.post "/:homeworkId/enscore", is-authenticated, is-teacher, (req, res)->
	content = Content.find-one {id: req.params.homework-id}

router.post "/:homeworkId/edit", is-authenticated, is-teacher, (req, res)->
	homework = Homework.find-one {id: homeworkId}
	if not homework
		res.write 'The homework doesn't exist!'
		res.end!
	else
		homework.deadline = req.param 'deadline'
		homework.instruction = req.param 'instruction'
		homework.name = req.param 'name'
		homeworks.save!

router.get '/:homeworkId/write', is-authenticated, is-student, (req, res)->
	content = Content.find-one {writer-id: req.user.id, homework-id: req.params.homeworkId}
	course = Course.find-one {id: req.params.id}
	if not content
		content = new Content {
			course-id: req.params.id,
			homework-id: req.params.homeworkId,
			content: '',
			writer-id: 'req.user.id'
		}
		content.save!
	res.render 'writeHomework', {user=req.user, course-name=course.name, content=content}

router.post '/:homeworkId/write', is-authenticated, is-student, (req, res)->
	content = Content.find-one {writer-id: req.user.id, homework-id: req.params.homework-id}
	if not content
		res.write 'Error'
		res.end!
	else
		content.content = req.params 'content'
		content.save!

