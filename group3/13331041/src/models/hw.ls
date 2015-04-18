require! ['mongoose']

module.exports = mongoose.model 'HW', {
	detail     : String,
	course     : String,
	homework   : String,
	student     : String,
	content    : String,
	deadline   : String,
	grade      : Number,
	time       : String
}