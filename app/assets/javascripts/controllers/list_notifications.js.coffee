controllers = angular.module 'timekeeper.controllers'

controllers.controller 'listNotificationsCtrl', ['$scope', 'Notification', ($scope, Notification) ->
  $scope.notifications = Notification.query()

  $scope.columnDefs = [
    {
      field: 'occurredOn'
      displayName: 'Wann'
      cellTemplate: '<div tk-date-from-now="{{row.entity[col.field]}}"></div>'
    }
    {
      field: 'who'
      displayName: 'Wer'
    }
    {
      field: 'clientFullName'
      displayName: 'Client'
    }
    {
      field: 'icon'
      displayName: 'Wie'
      width: 'auto'
      cellTemplate: '<icon class="{{ row.entity[col.field] }}"></icon>'
    }
    {
      field: 'note'
      displayName: 'Was'
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
