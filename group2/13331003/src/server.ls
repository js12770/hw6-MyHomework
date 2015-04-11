require! {express, http, path, 'cookie-parser', 'body-parser', mongoose, passport, 'express-session', './db'}
logger = require 'morgan'
flash = require 'connect-flash'
favicon = require 'static-favicon'
mongoose.connect db.url


homework-publish-schema-options =
  title: String
  description: String
  deadline: String
  publisher: String

homework-publish-schema = mongoose.Schema homework-publish-schema-options
Homework-publish = mongoose.model('HomeworkPublish', homework-publish-schema);

homework-submit-schema-options =
  title: String
  content: String
  belong-to: String
  submitter: String

homework-submit-schema = mongoose.Schema homework-submit-schema-options
Homework-submit = mongoose.model('HomeworkSubmit', homework-submit-schema);




app = express!
server = http.create-server app

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.use favicon!
app.use logger 'dev'
app.use bodyParser.json!
app.use bodyParser.urlencoded!
app.use cookieParser!
app.use express.static path.join __dirname, 'public'
app.use expressSession {secret: 'mySecretKey'}
app.use passport.initialize!
app.use passport.session!
app.use flash!

initPassport = require './passport/init'
initPassport passport
routes = (require './routes/index') passport
app.use '/', routes

app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err

if (app.get 'env') is 'development' then app.use (err, req, res, next) ->
  res.status err.status || 500
  res.render 'error', {
    err.message
    error: err
  }

exports = module.exports = server
exports.use = -> app.use.apply app, &  