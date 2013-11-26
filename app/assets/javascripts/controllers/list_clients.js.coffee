controllers = angular.module 'timekeeper.controllers'

controllers.controller 'listClientsCtrl', ['$scope', 'Client', 'errorBox', ($scope, Client, errorBox) ->
  $scope.current =
    client: null

  $scope.showAllClients = false

  $scope.deleteEvent = (event) ->
    event.remove().then ->
      loadClient($scope.current.client)

  $scope.deleteClient = (client) ->
    client.remove().then ->
      reloadClients()

  reloadClients = ->
    $scope.current.client = null
    $scope.client = null
    Client.query(all: $scope.showAllClients).then (clients) ->
      $scope.clients = clients

  loadClient = (client) ->
    return unless client?
    Client.get(client.id).then (client) ->
      $scope.client = client
    , (error) ->
      errorBox.open 'Error loading client', 'A problem occurred.  Please try again.', [JSON.stringify(error)]

  $scope.$watch 'showAllClients', ->
    reloadClients()

  $scope.$watch 'current.client', (client) ->
    loadClient(client)
]
