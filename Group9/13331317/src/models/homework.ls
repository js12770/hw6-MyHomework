require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	title: String,
	student: String,
	
	answer: String
}