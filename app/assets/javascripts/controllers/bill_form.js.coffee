controllers = angular.module 'timekeeper.controllers'

controllers.controller 'billFormCtrl', ['$scope', 'Bill', 'Client', 'User', 'Event', '$modal', 'errorBox', '$window', ($scope, Bill, Client, User, Event, $modal, errorBox, $window) ->

  # start up
  $scope.inProgress = true

  $scope.bill = {}
  $scope.clientOrder = []
  $scope.billItemsByEventId = {}

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
    $scope.loadBill($scope.bill.id)


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

  $scope.activeClientIds = ->
    items = $scope.matchedBillItems(true)
    _.chain(items).pluck('clientId').uniq().value()

  createAttributesList = (items) ->
    add = ({eventId: item.eventId} for item in items when item.included and !item.id)
    subtract = ({id: item.id, '_destroy': 1} for item in items when !item.included and item.id)
    add.concat subtract

  $scope.saveBill = ->
    bill = new Bill
      id: $scope.bill.id
      therapistId: $scope.therapist.id
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
      $window.location.href = "/bills/" + bill.id
    , (error) ->
      errorBox.open 'Error saving bill', 'Your bill could not be saved. Please try again.', [JSON.stringify error]
      console?.log "saveBill failed", error


  mergePreviousIncluded = (items) ->
    for item in items
      existingBillItem = $scope.billItemsByEventId[item.eventId]
      item.included = existingBillItem.included if existingBillItem?

  presetIncludedForNewBill = (items) ->
    currentMonth = moment().month()
    for item in items
      item.included = if moment(item.occurredOn).month() == currentMonth
        true
      else
        false

  presetIncludedForEditBill = (items) ->
    for item in items
      item.included = if item.id
        true
      else
        false

  createHash = (array, key = 'id') ->
    hash = {}
    for item in array
      hash[item[key]] = item
    hash

  mergeCategory = (items) ->
    for item in items
      item.category = $scope.eventCategoryHash[item.eventCategoryId]

  processBill = (bill) ->
    console.log "processBill", bill

    $scope.eventCategoryHash ||= createHash(bill.eventCategories)
    $scope.clientHash ||= createHash(bill.clients)
    $scope.therapist = bill.therapist

    if bill.id
      presetIncludedForEditBill(bill.billItems)
    else
      presetIncludedForNewBill(bill.billItems)

#   merge local changes
    mergePreviousIncluded(bill.billItems)
    mergeCategory(bill.billItems)
    bill.billedOn ||= $scope.bill.billedOn
    bill.number ||= $scope.bill.number

    $scope.billItemsByEventId = createHash(bill.billItems, 'eventId')

    billItemsByClient = {}
    clientOrder = []
    for key in bill.billItems
      clientOrder.push(key.clientId) unless billItemsByClient[key.clientId]
      billItemsByClient[key.clientId] ||= []
      billItemsByClient[key.clientId].push(key)
    $scope.billItemsByClient = billItemsByClient
    $scope.clientOrder = clientOrder

    $scope.bill = bill

    $scope.inProgress = false

  $scope.loadBill = (id) ->
    console.log "loadBill", id
    id = if id
      id + "/edit"
    else
      'new'
    Bill.get(id).then (bill) ->
      processBill(bill)
    , (error) ->
      errorBox.open 'Error loading bill', 'Bill could not be loaded. Current state is inconsistent. Please try again.', [JSON.stringify error]
      console?.log "loadBill failed", error

]
