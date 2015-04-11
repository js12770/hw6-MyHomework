require! ['mongoose']

module.exports = mongoose.model 'myAssignment', {
    userid: String,
    username: String,
    content: String,
    assignmentid: String,
    deadline: String,
    title: String,
    status: String,
}