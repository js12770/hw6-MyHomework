require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	sid: String,
	username: String,
	password: String,
	email: String,
	name: String,
	identity: String
}