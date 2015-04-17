require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	hid:String,
	username:String,
	answer:String,
	score:String
}