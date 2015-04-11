require! ['mongoose']

module.exports = mongoose.model 'Answer', {
	Content:String,
	Name:String,
	student:String
}
