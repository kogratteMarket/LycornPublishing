window.myApp = angular.module 'myApp', []

window.myApp.controller 'SearchResults', ($scope) ->

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

