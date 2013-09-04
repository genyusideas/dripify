require 'spec_helper'

describe FriendRelationship do
  let( :relationship ) { FactoryGirl.create( :friend_relationship ) }
  let( :follower ) { relationship.follower }
  let( :followed ) { relationship.followed }

  subject { relationship }

  it { should respond_to( :follower_id ) }
  it { should respond_to( :followed_id ) }
  it { should respond_to( :is_new ) }
  it { should respond_to( :new_follower? ) }
  it { should respond_to( :process_follower! ) }
  it { should be_new_follower }
  it { should be_valid }

  describe "when follower_id is not set" do
    before { relationship.follower_id = ' ' }
    it { should_not be_valid }
  end

  describe "when followed_id is not set" do
    before { relationship.followed_id = ' ' }
    it { should_not be_valid }
  end

  describe "when processing a follower" do
    before { relationship.process_follower! }
    it { should_not be_new_follower }
    it { should be_valid }
  end
end
