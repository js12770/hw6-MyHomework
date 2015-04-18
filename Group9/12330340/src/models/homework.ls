require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	hid: String,
	sid: String,
	tid: String,
	teacher: String,
	student: String,
	content: String,
	grade: String
}