require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	course-id: String,
	name: String,
	instruction: String,
	student-handed-id: [String],
	deadline: Date,
	content-id: [String]
}
