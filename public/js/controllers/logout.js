function LogoutController($scope, $rootScope, $location, Auth) {
  Auth.destroyCurrentUser();
  Auth.getCurrentUser();
}

LogoutController.$inject = ['$scope', '$rootScope', '$location', 'Auth'];
