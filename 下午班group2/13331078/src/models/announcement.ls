require! ['mongoose']

module.exports = mongoose.model 'Announcement', {
	username: String,
	firstName: String,
	lastName: String,
	producerName: String,
	question: String,
	answer: String,
	commitTime: Date
}