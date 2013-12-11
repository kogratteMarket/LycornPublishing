window.myApp = angular.module 'myApp', []

window.myApp.factory 'updateSearchResults', ($window, $q, $rootScope) ->
  deferred = $q.defer()

  $window.updateSearchResults = (obj) ->
    deferred.resolve obj
    $rootScope.$apply()

  return deferred.promise


window.myApp.controller 'SearchResults', ($scope, updateSearchResults) ->

  updateSearchResults.then (locations) ->
    $scope.locations = locations

    # Has to be moved, waiting for weather informations
    $(document).trigger 'searchResultsRendered'
    #for location in locations
    #  new lycorn.WeatherDetector location

  $scope.locations = []

  $scope.getMetroClass = (index) ->
    availableClasses = [
      'panel-primary'
      'panel-success'
      'panel-warning'
      'panel-danger'
      'panel-info'
    ]

    return availableClasses[index % 5]

