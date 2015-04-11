require! ['mongoose']

homeworkSchema = new mongoose.Schema {
	id : String,
	teacher : String
	title : String,
	description : String,
	deadline : Date,
	attachment : [
		name : String,
		time : Date,
		fujian : String,
		url: String,
		mark : String,
	]
}

module.exports = mongoose.model 'Homework', homeworkSchema
