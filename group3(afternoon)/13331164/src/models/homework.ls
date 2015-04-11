require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	student: String,
	name: String,
	answer: String
}