require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	username: String,
	password: String,
	identity: String,
	email: String,
	firstName: String,
	lastName: String
}