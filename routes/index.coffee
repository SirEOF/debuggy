mongoose = require('mongoose')
ErrorModel = mongoose.model("Error")
QueryModel = mongoose.model("Query")
async = require 'async'
_ = require 'underscore'

exports.index = (req, res) ->
  ErrorModel.find().sort('-dla').limit(4).exec (err, errors) =>
    if err
      console.log "ERROR", err

    console.log errors
    res.render "",
      recentErrors: errors


exports.error = (req, res) ->
  ErrorModel.findById(req.params.id).exec (err, error) ->
    if err
      console.log "ERROR", err
    res.render "error",
      error: error

exports.query = (req, res) ->

  async.auto
    query: (next) ->
      QueryModel.findById(req.params.id).exec next

    errors: ["query", (next, {query}) ->
      scoreMap = []

      ErrorModel.find().exec (err, errors) =>
        for error in errors
          console.log "Comparing", error.errorText, "and", query.errorText
          count = 0
          for word1 in error.errorText.split(' ')
            for word2 in query.errorText.split(' ')
              if word1.toLowerCase() == word2.toLowerCase()
                ++count
          scoreMap.push {error: error, count: count}
        console.log scoreMap
        console.log "LOL"
        next null, (_.pluck (_.sortBy scoreMap, (error) -> error.count)[0..3], 'error')
    ], (err, {errors, query}) =>
      if err
        console.log "ERROR", err

      res.render "query",
        errors: errors
        query: query

exports.addQuery = (req, res) ->
  console.log req.body
  q = new QueryModel
    errorText: req.body.errorMessage
    language: req.body.languageSelect
  q.save()
  res.redirect "/query/#{q.id}"

exports.addComment = (req, res) ->
  async.auto
    error: (next) =>
      ErrorModel.findById(req.body.id).exec next

    updateError: ["error", (next, {error}) =>
      error.fixes.push
        author: req.body.authorInput
        description: req.body.fixTextarea
      error.save()
      console.log error
      next()
    ]
    , (err, {error}) =>
      res.render "error",
        error: error

exports.addError = (req, res) ->

  async.auto
    query: (next) ->
      QueryModel.findById(req.body.id).exec next

    error: ["query", (next, {query}) =>
      e = new ErrorModel
        title: req.body.errorTitle
        errorText: query.errorText
        language: query.language
        description: req.body.errorDescription
      e.save next
    ]
    , (err, {error}) ->
      if err
        console.log "ERROR EVERYTHERE, ZOMG", err
      console.log error
      res.redirect "/error/#{error[0].id}"


