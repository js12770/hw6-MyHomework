require! ['mongoose']

assignment-schema = new mongoose.Schema {
	id: String
	teacher-name: String
	ass-name: String
	deadline: Date
	description: String
	meta:
		create-at:
			type: Date
			default: Date.now!
		update-at:
			type: Date
			default: Date.now!
}

assignment-schema.pre 'save', (next)!->
	if @is-new
		@meta.create-at = @meta.update-at = Date.now!
	else
		@meta.update-at = Date.now!
	next!

assignment-schema.statics = 
	fetch: (data)->
		@find {} .sort 'meta.update-at' .exec data
	find-by-id: (id, data)->
		@find-one {_id: id} .exec data

module.exports = assignment-schema