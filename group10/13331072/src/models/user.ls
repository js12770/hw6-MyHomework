require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	isteacher: String,
	username: String,
	password: String,
	email: String,
	firstName: String,
	lastName: String
}