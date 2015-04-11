require! {User:'../models/user', 'bcrypt-nodejs', 'passport-local', Course:'../models/course'}
LocalStrategy = passport-local.Strategy

is-valid-password = (user, password)-> bcrypt-nodejs.compare-sync password, user.password

module.exports = (req)->
	
	