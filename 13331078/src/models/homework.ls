require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	producerID: String,
	producerName: String,
	title: String,
	question: String,
	createTime: Date,
	ddl: Date
}