express = require("express")
mongoose  = require 'mongoose'
http = require("http")
path = require("path")
baucis = require 'baucis'

mongoose.connect 'mongodb://localhost/debuggy'

app = express()

app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use require("stylus").middleware(path.join(__dirname, "public"))
app.use express.static(path.join(__dirname, "public"))

app.use express.errorHandler()  if "development" is app.get("env")

# Load Models
errorModel = require './models/error'

#Load Routes
routes = require("./routes")

baucis.rest('Error');
app.use('/api/v1', baucis({ swagger: true }));

app.get "/", routes.index
app.get "/error/:id", routes.error
app.get "/query/:id", routes.query
app.post "/addComment", routes.addComment
app.post "/addError", routes.addError
app.post "/query", routes.addQuery

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
