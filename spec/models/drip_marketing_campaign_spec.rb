require 'spec_helper'

describe DripMarketingCampaign do
  before { @drip_campaign = DripMarketingCampaign.new }
  subject { @drip_campaign }

  it { should respond_to( :active ) }
  it { should respond_to( :drip_marketing_rules ) }
  it { should respond_to( :social_media_account ) }
  it { should be_active }
  it { should be_valid }

  # TODO: Re-enable once validation is figured out.
  # describe "when active is not set" do
  #   before { @drip_campaign.active = ' ' }
  #   it { should_not be_valid }
  # end

  describe "when adding a DripMarketingRule" do
    before do
      @drip_rule_one = @drip_campaign.drip_marketing_rules.build do |rule|
        rule.delay = 0
        rule.message = 'test'
      end
    end

    it "should have the rule" do
      @drip_campaign.drip_marketing_rules.should == [@drip_rule_one]
    end

    describe "when adding a DripMarketingRule" do
      before do
        @drip_rule_two = @drip_campaign.drip_marketing_rules.build do |rule|
          rule.delay = 1
          rule.message = 'test'
        end
      end

      it "should have the rule" do
        @drip_campaign.drip_marketing_rules.should == [@drip_rule_one, @drip_rule_two]
      end
    end
  end
end
