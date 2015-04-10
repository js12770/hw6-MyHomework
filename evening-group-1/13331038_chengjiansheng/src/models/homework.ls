require! ['mongoose']
module.exports = mongoose.model 'Homework', {
    teacherName: String,
    startDate: String,
    deadLine: String,
    name: String
}