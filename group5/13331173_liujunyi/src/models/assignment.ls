require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	/*assignmentId: String,*/
	deadline: String,
	title: String,
	details: String,
	author: String,
	briefIntroduction: String
}