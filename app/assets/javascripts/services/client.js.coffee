services = angular.module('timekeeper.services')

services.factory 'Client', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory url: '/api/clients', name: 'client'
]
