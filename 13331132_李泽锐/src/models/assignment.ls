require! ['mongoose']

module.exports = mongoose.model 'Assignment' {
	id: String,
	date: String,
	content: String
}
	