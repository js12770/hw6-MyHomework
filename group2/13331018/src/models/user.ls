require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	type: String,
	username: String,
	password: String,
	email: String,
	firstName: String,
	lastName: String,
	finishedassignment: {},
	marks: {}
}