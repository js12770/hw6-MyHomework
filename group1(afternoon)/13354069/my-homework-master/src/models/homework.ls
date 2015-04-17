require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	id: String,
	name: String,
	description: String,
	start: String,
	ddl: String
}