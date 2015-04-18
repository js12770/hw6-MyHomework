require! ['mongoose']

module.exports = mongoose.model 'User', {
    isTeacher: Boolean,
    username: String,
    password: String,
    email: String,
    firstName: String,
    lastName: String
}
