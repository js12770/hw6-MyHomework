require! ['mongoose']

module.exports = mongoose.model 'Submission', {
	student: String,
	task: String,
	handdate: String,
	detail: String,
	grade: String
}