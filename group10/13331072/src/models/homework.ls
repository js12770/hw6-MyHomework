require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	name: String,
	content: String,
	uploader: String,
	score: String
}