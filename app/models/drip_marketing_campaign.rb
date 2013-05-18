class DripMarketingCampaign < ActiveRecord::Base
  attr_accessible :active

  has_many :drip_marketing_rules

  validates :active, presence: true
end
