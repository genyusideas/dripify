class SocialMediaAccount < ActiveRecord::Base
  attr_accessible :handle, :handle_id, :type, :user_id

  belongs_to :user

  validates :handle, presence: true, length: { maximum: 256 }
  validates :handle_id, presence: true, uniqueness: true, length: { maximum: 256 }
end
