'use strict';


// Declare app level module which depends on filters, and services
angular.module('Drippio', ['Drippio.filters', 'Drippio.services', 'Drippio.directives', 'Drippio.controllers', 'ngResource', 'ngCookies', 'Drippio.config']).

  run(['$rootScope', '$location', 'Auth', 'SessionHandler', function( $rootScope, $location, Auth, SessionHandler ) {
    $rootScope.$on('event:unauthorized', function( event ) {
      console.log( 'unauthorized' );
      Auth.destroyCurrentUser();
      if( $location.path() == '/logout' || $location.path().match(/^\/(login|signup|)/) ) {
        if( $location.path() !== '/logout' ) {
          // TODO: Implement the ability to pass through to the original 
          // path after signin.
          // SessionHandler.setAfterSignInPath( $location.path() );
        }
        else if ( $location.path() !== '/signup' ) {
          $location.path( "/login" );
        }
        else { 
          $location.path( "/signup" );
        }
      }
    })
    $rootScope.$on( '$routeChangeStart', function( event, next, current ) {
      if( $location.path() !== '/login' && !$location.path().match(/^\/(login|signup|)/) ) {
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
      when('/', { templateUrl: '/assets/app/views/client/home.html', controller: 'HomeController' }).
      when('/login', { templateUrl: '/assets/app/views/client/login.html', controller: 'LoginController' }).
      when('/logout', { templateUrl: '/assets/app/views/client/logout.html', controller: 'LogoutController' }).
      when('/signup', { templateUrl: '/assets/app/views/client/signup.html', controller: 'SignupController' }).
      when('/plans', { templateUrl: '/assets/app/views/client/plans.html' }).
      when('/drip_marketing_campaigns', { 
        templateUrl: '/assets/app/views/client/drip_marketing_campaigns.html', 
        controller: 'DripMarketingCampaignsController' 
      }).
      otherwise({ redirectTo: '/login' });
  }]);

window.DrippioController = ['$scope', 'Auth', '$rootScope', '$location',
  function DrippioController($scope, Auth, $rootScope, $location) {
    $scope.partials = {
      nav: '/assets/app/views/client/navigation.html',
      footer: '/assets/app/views/client/footer.html'
    }
  }
]
