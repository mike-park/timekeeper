controllers = angular.module 'timekeeper.controllers'

controllers.controller 'missingSignaturesCtrl', ['$scope', 'MissingSignature', ($scope, MissingSignature) ->
  $scope.missingSignatures = MissingSignature.query()

  $scope.columnDefs = [
    {
      field: 'clientFullName'
      displayName: 'Client'
      width: '*'
    }
    {
      field: 'occurredOn'
      displayName: 'Wann'
      cellTemplate: '<div tk-date-format="{{row.entity[col.field]}}" format="L"></div>'
      width: '*'
    }
  ]

  $scope.ngGridOptions =
    data: 'missingSignatures'
    showGroupPanel: true
    columnDefs: 'columnDefs'
    enableRowSelection: false
    enableColumnResize: true
    enableColumnReordering: true
    groups: ['clientFullName']
    showFilter: true
]
