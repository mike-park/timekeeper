controllers = angular.module 'timekeeper.controllers'

controllers.controller 'eventsCtrl', ['$scope', 'Client', 'Therapist', 'Event', 'EventCategory', 'User', 'errorBox', ($scope, Client, Therapist, Event, EventCategory, User, errorBox) ->
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
  $scope.showAllClients = false
  $scope.showAllTherapistEvents = false

  loadEvents = (start, end, callback) ->
    if $scope.inProgress
      return callback($scope.events)

    options =
      therapist_id: $scope.current.therapist.id
      start: start.toISOString()
      end: end.toISOString()
      unbilled: !$scope.showAllTherapistEvents

    if $scope.current.client
      options.client_id = $scope.current.client.id

    Event.query(options).then (events) ->
      $scope.$emit 'hideEventPopover'
      $scope.events = events
      callback(events)

  $scope.reloadEvents = ->
    $scope.current.eventCounter += 1

  loadClients = () ->
    $scope.reloadEvents()
    options = {}
    id = $scope.current.therapist?.id
    if !$scope.showAllClients and id?
      options.therapist_id = id
    Client.query(options).then (clients) ->
      $scope.clients = clients
      $scope.current.client = null

  $scope.inProgress = true
  User.get('current').then (user) ->
#    console?.log "new: ", user
    $scope.therapists = user.therapists
    $scope.current.therapist = user.therapist
    $scope.categories = user.eventCategories
    $scope.current.category = user.eventCategories[0]
    $scope.inProgress = false
  , (error) ->
    errorBox.open 'Failed to load calendar', 'Sorry, I could not load all the information needed for the calendar. Please try again.', [JSON.stringify(error)]

  createEventOn = (date, allDay) ->
    console?.log "createEventOn", date, allDay
    # hack to avoid toJSON moving to the previous day
    date.setHours(12)
    client = $scope.current.client
    category = $scope.current.category
    therapist = $scope.current.therapist
    if client and category
      event = new Event(therapistId: therapist.id, clientId: client.id, eventCategoryId: category.id, occurredOn: date)
      console?.log "new event: ", event
      event.create().then (event) ->
        console?.log "created", event
        $scope.reloadEvents()
      , (error) ->
        errorBox.open 'Error creating new event', 'Your event could not be created. Please try again.',[JSON.stringify error]
        console?.log "failed: ", error

  createDefaultEventOn = (date, allDay, jsEvent, view) ->
    createEventOn(date, allDay)

  getEvents = (start, end, callback) ->
    #console?.log "getEvents", start, end
    loadEvents(start, end, callback)

  onEventDrop = (event, dayDelta) ->
    console?.log "eventDrop", event, dayDelta
    # HACK avoid toJSON moving to previous day 'cos TZ
    newDate = new Date(event.start)
    newDate.setHours(12)
    movedEvent = new Event(id: event.id, occurredOn: newDate)
    movedEvent.update().then (event) ->
      event
    , (error) ->
      $scope.$emit 'showError',
        title: 'Error moving event'
        description: 'Your event could not be moved. Please try again.'
        details: [JSON.stringify(error)]

  $scope.$watch 'current.therapist', (newValue, oldValue) ->
    if newValue != oldValue && newValue.id?
      loadClients()

  $scope.$watch 'current.client', ->
    $scope.reloadEvents()

  $scope.$watch 'showAllClients', ->
    loadClients()

  $scope.$watch 'showAllTherapistEvents', ->
    $scope.reloadEvents()

  $scope.eventOptions =
    events: getEvents
    onDayClick: createDefaultEventOn
    onDrop: createEventOn
    onEventDrop: onEventDrop
    eventsWatcher: ->
      $scope.current.eventCounter
]

