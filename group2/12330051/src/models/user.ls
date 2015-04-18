require! ['mongoose']

module.exports = mongoose.model 'User', {
	id: String,
	id_:String,
	username: String,
	password: String,
	email: String,
	identity: String
}