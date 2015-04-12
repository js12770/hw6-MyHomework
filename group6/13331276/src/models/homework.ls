require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	name: String,
	deadline: String,
	requirement: String,
	submitedUser; Array
}