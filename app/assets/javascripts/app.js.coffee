#= require utilities
#= require controllers
#= require services
#= require directives
#= require templates

timekeeper = angular.module('timekeeper', ['timekeeper.controllers', 'timekeeper.directives', 'ngGrid'])
timekeeper.value 'ui.config',
  jq:
    tooltip:
      placement: 'right'

$ ->
    $('.date-picker').datepicker({ dateFormat: 'dd.mm.yy' });
