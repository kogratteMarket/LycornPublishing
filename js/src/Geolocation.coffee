# This is the Location that I store on the global scope.
# I use this object to avoid to manipulate an array, and more, I'm actually a PHP dev and love my get/set methods!

class Geolocation
   constructor: (@lat, @long, @cityName, @country, @type = 'ip') ->

   getLat: ->
      @lat
   getLong: ->
      @long
   getCityName: ->
      @cityName
   country: ->
      @country


window.lycorn = {} if !window.lycorn
window.lycorn.Geolocation = Geolocation
