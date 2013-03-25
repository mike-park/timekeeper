angular.module('timekeeper.services').factory('cachingRailsResourceFactory', ['$q', 'railsResourceFactory', function ($q, railsResourceFactory) {
  function cachingRailsResourceFactory(config) {
    var resource = railsResourceFactory(config);
    resource.cacheMap = {};
    resource.values = [];
    resource.directGet = resource.get;

    function clearCache() {
      angular.forEach(resource.cacheMap, function (value, key) {
        delete resource.cache[key];
      });

      resource.values.length = 0;
    }

    function sortValues() {
      if (resource.hasOwnProperty('sort')) {
        resource.sort(resource.values);
      }
    }

    resource.load = function (params) {
      var promise = resource.query(params);

      return promise.then(function (results) {
        if (angular.isArray(results)) {
          clearCache();

          angular.forEach(results, function (value) {
            resource.cacheMap[value.id] = value;

            if (!value.hasOwnProperty('recordStatus') || value.recordStatus === 'a') {
              resource.values.push(value);
            }
          });

          sortValues();
          return resource.values;
        }

        return results;

      }, function (error) {
        clearCache();
        return $q.reject(error);
      });
    };

    resource.getCachedValue = function (id) {
      if (resource.cacheMap.hasOwnProperty(id)) {
        return resource.cacheMap[id];
      }

      return null;
    };

    resource.get = function (id) {
      var deferred, cached = resource.getCachedValue(id);

      if (cached) {
        deferred = $q.defer();
        deferred.resolve(cached);
        return deferred.promise;
      }

      return resource.directGet(id).then(function (result) {
        resource.cacheMap[result.id] = result;
        resource.values.push(result);
        return result;
      });
    };

    return resource;
  }

  return cachingRailsResourceFactory;
}]);
