require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	title: String,
	deadline: String,
	briefIntroduction: String,
	details: String,
	author: String
}