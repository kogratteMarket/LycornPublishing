# This is the research class.
# This is doing nothing special, and call an homemade WS to retrieve locations around the user position and the
# associated weather in an unique request
#
# You can look on the CityAroundResearch.js file to show what the compiled JS looks like.

class CityAroundResearch
   constructor: (@geolocation, @callback = (() ->), @proximity = 'asc') ->
      searchParams =
         lat: @geolocation.getLat()
         long: @geolocation.getLong()
         results: 10
         proximity: @proximity

      that = @

      $.get 'http://thelycornweather.sebacmieu.fr/search/city.php', searchParams, (data) ->
         console?.log data
         that.callback data
      , 'JSON'


window.lycorn = {} if !window.lycorn
window.lycorn.CityAroundResearch = CityAroundResearch
