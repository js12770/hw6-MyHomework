require! ['mongoose']

module.exports = mongoose.model 'Content', {
	id: String,
	course-id: String,
	homework-id: String,
	content: String,
	writer-id: String
}
