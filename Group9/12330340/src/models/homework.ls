require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	hid: String,
	sid: String,
	content: String,
	grade: String
}