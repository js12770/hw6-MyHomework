require! ['mongoose']

module.exports = mongoose.model 'Project', {
	id: String,
	name: String,
	deadline: Date
}