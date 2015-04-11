require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	HomeworkAuthor: String,
	HomeworkTitle: String,
	HomeworkDeadline: String,
	HomeworkRequirement: String
}