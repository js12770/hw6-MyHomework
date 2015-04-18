require! ['mongoose']

module.exports = mongoose.model 'HwSubmit', {
	hwid: String,
	content: String,
	student: String,
	submittime: String,
	score: Number
}