mongoose = require 'mongoose'

QuerySchema = new mongoose.Schema
  errorText: { type: String, trim: true }
  language: { type: String, trim: true }
  dla: { type: String, trim: true }

QueryModel = mongoose.model("Query", QuerySchema)

FixSchema = new mongoose.Schema
  author: { type: String, trim: true }
  description: { type: String, trim: true }
  dateCreated: {type: Date, default: Date.now}

ErrorSchema = new mongoose.Schema
  title: { type: String, trim: true }
  errorText: { type: String, trim: true }
  description: { type: String, trim: true }
  language: { type: String, trim: true }
  version: [{ type: String, trim: true }]
  dateCreated: {type: Date, default: Date.now }
  dla: {type: Date, default: Date.now }
  fixes: [FixSchema]

ErrorModel = mongoose.model("Error", ErrorSchema)

m = new ErrorModel
  "title": "Will is too sexy",
  "errorText": "Error: USER TOO SEXY: Will",
  "description": "Wills's picture is blinding other facebook users",
  "language": "PHP",
  "fixes": [
    {
      "author": "c0nrad",
      "description": "There is no solution :)",
    }
  ]
#m.save()

