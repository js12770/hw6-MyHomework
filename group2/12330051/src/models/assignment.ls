require! ['mongoose']

module.exports = mongoose.model 'Assignment', {
	id: String,
	id_: String,
	title:String,
	name:String,
	assignment: String,
	score: String
}