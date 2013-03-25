services = angular.module('timekeeper.services')

services.factory 'User', ['railsResourceFactory', (railsResourceFactory) ->
    resource = railsResourceFactory url: '/api/users', name: 'user'
    resource
  ]
