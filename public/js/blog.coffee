$(document).ready ->
  NUMBER_OF_BG_IMAGES = 11

  app = window || {}

  app.BlogModel = Backbone.Model.extend
    urlRoot: '/posts'

    defaults: ->
      slug: "default-title"
      date: "1-1-13"
      title: "Default Title"
      body: "hello world!"

  app.BlogPosts = Backbone.Collection.extend
    model: app.BlogModel

    url: '/posts'

    getPostBySlug: (slug) ->
      @findWhere {slug}

  app.BlogPostView = Backbone.View.extend
    tagName: 'div'
    className: 'blogPost'

    template: _.template($('#blogView-template').html())

    initialize: ->
      _.bindAll @

      @isFlipped = false

      @comments = new app.Comments( {url: '/comments/' + @model.get('slug') })
      @comments.fetch()

    render: (eventName) ->
      $(@el).html @template( @model.toJSON() )
      @

    unrender: =>
      $(@el).remove()

    hide: ->
      $(@el).hide(500)

    flip: ->
      console.log "FLIP MUTHERFUCKER"
      front = @el
      commentsView = new app.CommentsView ( {collection: @comments, model: @model })
      back_content = commentsView.render().el
      back = flippant.flip(front, back_content.innerHTML)
      back.addEventListener('dblclick', (e) ->
            back = back.close();
      )

    gotoSlug: ->
      app.router.navigate("post/#{@model.get('slug')}", {trigger: true})

    events:
      'click .close': 'hide'
      'click .title': 'gotoSlug'
      'dblclick' : 'flip'
  