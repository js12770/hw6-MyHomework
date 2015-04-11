require! ['mongoose']

module.exports = mongoose.model 'User', {
    id: Number,
    username: String,
    password: String,
    firstName: String,
    lastName: String,
    userType: Number
}
