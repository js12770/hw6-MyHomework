require! ['mongoose']

module.exports = mongoose.model 'shw', {
	id: String,
	worker: String,
	hwname: String,
	hwid: String,
	content: String
}