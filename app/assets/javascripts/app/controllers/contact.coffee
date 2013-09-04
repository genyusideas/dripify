ContactController = ($scope) ->
  $scope.sendMessage = () ->
    $body = "Sending message with name: (" + $scope.name + "), email: (" + $scope.email + "), subject: (" + $scope.subject + "), message: (" + $scope.message + ")";
    console.log $body

    ###
    TODO: Made Mandrill actually send the message. Until then, just show a flash.
    ###
  
    $scope.showSuccess = true
    $scope.flashMessage = "Your message has been sent successfully."

ContactController.$inject = ['$scope']
(exports ? this).ContactController = ContactController
