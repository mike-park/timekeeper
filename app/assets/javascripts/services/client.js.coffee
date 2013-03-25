services = angular.module('timekeeper.services')

# intercept returned client data and convert internal events into Event resources
services.factory 'clientEventsInterceptor', ['Event', (Event) ->
  (promise) ->

    convert = (events) ->
      new Event(event) for event in events

    promise.then (result) ->
      if result.data and angular.isArray(result.data)
        for client in result.data
          client.events = convert(client.events) if angular.isArray(client.events)
      else if result.data and angular.isArray(result.data.events)
        result.data.events = convert(result.data.events)
      result
]

services.factory 'Client', ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory
    url: '/api/clients'
    name: 'client'
    responseInterceptors: [
      'railsFieldRenamingInterceptor'
      'railsRootWrappingInterceptor'
      'clientEventsInterceptor']
]
