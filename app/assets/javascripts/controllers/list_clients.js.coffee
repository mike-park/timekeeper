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
    $scope.clients = Client.query(all: $scope.showAllClients)

  loadClient = (client) ->
    return unless client?
    $scope.client = Client.get(client.id).then (client) ->
      client
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
