require! ['mongoose']

module.exports = mongoose.model 'Course', {
	coursename: String,
	username: String
}
