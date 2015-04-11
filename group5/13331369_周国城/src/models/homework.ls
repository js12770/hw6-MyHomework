require! ['mongoose']

module.exports = mongoose.model 'Homework' {
	homework_name: String,
	participator: String,
	role_name: String
}