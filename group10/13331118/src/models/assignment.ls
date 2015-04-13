require! ['mongoose']
Md = (require 'Markdown').markdown

name = "assignment"
name-plural = "assignments"
single = "/#{name-plural}/:#{name}_id"
plural = "/#{name-plural}"
new-one = "/#{name-plural}/new"
edit = "/#{name-plural}/:#{name}_id/edit"

schema = new mongoose.Schema {
  id: String,
  createdby: String,
  ddlDate: String,
  ddlTime: String,
  title: String,
  detials: String
}

schema.virtual 'ddl' .get -> "#{@ddlDate} #{@ddlTime}"
schema.virtual 'brief' .get -> "#{@detials.slice(0, 100)}"
schema.virtual 'html' .get -> Md.toHTML '# ' + @title + '\n' + '# ' + 'detials' + '\n' + @detials + '\n' + '# ' + 'ddl' + '\n' + @ddl + '\n' +'# ' + 'homeworks' + '\n' + "[check homeworks](/#{name-plural}/#{@_id}/homeworks)"

# URLs
schema.virtual 'index' .get -> plural
schema.virtual 'create' .get -> plural
schema.virtual 'new' .get -> new-one
schema.virtual 'edit' .get -> "/#{name-plural}/#{@_id}/edit"
schema.virtual 'show' .get -> "/#{name-plural}/#{@_id}"
schema.virtual 'update' .get -> "/#{name-plural}/#{@_id}?_methon=PUT"
schema.virtual 'destroy' .get -> "/#{name-plural}/#{@_id}"


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