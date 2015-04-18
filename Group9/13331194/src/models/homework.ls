require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	title: String,
	startTime: String,
	endTime: String,
	student: String,
	content: String,
	submitTime: String,
	score: String
}