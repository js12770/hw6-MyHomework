require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id: String,
	teacher: String,
	name: String,
	deadline: String,
	content: String
}