class CityAroundResearch
  constructor: (@geolocation, @proximity) ->
    searchParams =
      lat: @geolocation.getLat()
      long: @geolocation.getLong()
      results: 3
      proximity: @proximity

    that = @

    $.get 'http://nik94.free.fr/LycornPublishing/search/city', searchParams, (data) ->
      console?.log data
      window.updateSearchResults data
    , 'JSON'


window.lycorn = {} if !window.lycorn
window.lycorn.CityAroundResearch = CityAroundResearch
