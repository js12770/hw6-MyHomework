require! ['mongoose']

userSchema = new mongoose.Schema {
	id: String,
	username: String,
	password: String,
	email: String,
	firstName: String,
	lastName: String,
	identity: String 
}


module.exports = mongoose.model 'User', userSchema
