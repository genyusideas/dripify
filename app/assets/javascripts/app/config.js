(function() {
  var drippio_config;

  drippio_config = angular.module("Drippio.config", []);

  drippio_config.value('Config', {
    api: {
      rootUrl: 'http://drippio-app.dev',
      fullUrl: 'http://drippio-app.dev'
    },
    devPath: '/dev_settings'
  });

}).call(this);
