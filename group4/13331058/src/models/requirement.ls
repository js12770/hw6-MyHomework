require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id: String,
	master: String,
	Head: String,
	ddl: String,
	content: String
}