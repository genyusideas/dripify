require 'spec_helper'

describe FriendRelationship do
  let( :follower ) { FactoryGirl.create( :twitter_account ) }
  let( :followed ) { FactoryGirl.create( :twitter_account ) }

  before do
    @relationship = FriendRelationship.new(
      follower_id: follower.id,
      followed_id: followed.id
    )
  end

  subject { @relationship }

  it { should respond_to( :follower_id ) }
  it { should respond_to( :followed_id ) }
  it { should be_valid }

  describe "when follower_id is not set" do
    before { @relationship.follower_id = ' ' }
    it { should_not be_valid }
  end

  describe "when followed_id is not set" do
    before { @relationship.followed_id = ' ' }
    it { should_not be_valid }
  end
end
