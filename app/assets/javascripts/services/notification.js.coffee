services = angular.module('timekeeper.services')

services.factory 'Notification', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory url: '/api/notifications', name: 'notification'
]
