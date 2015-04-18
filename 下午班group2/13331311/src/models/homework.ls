require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	assignmentid: String,
	upper: String,
	studentName: String,
	content: String
}