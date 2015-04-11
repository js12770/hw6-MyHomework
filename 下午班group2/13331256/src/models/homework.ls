require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	title: String,
	deadline: Date,
	teacher: String,
	anwser: Array
}
