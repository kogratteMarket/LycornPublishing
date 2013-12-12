class Loader
   @default =
      nbItems: 10
      speed: 1000

   constructor: (@element, options) ->
      @animateIncrease()

   animateIncrease: ->
      that = this

      @element.animate({
         width: '100%'
      }, 'slow', 'swing', ->
         setTimeout ->
            that.animateDecrease()
         , 1000
      )

   animateDecrease: ->
      that = this

      @element.animate({
         width: '0%'
      }, 'slow', 'swing', ->

         setTimeout ->
            that.animateIncrease()
         , 1000
      )

window.lycornLoader = Loader