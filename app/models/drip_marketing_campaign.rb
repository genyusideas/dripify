class DripMarketingCampaign < ActiveRecord::Base
  attr_accessible :active

  has_many :drip_marketing_rules
  belongs_to :social_media_account

  # TODO: Consult the ActiveRecord docs and re-enable.
  # validates :active, presence: true
end
