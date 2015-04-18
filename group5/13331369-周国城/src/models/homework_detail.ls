require! ['mongoose']

module.exports = mongoose.model 'HomeworkDetail', {
	homework_name: String,
	content: String,
	requires: String,
	deadline: String,
	possessor: String
}
