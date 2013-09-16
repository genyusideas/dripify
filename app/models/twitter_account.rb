class TwitterAccount < SocialMediaAccount
  has_many :friend_relationships, foreign_key: "followed_id"
  has_many :messages, class_name: "TwitterMessage"
  has_many :pending_messages, class_name: "TwitterMessage", conditions: "twitter_messages.status = 'pending'"
  has_many :error_messages, class_name: "TwitterMessage", conditions: "twitter_messages.status = 'error'"
  has_many :sent_messages, class_name: "TwitterMessage", conditions: "twitter_messages.status = 'sent'"

  def actual_followers
    self.friend_relationships.map &:follower_id
  end

  def new_followers
    self.friend_relationships.where(is_new: true).map &:follower_id
  end

  def update_followers!
    follower_ids = self.get_followers_from_api

    follower_ids.each do |id|
      if self.friend_relationships.find_by_follower_id(id).nil?
        self.friend_relationships.create! follower_id: id
      end
    end
  end

  def get_followers_from_api
    # Def stub this out, for now.
    follower_ids = []
    7.times do |n|
      num = rand(10).to_a
      follower_ids.push(num) unless follower_ids.include?(num)
    end
    follower_ids
  end
end
