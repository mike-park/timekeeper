// https://github.com/angular-ui/bootstrap/pull/441#issuecomment-23909318
// based on messageBox
angular.module('errorBox', ["timekeeper.templates"])

  .controller('ErrorBoxController', ['$scope', '$modalInstance', 'model', function ($scope, $modalInstance, model) {
    $scope.$emit('hideProgress');


    $scope.onToggleShowDetails = function () {
      $scope.showDetails = !$scope.showDetails;
      $scope.detailButtonText = ($scope.showDetails ? 'Less' : 'More') + ' Details';
    };


    $scope.title = model.title;
    $scope.description = model.description;
    $scope.details = model.details || [];
    $scope.showDetails = true;
    $scope.onToggleShowDetails();
    $scope.hasDetails = $scope.details.length > 0;
    $scope.close = function (res) {
      $modalInstance.close(res);
    };
  }])

  .factory('errorBox', ['$modal', 'ERROR_TEMPLATE', function ($modal, ERROR_TEMPLATE) {
    return {
      open: function (title, description, details, modalOptions) {
        var options = {
          templateUrl: ERROR_TEMPLATE,
          controller: 'ErrorBoxController',
          resolve: {
            model: function () {
              return {
                title: title,
                description: description,
                details: details
              };
            }
          }
        };

        if (modalOptions)
          angular.extend(options, modalOptions);

        return $modal.open(options);
      }
    }
  }]);
