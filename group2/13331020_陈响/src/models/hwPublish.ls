require! ['mongoose']

module.exports = mongoose.model 'HwPublish', {
	hwid: String,
	requirement: String,
	deadline: String,
	teacher: String
}