services = angular.module('timekeeper.services')

services.factory 'MissingSignature', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory url: '/api/missing_signatures', name: 'missingSignature'
]
