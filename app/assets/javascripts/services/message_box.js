// https://github.com/angular-ui/bootstrap/pull/441#issuecomment-23909318
// $dialog.messageBox replacement using $modal in bootstrap3 branch of angular-ui bootstrap
angular.module('messageBox', ["templates/messageBox/messageBox.html"])

  .controller('MessageBoxController', ['$scope', '$modalInstance', 'model', function ($scope, $modalInstance, model) {
    $scope.title = model.title;
    $scope.message = model.message;
    $scope.buttons = model.buttons;
    $scope.close = function (res) {
      $modalInstance.close(res);
    };
  }])

  .factory('messageBox', ['$modal', function ($modal) {
    return {
      open: function (title, message, buttons, modalOptions) {
        var options = {
          templateUrl: 'templates/messageBox/messageBox.html',
          controller: 'MessageBoxController',
          resolve: {
            model: function () {
              return {
                title: title,
                message: message,
                buttons: buttons
              };
            }
          }
        }

        if (modalOptions)
          angular.extend(options, modalOptions);

        return $modal.open(options);
      }
    }
  }]);

angular.module("templates/messageBox/messageBox.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("templates/messageBox/messageBox.html",
    "<div class=\"modal-header\">" +
    "  <h3>{{ title }}</h3>" +
    "</div>" +
    "<div class=\"modal-body\">" +
    "  <p>{{ message }}</p>" +
    "</div>" +
    "<div class=\"modal-footer\">" +
    "  <button ng-repeat=\"btn in buttons\" ng-click=\"close(btn.result)\" class=\"btn\" ng-class=\"btn.cssClass\">{{ btn.label }}</button>" +
    "</div>");
}]);
