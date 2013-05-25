require 'spec_helper'

describe UsersController do
  render_views

  describe "when requesting an existing user" do
    let!(:user) { FactoryGirl.create( :user ) }
    before do 
      get :show, id: user.id, format: :json
      @body = JSON.parse(response.body)
    end

    it "returns the correct user" do
      response.should be_success
    end

    it "should return the user in the correct format" do
      @body.should include('email')
      @body.should include('first_name')
      @body.should include('last_name')
    end

    it "should be the correct user" do
      @body['email'].should == user.email
    end
  end

  describe "when requesting a user that doesn't exist" do
    before do
      id = User.last.id unless User.all.empty?
      id = 1 if User.all.empty?
      get :show, id: id, format: :json
      @body = JSON.parse(response.body)
    end

    it "should not return any user" do
      response.should_not be_success
    end

    it "should return the error message" do
      @body.should include('error')
      @body['error'].should == "User not found"
    end

    it "should return the error status" do
      response.status.should == 403
    end
  end
end