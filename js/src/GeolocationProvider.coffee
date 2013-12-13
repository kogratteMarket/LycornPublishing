# Maybe the biggest object in this test.
#
# On theory, you can use HTML5 or GPS to load the client location, but: he can refuse, he can be using
# the fuc*** old browser IE or anything else I cannot imagine.
#
# To prevent this, I choose to load informations from another provider, and discover the http://ipinfo.io/json.
# This service provide a lat/long like the GPS, but also the city name and the zipcode.
#
# Using the GPS, you only get the lat/long data, so I need to retrieve the associated zipCode.
#
# To do that, a little call to the geocode api from google, and retrieve missing informations to fill the Geolocation
# object!

class GeolocationProvider

   constructor: (@callback = (() ->)) ->
      @doc = jQuery document
      @geolocationOpts =
         enableHighAccuracy: true
         maximumAge: 0
         timeout: 3000

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

         # No magic stuff here, this is the JQuery call that I'm using!
         $.get 'http://maps.googleapis.com/maps/api/geocode/json', geocodingParams, (data) ->
            for component of data.results.address_components
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
   # Returned informations are complete on most of time, but there is always a but,
   # and sometimes there is no zipcode or cityname. Like for the GPS results,
   # a little request on the geocode service solve the problem.
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
               for component of data.results.address_components
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
