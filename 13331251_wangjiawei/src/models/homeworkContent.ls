require! ['mongoose']

module.exports = mongoose.model 'Content', {
	id: String,
	homework-id: String,
	content: String,
	writer-id: String,
	score: String
}
