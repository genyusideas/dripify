require 'spec_helper'

describe TwitterAccount do
  before do
    @twitter = TwitterAccount.new do |t|
      t.handle = "@thebigmatay"
      t.handle_id = "1"
    end
  end

  subject { @twitter }

  it { should respond_to( :handle ) }
  it { should respond_to( :handle_id ) }
  it { should respond_to( :user ) }
  it { should respond_to( :user_id ) }
  it { should respond_to( :drip_marketing_campaigns ) }
  it { should respond_to( :active_drip_marketing_campaign ) }
  it { should respond_to( :inactive_drip_marketing_campaigns ) }
  it { should be_valid }

  describe "when handle is not set" do
    before { @twitter.handle = ' ' }
    it { should_not be_valid }
  end

  describe "when handle is too long" do 
    before { @twitter.handle = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when handle is at max length" do
    before { @twitter.handle = 256 }
    it { should be_valid }
  end

  describe "when handle_id is not set" do
    before { @twitter.handle_id = ' ' }
    it { should_not be_valid }
  end

  describe "when handle_id is too long" do 
    before { @twitter.handle_id = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when handle_id is at max length" do
    before { @twitter.handle_id = 256 }
    it { should be_valid }
  end

  describe "when a duplicate handle id is created" do
    before do
      @duplicate = TwitterAccount.new do |d|
        d.handle = 'duplicate'
        d.handle_id = @twitter.handle_id
      end
      @duplicate.save
    end

    it { should_not be_valid }
  end

  describe "when adding a drip marketing campaign" do
    before do
      @twitter.save
      @campaign = @twitter.drip_marketing_campaigns.build( active: false )
      @campaign.save
    end
    it "should have the drip marketing campaign" do
      @twitter.drip_marketing_campaigns.should == [@campaign]
    end

    describe "when adding a second drip marketing campaign" do
      before do
        @campaign_two = @twitter.drip_marketing_campaigns.build( active: false )
        @campaign_two.save 
      end

      it "should have both drip marketing campaigns" do
        @twitter.drip_marketing_campaigns.should == [@campaign, @campaign_two]
      end

      it "should have both drip marketing campaigns as inactive" do
        @twitter.inactive_drip_marketing_campaigns.should == [@campaign, @campaign_two]
      end

      describe "when a campaign is active" do
        before { @campaign.update_attributes( active: true ) }
        
        it "should still have the drip marketing campaigns" do
          @twitter.drip_marketing_campaigns.should == [@campaign, @campaign_two]
        end

        it "should be an active campaign" do
          @twitter.active_drip_marketing_campaign.should == @campaign
        end

        it "should not be an invalid campaign" do
          @twitter.inactive_drip_marketing_campaigns.should == [@campaign_two]
        end
      end
    end
  end
end
