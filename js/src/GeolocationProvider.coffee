class GeolocationProvider

   constructor: (@callback = (() ->)) ->
      @doc = jQuery document
      @geolocationOpts =
         enableHighAccuracy: true
         maximumAge: 0
         timeout: 30

      if navigator.geolocation
         @searchWithGPS()
      else
         @searchWithoutGPS()

   # Try to get a position using the device GPS.
   # Fallback on IP Detection on fail
   searchWithGPS: ->
      that = this

      navigator.geolocation.getCurrentPosition (position) ->
         provider = that
         lat = position.coords.latitude
         long = position.coords.longitude

         geocodingParams =
            latlng: lat + ',' + long
            sensor: 'true'

         $.get 'http://maps.googleapis.com/maps/api/geocode/json', geocodingParams, (data) ->
            for component of results.address_components
               for type in component.types
                  city = component.short_name if type is "locality"
                  country = component.short_name if type is "country"

            provider.buildLocation lat, long, city, country, 'GPS'

            return
         , 'JSON'
      , @searchWithoutGPSAsFallback(@), @geolocationOpts

      return

   searchWithoutGPSAsFallback: (scope) ->
      context = scope
      temp = ->
         return context.searchWithoutGPS.apply context

   # Search for user location using IP and http://ipinfo.io/
   searchWithoutGPS: ->
      provider = this

      $.get 'http://ipinfo.io/json', (data) ->
         _tmp = data.loc.split ','
         lat = _tmp[0]
         long = _tmp[1]

         # If they are missing informations
         if !data.city or !data.country

            geocodingParams =
               latlng: lat + ',' + long
               sensor: 'true'

            $.get 'http://maps.googleapis.com/maps/api/geocode/json', geocodingParams, (data) ->
               for component of results.address_components
                  for type in component.types
                     city = component.short_name if type is "locality"
                     country = component.short_name if type is "country"

               provider.buildLocation lat, long, city, country, 'GPS'

               return
         # Retrieved informations are complete
         provider.buildLocation lat, long, data.city, data.country, 'IP'
         return
      , 'JSON'

      return

   buildLocation: (lat, long, city, country, type) ->
      location = new lycorn.Geolocation lat, long, city, country, type

      @callback location

      return

   window.lycorn = {} if !window.lycorn
   window.lycorn.GeolocationProvider = GeolocationProvider
