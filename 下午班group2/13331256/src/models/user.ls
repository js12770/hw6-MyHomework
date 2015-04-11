require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	username: String,
	password: String,
	presence: String,
	email: String,
	firstName: String,
	lastName: String,
	problem: Array
}