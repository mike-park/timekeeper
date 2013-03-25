services = angular.module('timekeeper.services')

services.factory 'Therapist', ['railsResourceFactory', (railsResourceFactory) ->
    resource = railsResourceFactory url: '/therapists', name: 'therapist'
    resource
  ]
