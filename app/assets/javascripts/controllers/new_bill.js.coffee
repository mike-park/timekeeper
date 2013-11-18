controllers = angular.module 'timekeeper.controllers'

controllers.controller 'newBillCtrl', ['$scope', 'Bill', 'Client', 'User', 'Event', ($scope, Bill, Client, User, Event) ->
  # models updated from ui
  $scope.current =
    clients: {}
    bill: {}
    names: []
    eventCounter: 0

  $scope.categories = []
  $scope.clients = []
  $scope.event = {}

  User.get('current').then (user) ->
    $scope.current.therapist = user.therapist
    $scope.categories = user.eventCategories
  , (error) ->
    $scope.$emit 'showError',
      title: 'Failed to load user info'
      description: 'Sorry, I could not load all the information needed for creating a bill. Please try again.'
      details: [JSON.stringify(error)]

  Client.query({}).then (clients) ->
    $scope.clients = clients

  $scope.deleteEvent = (event) ->
    console.log "delete", event

  $scope.markAll = (value) ->
    key.included = value for key in $scope.bill.billItems

  saveEvent = (event) ->
    console.log "saveEvent", event
    event = new Event(event)
    action = if event.id
      event.update
    else
      event.create
    action.call(event).then (event) ->
      console?.log "success", event
      $scope.reloadEvents()
    , (error) ->
      $scope.$emit 'showError',
        title: 'Error saving event'
        description: 'Your event could not be saved. Please try again.'
        details: [JSON.stringify error]
      console?.log "failed", error

  $scope.saveBillItem = ->
    console?.log "saveBillItem", $scope.billItem
    item = $scope.billItem
    event =
      therapistId: $scope.therapist.id
      clientId: item.client.id
      eventCategoryId: item.category.id
      occurredOn: item.occurredOn
      id: item.eventId
    return unless event.occurredOn and event.clientId and event.eventCategoryId
    saveEvent(event)

  $scope.reloadEvents = ->
    console.log "reloadEvents"
    $scope.billItem.editing = false
    loadBill()

  $scope.editBillItem = (billItem) ->
    $scope.billItem = angular.copy(billItem)
    $scope.billItem.client = $scope.clientHash[billItem.clientId]
    $scope.billItem.category = $scope.eventCategoryHash[billItem.eventCategoryId]
    $scope.billItem.editing = true

  $scope.resetBillItem = ->
    $scope.billItem.editing = false


  loadBill = ->
    Bill.get('new').then (bill) ->
      console.log "bill", bill
      hash = {}
      for key in bill.clients
        hash[key.id] = key
      $scope.clientHash = hash

      hash = {}
      for key in bill.eventCategories
        hash[key.id] = key
      $scope.eventCategoryHash = hash

      billItemsByEventId = {}
      billItemsByClient = {}
      clientOrder = []

      for key in bill.billItems
        key.included = billItemsByEventId[key.eventId].included if billItemsByEventId[key.eventId]
        billItemsByEventId[key.eventId] = key
        clientOrder.push(key.clientId) unless billItemsByClient[key.clientId]
        billItemsByClient[key.clientId] ||= []
        billItemsByClient[key.clientId].push(key)

      $scope.billItemsByEventId = billItemsByEventId
      $scope.billItemsByClient = billItemsByClient
      $scope.clientOrder = clientOrder

      $scope.bill ||= bill
      $scope.bill.billItems = bill.billItems
      $scope.therapist = bill.therapist

  loadBill()
]


