require! {Course: '../models/courses', Homework: '../models/homework', Content: '../models/homeworkContent', 'express', homeworks: './homeworks'}

router = express.Router!

is-authenticated = (req, res, next)-> if req.is-authenticated! then next! else res.redirect '/'

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

module.exports = router

router.get '/', is-authenticated, (req, res)!->
	user = req.user
	if user.character == 'teacher'
		courses = Course.find {} .where('teacherId').equals(user._id).exec (err, courses)->
			res.render 'courses', user: req.user, courses: courses
	else
		courses = Course.find {}, (err, courses)->
			console.log courses
			res.render 'courses', user: req.user, courses: courses

router.get '/create', is-authenticated, is-teacher, (req, res)!->
	res.render 'createCourse', user: req.user

router.post '/create', is-authenticated, is-teacher, (req, res)->
	user = req.user
	course = Course.find-one {name: req.param.name}
	if not course
		res.write 'This course has existed!'
		res.end!
	else
		new-course = new Course {
			name: req.param 'name'
			student-id: []
			teacher-id: user._id
			homework-id: []
		}
		new-course.save (err)->
			if err
				console.log 'Create a course failed: ', err
				res.write "Failed to create a course: #{err}"
			else
				console.log 'Create a course successed!'
				res.redirect '/courses'
router.get '/:id', is-authenticated, (req, res)!->
	console.log req.params.id
	Course.find-one {_id: req.params.id}, (err, course)->
		if err
			res.write '404 not found!'
		else
			console.log 'hehe'
			res.render 'courseDetail', course: course
	
router.get '/:id/edit', is-authenticated, is-teacher, (req, res)!->	
	course = Course.find-one {id: req.params.id}
	if not course
		res.write '404 not found!'
		res.end!
	else
		res.render 'editCourse', course: course, user: req.user

router.post '/:id/edit', is-authenticated, is-teacher, (req, res)!->
	course = Course.find-one {id: req.params.id}
	if not course
		res.write 'This course is not exist!'
		res.end!
	else
		course.name = req.param 'name'
		course.save!
		res.redirect '../'
router.get '/:id/delete', is-authenticated, is-teacher, (req, res)!->
	Course.remove {id: req.param.id}, (err)!->
		if err
			res.write 'Failed to remove'
			res.end!
		else
			console.log 'Successed to remove a course!'
			res.redirect '.../'

