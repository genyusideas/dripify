function LoginController($scope, $rootScope, $location, $http, Config, User, Auth, SessionHandler) {
  $scope.currentUser = Auth.getCurrentUser();

  // Redirect to a signed in page if the user is signed in.
  if ( $scope.currentUser != null ) {
    location.path( '/' );
  }

  $scope.login = function() {
    var payload = {
      email: $scope.username,
      password: $scope.password,
    };
    $http.post( Config.api.rootUrl + '/users/sign_in', payload ).
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
    });

  };
};

LoginController.$inject = ['$scope', '$rootScope', '$location', '$http', 'Config', 'User', 'Auth', 'SessionHandler']