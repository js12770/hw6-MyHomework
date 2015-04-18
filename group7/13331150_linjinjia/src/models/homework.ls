require! ['mongoose']

homework-schema = new mongoose.Schema {
	id: String
	assignment-id: String
	student-name: String
	content: String
	grade: String
	meta:
		create-at:
			type: Date
			default: Date.now!
		update-at:
			type: Date
			default: Date.now!
}

homework-schema.pre 'save', (next)!->
	if @is-new
		@meta.create-at = @meta.update-at = Date.now!
	else
		@meta.update-at = Date.now!
	next!

homework-schema.statics = 
	fetch: (data)->
		@find {} .sort 'meta.update-at' .exec data
	find-by-id: (id, data)->
		@find-one {_id: id} .exec data
	find-by-assignment-id: (id, data)->
		@find {assignment-id: id} .exec data

module.exports = mongoose.model 'homework', homework-schema