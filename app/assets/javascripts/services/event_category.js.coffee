services = angular.module('timekeeper.services')

services.factory 'EventCategory', ['railsResourceFactory', (railsResourceFactory) ->
    resource = railsResourceFactory url: '/event_categories', name: 'eventCategory', pluralName: 'eventCategories'
    resource
  ]
