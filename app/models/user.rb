class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable,
         :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  has_many :social_media_accounts, dependent: :destroy
  has_many :twitter_accounts, dependent: :destroy

  validates :email, presence: true
  validates :first_name, presence: true, length: { maximum: 256 }
  validates :last_name, presence: true, length: { maximum: 256 }
end
