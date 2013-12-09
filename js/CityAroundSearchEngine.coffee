class CityAroundSearchEngine
  constructor: (@currentLocation, @googleMap) ->

    service = new google.maps.places.PlacesService @googleMap.getGoogleMap()

    request =
      location: @currentLocation
      radius: '500'
      types: ['museum']

    service.nearbySearch request, (result, status) ->
      console?.log result, status



window.lycorn = {} if window.lycorn is undefined

window.lycorn.CityAroundSearchEngine = CityAroundSearchEngine
