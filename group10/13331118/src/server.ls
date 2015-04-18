require! {express, http, path, 'cookie-parser', 'body-parser', 'method-override', multer, mongoose, passport, 'express-session', './db'}
logger = require 'morgan'
flash = require 'connect-flash'
favicon = require 'serve-favicon'
mongoose.connect db.url

app = express!
# server = http.create-server app

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

app.use (favicon "#{__dirname}/public/images/favicon.png")
app.use logger 'dev'
app.use bodyParser.json!
app.use (bodyParser.urlencoded extended: false)
app.use (multer dest: './bin/public/uploads/homework', rename: (fieldname, filename)-> (filename.replace(/\W+/g, '-') .toLowerCase!) + Date.now!)
app.use cookieParser!
app.use (methodOverride '_method')
app.use express.static path.join __dirname, 'public'
app.use expressSession {secret: 'mySecretKey', resave: true, saveUninitialized: false}
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

module.exports = app
# exports.use = -> app.use.apply app, &