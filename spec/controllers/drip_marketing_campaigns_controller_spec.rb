require 'spec_helper'

describe DripMarketingCampaignsController do
  render_views

  let!(:user) { FactoryGirl.create(:user) }
  let(:twitter) { FactoryGirl.create(:twitter_account) }
  let(:drip_campaign) { DripMarketingCampaign.new }
  before do
    twitter.user = user
    twitter.save
    drip_campaign.social_media_account = twitter
    drip_campaign.save
  end

  describe "show behavior" do
    describe "when requesting an existing drip marketing campaign" do
      before do
        get :show, id: drip_campaign.id, twitter_account_id: twitter.id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "returns successfully" do
        response.should be_success
      end

      it "should return the body in the correct format" do
        @body.should include('id')
      end
    end

    describe "when requesting a campaign that doesn't exist" do
      before do
        id = DripMarketingCampaign.last.id + 1 unless DripMarketingCampaign.all.empty?
        id = 1 if DripMarketingCampaign.all.empty?
        get :show, id: id, twitter_account_id: twitter.id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any campaign" do
        response.should_not be_success
      end

      it "should return the error message" do
        @body.should include('error')
        @body['error'].should == "DripMarketingCampaign not found"
      end

      it "should return the error status" do
        response.status.should == 403
      end
    end

    describe "when requesting a Twitter account that doesn't exist" do
      before do
        id = TwitterAccount.last.id + 1 unless TwitterAccount.all.empty?
        id = 1 if TwitterAccount.all.empty?
        get :show, id: drip_campaign.id, twitter_account_id: id, user_id: user.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any campaign" do
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

    describe "when requesting a User that doesn't exist" do
      before do
        id = User.last.id + 1 unless User.all.empty?
        id = 1 if User.all.empty?
        get :show, id: drip_campaign.id, twitter_account_id: twitter.id, user_id: id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should not return any campaign" do
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
  end

  describe "index behavior" do
    describe "when requesting an existing account's drip marketing campaigns" do
      before do
        @drip_campaigns = Array.new
        @drip_campaigns.push(drip_campaign)
        (0..10).each do |i|
          campaign = DripMarketingCampaign.new
          campaign.social_media_account = twitter
          campaign.save
          @drip_campaigns.push(campaign)
        end

        get :index, user_id: user.id, twitter_account_id: twitter.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should return successfully" do
        response.should be_success
      end

      it "should return the right number of campaign objects" do
        @body.count.should == @drip_campaigns.count
      end

      it "should return the right campaigns" do
        i = 0
        @body.each do |campaign|
          campaign['id'].should == @drip_campaigns[i].id
          i += 1
        end
      end
    end

    describe "when an account has no campaigns" do
      let!(:empty_account) { FactoryGirl.create(:twitter_account) }
      before do
        empty_account.user = user
        empty_account.save

        get :index, user_id: user.id, twitter_account_id: empty_account.id, format: :json
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

  describe "create behavior" do
    describe "when adding a new campaign" do
      let(:campaign_to_create) { DripMarketingCampaign.new }
      before do
        post :create,
          user_id: user.id,
          twitter_account_id: twitter.id,
          format: :json
      end

      describe "when adding a new campaign" do
        before { @body = JSON.parse(response.body) }

        it "returns successfully" do
          response.status.should == 200
        end

        it "should return the account in the correct format" do
          @body.should include('id')
        end
      end
    end
  end
end
