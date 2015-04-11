require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	assignmentname: String,
	creater: String,
	author: String,
	content: String,
	deadline: String,
}