require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	username: String,
	password: String,

	status: String,
	
	email: String,
	firstName: String,
	lastName: String
}