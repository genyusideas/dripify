'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('Drippio.services', ['ngResource', 'Drippio.config']).
  value('version', '0.1').

  factory( 'SessionHandler', ['$cookieStore', '$location', function( $cookieStore, $location ) {
    var sessionHandler = {};
    sessionHandler.setToken = function( newToken ) {
      $cookieStore.put('authToken', newToken);
    };
    sessionHandler.getToken = function() {
      if( !angular.isDefined( $cookieStore.get('authToken') ) ) {
        return '';
      } else {
        return $cookieStore.get('authToken');
      }
    };
    sessionHandler.isTokenSet = function() {
      return angular.isDefined( $cookieStore.get('authToken') );
    }
    //
    // Method to wrap a given action of a resource to send the
    // auth token with every request to the API.
    //
    sessionHandler.wrapActions = function( resource, actions ) {
      var wrappedResource = resource;
      for( var i = 0; i < actions.length; i++ ) {
        sessionWrapper( wrappedResource, actions[i] );
      }
      return wrappedResource;
    };
    //
    // Method to wrap the resource action and send the request
    // with the auth token.
    //
    var sessionWrapper = function( resource, action ) {
      resource['_' + action] = resource[action];
      resource[action] = function( data, success, error ) {
        return resource['_' + action](
          // Call action with the provided data and
          // the appended auth_token.
          angular.extend({}, data || {},
            {auth_token: sessionHandler.getToken()}),
          success,
          error
        );
      }
    };

    return sessionHandler;
  }]).

  factory( 'User', ["$resource", "Config", "SessionHandler",
    function( $resource, Config, SessionHandler ) {
      var resource = $resource( Config.api.fullUrl + "/users/:slug/:action",
        { slug: '@id'},
        {
          login: { method: 'POST', params: { slug: 'sign_in' } },
          load: { method: 'GET', params: { slug: 'get_current_user' } },
          update: { method: 'PUT' },
          setAsActive: { method: 'PUT', params: { slug: 'set_user_active' } }
        }
      );
      resource = SessionHandler.wrapActions( resource, ["query", "get", "update", "load", "setAsActive"] );

      return resource;
    }]
  ).

  factory('TwitterAccount', ["$resource", "Config", 'SessionHandler',
    function($resource, Config, SessionHandler) {
      var resource = $resource(  Config.api.fullUrl + "/users/:slug/twitter_accounts/:twitter_id",
        {},
        {
          update: { method: "PUT" }
        }
      );
      resource = SessionHandler.wrapActions( resource, ["query"] );

      return resource;
    }]
  ).

  factory('DripMarketingCampaign', ["$resource", "Config", 'SessionHandler',
    function($resource, Config, SessionHandler) {
      var resource = $resource(  Config.api.fullUrl + "/users/:slug/twitter_accounts/:twitter_id/drip_marketing_campaigns/:drip_marketing_campaign_id",
        {},
        {
          update: { method: "PUT" }
        }
      );
      resource = SessionHandler.wrapActions( resource, ["query", "get", "create"] );

      return resource;
    }]
  ).

  factory('DripMarketingRule', ["$resource", "Config", 'SessionHandler',
    function($resource, Config, SessionHandler) {
      var resource = $resource(  Config.api.fullUrl + "/users/:slug/twitter_accounts/:twitter_id/drip_marketing_campaigns/:drip_marketing_campaign_id/drip_marketing_rules/:drip_marketing_rule_id",
        {},
        {
          update: { method: "PUT" },
          delete: { method: "DELETE" }
        }
      );
      resource = SessionHandler.wrapActions( resource, ["query", "save", "update", "delete"] );

      return resource;
    }]
  ).

  factory( 'Auth', ["User", "$location", "$rootScope", "SessionHandler",
    function( User, $location, $rootScope, SessionHandler ) {
      var auth = {
        currentUser: undefined,

        getCurrentUser: function( callback ) {
          if( !angular.isDefined( auth.currentUser ) ) {
            User.load( {}, function success( user ) {
              console.log("successfully loaded the current user");
              auth.currentUser = user;
              $rootScope.currentUser = auth.currentUser;
              if( callback !== undefined ) callback( auth );
              if( $location.path() == '/login' || $location.path() == '/signup' ) $location.path( '/drip_marketing_campaigns' );
            }, function error() {
              console.log('error loading currentUser');
            }
            );
          } else {
            if( callback !== undefined )
              callback( auth );
          }
          return auth.currentUser;
        },
        destroyCurrentUser: function() {
          SessionHandler.setToken( undefined );
          $rootScope.currentUser = undefined;
          auth.currentUser = undefined;
        }
      };
      return auth;
    }]
  );
