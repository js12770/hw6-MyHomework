require! ['mongoose']

assignmentSchema = new mongoose.Schema {
	id: String,
	name: String,
	description: String,
	deadline: Date,
	teacher: String,
	deadline_text: String
	meta: {
		createAt: {
			type: Date,
			default: Date.now!
		},
		updateAt: {
			type: Date,
			default: Date.now!
		}
	}
}

assignmentSchema.pre 'save',(next)!->
	if @.isNew 
		@.meta.createAt = @.meta.updateAt = Date.now!
	else
		@.meta.updateAt = Date.now!
	next!

assignmentSchema.statics = {
	fetch: (cb)->
		@ .find {} .sort 'meta.updateAt' .exec cb
	findById: (id, cb)->
		@ .findOne {_id: id} .exec cb
}

module.exports = assignmentSchema
