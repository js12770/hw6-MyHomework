require! ['mongoose']

homeworkSchema = new mongoose.Schema {
	id: String,
	assignment_id: String,
	student_id: String,
	student_name: String,
	content: String,
	grade: String,
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

homeworkSchema.pre 'save',(next)!->
	if @.isNew 
		@.meta.createAt = @.meta.updateAt = Date.now!
	else
		@.meta.updateAt = Date.now!
	next!

homeworkSchema.statics = {
	fetch: (cb)->
		@ .find {} .sort 'meta.updateAt' .exec cb
	findById: (id, cb)->
		@ .findOne {_id: id} .exec cb
	findByAssignment: (id, cb)->
		@ .find {assignment_id: id} .exec cb
	findByAssignmentAndStudent: (a_id, s_id, cb)->
		@ .findOne {assignment_id: a_id, student_id: s_id} .exec cb
}

module.exports = homeworkSchema
