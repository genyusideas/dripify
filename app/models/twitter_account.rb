class TwitterAccount < SocialMediaAccount
  has_many :friend_relationships, foreign_key: "followed_id"
  
  def actual_followers
    self.friend_relationships.map &:follower_id
  end

  def new_followers
    self.friend_relationships.where(is_new: true).map &:follower_id
  end
end
