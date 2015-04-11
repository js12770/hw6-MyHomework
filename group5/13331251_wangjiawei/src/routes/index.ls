require! ['express', './courses', './homeworks']

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

	router.get '/home', is-authenticated, (req, res)!-> res.render 'home', user: req.user

	router.get '/signout', (req, res)!-> 
		req.logout!
		res.redirect '/'

	router.use '/courses', courses
	router.use '/homeworks', homeworks
