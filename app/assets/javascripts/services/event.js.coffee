services = angular.module('timekeeper.services')

services.factory 'Event', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory url: '/api/events', name: 'event'
]
