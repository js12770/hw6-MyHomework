require! {'./login', './signup', User: '../models/user', Assignment: '../models/assignment', 'bcrypt-nodejs'}

module.exports = (passport)-> 
	passport.serialize-user (user, done)->
		console.log 'serialize user: ', user
		done null, user._id

	passport.deserialize-user (id, done)-> User.find-by-id id, (error, user)!->
		console.log 'deserialize user: ', user
		done error, user

	# Assignment.fetch (err, assignment)!->
	# 	if err
	# 		console.log err
		# if assignment.length is 0
		# 	default-assignment = new Assignment {
		# 		ass-name: 'my-homework'
		# 		description: 'HW6 my-homework'
		# 		deadline: new Date 'May 1, 2015 00:00:00'
		# 		teacher-name: 'Eric-wangqing'
		# 	}
		# 	default-assignment.save (err)!->
		# 		if err
		# 			console.log err

		# 	default-teacher = new User {
		# 		username: 'admin'
		# 		password: bcrypt-nodejs.hash-sync 'admin', (bcrypt-nodejs.gen-salt-sync 10), null
		# 		email: 'admin@admin.com'
		# 		first-name: 'Eric-wangqing'
		# 		last-name: 'Eric-wangqing'
		# 		role: 'teacher'
		# 	}

		# 	default-teacher.save (err)!->
		# 		if err
		# 			console.log err


	login passport
	signup passport
