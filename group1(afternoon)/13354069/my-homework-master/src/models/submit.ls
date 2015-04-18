require! ['mongoose']

module.exports = mongoose.model 'Submit', {
	id: String,
	stu: String,
	hw: String,
	content: String,
	score: Number,
	time: String,
	ddl: String
}