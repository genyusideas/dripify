require 'spec_helper'

describe DripMarketingRule do
  before do
    @drip_rule = DripMarketingRule.new( delay: 0, message: "Test message" )
  end

  subject { @drip_rule }

  it { should respond_to( :delay ) }
  it { should respond_to( :message ) }
  it { should respond_to( :drip_marketing_campaign ) }
  it { should be_valid }

  describe "when delay is not set" do
    before { @drip_rule.delay = ' ' }
    it { should_not be_valid }
  end

  describe "when delay is not an integer" do
    before { @drip_rule.delay = 'one' }
    it { should_not be_valid }
  end

  describe "when delay is less than 0" do
    before { @drip_rule.delay = -1 }
    it { should_not be_valid }
  end

  describe "when delay is 0" do
    before { @drip_rule.delay = 0 }
    it { should be_valid }
  end

  describe "when delay is too large" do
    before { @drip_rule.delay = 366 }
    it { should_not be_valid }
  end

  describe "when delay is at max size" do
    before { @drip_rule.delay = 365 }
    it { should be_valid }
  end

  describe "when message is not set" do
    before { @drip_rule.message = ' ' }
    it { should_not be_valid }
  end

  describe "when message is too long" do
    before { @drip_rule.message = 'a' * 10001 }
    it { should_not be_valid }
  end

  describe "when message is the max length" do
    before { @drip_rule.message = 'a' * 10000 }
    it { should be_valid }
  end
end
