require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	title: String,
	content: String,
	deadline: Date,
	Score: Number
}