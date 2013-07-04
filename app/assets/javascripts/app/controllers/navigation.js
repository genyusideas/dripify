function NavigationController($scope, $rootScope, $location, $location, Auth, SessionHandler) {
  $scope.currentUser = Auth.getCurrentUser();
  $scope.loggedInItems = [];
  $scope.authItem = {};

  $rootScope.$watch('currentUser', function(newUser, oldUser){
    if( newUser ) {
      $scope.currentUser = newUser;
      $scope.rootUrl = '#/drip_marketing_campaigns';
      $scope.navItems = $scope.loggedInNavItems;
      $scope.authItem = $scope.loggedInAuthItem;
    } else {
      $scope.rootUrl = '#/login';
      $scope.navItems = $scope.loggedOutNavItems;
      $scope.authItem = $scope.loggedOutAuthItem;
    }
  }, true);

  $scope.loggedOutNavItems = [
    { href: "#/plans", linkText: "Plans" },
    { href: "#", linkText: "Home" }
  ];
  $scope.loggedOutAuthItem = 
    { href: "#/login", linkText: "Sign In", class: 'small signin button radius' };

  $scope.loggedInNavItems = [
    { href: "#/drip_marketing_campaigns", linkText: "Your Drips" },
    { href: "#", linkText: "Home" }
  ];
  $scope.loggedInAuthItem = 
    { href: "#/logout", linkText: "Sign Out", class: 'small signin button radius' };

  if ( SessionHandler.isTokenSet() ) {
    $scope.currentUser = Auth.getCurrentUser();
    $scope.rootUrl = '#/drip_marketing_campaigns';
    $scope.navItems = $scope.loggedInNavItems;
    $scope.authItem = $scope.loggedInAuthItem;
  } else {
    $scope.rootUrl = '#/login';
    $scope.navItems = $scope.loggedOutNavItems;
    $scope.authItem = $scope.loggedOutAuthItem;
  }
}

NavigationController.$inject = ['$scope', '$rootScope', '$location', '$location', 'Auth', 'SessionHandler'];
