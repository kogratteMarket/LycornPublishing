class CityAroundResearch
   constructor: (@geolocation, @callback = (() ->), @proximity = 'asc') ->
      searchParams =
         lat: @geolocation.getLat()
         long: @geolocation.getLong()
         results: 10
         proximity: @proximity

      that = @

      $.get 'http://thelycornweather.sebacmieu.fr/search/city', searchParams, (data) ->
         console?.log data
         that.callback data
      , 'JSON'


window.lycorn = {} if !window.lycorn
window.lycorn.CityAroundResearch = CityAroundResearch
