require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	teacher: String,
	title: String,
	deadline: Date,
	text: String
}