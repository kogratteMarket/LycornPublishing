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
