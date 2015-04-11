require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	name: String,
	content: String,
	ddl: String,
	uploader: String,
	score: String
}