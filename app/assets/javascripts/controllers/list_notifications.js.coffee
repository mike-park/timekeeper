controllers = angular.module 'timekeeper.controllers'

controllers.controller 'listNotificationsCtrl', ['$scope', 'Notification', ($scope, Notification) ->
  Notification.query().then (notifications) ->
    $scope.notifications = notifications

  $scope.columnDefs = [
    {
      field: 'occurredOn'
      displayName: 'Wann'
      cellTemplate: '<div tk-date-from-now="{{row.entity[col.field]}}"></div>'
      width: 140
    }
    {
      field: 'who'
      displayName: 'Wer'
      maxWidth: 190
      width: 190
    }
    {
      field: 'clientFullName'
      displayName: 'Client'
      width: 280
    }
    {
      field: 'icon'
      displayName: 'Wie'
      width: 50
      cellTemplate: '<icon class="{{ row.entity[col.field] }}"></icon>'
    }
    {
      field: 'note'
      displayName: 'Was'
      minWidth: 300
    }
  ]

  $scope.ngGridOptions =
    data: 'notifications'
    showGroupPanel: true
    columnDefs: 'columnDefs'
    enableRowSelection: false
    enableColumnResize: true
    enableColumnReordering: true
]
