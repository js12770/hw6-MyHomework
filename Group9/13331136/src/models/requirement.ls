require! ['mongoose']

module.exports = mongoose.model 'Requirement', {
	rqmt: String
}