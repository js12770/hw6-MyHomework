require! ['mongoose']
Md = (require 'Markdown').markdown

name = "homework"
name-plural = "homeworks"

owner = "assignment"
owner-purla = "assignments"

# endpoints
single = "/#{owner-purla}/:#{owner}_id/#{name-plural}/:#{name}_id"
plural = "/#{owner-purla}/:#{owner}_id/#{name-plural}"
new-one = "/#{owner-purla}/:#{owner}_id/#{name-plural}/new"
edit = "/#{owner-purla}/:#{owner}_id/#{name-plural}/:#{name}_id/edit"

schema = new mongoose.Schema {
  id: String,
  user_id: String,
  createdby: String,
  assignment_id: String,
  marks: Number,
  review: String,
  path: String,
}
schema.virtual 'html' .get -> Md.toHTML '# homework createby: ' + @createdby + '\n' + @review

schema.virtual 'index' .get -> plural
schema.virtual 'create' .get -> plural
schema.virtual 'new' .get -> new-one
schema.virtual 'edit' .get -> "/#{owner-purla}/#{@assignment_id}/#{name-plural}/#{@_id}/edit"
schema.virtual 'show' .get -> "/#{owner-purla}/#{@assignment_id}/#{name-plural}/#{@_id}"
schema.virtual 'update' .get -> "/#{owner-purla}/#{@assignment_id}/#{name-plural}/#{@_id}?_method=PUT"
schema.virtual 'destroy' .get -> "/#{owner-purla}/#{@assignment_id}/#{name-plural}/#{@_id}"


model = mongoose.model name, schema

# endpoints
model.index = -> plural
model.create = -> plural
model.new = -> new-one
model.edit = -> edit
model.show = -> single
model.update = -> single
model.destroy = -> single
# views
model.index.template = -> "#{name-plural}"
model.new.template = -> "#{name}-new"
model.edit.template = -> "#{name}-edit"
model.show.template = -> "#{name}"

module.exports = model