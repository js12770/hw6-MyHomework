require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	homeworkid: String,
	require: String,
	teacher: String,
	ddl: Date
}