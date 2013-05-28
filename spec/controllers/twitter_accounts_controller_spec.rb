require 'spec_helper'

describe TwitterAccountsController do
  render_views

  let!(:user) { FactoryGirl.create(:user) }
  let!(:twitter) { FactoryGirl.create(:twitter_account) }
  before do
    twitter.user = user
    twitter.save
  end

  describe "show behavior" do
    describe "when requesting an existing twitter_account" do
      before do
        get :show, id: twitter.id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "returns successfully" do
        response.should be_success
      end

      it "should return the account in the correct format" do
        @body.should include('id')
        @body.should include('handle')
      end

      it "should be the correct account" do
        @body['handle'].should == twitter.handle
      end
    end

    describe "when requesting an account that doesn't exist" do
      before do
        id = TwitterAccount.last.id + 1 unless TwitterAccount.all.empty?
        id = 1 if TwitterAccount.all.empty?
        get :show, id: id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any account" do
        response.should_not be_success
      end

      it "should return the error message" do
        @body.should include('error')
        @body['error'].should == "Twitter account not found"
      end

      it "should return the error status" do
        response.status.should == 403
      end
    end

    describe "when requesting an account that belongs to another user" do
      let!(:second_user) { FactoryGirl.create(:user) }
      before do
        get :show, id: twitter.id, user_id: second_user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any account" do
        response.should_not be_success
      end

      it "should return the error message" do
        @body.should include('error')
        @body['error'].should == "Twitter account not found"
      end

      it "should return the error status" do
        response.status.should == 403
      end
    end

    describe "when requesting an account from a user that does not exist" do
      before do
        user_id = User.last.id + 1 unless User.all.empty?
        user_id = 1 if User.all.empty?
        
        get :show, id: twitter.id, user_id: user_id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any account" do
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

  describe "index behavior" do
    describe "when requesting an existing user's twitter accounts" do
      before do
        @twitter_accounts = Array.new
        @twitter_accounts.push(twitter)
        (0..10).each do |i|
          twitter_account = FactoryGirl.create(:twitter_account)
          twitter_account.user = user
          twitter_account.save
          @twitter_accounts.push(twitter_account)
        end

        get :index, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should return successfully" do
        response.should be_success
      end

      it "should return the right number of account objects" do
        @body.count.should == @twitter_accounts.count
      end

      it "should return the right twitter accounts" do
        i = 0
        @body.each do |account|
          account['handle'].should == @twitter_accounts[i].handle
          i += 1
        end
      end
    end

    describe "when a user has no twitter accounts" do
      let!(:empty_user) { FactoryGirl.create(:user) }
      before do
        get :index, user_id: empty_user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should return successfully" do
        response.should be_success
      end

      it "should return the right number of account objects" do
        @body.count.should == 0
      end
    end
  end

  describe "post behavior" do
    let(:twitter_to_create) { FactoryGirl.build(:twitter_account) }
    before do
      post :create, 
        twitter_account: { handle: twitter_to_create.handle, handle_id: twitter_to_create.handle_id }, 
        user_id: user.id, 
        format: :json
    end

    describe "when adding a new twitter account" do
      before { @body = JSON.parse(response.body) }

      it "returns successfully" do
        # response.should be_success
        response.status.should == 200
      end

      it "should return the account in the correct format" do
        @body.should include('id')
        @body.should include('handle')
      end

      it "should be the correct account" do
        @body['handle'].should == twitter_to_create.handle
      end
    end

    describe "when adding a twitter account that already exists" do
      before do
        post :create, 
          twitter_account: { handle: twitter_to_create.handle, handle_id: twitter_to_create.handle_id }, 
          user_id: user.id, 
          format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return successfully" do
        response.should_not be_success
      end

      it "should return the error message" do
        @body.should include('error')
        @body['error'].should == "Error saving account"
      end

      it "should return the error status" do
        response.status.should == 500
      end
    end
  end

  describe "when adding to new twitter account with no user" do
    let(:twitter_to_create) { FactoryGirl.build(:twitter_account) }
    before do
      id = User.last.id + 1 unless User.all.empty?
      id = 1 if User.all.empty?
      post :create,
        twitter_account: { handle: twitter_to_create.handle, handle_id: twitter_to_create.handle_id },
        user_id: id,
        format: :json
      @body = JSON.parse(response.body)
    end

    it "should not return successfully" do
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

  describe "destroy behavior" do
    let(:twitter_to_destroy) { FactoryGirl.create(:twitter_account) }

    describe "when destroying a twitter account" do
      before do
        twitter_to_destroy.user = user
        twitter_to_destroy.save

        delete :destroy, id: twitter_to_destroy.id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "returns successfully" do
        response.should be_success
      end

      it "should not exist in the database" do
        TwitterAccount.find_by_id( twitter_to_destroy.id ).should == nil
      end
    end

    describe "when destroying a twitter account that doesn't exist" do
      before do
        delete :destroy, id: twitter_to_destroy.id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end      

      it "should not return successfully" do
        response.should_not be_success
      end

      it "should return the error message" do
        @body.should include('error')
        @body['error'].should == "Twitter account does not exist"
      end

      it "should return the error status" do
        response.status.should == 403
      end
    end
  end

  describe "when destroying to twitter account from the wrong user" do
    let(:twitter_to_destroy) { FactoryGirl.create(:twitter_account) }
    let(:wrong_user) { FactoryGirl.create(:user) }
    before do
      twitter_to_destroy.user = user
      twitter_to_destroy.save
      
      delete :destroy, id: twitter_to_destroy.id, user_id: wrong_user.id, format: :json
      @body = JSON.parse(response.body)
    end

    it "should not return successfully" do
      response.should_not be_success
    end

    it "should return the error message" do
      @body.should include('error')
      @body['error'].should == "Twitter account does not exist"
    end

    it "should return the error status" do
      response.status.should == 403
    end
  end
end
