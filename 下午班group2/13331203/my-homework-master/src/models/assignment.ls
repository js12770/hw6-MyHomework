require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	teacher: String,
	deadline: String,
	Content:String,
	Name:String
}
