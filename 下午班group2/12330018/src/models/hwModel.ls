require! ['mongoose']

homeworkSchema = new mongoose.Schema {
  id : String,
  teacher : String
  title : String,
  content : String,
  ddl : Date,
  submmits : [
    student : String,
    id: String,
    time : Date,
    essay: String,
    mark : String,
  ]
}

module.exports = mongoose.model 'Homework', homeworkSchema