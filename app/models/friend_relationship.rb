class FriendRelationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id, :is_new

  before_save :process_new

  validates :followed_id, presence: true
  validates :follower_id, presence: true
  
  def new_follower?
    self.is_new
  end

  def process_follower!
    self.update_attributes is_new: false
  end

  private

    def process_new
      if self.is_new.nil?
        self.is_new = false
      end
    end
end
