controllers = angular.module 'timekeeper.controllers'

controllers.controller 'showEventsCtrl', ['$scope', 'Client', 'Therapist', 'Event', 'EventCategory', 'User', 'errorBox', ($scope, Client, Therapist, Event, EventCategory, User, errorBox) ->
  # models updated from ui
  $scope.current =
    client: null
    category: null
    therapist: null
    eventCounter: 0

  $scope.events = []
  $scope.therapists = []
  $scope.categories = []
  $scope.clients = []
  $scope.showAllTherapistEvents = true

  $scope.reloadEvents = ->
    $scope.current.eventCounter += 1

  loadEvents = (start, end, callback) ->
    if $scope.inProgress
      return callback($scope.events)

    options =
      start: start.toISOString()
      end: end.toISOString()
      unbilled: !$scope.showAllTherapistEvents

    if $scope.current.therapist
      options.therapist_id = $scope.current.therapist.id

    if $scope.current.client
      options.client_id = $scope.current.client.id

    if $scope.current.category
      options.event_category_id = $scope.current.category.id

    Event.query(options).then (events) ->
      $scope.events = events
      callback(events)

  Client.query().then (clients) ->
    $scope.clients = clients

  $scope.inProgress = true
  User.get('current').then (user) ->
#    console?.log "new: ", user
    $scope.therapists = user.therapists
    $scope.current.therapist = user.therapist
    $scope.categories = user.eventCategories
    $scope.inProgress = false
  , (error) ->
    errorBox.open 'Failed to load calendar', 'Sorry, I could not load all the information needed for the calendar. Please try again.', [JSON.stringify(error)]

  getEvents = (start, end, callback) ->
#    console?.log "getEvents", start, end
    loadEvents(start, end, callback)

  renderEvent = (event, element, view) ->
    unless $scope.current.therapist
      element.find('.fc-event-title').append("<span class='abbrv'>#{event.therapistAbbrv}</span>")
    true

  $scope.$watch 'current.therapist', ->
    $scope.reloadEvents()

  $scope.$watch 'current.client', ->
    $scope.reloadEvents()

  $scope.$watch 'current.category', ->
    $scope.reloadEvents()

  $scope.$watch 'showAllTherapistEvents', ->
    $scope.reloadEvents()

  $scope.eventOptions =
    events: getEvents
    onEventRender: renderEvent
    eventsWatcher: ->
      $scope.current.eventCounter
]
