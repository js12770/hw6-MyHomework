require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	id: String,
	tid: String,
	requires: String,
	deadline: String
}