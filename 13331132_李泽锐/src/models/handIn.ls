require! ['mongoose']

module.exports = mongoose.model 'HandIn' {
	id: String,
	student: String,
	deadline: String,
	assignment: String,
	answer: String,
	grade: String
}