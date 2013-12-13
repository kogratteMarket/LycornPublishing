// Generated by CoffeeScript 1.6.3
(function() {
  var CityAroundResearch, Geolocation, GeolocationProvider, Loader;

  CityAroundResearch = (function() {
    function CityAroundResearch(geolocation, callback, proximity) {
      var searchParams, that;
      this.geolocation = geolocation;
      this.callback = callback != null ? callback : (function() {});
      this.proximity = proximity != null ? proximity : 'asc';
      searchParams = {
        lat: this.geolocation.getLat(),
        long: this.geolocation.getLong(),
        results: 10,
        proximity: this.proximity
      };
      that = this;
      $.get('http://thelycornweather.sebacmieu.fr/search/city.php', searchParams, function(data) {
        if (typeof console !== "undefined" && console !== null) {
          console.log(data);
        }
        return that.callback(data);
      }, 'JSON');
    }

    return CityAroundResearch;

  })();

  if (!window.lycorn) {
    window.lycorn = {};
  }

  window.lycorn.CityAroundResearch = CityAroundResearch;

  Geolocation = (function() {
    function Geolocation(lat, long, cityName, country, type) {
      this.lat = lat;
      this.long = long;
      this.cityName = cityName;
      this.country = country;
      this.type = type != null ? type : 'ip';
    }

    Geolocation.prototype.getLat = function() {
      return this.lat;
    };

    Geolocation.prototype.getLong = function() {
      return this.long;
    };

    Geolocation.prototype.getCityName = function() {
      return this.cityName;
    };

    Geolocation.prototype.country = function() {
      return this.country;
    };

    return Geolocation;

  })();

  if (!window.lycorn) {
    window.lycorn = {};
  }

  window.lycorn.Geolocation = Geolocation;

  GeolocationProvider = (function() {
    function GeolocationProvider(callback) {
      this.callback = callback != null ? callback : (function() {});
      this.doc = jQuery(document);
      this.geolocationOpts = {
        enableHighAccuracy: true,
        maximumAge: 0,
        timeout: 5000
      };
      if (navigator.geolocation) {
        this.searchWithGPS();
      } else {
        this.searchWithoutGPS();
      }
    }

    GeolocationProvider.prototype.searchWithGPS = function() {
      var that;
      that = this;
      navigator.geolocation.getCurrentPosition(function(position) {
        var geocodingParams, lat, long, provider;
        provider = that;
        lat = position.coords.latitude;
        long = position.coords.longitude;
        geocodingParams = {
          latlng: lat + ',' + long,
          sensor: 'true'
        };
        return $.get('http://maps.googleapis.com/maps/api/geocode/json', geocodingParams, function(data) {
          var city, component, country, type, _i, _len, _ref;
          for (component in data.results.address_components) {
            _ref = component.types;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              type = _ref[_i];
              if (type === "locality") {
                city = component.short_name;
              }
              if (type === "country") {
                country = component.short_name;
              }
            }
          }
          provider.buildLocation(lat, long, city, country, 'GPS');
        }, 'JSON');
      }, this.searchWithoutGPSAsFallback(this), this.geolocationOpts);
    };

    GeolocationProvider.prototype.searchWithoutGPSAsFallback = function(scope) {
      var context, temp;
      context = scope;
      return temp = function() {
        return context.searchWithoutGPS.apply(context);
      };
    };

    GeolocationProvider.prototype.searchWithoutGPS = function() {
      var provider;
      provider = this;
      $.get('http://ipinfo.io/json', function(data) {
        var geocodingParams, lat, long, _tmp;
        _tmp = data.loc.split(',');
        lat = _tmp[0];
        long = _tmp[1];
        if (!data.city || !data.country) {
          geocodingParams = {
            latlng: lat + ',' + long,
            sensor: 'true'
          };
          $.get('http://maps.googleapis.com/maps/api/geocode/json', geocodingParams, function(data) {
            var city, component, country, type, _i, _len, _ref;
            for (component in data.results.address_components) {
              _ref = component.types;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                type = _ref[_i];
                if (type === "locality") {
                  city = component.short_name;
                }
                if (type === "country") {
                  country = component.short_name;
                }
              }
            }
            provider.buildLocation(lat, long, city, country, 'GPS');
          });
        }
        provider.buildLocation(lat, long, data.city, data.country, 'IP');
      }, 'JSON');
    };

    GeolocationProvider.prototype.buildLocation = function(lat, long, city, country, type) {
      var location;
      location = new lycorn.Geolocation(lat, long, city, country, type);
      this.callback(location);
    };

    if (!window.lycorn) {
      window.lycorn = {};
    }

    window.lycorn.GeolocationProvider = GeolocationProvider;

    return GeolocationProvider;

  })();

  Loader = (function() {
    Loader["default"] = {
      nbItems: 10,
      speed: 1000
    };

    function Loader(element, options) {
      this.element = element;
      this.animateIncrease();
    }

    Loader.prototype.animateIncrease = function() {
      var that;
      that = this;
      return this.element.animate({
        width: '100%'
      }, 'slow', 'swing', function() {
        return setTimeout(function() {
          return that.animateDecrease();
        }, 1000);
      });
    };

    Loader.prototype.animateDecrease = function() {
      var that;
      that = this;
      return this.element.animate({
        width: '0%'
      }, 'slow', 'swing', function() {
        return setTimeout(function() {
          return that.animateIncrease();
        }, 1000);
      });
    };

    return Loader;

  })();

  window.lycornLoader = Loader;

  window.myApp = angular.module('myApp', []);

  window.myApp.controller('SearchResults', function($scope) {
    $scope.locations = [];
    $scope.arriving = true;
    $scope.doshow = {};
    $scope.getTempIndicatorClass = function(temp) {
      if (temp < 6) {
        return 'cold';
      }
      if (temp < 22) {
        return 'warm';
      }
      return 'hot';
    };
    return $scope.getMetroClass = function(index) {
      var availableClasses;
      availableClasses = ['panel-primary', 'panel-success', 'panel-warning', 'panel-danger', 'panel-info'];
      return availableClasses[index % 5];
    };
  });

}).call(this);
