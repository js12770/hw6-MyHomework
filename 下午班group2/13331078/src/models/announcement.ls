require! ['mongoose']

module.exports = mongoose.model 'Announcement', {
	username: String,
	firstName: String,
	lastName: String,
	producerID: String,
	hw_id: String,
	title: String,
	answer: String,
	commitTime: Date,
	nth: {type:Number, default: 0}
	grade: {type:Number, default: -1}
}