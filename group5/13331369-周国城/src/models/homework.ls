require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	homework_name: String,
	participator: String,
	role: String,
	possessor: String,
	status: String,
	original_name: String,
	dest_name: String,
	score: String
}