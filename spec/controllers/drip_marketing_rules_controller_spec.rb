require 'spec_helper'

describe DripMarketingRulesController do
  render_views

  let!(:user) { FactoryGirl.create(:user) }
  let(:twitter) { FactoryGirl.create(:twitter_account) }
  let(:drip_campaign) { DripMarketingCampaign.new }
  let(:drip_marketing_rule) { FactoryGirl.create(:drip_marketing_rule) }
  before do
    twitter.user = user
    twitter.save
    drip_campaign.social_media_account = twitter
    drip_campaign.save
    drip_marketing_rule.drip_marketing_campaign = drip_campaign
    drip_marketing_rule.save
  end

  describe "index behavior" do
    describe "when requesting an existing drip marketing campaign's rules" do
      before do
        @drip_rules = Array.new
        @drip_rules.push(drip_marketing_rule)
        (0..10).each do |i|
          rule = FactoryGirl.create(:drip_marketing_rule)
          rule.drip_marketing_campaign = drip_campaign
          rule.save
          @drip_rules.push(rule)
        end

        get :index, user_id: user.id, twitter_account_id: twitter.id, drip_marketing_campaign_id: drip_campaign.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should return successfully" do
        response.should be_success
      end

      it "should return the right number of rule objects" do
        @body.count.should == @drip_rules.count
      end

      it "should return the right campaigns" do
        i = 0
        @body.each do |campaign|
          campaign['id'].should == @drip_rules[i].id
          i += 1
        end
      end
    end

    describe "when a campaign has no rules" do
      let!(:empty_campaign) { DripMarketingCampaign.new }
      before do
        empty_campaign.social_media_account = twitter
        empty_campaign.save

        get :index, user_id: user.id, twitter_account_id: twitter.id, drip_marketing_campaign_id: empty_campaign.id, format: :json
        @body = JSON.parse(response.body)
      end

      it "should return successfully" do
        response.should be_success
      end

      it "should return the right number of rule objects" do
        @body.count.should == 0
      end
    end
  end

  describe "create behavior" do
    describe "when adding a new rule" do
      let(:rule_to_create) { FactoryGirl.create(:drip_marketing_rule) }
      before do
        post :create, 
          user_id: user.id, 
          twitter_account_id: twitter.id, 
          drip_marketing_campaign_id: drip_campaign.id, 
          drip_marketing_rule: { delay: rule_to_create.delay, message: rule_to_create.message },
          format: :json
        @body = JSON.parse(response.body)
      end

      it "returns successfully" do
        response.status.should == 200
      end

      it "should return the rule in the correct format" do
        @body.should include('id')
      end
    end
  end
end
