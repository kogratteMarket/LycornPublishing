class WeatherDetector

  constructor: (@cityData) ->
    @providerUrl = 'http://api.previmeteo.com/06eee7d1c20d0bb49d9e909acf4ddcb0/ig/api'

    console?.log 'New weather request for', @cityData

    requestParams =
      weather: @cityData.zipCode + ',' + @cityData.country
      hl: 'fr'
      res: 'json'

    that = @

    console?.log @providerUrl

    $.get @providerUrl, requestParams, (data) ->
      console?.log 'Retrieved weather for', that.cityData, data
    , 'JSON'

window.lycorn = {} if !window.lycorn
window.lycorn.WeatherDetector = WeatherDetector