function SignupController($scope, $rootScope, $location, $http, Config, User, Auth, SessionHandler) {

  $scope.signup = function() {
    var payload = {
      user: {
        email: $scope.username,
        password: $scope.password,
        password_confirmation: $scope.confirm_password,
        first_name: $scope.first_name,
        last_name: $scope.last_name
      }
    };
    $http.post( Config.api.rootUrl + '/users', payload ).
    success( function( data ) {
      if ( data.errors != null ) {
        $scope.isLoginError = true;
        $scope.loginErrorContent = data.errors[0];
      } else {
        $scope.isLoginError = false;
        SessionHandler.setToken(data.authentication_token);
        Auth.getCurrentUser();
      }
    }).
    error (function( data ) {
      console.log('error');
      console.debug( data );
      console.log( data );

      $scope.currentUser = Auth.getCurrentUser();

  // Redirect to a signed in page if the user is signed in.
  if ( $scope.currentUser != null ) {
    location.path( '/' );
  }
    });

  };
};

SignupController.$inject = ['$scope', '$rootScope', '$location', '$http', 'Config', 'User', 'Auth', 'SessionHandler']