$(document).ready ->

  app = window


  app.AppView = Backbone.View.extend
    el: $ 'body'

    initialize: ->
      _.bindAll @

      app.chatView = @chatView = new app.ChatView

    renderPosts: ->
      @collection.each ( model ) ->
        view = new app.BlogPostView( {model: model})
        $('#blogPostBlock').append( view.render().el )

    renderSinglePost: (slug) ->
      if @collection.length == 0
        @collection.fetch({async: false})
      model = @collection.getPostBySlug(slug)
      view = new app.BlogPostView ( {model: model } )
      $('#singlePost').html( view.render().el )

  app.app = new app.AppView()
