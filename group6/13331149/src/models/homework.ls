require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	content: String,
	week: Number,
	student: String,
	score: Number
	date: Date;
}