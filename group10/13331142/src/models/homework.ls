require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	name: String,
	deadline: Date,
	discription: String,
	sponsor: String,
}