controllers = angular.module 'timekeeper.controllers'

controllers.controller 'listClientsCtrl', ['$scope', 'Client', ($scope, Client) ->
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
      $scope.$emit 'showError',
        title: 'Error loading client'
        description: 'A problem occurred.  Please try again.'
        details: [JSON.stringify(error)]

  $scope.$watch 'showAllClients', ->
    reloadClients()

  $scope.$watch 'current.client', (client) ->
    loadClient(client)
]
