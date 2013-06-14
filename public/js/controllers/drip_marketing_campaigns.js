function DripMarketingCampaignsController($scope, $rootScope, $location, $http, Config, User, Auth, TwitterAccount, DripMarketingCampaign, DripMarketingRule) {
  $scope.currentUser = Auth.getCurrentUser();
  $scope.currentStep = 'sprinkle';
  $scope.drips = [];
  $scope.twitter_accounts = [];
  $scope.selected_account = '';
  $scope.selected_campaign = '';

  $scope.loadTwitterAccounts = function() {
    TwitterAccount.query({ slug: $scope.currentUser.id }, function( account ) {
      var i = 0;
      for ( i = 0; i < account.length; i++ ) {
        var acct = {
          id: account[i].id,
          name: account[i].handle,
          profile_image: 'http://www.gravatar.com/avatar/f3a44a2cbd5a660f8ff43e27ab5145db.png'
        };
        $scope.twitter_accounts.push( acct );
        $scope.load_campaign( acct );
      }
      $scope.selected_account = $scope.twitter_accounts[0];
    });
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
                var k = 0;
                for ( k = 0; k < rules.length; k++ ) {
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
          $scope.selected_campaign = campaigns[j];
          $scope.currentStep = 'downpour';
        } else {
          DripMarketingRule.save({
            slug: $scope.currentUser.id,
            twitter_id: twitter_account.id,
          },
          {},
          function( response ) {
            alert('created');
            console.debug( response );
            $scope.selected_campaign = response;
          });
          $scope.addDrip();
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

  $scope.addAccount = function() {
    if ($scope.twitter_accounts.length == 0) {
      var account = {
        name: '@thebigmatay',
        profile_image: 'http://www.gravatar.com/avatar/f3a44a2cbd5a660f8ff43e27ab5145db.png'
      };
      $scope.twitter_accounts.push(account);
    }
    else if ($scope.twitter_accounts.length == 1) {
      var account = {
        name: '@theopphub',
        profile_image: 'https://si0.twimg.com/profile_images/2692639155/f99fc2703b11c993bef13c1f44abef62_bigger.png'
      };
      $scope.twitter_accounts.push(account);
    }
    else if ($scope.twitter_accounts.length == 2) {
      var account = {
        name: '@iamicarus',
        profile_image: 'http://www.gravatar.com/avatar/7e852a700b0da23a39845065be2907c2.png'
      };
      $scope.twitter_accounts.push(account);
    }
    $scope.selected_account = account;
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
          drip_marketing_campaign_id: 5,
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
          twitter_id: 8,
          drip_marketing_campaign_id: 5
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
      if ($scope.twitter_accounts.id == twitter_index) {
        $scope.selected_account = $scope.twitter_accounts[i];
        $scope.drips = [];
        $scope.load_campaign( $scope.twitter_accounts[i] );
      }
    }
  };

  $scope.loadTwitterAccounts();
};

DripMarketingCampaignsController.$inject = ['$scope', '$rootScope', '$location', '$http', 'Config', 'User', 'Auth', 'TwitterAccount', 'DripMarketingCampaign', 'DripMarketingRule']