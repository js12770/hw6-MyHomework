require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	student: String,
	title: String,
	answer: String,
	grade: String
}