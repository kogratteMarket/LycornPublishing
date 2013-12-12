window.myApp = angular.module 'myApp', []

window.myApp.controller 'SearchResults', ($scope) ->

   $scope.locations = []

   $scope.arriving = true

   $scope.getTempIndicatorClass = (temp) ->
      return 'cold' if temp < 6
      return 'warm' if temp < 22
      return 'hot'

   $scope.getMetroClass = (index) ->
      availableClasses = [
         'panel-primary'
         'panel-success'
         'panel-warning'
         'panel-danger'
         'panel-info'
      ]

      return availableClasses[index % 5]

