services = angular.module('timekeeper.services')

services.factory 'Bill', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory url: '/api/bills', name: 'bill'
]
