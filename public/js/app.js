'use strict';


// Declare app level module which depends on filters, and services
angular.module('Drippio', ['Drippio.filters', 'Drippio.services', 'Drippio.directives', 'Drippio.controllers', 'ngResource', 'ngCookies', 'Drippio.config']).

  run(['$rootScope', '$location', 'Auth', 'SessionHandler', function( $rootScope, $location, Auth, SessionHandler ) {
    $rootScope.$on('event:unauthorized', function( event ) {
      console.log( 'unauthorized' );
      Auth.destroyCurrentUser();
      if( $location.path() == '/logout' || $location.path().match(/^\/(login|join|)/) ) {
        if( $location.path() !== '/logout' ) {
          // TODO: Implement the ability to pass through to the original 
          // path after signin.
          // SessionHandler.setAfterSignInPath( $location.path() );
        }
        $location.path( "/login" );
      }
    })
    $rootScope.$on( '$routeChangeStart', function( event, next, current ) {
      if( $location.path() !== '/login' && !$location.path().match(/^\/(login|join|)/) ) {
        Auth.getCurrentUser();
      }
    })
  }]).

  config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider) {
    var interceptor = ['$rootScope', '$q', function(scope, $q) {
      function success( response ){
        return response;
      };
      function error( response ) {
        if ( response.status == 401 ) {
          var deferred = $q.defer();
          scope.$broadcast( 'event:unauthorized' );
          return deferred.promise;
        } else if ( response.status == 422 ) {
          return response;
        } else {
          return $q.reject( response );
        }
      };

      return function( promise ) {
        return promise.then( success, error );
      }
    }];
    $httpProvider.responseInterceptors.push( interceptor );
    $routeProvider.
      when('/login', { templateUrl: 'views/login.html', controller: 'LoginController' }).
      when('/logout', { templateUrl: 'views/logout.html', controller: 'LogoutController' }).
      when('/plans', { templateUrl: 'views/plans.html' }).
      when('/drip_marketing_campaigns', { 
        templateUrl: 'views/drip_marketing_campaigns.html', 
        controller: 'DripMarketingCampaignsController' 
      }).
      when('/').
      otherwise({ redirectTo: '/login' });
  }]);

window.DrippioController = ['$scope', 'Auth', '$rootScope', '$location',
  function DrippioController($scope, Auth, $rootScope, $location) {
    $scope.partials = {
      nav: 'views/navigation.html',
      footer: 'views/footer.html'
    }
  }
]
