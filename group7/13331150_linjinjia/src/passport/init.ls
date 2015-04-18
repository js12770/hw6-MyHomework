require! {'./login', './signup', User: '../models/user', Assignment: '../models/assignment', 'bcrypt-nodejs'}

module.exports = (passport)-> 
	passport.serialize-user (user, done)->
		console.log 'serialize user: ', user
		done null, user._id

	passport.deserialize-user (id, done)-> User.find-by-id id, (error, user)!->
		console.log 'deserialize user: ', user
		done error, user

	login passport
	signup passport
