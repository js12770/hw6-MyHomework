require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	producer: String,
	question: String,
	ddl: Date
}