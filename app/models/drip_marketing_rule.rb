class DripMarketingRule < ActiveRecord::Base
  attr_accessible :delay, :message

  validates :delay, presence: true, numericality: { 
    integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 365
   }
  validates :message, presence: true, length: { maximum: 10000 }
end
