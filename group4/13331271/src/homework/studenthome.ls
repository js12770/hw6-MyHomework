require! {Issue:'../models/issue'}
require! {Submission:'../models/submission'}
require! {User:'../models/user'}
require! moment

# homework类，记录各种信息，用到三个collection
class Myhomework
    (@issue) ->
        @title = issue.title
        @deadline = issue.deadline
        @content = issue.content
        @id = issue._id
        @latest-submit-time = \None
        @score = \None
        @teacher-name = \None
        now = moment new Date() .format 'YYYY-MM-DD HH:mm'
        @overdue = now >= @deadline
        @my-submit = \None
        @filename = \None

module.exports = (req, res) !->
    issues-list = []
    submit-list = []
    user-list = []
    (error, issues) <- Issue.find!
    return (console.log "Get issues error: ", error) if error
    issues-list = issues
    (error, users) <- User.find!
    return (console.log "Get user error: ", error) if error
    user-list = users
    (error, submit) <- Submission.find!
    return (console.log "Get submit error: ", error) if error
    submit-list = submit
    all-my-homework = [new Myhomework issue for issue in issues-list]
    for my-homework in all-my-homework
        for submit in submit-list
            if submit.title == my-homework.title and submit.username == req.user.lastName + req.user.firstName
                my-homework.latest-submit-time = submit.submittime
                my-homework.score = submit.score
                my-homework.my-submit = submit.content
                my-homework.filename = submit.filename
        for user in user-list
            if user.username is my-homework.issue.username
                my-homework.teacher = user.lastName + user.firstName
    res.render 'student', user: req.user, all-homework: all-my-homework, message: req.flash 'message'

    #all.callbackres.render 'student', user: req.user, all-homework: all-my-homework