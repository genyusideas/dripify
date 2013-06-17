class FriendRelationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
