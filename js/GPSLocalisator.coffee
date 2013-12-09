class GPSLocalisator
  @currentRenderedMap = 0

  @geolocationOpts =
    enableHighAccuracy: true
    maximumAge: 0
    timeout: 30

  constructor: ->
    if navigator.geolocation
      that = this
      navigator.geolocation.getCurrentPosition (position) ->
        that.useGeolocation position
        return
      , @geolocationFallback, @geolocationOpts

  useGeolocation: (position) ->
    latitude = position.coords.latitude
    longitude = position.coords.longitude

    @currentLocation = new google.maps.LatLng latitude, longitude

    console?.log 'Coord found ! ', latitude, longitude
    
    googleMap = new lycorn.GoogleMap @currentLocation
    citySearch = new lycorn.CityAroundSearchEngine @currentLocation, googleMap

    return

  geolocationFallback: ->
    console?.log 'Geolocation fallback'

window.lycorn = {} if window.lycorn is undefined

window.lycorn.GPSLocalisator = GPSLocalisator
