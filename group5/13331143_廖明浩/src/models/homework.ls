require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	title: String,
	detail: String,
	teacher: String,
	deadline: String
}