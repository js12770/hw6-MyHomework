require! ['mongoose']

module.exports = mongoose.model 'HwSumbit', {
	course: String,
	content: String,
	student: String,
	score: Number,
	date: String
}