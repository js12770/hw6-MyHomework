require! ['mongoose']

module.exports = mongoose.model 'Submit', {
	user_id: String,
	content: String,
	homework_id : String,
	grade : String,
	user_name : String
}