function DripMarketingCampaignsController($scope, $rootScope, $location, $http, Config, User, Auth, SessionHandler, TwitterAccount, DripMarketingCampaign, DripMarketingRule) {
  $scope.currentUser = Auth.getCurrentUser();
  $scope.currentStep = 'sprinkle';
  $scope.drips = [];
  $scope.twitter_accounts = [];
  $scope.selected_account = '';
  $scope.selected_campaign = '';
  $scope.add_account_url = Config.api.fullUrl + "/auth/twitter?auth_token=" + SessionHandler.getToken();

  $scope.loadTwitterAccounts = function() {
    if ( $scope.currentUser ) {
      TwitterAccount.query({ slug: $scope.currentUser.id }, function( account ) {
        var i = 0;
        for ( i = 0; i < account.length; i++ ) {
          var acct = {
            id: account[i].id,
            name: account[i].handle,
            profile_image: account[i].profile_image_url
          };
          $scope.twitter_accounts.push( acct );
          $scope.load_campaign( acct );
        }
        if ( $scope.twitter_accounts.length > 0 )
          $scope.selected_account = $scope.twitter_accounts[0];
      });
    }
  };

  $scope.load_campaign = function( twitter_account ) {
    DripMarketingCampaign.query(
      { 
        slug: $scope.currentUser.id,
        twitter_id: twitter_account.id
      },
      function( campaigns ) {
        if (campaigns && campaigns.length > 0) {
          for ( var j = 0; j < campaigns.length; j++ ) {
            DripMarketingRule.query({
              slug: $scope.currentUser.id,
              twitter_id: twitter_account.id,
              drip_marketing_campaign_id: campaigns[j].id
            },
            function( rules ) {
              if ( rules && rules.length > 0 ) {
                console.log("HELLO")
                var k = 0;
                for ( k = 0; k < rules.length; k++ ) {
                  console.log("ID = " + rules[k].id);
                  console.log("DELAY = " +rules[k].delay);
                  console.log("MESSAGE = " + rules[k].message);
                  var drip = {
                    id: rules[k].id,
                    delay: rules[k].delay,
                    message: rules[k].message
                  };
                  $scope.drips.push( drip );
                }
              } else {
                $scope.addDrip();
              }
            });
          }
          $scope.selected_campaign = campaigns[0];
          $scope.currentStep = 'downpour';
        } else {
          DripMarketingCampaign.save({
            slug: $scope.currentUser.id,
            twitter_id: twitter_account.id,
          },
          {},
          function( response ) {
            $scope.selected_campaign = response;
            $scope.addDrip();
          });
        }
      }
    );
  }

  $scope.clickSprinkle = function() {
    $scope.currentStep = 'sprinkle';
  };

  $scope.clickDownpour = function() {
    $scope.currentStep = 'downpour';
  };

  $scope.clickMeasure = function() {
    $scope.currentStep = 'measure';
  }

  $scope.addDrip = function() {
    var drip = {
      delay: '',
      message: ''
    }
    $scope.drips.push( drip );
  };

  $scope.saveDrips = function() {
    for ( var i = 0; i < $scope.drips.length; i++ ) {
      var drip = $scope.drips[i];
      if ( drip.id ) {
        DripMarketingRule.update({
          slug: $scope.currentUser.id,
          twitter_id: $scope.selected_account.id,
          drip_marketing_campaign_id: $scope.selected_campaign.id,
          drip_marketing_rule_id: drip.id
        },
        {
          drip_marketing_rule: drip
        },
        function( response ) {
          
        });
      } else {
        DripMarketingRule.save({
          slug: $scope.currentUser.id,
          twitter_id: $scope.selected_account.id,
          drip_marketing_campaign_id: $scope.selected_campaign.id
        },
        {
          drip_marketing_rule: drip
        },
        function( response ) {
          
        });
      }
    }
  };

  $scope.selectTwitterAccount = function( twitter_index ) {
    for ( var i = 0; i < $scope.twitter_accounts.length; i++ ) {
      if ($scope.twitter_accounts[i].id == twitter_index) {
        $scope.selected_account = $scope.twitter_accounts[i];
        $scope.drips = [];
        $scope.load_campaign( $scope.twitter_accounts[i] );
      }
    }
  };

  //
  // Watch for changes to currentUser so that we can know to request
  // the list of accounts and other information from the server.
  //
  $rootScope.$watch('currentUser', function(newUser, oldUser) {
    if ( newUser ) {
      $scope.currentUser = newUser;
    }
  }, true);

  $scope.$watch('currentUser', function(newUser, oldUser) {
    if ( newUser ) {
      $scope.loadTwitterAccounts();
    }
  }, true);
};

DripMarketingCampaignsController.$inject = ['$scope', '$rootScope', '$location', '$http', 'Config', 'User', 'Auth', 'SessionHandler', 'TwitterAccount', 'DripMarketingCampaign', 'DripMarketingRule']
