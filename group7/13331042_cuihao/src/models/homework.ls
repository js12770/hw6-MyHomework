require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	assignmentId: String,
	time: String,
	title: String,
	details: String,
	author: String,
	score: String
}