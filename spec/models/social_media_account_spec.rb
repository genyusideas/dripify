require 'spec_helper'

describe SocialMediaAccount do
  before do
    @social = SocialMediaAccount.new do |s|
      s.handle = "thebigmatay"
      s.handle_id = "thebigmatay_id"
    end
  end

  subject { @social }

  it { should respond_to( :handle ) }
  it { should respond_to( :handle_id ) }
  it { should respond_to( :type ) }
  it { should respond_to( :user ) }
  it { should respond_to( :user_id ) }
  it { should be_valid }

  describe "when handle is not set" do
    before { @social.handle = ' ' }
    it { should_not be_valid }
  end

  describe "when handle is too long" do 
    before { @social.handle = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when handle is at max length" do
    before { @social.handle = 256 }
    it { should be_valid }
  end

  describe "when handle_id is not set" do
    before { @social.handle_id = ' ' }
    it { should_not be_valid }
  end

  describe "when handle_id is too long" do 
    before { @social.handle_id = 'a' * 257 }
    it { should_not be_valid }
  end

  describe "when handle_id is at max length" do
    before { @social.handle_id = 256 }
    it { should be_valid }
  end

  describe "when a duplicate handle id is created" do
    before do
      @duplicate = SocialMediaAccount.new do |d|
        d.handle = 'duplicate'
        d.handle_id = @social.handle_id
      end
      @duplicate.save
    end

    it { should_not be_valid }
  end
end
