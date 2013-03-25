#= require_self
#= require_tree ./services

services = angular.module('timekeeper.services', ['rails'])

services.config ["$httpProvider", (provider) ->
    provider.defaults.headers.common['X-CSRF-Token'] = angular.element('meta[name=csrf-token]').attr('content')
  ]

