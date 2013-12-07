$(document).ready ->
  app = window || {}

  app.constants ?= {}
  app.constants = _.extend app.constants, 
    name: "LOL"

  app.ErrorModel = Backbone.Model.extend
    defaults: ->
      
    initialize: ->

  app.ErrorView = Backbone.View.extend
    el: "#gameCanvas"

    initialize: ->
      _.bindAll @, "render"

    render: (ctx) ->
      
  app.Errors = Backbone.Collection.extend
    model: app.ErrorModel
