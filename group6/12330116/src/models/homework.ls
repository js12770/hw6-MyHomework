require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	username: String,
	time: String,
	filename: String
}