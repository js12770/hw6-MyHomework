require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	username: String,
	password: String,
	email: String,
	firstName: String,
<<<<<<< HEAD
	lastName: String
=======
	lastName: String,
	identity: String
>>>>>>> 8e87d8047ea9b60158d5b4011b64802f4e8a21e3
}