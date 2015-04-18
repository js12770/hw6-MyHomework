require! ['mongoose']

module.exports = mongoose.model 'Submit', {
	homework_id: String,
	student: String,
	content: String,
	score: String,
	title: String
}