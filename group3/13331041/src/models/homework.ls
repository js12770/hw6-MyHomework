require! ['mongoose']

module.exports = mongoose.model 'Homework', {
	detail     : String,
	deadline  :  String,
	course    :  String,
	homework  :  String,
	author    :  String,
	time      :  String
}