class GoogleMap

  constructor: (@mapCenter) ->
    map = document.createElement 'div'
    map.className = 'googleMap'

    document.getElementById('mapsContainer').appendChild map

    @render()
    @renderPoint @mapCenter

    return @

  render: ->
    mapOptions =
      center: @mapCenter
      zoom: 16

    @gmap = new google.maps.Map document.getElementsByClassName('googleMap')[0], mapOptions

  renderPoint: (point) ->
    markerData =
      position: point
      map: @gmap

    new google.maps.Marker markerData

  getGoogleMap: ->
    return @gmap



window.lycorn = {} if window.lycorn is undefined

window.lycorn.GoogleMap = GoogleMap
