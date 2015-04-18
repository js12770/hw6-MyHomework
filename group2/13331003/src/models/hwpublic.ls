require! ['mongoose']

module.exports = mongoose.model 'HwPublic', {
	course: String,
	content: String,
	teacher: String,
	deadline: String
}