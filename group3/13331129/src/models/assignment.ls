require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	title: String,
	description: String,
	date: String
}