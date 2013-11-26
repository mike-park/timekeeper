controllers = angular.module 'timekeeper.controllers'

controllers.controller 'newBillCtrl', ['$scope', 'Bill', 'Client', 'User', 'Event', '$modal', 'errorBox', '$window', ($scope, Bill, Client, User, Event, $modal, errorBox, $window) ->

  # start up
  $scope.inProgress = true

  $scope.categories = []
  $scope.clients = []
  $scope.bill = {}
  $scope.clientOrder = []
  $scope.billItemsByEventId = {}

  User.get('current').then (user) ->
    $scope.categories = user.eventCategories
  , (error) ->
    errorBox.open 'Failed to load user info', 'Sorry, I could not load all the information needed for creating a bill. Please try again.', [JSON.stringify(error)]

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
      errorBox.open 'Error saving event', 'Your event could not be saved. Please try again.', [JSON.stringify error]
      console?.log "failed", error

  UTCtoLocalTime = (utc) ->
    timeOffsetInHours = (new Date().getTimezoneOffset()/60) * (-1)
    utc = new Date(utc)
    utc.setHours(utc.getHours() + timeOffsetInHours)
    utc

  $scope.saveBillItem = ->
    console?.log "saveBillItem", $scope.billItem
    item = $scope.billItem
    event =
      therapistId: $scope.therapist.id
      clientId: item.client.id
      eventCategoryId: item.category.id
      occurredOn: UTCtoLocalTime(item.occurredOn)
      id: item.eventId
    return unless event.occurredOn and event.clientId and event.eventCategoryId
    saveEvent(event)

  $scope.reloadEvents = ->
    console.log "reloadEvents"
    $scope.billItem.editing = false
    loadBill(false)


  $scope.addBillItem = (clientId) ->
    $scope.editBillItem({clientId: clientId})

  $scope.editBillItem = (billItem) ->
    if billItem
      $scope.billItem = angular.copy(billItem)
      $scope.billItem.client = $scope.clientHash[billItem.clientId]
      $scope.billItem.category = $scope.eventCategoryHash[billItem.eventCategoryId]
    else
      $scope.billItem = {}
    modal = $modal.open
      templateUrl: 'billItemTemplate.html'
      scope: $scope
    modal.result.then ->
      $scope.saveBillItem()
    , ->
      console.log "modal dismissed"

  $scope.resetBillItem = ->
    $scope.billItem.editing = false

  $scope.clickBillItem = (editing, billItem) ->
    if editing
      $scope.editBillItem(billItem)
    else
      billItem.included = !billItem.included

  $scope.matchedBillItems = (included) ->
    items = []
    return [] unless $scope.bill.billItems
    for item in $scope.bill.billItems
      items.push(item) if item.included == included
    items

  createAttributesList = (items) ->
    add = ({eventId: item.eventId} for item in items when item.included and !item.id)
    subtract = ({id: item.id, '_destroy': 1} for item in items when !item.included and item.id)
    add.concat subtract

  $scope.saveBill = ->
    bill = new Bill
      id: $scope.bill.id
      billedOn: $scope.bill.billedOn
      number: $scope.bill.number
      billItemsAttributes: createAttributesList $scope.bill.billItems
    if $scope.bill.id
      action = $scope.bill.update
    else
      action = $scope.bill.create
    console.log "saving", bill
    action.call(bill).then (bill) ->
      console?.log "success", bill, bill.$url()
      $window.location.href = bill.$url()
    , (error) ->
      errorBox.open 'Error saving bill', 'Your bill could not be saved. Please try again.', [JSON.stringify error]
      console?.log "saveBill failed", error


  presetIncluded = (key) ->
    existingBillItem = $scope.billItemsByEventId[key.eventId]
    currentMonth = moment().month()
    key.included = if existingBillItem?
      existingBillItem.included
    else if moment(key.occurredOn).month() == currentMonth
      true
    else
      false

  loadBill = (firstTime) ->
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
      $scope.billItemsByEventId ||= {}

      for key in bill.billItems
        presetIncluded(key)
        key.category = $scope.eventCategoryHash[key.eventCategoryId]
        billItemsByEventId[key.eventId] = key
        clientOrder.push(key.clientId) unless billItemsByClient[key.clientId]
        billItemsByClient[key.clientId] ||= []
        billItemsByClient[key.clientId].push(key)

      $scope.billItemsByEventId = billItemsByEventId
      $scope.billItemsByClient = billItemsByClient
      $scope.clientOrder = clientOrder

      unless firstTime
        bill.billedOn = $scope.bill.billedOn
        bill.number = $scope.bill.number

      $scope.bill = bill
      $scope.therapist = bill.therapist

      $scope.inProgress = false

  loadBill(true)
]


