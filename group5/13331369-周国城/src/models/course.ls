require! ['mongoose']

module.exports = mongoose.model 'Course', {
	course_name: String,
	role: String,
	role_name: String,
	possessor: String
}