class SocialMediaAccount < ActiveRecord::Base
  attr_accessible :handle, :handle_id, :type, :user_id

  belongs_to :user
  has_many :drip_marketing_campaigns
  has_one :active_drip_marketing_campaign, class_name: 'DripMarketingCampaign', conditions: 'drip_marketing_campaigns.active = true'
  has_many :inactive_drip_marketing_campaigns, class_name: 'DripMarketingCampaign', conditions: "drip_marketing_campaigns.active = 'false'"

  validates :handle, presence: true, length: { maximum: 256 }
  validates :handle_id, presence: true, uniqueness: true, length: { maximum: 256 }
end