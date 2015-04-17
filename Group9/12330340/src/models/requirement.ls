require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id: String,
	tid: String,
	teacher: String,
	requires: String,
	deadline: String
}