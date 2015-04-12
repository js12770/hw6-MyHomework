require! ['mongoose']

module.exports = mongoose.model 'Request', {
	username: String,
	deadline: String,
	content: String,
	title: String
}