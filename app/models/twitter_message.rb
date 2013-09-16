class TwitterMessage < ActiveRecord::Base
  attr_accessible :message, :recipient_id, :send_date, :status, :twitter_account_id

  belongs_to :twitter_account

  validates :message, presence: true, length: { maximum: 10000  }
  validates :recipient_id, presence: true
  validates :send_date, presence: true
  validates :status, presence: true
  validates :twitter_account_id, presence: true

  def error?
    self.status == "error"
  end

  def pending?
    self.status == "pending"
  end

  def sent?
    self.status == "sent"
  end

  def error!
    self.update_attributes status: "error"
  end

  def pending!
    self.update_attributes status: "pending"
  end

  def sent!
    self.update_attributes status: "sent"
  end
end
