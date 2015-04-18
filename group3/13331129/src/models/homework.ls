require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	name: String,
	url: String,
	student: String,
	grade: String,
	assignment: String
}