require 'spec_helper'

describe UsersController do
  render_views

  describe "when requesting an existing user" do
    let!(:user) { FactoryGirl.create( :user ) } 

    it "returns the correct user" do
      get :show, id: user.id, format: :json
      response.should be_success

      body = JSON.parse(response.body)
      body.should include('email')
      body['email'].should == user.email
    end
  end
end