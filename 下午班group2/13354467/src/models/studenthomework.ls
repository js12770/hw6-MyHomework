require! ['mongoose']

module.exports = mongoose.model 'Studenthomework', {
	homeworkid: String,
	student: String,
	content: String
}