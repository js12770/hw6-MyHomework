require! ['mongoose']

module.exports = mongoose.model 'Project', {
	name: String,
	start-time: String,
	deadline: String,
	status: String
}