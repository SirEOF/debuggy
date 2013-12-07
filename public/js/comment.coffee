$(document).ready ->
  app = window || {}

  app.CommentModel = Backbone.Model.extend

    defaults: ->
      name: "Anon"

  app.Comments = Backbone.Collection.extend
    model: app.CommentModel

    initialize: (properties) ->
      @url = properties.url

    getCommentsBySlug: (slug) ->
      @findWhere {slug}

  app.CommentView = Backbone.View.extend

    template: _.template($('#comment-template').html())

    events:
      'click span' : -> console.log "HAIAHIAIA"

    initialize: ->
      _.bindAll @

    render: () ->
      $(@el).html @template (@model.toJSON())
      @delegateEvents()
      @

  app.CommentsView = Backbone.View.extend
    tagName: "commentsView"
    template: _.template($('#comments-template').html())

    events:
      'dblclick' : 'flip'

    initialize: ->
      _.bindAll @

    flip: ->
      console.log "comments flip"

    render: (e) ->
      $(@el).html @template( @model.toJSON() )

      container = $(@el).find(".comments")
      @collection.each (commentModel) ->
        commentView = new app.CommentView ({ model: commentModel })
        container.append commentView.render().el
      @delegateEvents()
      @