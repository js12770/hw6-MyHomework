require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	title: String,
	teacherName: String,
	teacherId: String,
	deadline: String,
	requirement: String,
	students: Array
}
